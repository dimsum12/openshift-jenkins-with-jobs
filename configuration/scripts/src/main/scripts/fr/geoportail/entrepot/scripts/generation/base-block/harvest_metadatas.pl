#!/usr/bin/perl
#########################################################################################################################
#
# USAGE :
#
# ARGS :
#   The source directory of the metadatas
#   The destination directory of the metadatas
#   The type of the metadatas ( 0 = INSPIRE; 1 = ISO; 2 = PVA )
# RETURNS :
#   * 0 if the process is correct
#   * 1 if there are errors during the harvesting operation
#   * 2 if the source directory of the metadatas exists
#   * 3 if the catalog returns a bad response on the harvesting operation status
#   * 4 if the catalog is unaccessible
#   * 5 if failed to retrieve crawling id
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/harvest_metadatas.pl $
#   $Date: 26/09/11 $
#   $Author: Charles-Henri Biller (a149912) <charles-henri.biller@atos.net> $
#########################################################################################################################

use strict;
use warnings;
use Cwd;
use Logger;
use Database;
use Config::Simple;
use DBI;
use HTTP::Request::Common;
use LWP::UserAgent;
use File::Basename;
use Execute;
use Tools;

use XML::XPath;
use XML::XPath::XMLParser;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "harvest_metadatas.pl", $logger_levels );

my $url_proxy     = $config->param("proxy.url");
my $url_catalogue = $config->param("resources.ws.url.catalogue");

my $provider_inspire = $config->param("harvesting.provider.inspire");
my $provider_isoap   = $config->param("harvesting.provider.isoap");
my $prefix_version   = $config->param("harvesting.prefix.version");

my $check_status_timeout = $config->param("harvesting.timeout");

# Xpath variables to parse catalog responses
my $xpath_status        = $config->param("harvesting.xpath.status");
my $xpath_crawl_id      = $config->param("harvesting.xpath.crawl.id");
my $xpath_directory     = $config->param("harvesting.xpath.directory");
my $xpath_success_count = $config->param("harvesting.xpath.success.count");
my $xpath_failure_count = $config->param("harvesting.xpath.failure.count");
my $xpath_success_files = $config->param("harvesting.xpath.success.files");
my $xpath_failure_files = $config->param("harvesting.xpath.failure.files");
my $xpath_records_count = $config->param("harvesting.xpath.records.count");

my $crawl_status_ok = $config->param("harvesting.crawl.status.ok");

my $xpath_metadatas_file_identifier =
  $config->param("harvesting.xpath.metadatas.file.identifier");

my %resource_type = (
    "0" => "http://schemas.opengis.net/iso/19139/20060504/gmd",
    "1" => "http://www.isotc211.org/schemas/2005/gmd",
    "2" => "IGN"
);

