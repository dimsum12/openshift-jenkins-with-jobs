
#########################################################################################################################
#
# USAGE :
#   This script will generate a dematerialized data broadcast data using the generation id
#       First it collect informations from service REST
#       Then it plays all SQL or SHP files from the delivery linked to the generation
#       Finally it update the broadcast data with schema information
# ARGS :
#   The generation ID
# RETURNS :
#   * 0 if generation is correct
#   * 1 if the REST service is not reacheable or if the ID is incorrect
#   * 2 if the generation is linked to many deliveries
#   * 3 if the generation is linked to many broadcast datas
#   * 4 if the delivery used does not contains an information file
#   * 5 if there was an error during file copy
#   * 6 if the REST service for updating the broadcast data send an error
#   * 7 if the delivery has no missions
#   * 8 if the mission has no entities
#   * 9 if the REST service for updating entities of broadcast data send an error
#   * 10 if the REST service for updating bd size send an error
#   * 253 if the generation structure is incorrect
#   * 254 if the JSON return is not parseable
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/demat_data_generation.pl $
#   $Date: 20/10/11 $
#   $Author: Charles-Henri Biller (a149912) <charles-henri.biller@atos.net> $
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
use WebserviceTools;
use Config::Simple;
use JSON;
use Execute;

use XML::XPath;
use XML::XPath::XMLParser;

require "harvest_generation.pl";
require "update_broadcastdata_size.pl";
require "copy_data.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

our $deliveryconf;

my $logger =
  Logger->new( "demat_data_generation.pl", $config->param("logger.levels") );

my $root_storage         = $config->param("filer.root.storage");
my $xpath_geometry_gml   = $config->param("metadata.xpath.geometry.gml");
my $deliveries_path      = $config->param("filer.delivery-ftp");
my $auto_detect_filename = $config->param("auto-detect.filename");
my $url_ws_entrepot      = $config->param("resources.ws.url.entrepot");
my $url_proxy            = $config->param("proxy.url");
my $rmv_write_permission = $config->param("resources.rmv.write.permission");

