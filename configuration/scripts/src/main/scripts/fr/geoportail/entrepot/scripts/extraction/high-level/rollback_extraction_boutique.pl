#!/usr/bin/perl
##########################################################################################################################################
#
# USAGE :
#   This script will rollback an extraction
# ARGS :
#   The extraction id
# RETURNS :
#   * 0 if the extraction is Ok
#   * 1 if the REST service is not reacheable or if the ID is incorrect
#   * 2 if the process is not linked to only one output broadcast data
#   * 3 if an error ocurred during cleaning directories
#   * 253 if the extraction structure is incorrect
#   * 254 if the json response cannot be decoded
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 2 $
#   $Source src/main/scripts/fr/geoportail/entrepot/extraction/rollback_extraction_boutique.pl $
#   $Date: 22/11/11 $
#   $Author: Maimouna Deme (a510440) <maimouna.deme@atos.net> $
############################################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Cwd;
use HTTP::Request::Common;
use Config::Simple;
use JSON;
use Execute;
use LWP::UserAgent;

our $VERSION = "1.0";
our $config;

if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger = Logger->new( "rollback_extraction_boutique.pl",
    $config->param("logger.levels") );

my $url_proxy       = $config->param("proxy.url");
my $url_ws_entrepot = $config->param("resources.ws.url.entrepot");
my $tmp_path        = $config->param("resources.tmp.path");
my $tmp_extraction  = $config->param("resources.tmp.extractions");
my $root_storage    = $config->param("filer.root.storage");

sub rollback_extraction_boutique {

    # Extraction des paramètres
    my ($extraction_id) = @_;
    if ( !defined $extraction_id ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : extraction_id = " . $extraction_id );

    # Appel au web service pour récupérer l'extraction à effectuer
    my $ua = LWP::UserAgent->new;
    if ( $url_proxy ne "none" ) {
        $logger->log( "DEBUG", "Utilisation du proxy : " . $url_proxy );
        $ua->proxy( [ 'http', 'ftp' ], $url_proxy );
    }

    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/extraction/getExtraction" );

    my $response =
      $ua->request( GET $url_ws_entrepot
          . "/extraction/getExtraction?extractionId="
          . $extraction_id );

    if ( !$response->is_success ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la récupération de l'extraction d'identifiant :"
              . $extraction_id );
        return 1;
    }

    my $json_response = $response->decoded_content;
    my $hash_response = JSON::from_json($json_response);
    if ( !$hash_response ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la conversion de la réponse JSON"
        );
        return 254;
    }
    $logger->log( "DEBUG", "Récupération des informations de l'extraction" );

    # Lecture des données en sortie
    my $broadcast_datas = $hash_response->{'broadcastDatas'};
    if ( defined @{$broadcast_datas} ) {
        if ( scalar( @{$broadcast_datas} ) != 1 ) {
            $logger->log( "ERROR",
                    "La génération demandée est lié à "
                  . scalar( @{$broadcast_datas} )
                  . " données en sortie alors que ce type de traitement n'en attend que 1"
            );
            return 2;
        }
    }
    else {
        $logger->log( "ERROR",
"La génération demandée n'est lié à aucune donnée en sortie alors que ce type de traitement en attend 1"
        );
        return 2;
    }
    $logger->log( "DEBUG",
        scalar( @{$broadcast_datas} )
          . " donnée(s) de diffusion en sortie de la génération" );

    my $bd_id = $broadcast_datas->[0]->{'id'};
    if ( !$bd_id ) {
        $logger->log( "ERROR",
            "La données en sortie du processus ne possède pas d'identifiant"
        );
        return 253;
    }
    $logger->log( "DEBUG", "Identifiant de la donnée de sortie : " . $bd_id );

    my $storage = $broadcast_datas->[0]->{'storage'};
    if ( !$storage ) {
        $logger->log( "ERROR",
"La données en sortie du processus n'est pas associé à un stockage "
        );
        return 253;
    }

    my $storage_path = $storage->{'logicalName'};
    if ( !$storage_path ) {
        $logger->log( "ERROR",
"Le stockage associé à la donnée de diffusion ne contient pas de chemin "
        );
        return 253;
    }
    $logger->log( "DEBUG",
        "Chemin de stockage de la donnée de sortie : " . $storage_path );

    # Calcul du repertoire de travail temporaire de l'extraction
    my $tmp_output_storage = $tmp_path . $tmp_extraction . "/" . $extraction_id;
    $logger->log( "INFO",
        "L'extraction temporaire sera effectuée vers : "
          . $tmp_output_storage );

    # Calcul de la destination de l'extraction
    my $extraction_output_storage =
      $root_storage . $storage_path . "/" . $bd_id;
    $logger->log( "INFO",
        "Le packaging final sera effectué vers : "
          . $extraction_output_storage );

    # Suppression des données générées en cours d'extraction
    $logger->log( "INFO",
        "Suppression du répertoire temporaire " . $tmp_output_storage );
    my $delete_tmp_cmd = "rm -rf " . $tmp_output_storage;
    my $delete_tmp_return = Execute->run( $delete_tmp_cmd, "true" );
    if ( $delete_tmp_return->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Impossible de supprimer le répertoire temporaire "
              . $tmp_output_storage );
        $delete_tmp_return->log_all( $logger, "DEBUG" );
        return 3;
    }

    $logger->log( "INFO",
        "Suppression du répertoire temporaire " . $tmp_output_storage );
    my $delete_bd_cmd = "rm -rf " . $extraction_output_storage;
    my $delete_bd_return = Execute->run( $delete_bd_cmd, "true" );
    if ( $delete_bd_return->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Impossible de supprimer le répertoire temporaire "
              . $extraction_output_storage );
        $delete_bd_return->log_all( $logger, "DEBUG" );
        return 3;
    }

    return 0;
}