sub harvest_metadatas {

    # Parameters number validation
    my ( $dir_mtd_src, $dir_mtd_dest, $type ) = @_;

    if (   !defined $dir_mtd_src
        || !defined $dir_mtd_dest
        || !defined $type )
    {
        $logger->log( "ERROR",
            "Le nombre de paramèes renseignén'est pas celui attendu (3)" );
        return 255;
    }

    # Init useragent with or without proxy
    my $ua = LWP::UserAgent->new;
    if ( $url_proxy ne "none" ) {
        $ua->proxy( [ 'http', 'ftp' ], $url_proxy );
        $logger->log( "DEBUG",
            "Les paramètres du proxy ont été initialisés ($url_proxy)" );
    }

    # Copy metadatas in repository
    if ( -e $dir_mtd_src ) {
        if ( -e $dir_mtd_dest ) {
            Execute->run( "rm -rf $dir_mtd_dest", "false" );
            $logger->log( "DEBUG",
"Le répertoire de destination $dir_mtd_dest des métadonnées à intégrer a été supprimé"
            );
        }
        Execute->run( "mkdir -p $dir_mtd_dest",             "false" );
		
		
		# utilisation d'un tar & pipe au lieu d'un cp tou simple car le cp tombe en erreur s'il y a trop de fichiers à copier
		my $copy_command = "(cd $dir_mtd_src/; tar cf - ./*) | (cd $dir_mtd_dest; tar xf -)";
		$logger->log( "DEBUG",
                "La commande appelée est : " . $copy_command );
		my $copy_return = Execute->run( $copy_command, "true" );

		# get back to ancien folder
		if ( $copy_return->get_return() != 0 ) {
			$logger->log( "ERROR",
				"La commande de copie (via tar & pipe) a échoué : "
				  . $copy_return->get_return() );
			$logger->log( "ERROR", "Sortie complète :" );
			$copy_return->log_all( $logger, "ERROR" );
			return 9;
		}
		
        $logger->log( "INFO",
"Copie des métadonnées à intégrer effectuée de $dir_mtd_src vers $dir_mtd_dest"
        );
    }
    else {
        $logger->log( "ERROR",
"Le répertoire source des métadonnées $dir_mtd_src des métadonnées n'existe pas"
        );
        return 2;
    }

    # Check and upate metadatas version
    # my $result = check_metadata_version( $dir_mtd_dest, $ua, $type );
    # if ( $result != 0 ) {
    # system "rm -rf $dir_mtd_dest";
    # return $result;
    # }

    # Init params for harvesting
    my $params =
        "?service=CSW&request=crawl&version=2.0.2&folder="
      . $dir_mtd_dest
      . "&resourceType="
      . $resource_type{$type}
      . "&asynchronous=true&delay=0&threadnb=4";

    # Harvest metadatas (asynchronous)
    my $response, my $request;
    if ( Tools->is_numeric($type) && 0 == $type ) {
        $logger->log( "INFO",
            "Intégration des métadonnées $provider_inspire démarrée" );
        $logger->log( "DEBUG",
            "Crawl on " . $url_catalogue . $provider_inspire . $params );
        $request = $url_catalogue . $provider_inspire;
    }
    else {
        $logger->log( "INFO",
            "Intégration des métadonnées $provider_isoap démarrée " );
        $logger->log( "DEBUG",
            "Crawl on " . $url_catalogue . $provider_isoap . $params );
        $request = $url_catalogue . $provider_isoap;
    }

    # Send an harvesting request to the catalog
    $response = $ua->request( GET $request. $params );

    if ( $response->is_success ) {

        # Retrieve id of the harvest operation
        my $xp = XML::XPath->new( xml => $response->content );
        my $harvest_id = $xp->getNodeText($xpath_crawl_id);
        $logger->log( "DEBUG",
            "L'Identifiant de l'opération de moissonnage est " . $harvest_id );

        $params = "?service=CSW&request=crawl&version=2.0.2&id=" . $harvest_id;

        # Retrieve status of harvesting operation
        my $bcontinue = 1;
        $logger->log( "INFO", "Intégration des métadonnées en cours..." );
        while ($bcontinue) {
            $response = $ua->request( GET $request. $params );
            $logger->log( "DEBUG",
"Récupération du statut de l'opération de moissonnage, $request$params"
            );

            if ( $response->is_success ) {
                my $response_content = $response->content;
                $xp = XML::XPath->new( xml => $response_content );

                my $status        = $xp->getNodeText($xpath_status);
                my $failure_count = $xp->getNodeText($xpath_failure_count);
                my $failure_files = $xp->find($xpath_failure_files);
                my $success_count = $xp->getNodeText($xpath_success_count);
                my $success_files = $xp->find($xpath_success_files);
                my $directory     = $xp->getNodeText($xpath_directory);

                $logger->log( "DEBUG", "Statut du moissonnage : $status" );

                # Check the end of the harvesting
                if ( $status eq $crawl_status_ok ) {
                    $logger->log( "INFO",
"Intégration des métadonnées terminée pour le répertoire $directory"
                    );
                    if ($success_count) {
                        $logger->log( "INFO",
                            "$success_count métadonnée(s) intégrée(s)" );
                        foreach my $mtd ( $success_files->get_nodelist ) {
                            $logger->log( "DEBUG",
                                XML::XPath::XMLParser::as_string($mtd)
                                  . " intégrée" );
                        }
                    }
                    if ($failure_count) {
                        $logger->log( "ERROR",
                            "$failure_count métadonnée(s) en erreur" );
                        foreach my $mtd ( $failure_files->get_nodelist ) {
                            my $file_identifier =
                              XML::XPath::XMLParser::as_string($mtd);
                            $logger->log( "ERROR",
                                "$file_identifier non intégrée" );

                            # Clean repository
                            Execute->run( "rm $directory/$file_identifier",
                                "false" );
                            $logger->log( "DEBUG",
"Suppression du repository de la métadonnées $directory/$file_identifier"
                            );
                        }
                        return 1;
                    }
                    $bcontinue = 0;
                }
                else {
                    Execute->run( "sleep $check_status_timeout", "false" );
                }
            }
            else {
                $logger->log( "ERROR",
"Erreur lors de la récupération du statut de l'opération de moissonnage des métadonnées pour l'id $harvest_id"
                );
                return 4;
            }
        }
    }
    else {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de l'interrogation du catalogue pour une intégration des métadonnées"
        );
        return 3;
    }

    return 0;

}

