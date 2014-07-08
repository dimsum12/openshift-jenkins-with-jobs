#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will generate a pregenerated broadcast data using the generation id
#       First it collect informations from service REST
#       Then it copies all files from the delivery folder to the destination folder
#       Finally it update the broadcast data
# ARGS :
#   The generation ID
# RETURNS :
#   * 0 if generation is correct
#   * 1 if the REST service is not reacheable or if the ID is incorrect
#   * 2 if the generation is linked to many deliveries
#   * 3 if the generation is linked to many broadcast datas
#   * 4 if the delivery config file couldn't be load
#   * 5 if an error occured during copying datas to target directory
#   * 6 if an error occured during calculating size en md5 value to update the broadcast data
#   * 7 if an error occured calling REST service to add pre-package to the broadcast data
#   * 8 if an error occured during removing write permissions on the data storage
#   * 9 if an error occured during updating broadcastdata size
#   * 253 if the generation structure is incorrect
#   * 254 if the JSON return is not parseable
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 2 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/pregenerated_data_generation.pl $
#   $Date: 25/01/12 $
#   $Author: Stefan Tudose (a508763) <stefan.tudose@atos.net> $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Deliveryconf;
use Database;
use Execute;
use Cwd;
use LWP::UserAgent;
use HTTP::Request::Common;
use Config::Simple;
use File::Basename;
use JSON;

require "copy_data.pl";
require "create_md5.pl";
require "update_broadcastdata_size.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger = Logger->new( "pregenerated_data_generation.pl",
    $config->param("logger.levels") );

my $root_storage         = $config->param("filer.root.storage");
my $deliveries_path      = $config->param("filer.delivery-ftp");
my $auto_detect_filename = $config->param("auto-detect.filename");
my $url_ws_entrepot      = $config->param("resources.ws.url.entrepot");
my $url_proxy            = $config->param("proxy.url");
my $rmv_write_permission = $config->param("resources.rmv.write.permission");