sub demat_data_generation {

    # Extraction des paramètres
    my ($generation_id) = @_;
    if ( !defined $generation_id ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : generation_id = " . $generation_id );

    # Appel au web service pour récupérer la génération à effectuer
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
    $logger->log( "DEBUG", $response->decoded_content );

    # Conversion de la réponse JSON en structure PERL
    my $json_response = $response->decoded_content;
    my $hash_response = JSON::from_json($json_response);
    if ( !$hash_response ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la conversion de la réponse JSON"
        );
        return 254;
    }

    # Lecture des données en entrée
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

    my $delivery_login = $input_datas->[0]->{'login'};
    if ( !$delivery_login ) {
        $logger->log( "ERROR",
            "La donnée en entrée du processus n'est pas de type Delivery" );
        return 2;
    }
    $logger->log( "DEBUG",
        "Login de la livraison en base : " . $delivery_login );

    my $delivery_id = $input_datas->[0]->{'id'};
    if ( !$delivery_id ) {
        $logger->log( "ERROR", "La donnée en entrée n'a pas d'identifiant" );
        return 253;
    }
    $logger->log( "DEBUG",
        "Identifiant de la livraison en base : " . $delivery_id );

    my $delivery_product = $input_datas->[0]->{'deliveryProduct'};
    if ( !$delivery_product ) {
        $logger->log( "ERROR",
            "La donnée en entrée n'a pas de produit de livraison défini" );
        return 253;
    }
    my $delivery_product_name = $delivery_product->{'name'};
    if ( !$delivery_product_name ) {
        $logger->log( "ERROR",
            "Le produit de livraison de la donnée en entrée n'a pas de nom" );
        return 253;
    }
    $logger->log( "DEBUG",
        "Nom du produit de livraison en base : " . $delivery_product_name );

    $logger->log( "DEBUG",
"Récupération des informations depuis la données de diffusion liée à la génération"
    );

    # Lecture des données en sortie
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
        "Intégration en BDD à partir de la livraison " . $delivery_id );

    my $delivery_dir = $deliveries_path . $delivery_login;
    $logger->log( "INFO",
        "Récupération du repertoire de la livraison : " . $delivery_dir );

    # Récupération des informations du fichier d'informations complémentaires
    if ( not( defined $deliveryconf ) ) {
        $deliveryconf = Deliveryconf->new( $delivery_dir, $logger, $config );
        if ( !$deliveryconf ) {
            return 4;
        }
    }

    # Récupération des informations de stockage
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

    my $destination_dir = $root_storage . "/" . $storage_path . '/' . $bd_id;
    $logger->log( "INFO", "Répertoire de destination : " . $destination_dir );

    # Traitement individuel des missions PVA
    my @parts = $deliveryconf->get_parts();
    $logger->log( "INFO", scalar @parts . " paquet(s) à traiter" );
    my ( @missions, @entities, %hash_demat );

    foreach my $p_part (@parts) {
        my %part             = %{$p_part};
        my $mission_data_dir = $delivery_dir . "/" . $part{dir_data};
        my $mission_metadata_dir =
          $delivery_dir . "/" . $part{dir_metadata_pva};
        my $mission = $part{name};

        $logger->log( "INFO", "Copie des données de la mission " . $mission );
        my $return_copy_data =
          copy_data( $mission_data_dir, $destination_dir . "/" . $part{name} );
        $logger->log( "DEBUG", " --> Valeur de retour : " . $return_copy_data );

        if ( $return_copy_data != 0 ) {
            $logger->log( "ERROR",
                "Une erreur est survenue lors de la copie des données " );
            return 5;
        }

        # Récupération des entités
        my $cmd_find = "cd " . $mission_data_dir . "; find -type f";
        $logger->log( "DEBUG", "Appel à la commande : " . $cmd_find );
        my $cmd_find_result = Execute->run( $cmd_find, "true" );
        if ( $cmd_find_result->get_return() != 0 ) {
            $logger->log( "ERROR",
                "Erreur lors de la récupération des entités d'une mission : "
                  . $cmd_find );
            return 8;
        }
        my @entities = $cmd_find_result->get_log();
        $logger->log( "DEBUG", scalar @entities . " entité(s) trouvée(s)" );

        push( @missions, $mission );
        foreach my $entity (@entities) {
            chomp $entity;
            $hash_demat{$entity} = $mission;
        }

        # Harvest des métadonnées
        $logger->log( "INFO", "Moissonage des métadonnées" );
        my $return_harvest_generation =
          harvest_generation( $mission_metadata_dir, $bd_id );
        if ( $return_harvest_generation != 0 ) {
            $logger->log( "ERROR",
                "Erreur lors du moissonnage des métadonnées." );
            $logger->log( "DEBUG",
                "Code retour : " . $return_harvest_generation );

            return 8;
        }
    }

    # Remove write permission for all to the destination directory
    my $cmd_rmv_write_permission =
      $rmv_write_permission . " " . $destination_dir;
    $logger->log( "DEBUG",
        "Appel à la commande : " . $cmd_rmv_write_permission );
    my $cmd_rmv_write_permission_result =
      Execute->run( $cmd_rmv_write_permission, "true" );
    if ( $cmd_rmv_write_permission_result->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de la suppression des drotis en écriture sur "
              . $destination_dir );
        return 8;
    }

    # Mise à jour de la données de diffusion
    $response = $ua->request(
        POST $url_ws_entrepot. "/generation/updateDematBD",
        [
            broadcastDataId   => $bd_id,
            dematEntitiesName => \@missions,
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
        return 7;
    }

    # Mise à jour des métadonnées par mission
    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/generation/updateDematEntities" );
    $response = $ua->request(
        POST $url_ws_entrepot. "/generation/updateDematEntities",
        Content_Type => 'application/json',
        Content      => JSON->new->encode( \%hash_demat )
    );

    $logger->log( "DEBUG", JSON->new->encode( \%hash_demat ) );
    if ( $response->is_success ) {
        $logger->log( "INFO",
                "Mise à jour de la donnée de diffusion " 
              . $bd_id
              . " effectuée" );
    }
    else {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour des entités dématérialisées associées à la donnée de diffusion "
              . $bd_id );
        return 9;
    }

    # MAJ de la taille totale de la donnée de diffusion
    if ( update_broadcastdata_size( $destination_dir, $bd_id, 0 ) ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour de la taille de la donnée de diffusion "
              . $bd_id );
        return 10;

    }

    return 0;
}