# Verify and update the version of the metadata
sub check_metadata_version {
    my ( $dir_mtd, $ua, $type ) = @_;

    # Find all metadata
    my @metadata_files = `find $dir_mtd -type f -name "*.xml"`;
    $logger->log( "INFO", "Versionnement des métadonnées démarrées" );
    $logger->log( "DEBUG",
        scalar @metadata_files . " métadonnée(s) trouvée(s)" );

    # Browse all metadatas to check metadata version
    foreach my $metadata_file (@metadata_files) {
        chomp $metadata_file;

        my ( $filename, $directory, $suffix ) =
          fileparse( $metadata_file, qr/[.][^.]*/ );

        my $getrecords =
"<?xml version='1.0' encoding='UTF-8'?> <csw:GetRecords xmlns:csw='http://www.opengis.net/cat/csw/2.0.2' service='CSW' version='2.0.2' maxRecords='10' outputSchema='http://www.isotc211.org/2005/gmd'> <csw:Query typeNames='csw:Record'> <csw:ElementSetName>brief</csw:ElementSetName> <csw:Constraint version='1.1.0'> <Filter xmlns='http://www.opengis.net/ogc' xmlns:gml='http://www.opengis.net/gml'> <And> <PropertyIsLike> <PropertyName>dc:identifier</PropertyName> <Literal>$filename%</Literal> </PropertyIsLike> </And> </Filter> </csw:Constraint> </csw:Query> </csw:GetRecords>";

        my $response;
        if ($type) {
            $response = $ua->request(
                POST $url_catalogue. $provider_inspire,
                Content_Type => 'text/xml',
                Content      => $getrecords
            );
            $logger->log( "DEBUG",
"GetRecords sur le fileIdentifier like \"$filename%\" on $url_catalogue$provider_inspire"
            );
        }
        else {
            $response = $ua->request(
                POST $url_catalogue. $provider_isoap,
                Content_Type => 'text/xml',
                Content      => $getrecords
            );
            $logger->log( "DEBUG",
"GetRecords sur le fileIdentifier like \"$filename%\" on $url_catalogue$provider_isoap"
            );
        }

        my $content = $response->content;

        #Check if metadata exists in catalog and create a new metadata version
        if ( $response->is_success ) {
            my $xp = XML::XPath->new( xml => $content );
            my $count = $xp->getNodeText($xpath_records_count);

            my $last_version = 0;

            # Retrieve the last metadata version
            if ( "0" ne $count ) {
                my $metadatas = $xp->find($xpath_metadatas_file_identifier);
                foreach my $metadata ( $metadatas->get_nodelist ) {
                    my $version = my $file_identifier =
                      XML::XPath::XMLParser::as_string($metadata);
                    $version =~ s/.*$prefix_version([0-9]*)[.]xml/$1/;

                    # is numeric
                    if ( $version =~ /^[0-9]+$/ ) {
                        if ( $version >= $last_version ) {
                            $last_version = $version;
                        }
                    }
                }
                $logger->log( "DEBUG",
"Dernière version trouvée pour $filename$suffix, version V$last_version"
                );
                $last_version++;
            }
            else {
                $logger->log( "DEBUG",
                    "Aucune version antérieure trouvée pour $filename$suffix"
                );
                $last_version = 1;
            }

            # Create new metadata version and delete original version
            Execute->run(
"cat $metadata_file | sed -e 's/$filename/$filename$prefix_version$last_version/' > $directory$filename$prefix_version$last_version$suffix",
                "false"
            );
            my $return_value = unlink $metadata_file;
            $logger->log( "INFO",
"La métadonnée $filename$suffix a été versionné en $filename$prefix_version$last_version$suffix"
            );
        }
        else {
            $logger->log( "ERROR",
"Erreur lors de la récupération du statut de l'opération de getRecords"
            );
            return 5;
        }
    }
    $logger->log( "INFO", "Versionnement des métadonnées terminées" );
    return 0;
}
