#!/usr/bin/perl

#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script drop a specific schema name
# ARGS :
#   The schema name to drop
# RETURNS :
#   * 0 if generation is correct
#   * 1 if the schema name is incorrect
#   * 2 if the schema name does not exist in the DB
#   * 240 if the schema dropping has failed
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/rollback_harvest_metadatas.pl $
#   $Date: 26/09/11 $
#   $Author: Charles-Henri Biller (a149912) <charles-henri.biller@atos.net> $
#########################################################################################################################

use strict;
use warnings;
use Cwd;
use Logger;
use Database;
use Config::Simple;
use HTTP::Request::Common;
use LWP::UserAgent;
use XML::XPath;
use XML::XPath::XMLParser;
use File::Basename;
use Execute;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "rollback_harvest_metadatas.pl", $logger_levels );

my $url_proxy = $config->param("proxy.url");

my $url_catalogue = $config->param("resources.ws.url.catalogue");

my $provider_inspire = $config->param("harvesting.provider.inspire");
my $provider_isoap   = $config->param("harvesting.provider.isoap");

my $xpath_transaction_delete_count =
  $config->param("harvesting.xpath.transaction.delete.count");

sub rollback_harvest_metadatas {

    # Parameters number validation
    my ( $dir_mtd, $is_inspire ) = @_;

    if ( !defined $dir_mtd || !defined $is_inspire ) {
        $logger->log( "ERROR",
            "Le nombre de paramèes renseignén'est pas celui attendu (2)" );
        return 255;
    }

    if ( !-e $dir_mtd ) {
        $logger->log( "ERROR",
"Le répertoire des métadonnées à supprimer du catalogue $dir_mtd de métadonnées n'existe pas"
        );
        return 2;
    }

    # Init useragent with or without proxy
    my $ua = LWP::UserAgent->new;
    if ( $url_proxy ne "none" ) {
        $ua->proxy( [ 'http', 'ftp' ], $url_proxy );
        $logger->log( "DEBUG",
            "Les paramètres du proxy ont été initialisés ($url_proxy)" );
    }

    # Init URL to request for delete metadata
    my $request;
    if ($is_inspire) {
        $logger->log( "INFO",
"Rollback de l'intégration des métadonnées $provider_inspire démarrée pour le répertoire $dir_mtd"
        );
        $request = $url_catalogue . $provider_inspire;
    }
    else {
        $logger->log( "INFO",
"Rollback de l'intégration des métadonnées $provider_isoap démarrée pour le répertoire $dir_mtd"
        );
        $request = $url_catalogue . $provider_isoap;
    }

    # Rollback metadatas harvested
    # Find all metadata
    my @metadata_files = `find $dir_mtd -type f -name "*.xml"`;
    $logger->log( "DEBUG",
        scalar @metadata_files . " métadonnée(s) trouvée(s) à supprimer" );

    # Browse all metadatas to init xml transaction message for delete operation
    my $delete_transaction = "<?xml version='1.0' encoding='UTF-8'?>";
    $delete_transaction = $delete_transaction
      . "<csw:Transaction service='CSW' version='2.0.2' xmlns:csw='http://www.opengis.net/cat/csw/2.0.2' xmlns:ogc='http://www.opengis.net/ogc'>";

    foreach my $metadata_file (@metadata_files) {
        chomp $metadata_file;

        my ( $filename, $directory, $suffix ) =
          fileparse( $metadata_file, qr/[.][^.]*/ );

        $delete_transaction = $delete_transaction . "<csw:Delete>";
        $delete_transaction =
          $delete_transaction . "<csw:Constraint version='1.1.0'>";
        $delete_transaction = $delete_transaction . "<ogc:Filter>";
        $delete_transaction = $delete_transaction . "<ogc:PropertyIsEqualTo>";
        $delete_transaction = $delete_transaction
          . "<ogc:PropertyName>dc:identifier</ogc:PropertyName>";
        $delete_transaction =
          $delete_transaction . "<ogc:Literal>$filename$suffix</ogc:Literal>";
        $delete_transaction = $delete_transaction . "</ogc:PropertyIsEqualTo>";
        $delete_transaction = $delete_transaction . "</ogc:Filter>";
        $delete_transaction = $delete_transaction . "</csw:Constraint>";
        $delete_transaction = $delete_transaction . "</csw:Delete>";
    }

    $delete_transaction = $delete_transaction . "</csw:Transaction>";

    # Send delete transaction to the catalog
    my $response;
    if ($is_inspire) {
        $response = $ua->request(
            POST $url_catalogue. $provider_inspire,
            Content_Type => 'text/xml',
            Content      => $delete_transaction
        );
    }
    else {
        $response = $ua->request(
            POST $url_catalogue. $provider_isoap,
            Content_Type => 'text/xml',
            Content      => $delete_transaction
        );
    }

    $logger->log( "DEBUG", "POST requête - $delete_transaction" );

    my $content = $response->content;

    if ( $response->is_success ) {
        my $xp        = XML::XPath->new( xml => $content );
        my $count     = $xp->getNodeText($xpath_transaction_delete_count);
        my $exception = $xp->getNodeText("ows:ExceptionReport");

        if ( "" ne $exception ) {
            $logger->log( "ERROR",
                "Une erreur est survenue sur le catalogue, $content" );
            return 1;
        }

        $logger->log( "DEBUG", "POST retour - $content" );
        $logger->log( "INFO",
            "$count/" . scalar @metadata_files . " ont été supprimés" );

        # Delete metadatas directory
        Execute->run( "rm -rf $dir_mtd", "false" );
        $logger->log( "INFO",
            "Suppression du répertoire de métadonnées $dir_mtd" );
    }
    else {
        $logger->log( "ERROR",
"Erreur lors de l'envoi de la requête de suppresion au catalog, $content"
        );
        return 3;
    }

    return 0;
}