sub pregenerated_data_generation {
    my ($generation_id) = @_;
    if ( !defined $generation_id ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : generation_id = " . $generation_id );

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
    if ( defined @{$input_datas} && scalar( @{$input_datas} ) != 1 ) {
        $logger->log( "ERROR",
                "La génération demandée est lié à "
              . scalar( @{$input_datas} )
              . " données en entrée alors que ce type de traitement n'en attend que 1"
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

    my $broadcast_datas = $hash_response->{'broadcastDatas'};
    if ( defined @{$broadcast_datas} && scalar( @{$broadcast_datas} ) != 1 ) {
        $logger->log( "ERROR",
                "La génération demandée est lié à "
              . scalar( @{$broadcast_datas} )
              . " données en sortie alors que ce type de traitement n'en attend que 1"
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

    my $destination_dir = $root_storage . $storage_path . '/' . $bd_id;
    $logger->log( "INFO", "Répertoire de destination : " . $destination_dir );

    # Read the configuration file
    my $deliveryconf =
      Deliveryconf->new( $deliveries_path . $delivery_login, $logger, $config );
    if ( !$deliveryconf ) {
        $logger->log( "ERROR",
"La données en sortie du processus n'est pas associé à un stockage "
        );
        return 4;
    }

    my @parts = $deliveryconf->get_parts();
    $logger->log( "INFO", scalar @parts . " paquet(s) à traiter" );
    for my $p_part (@parts) {
        my %part = %{$p_part};
        my $delivery_dir =
          $deliveries_path . $delivery_login . "/" . $part{dir_data} . '/';
        $logger->log( "INFO",
            "Récupération du répertoire du paquet : " . $delivery_dir );

        # Copy the datas to target directory
        $logger->log( "INFO",
"Lancement du processus de copie des données de diffusion prégénérées"
        );
        my $return_copy_data =
          copy_data( $delivery_dir, $destination_dir, "true" );
        if ( $return_copy_data != 0 ) {
            $logger->log( "ERROR",
                "Une erreur est survenue lors de la copie des données " );
            $logger->log( "ERROR",
                " --> Valeur de retour : " . $return_copy_data );
            return 5;
        }

        # Prepare update informations
        my $package_dir = $destination_dir . "/" . basename( $part{dir_data} );

        # List all the archive files in the directory
        my $cmd_list_archives = "ls -1 " . $package_dir;
        $logger->log( "DEBUG", "Appel à la commande : " . $cmd_list_archives );
        my $result_list_archives = Execute->run( $cmd_list_archives, "true" );
        if ( $result_list_archives->get_return() != 0 ) {
            $logger->log( "ERROR",
                "Erreur d'éxecution de la commande : " . $cmd_list_archives );
            $logger->log( "ERROR",
                " --> Valeur de retour : "
                  . $result_list_archives->get_return() );
            return 6;
        }

        for my $file ( $result_list_archives->get_log() ) {
            chomp $file;
            my $archive_file = $package_dir . "/" . $file;

            my $return_create_md5 = create_md5($archive_file);
            if ( $return_create_md5 != 0 ) {
                $logger->log( "ERROR",
                    "erreur durant l'appel à create_md5 sur "
                      . $archive_file );
                $logger->log( "ERROR",
                    "Code retour de la fonction create_md5 : "
                      . $return_create_md5 );
                return 6;
            }
        }

        my $string_update;
        my $cmd_list_md5 = "ls " . $package_dir . "/*.md5";
        $logger->log( "DEBUG",
"Appel à la commande listant les fichiers md5 dans le répertoire final : "
              . $cmd_list_md5 );
        my $return_list_md5 = Execute->run( $cmd_list_md5, "false" );
        my @archives_md5 = $return_list_md5->get_log();
        $logger->log( "DEBUG",
            "Nombre de fichiers md5 dans le dossier :" . scalar @archives_md5 );
        foreach my $md5_file (@archives_md5) {
            chomp $md5_file;

            my $md5_file_handler;
            if ( !open $md5_file_handler, "<", $md5_file ) {
                $logger->log( "ERROR",
                    "Impossible de lire le fichier  : " . $md5_file );

                return 6;
            }
            else {
                $logger->log( "DEBUG",
                    "Ouverture du fichier en lecture : " . $md5_file );
                while ( my $line = <$md5_file_handler> ) {
                    chomp $line;

                    my @md5_and_file = split / \*/, $line;
                    my $size = -s ( $package_dir . "/" . $md5_and_file[1] );
                    $logger->log( "DEBUG",
                            "Fichier "
                          . $md5_and_file[1]
                          . " - Taille : "
                          . $size
                          . " - Clé MD5 : "
                          . $md5_and_file[0] );

                    $string_update =
                        $string_update
                      . $md5_and_file[1] . ','
                      . $size . ','
                      . $md5_and_file[0] . ";";
                }
            }

            if ( !close $md5_file_handler ) {
                $logger->log( "ERROR",
                    "Impossible de fermer le fichier ouvert en lecture : "
                      . $md5_file );

                return 6;
            }
        }

        # Ajout du pré-package à la donnée de diffusion
        $logger->log( "DEBUG",
                "Appel au service REST : "
              . $url_ws_entrepot
              . "/generation/addDownloadableBroadcastData" );
        $response = $ua->request(
            POST $url_ws_entrepot. "/generation/addDownloadableBroadcastData",
            [
                broadcastDataId => $bd_id,
                name            => basename( $part{dir_data} ),
                format          => $part{format},
                projection      => $part{projection},
                zone            => $part{zone},
                release         => $part{release},
                resolution      => $part{resolution},
                fileList        => $string_update
            ]
        );

        if ( $response->is_success ) {
            $logger->log( "INFO", "Ajout du pré-package effectué" );
        }
        else {
            $logger->log( "ERROR",
                "Une erreur s'est produite lors de l'ajout du pré-package" );
            return 7;
        }
    }

    # Remove write permission for all to the destination directory
    my $cmd_rmv_write_permission =
      $rmv_write_permission . " " . $destination_dir;
    $logger->log( "DEBUG",
        "Appel à la commande : " . $cmd_rmv_write_permission );
    my $result_rmv_write_permission =
      Execute->run( $cmd_rmv_write_permission, "true" );
    if ( $result_rmv_write_permission->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Erreur d'éxecution de la commande" . $cmd_rmv_write_permission );
        $logger->log( "ERROR",
            " --> Valeur de retour : "
              . $result_rmv_write_permission->get_return() );
        return 8;
    }

    # MAJ de la taille totale de la donnée de diffusion
    if ( update_broadcastdata_size( $destination_dir, $bd_id, 0 ) ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour de la taille de la donnée de diffusion "
              . $bd_id );
        return 9;

    }

    return 0;
}

