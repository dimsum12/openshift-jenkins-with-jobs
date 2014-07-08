#!/usr/bin/perl
#########################################################################################################################
#
# USAGE :
#   This script extract a Metadata file from an internal CSW service
# ARGS :
#	The absolute file name used for writing the
#	The type of extraction (ISOAP or INSPIRE) used as context for provider
#	Access key to the CSW service
#	Identifier of the metadata to extract
# RETURNS :
#   * 0 if the extraction is correct
#   * 1 if the CSW request generate an error
#   * 2 if an error occured during writing file
#   * 3 if an error occured during extracting Xpath from result
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/extraction/base-block/extract_mtd_file.pl $
#   $Date: 21/12/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger =
  Logger->new( "extract_mtd_file.pl", $config->param("logger.levels") );

# Configuration
my $url_proxy        = $config->param("proxy.url");
my $metadata_scheme  = $config->param("metadata_extraction.scheme");
my $metadata_host    = $config->param("metadata_extraction.host");
my $metadata_port    = $config->param("metadata_extraction.port");
my $metadata_path    = $config->param("metadata_extraction.path");
my $metadata_service = $config->param("metadata_extraction.service");
my $metadata_version = $config->param("metadata_extraction.version");
my $metadata_request = $config->param("metadata_extraction.request");

# Clés statiques
my $parameter_key_service          = "?service=";
my $parameter_key_version          = "&version=";
my $parameter_key_request          = "&request=";
my $parameter_key_id               = "&Id=";
my $parameter_key_elementsetname   = "&elementsetname=";
my $parameter_value_elementsetname = "full";
my $xpath_record = "/csw:GetRecordByIdResponse/gmd:MD_Metadata";

sub extract_mtd_file {

    # Extraction des paramètres
    my ( $file_name, $type_extraction, $cda_key, $mtd_id ) = @_;
    if (   !defined $file_name
        || !defined $type_extraction
        || !defined $cda_key
        || !defined $mtd_id )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (4)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : file_name = " . $file_name );
    $logger->log( "DEBUG",
        "Paramètre 2 : type_extraction = " . $type_extraction );
    $logger->log( "DEBUG", "Paramètre 3 : cda_key = " . $cda_key );
    $logger->log( "DEBUG", "Paramètre 4 : mtd_id = " . $mtd_id );

    # Création de la requête CSW
    my $request =
        $metadata_scheme . "://"
      . $metadata_host . "/"
      . $cda_key
      . $metadata_path
      . $type_extraction
      . $parameter_key_service
      . $metadata_service
      . $parameter_key_version
      . $metadata_version
      . $parameter_key_request
      . $metadata_request
      . $parameter_key_id
      . $mtd_id
      . $parameter_key_elementsetname
      . $parameter_value_elementsetname;
    $logger->log( "INFO", "requete CSW  : " . $request );

    # Configuration du proxy
    my $ua = LWP::UserAgent->new;
    if ( $url_proxy ne "none" ) {
        $logger->log( "DEBUG", "Utilisation du proxy : " . $url_proxy );
        $ua->proxy( [ 'http', 'ftp' ], $url_proxy );
    }

    # Requête CSW
    my $response = $ua->request( GET $request );
    if ( $response->is_success ) {
        $logger->log( "DEBUG", "requête CSW exécutée avec succés" );

        my $xp = XML::XPath->new( xml => $response->content );
        my $result = $xp->find($xpath_record);
        if ( !defined $result || 0 == scalar $result->get_nodelist ) {
            $logger->log( "ERROR",
                "Impossible d'extraire de la réponse le Xpath "
                  . $xpath_record );
            return 3;
        }

        my $mtd_content = "";
        $logger->log( "DEBUG",
            "Nombre de noeuds de métadonnée dans la réponse : "
              . scalar $result->get_nodelist );
        foreach my $node ( $result->get_nodelist ) {
            $mtd_content = $mtd_content . $node->toString;
        }

        # Ecriture du fichier de sortie
        my $hdl_mtd_file;
        if ( !open $hdl_mtd_file, ">:encoding(UTF-8)", $file_name ) {
            $logger->log( "ERROR",
                "Impossible de créer le fichier " . $file_name );
            return 2;
        }

        print {$hdl_mtd_file} $mtd_content;

        if ( !close $hdl_mtd_file ) {
            $logger->log( "ERROR",
                "Impossible de fermer le fichier " . $file_name );
            return 2;
        }
    }
    else {

        # Erreur de requête CSW
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la requête sur le service CSW : "
              . $request );
        return 1;
    }

    return 0;
}
