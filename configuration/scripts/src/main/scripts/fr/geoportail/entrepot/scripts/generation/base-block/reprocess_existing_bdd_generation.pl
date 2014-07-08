#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will generate a PgSQL broadcast data from an existing PgSQL broadcast data
#       First it collect informations from service REST about the generation, input data and broadcast data
#       Then it plays all scripts
#       Finally it update the broadcast data with schema information
# ARGS :
#   The generation ID
#   The directory containing the scripts to be executed
# RETURNS :
#   * 0 if generation is correct
#   * 1 if the REST service is not reacheable or if the ID is incorrect
#   * 2 if the generation is linked to many input datas
#   * 3 if the generation is linked to many broadcast datas
#   * 4 if an error occured while executing a script
#   * 5 if the REST service for updating the braodcast data send an error
#   * 253 if the generation structure is incorrect
#   * 254 if the JSON return is not parseable
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/reprocess_existing_bdd_generation.pl $
#   $Date: 18/08/11 $
#   $Author: Stefan Tudose (a508763) <stefan.tudose@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Deliveryconf;
use Database;
use Cwd;
use LWP::UserAgent;
use HTTP::Request::Common;
use Config::Simple;
use JSON;

require "generate_bdd_from_existing_bdd.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger = Logger->new( "reprocess_existing_bdd_generation.pl",
    $config->param("logger.levels") );

my $deliveries_path      = $config->param("filer.delivery-ftp");
my $auto_detect_filename = $config->param("auto-detect.filename");
my $url_ws_entrepot      = $config->param("resources.ws.url.entrepot");
my $url_proxy            = $config->param("proxy.url");

sub reprocess_existing_bdd_generation {
    my ( $generation_id, $script_directory ) = @_;
    if ( !defined $generation_id ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (2)"
        );
        return 255;
    }
    $logger->log( "DEBUG", "Paramètre 1 : generation_id = " . $generation_id );

    if ( !defined $script_directory ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (2)"
        );
        return 255;
    }
    $logger->log( "DEBUG",
        "Paramètre 2 : script_directory = " . $script_directory );

    my $ua = LWP::UserAgent->new;
    if ( $url_proxy ne "none" ) {
        $ua->proxy( [ 'http', 'ftp' ], $url_proxy );
    }

    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/generation/getGeneration" );
    my $response =
      $ua->request( GET $url_ws_entrepot
          . "/generation/getGeneration?generationId="
          . $generation_id );

    if ( $response->is_success ) {
        $logger->log( "INFO",
            "Récupération de la génération d'identifiant "
              . $generation_id );
    }
    else {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la récupération de la génération "
              . $generation_id );
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

    $logger->log( "DEBUG",
"Récupération des informations depuis la livraison liée à la génération"
    );

    my $input_datas = $hash_response->{'inputDatas'};
    if ( defined @{$input_datas} ) {
        if ( scalar( @{$input_datas} ) != 1 ) {
            $logger->log( "ERROR",
                    "La génération demandée est lié à "
                  . scalar( @{$input_datas} )
                  . " données en entrée alors que ce type de traitement n'en attend que 1"
            );
            return 2;
        }
    }
    else {
        $logger->log( "ERROR",
"La génération demandée n'est lié à aucune donnée en entrée alors que ce type de traitement en attend 1"
        );
        return 2;
    }
    $logger->log( "DEBUG",
        scalar( @{$input_datas} ) . " donnée(s) liée(s) à la génération" );

    my $input_data_id = $input_datas->[0]->{'id'};
    if ( !$input_data_id ) {
        $logger->log( "ERROR", "La donnée en entrée n'a pas d'identifiant" );
        return 253;
    }
    $logger->log( "DEBUG",
        "Identifiant de la livraison en base : " . $input_data_id );

    my $source_schema_name = $input_datas->[0]->{'schemaName'};
    if ( !$source_schema_name ) {
        $logger->log( "ERROR", "La donnée en entrée n'a pas de schéma " );
        return 253;
    }
    $logger->log( "DEBUG",
        "Le schéma associé à la donnée en entrée : "
          . $source_schema_name );

    $logger->log( "DEBUG",
"Récupération des informations depuis la données de diffusion liée à la génération"
    );

    my $broadcast_datas = $hash_response->{'broadcastDatas'};
    if ( defined @{$broadcast_datas} ) {
        if ( scalar( @{$broadcast_datas} ) != 1 ) {
            $logger->log( "ERROR",
                    "La génération demandée est lié à "
                  . scalar( @{$broadcast_datas} )
                  . " données en sortie alors que ce type de traitement n'en attend que 1"
            );
            return 3;
        }
    }
    else {
        $logger->log( "ERROR",
"La génération demandée n'est lié à aucune donnée en sortie alors que ce type de traitement en attend 1"
        );
        return 3;
    }

    $logger->log( "DEBUG",
        scalar( @{$broadcast_datas} )
          . " donnée(s) de diffusion en sortie de la génération" );

    my $bd_version = $broadcast_datas->[0]->{'version'};
    if ( !$bd_version ) {
        $logger->log( "ERROR",
            "La données en sortie du processus ne possède pas de version" );
        return 253;
    }
    $logger->log( "DEBUG", "Version de la donnée de sortie : " . $bd_version );

    my $bd_id = $broadcast_datas->[0]->{'id'};
    if ( !$bd_id ) {
        $logger->log( "ERROR",
            "La données en sortie du processus ne possède pas d'identifiant"
        );
        return 253;
    }
    $logger->log( "DEBUG", "Identifiant de la donnée de sortie : " . $bd_id );

    $logger->log( "INFO",
        "Génération de la BDD à partir de la donnée de diffusion "
          . $input_data_id );

    my $target_schema_name =
      $source_schema_name . "_reprocessed_" . $bd_version;

    # Mise à jour de la donnée de diffusion
    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/generation/updatePgsqlBD" );
    $response = $ua->request(
        POST $url_ws_entrepot. "/generation/updatePgsqlBD",
        [
            broadcastDataId  => $bd_id,
            schemaName       => $target_schema_name,
            metadatasInspire => "",
            metadatasIsoap   => ""
        ]
    );

    if ( $response->is_success ) {
        $logger->log( "INFO",
                "Mise à jour de la donnée de diffusion " 
              . $bd_id
              . " effectuée" );
    }
    else {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour de la donnée de diffusion "
              . $bd_id );
        return 5;
    }

    $logger->log( "INFO",
        "Lancement du processus de génération de données BDD retravaillées "
    );
    my $return_generate_bdd_existing_bdd =
      generate_bdd_from_existing_bdd( $script_directory, $source_schema_name,
        $target_schema_name );
    $logger->log( "DEBUG",
        " --> Valeur de retour : " . $return_generate_bdd_existing_bdd );

    if ( $return_generate_bdd_existing_bdd != 0 ) {
        $logger->log( "ERROR",
"Une erreur est survenue lors de la génération de données BDD retravaillées "
        );
        return 4;
    }

    return 0;
}

