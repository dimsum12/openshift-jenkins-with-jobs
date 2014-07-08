#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script do a uplaod check on a delivery
# ARGS :
#   The delivery ID
# RETURNS :
#   * 0 if verification is correct
#   * 1 if delivery repo does not exists
#   * 2 check MD5 failed
#   * 3 error during calling Webservice to cretae new BroadcastData
#   * 4 JSON conversion failed
#   * 5 broadcastdata does not have an id
#   * 6 broadcastdata does not have a storage
#   * 7 broadcastdata storage does not have a logicalName
#   * 8 root storage path does not exists
#   * 9 create directory for BD failed
#   * 10 copy of data from delivery to BD failed
#   * 11 update of BD via webservice failed
#	* 12 a directory exists in delivery folder
#	* 13 a file size in delivery folder exceed limit
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/check/high-level/upload_check.pl $
#   $Date: 17/08/11 $
#   $Author: Nicolas Godelu (a184059) <nicolas.godelu@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;
use DBI;
use LWP::UserAgent;
use File::Basename;
use HTTP::Request::Common;
use JSON;
use Execute;

require "check_md5.pl";
require "copy_folder_content_to.pl";
require "create_folder.pl";
require "check_size.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger = Logger->new( "upload_check.pl", $config->param("logger.levels") );

my $deliveries_path = $config->param("filer.delivery-ftp");
my $warning_chain   = $config->param("check.warning.chain");
my $root_path       = $config->param("filer.root.storage");
my $max_file_size   = $config->param("check.maxfilesize");

my $url_ws_entrepot = $config->param("resources.ws.url.entrepot");
my $url_proxy       = $config->param("proxy.url");

sub upload_check {

    # Parameters number validation
    my ($delivery_id) = @_;
    if ( !defined $delivery_id ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }
    $logger->log( "INFO", "Vérification du dépôt " . $delivery_id );

    # contruct delivery dir
    my $delivery_dir = $deliveries_path . "FTP-" . $delivery_id . "/";
    $logger->log( "DEBUG", " le depot se situe ici : " . $delivery_dir );
    if ( !-e $delivery_dir ) {
        $logger->log( "ERROR", "le dossier de la livraison n'existe pas" );
        return 1;
    }

    # check MD5
    $logger->log( "INFO", "Vérification des clés md5" );
    my $return_check_md5 = check_md5( $delivery_dir, $delivery_dir );
    if ( $return_check_md5 != 0 ) {
        $logger->log( "ERROR", "Au moins une vérification md5 est en erreur" );
        return 2;
    }

    # check that delivery directory does not contain directory
    $logger->log( "INFO", "Vérification de l'existence de dossier" );
    my $cmd_list_directories = "find " . $delivery_dir . " -type d";
    $logger->log( "DEBUG",
        "Appel à la commande comptant listant les dossiers : "
          . $cmd_list_directories );
    my $result_find_directories =
      Execute->run( $cmd_list_directories, "false" );
    my @directories  = $result_find_directories->get_log();
    my $nb_directory = scalar @directories;
    $logger->log( "DEBUG", "number of directories is : " . $nb_directory );

    if ( $nb_directory > 1 ) {
        $logger->log( "ERROR",
"Le dossier de livraison ne devrait contenir aucun dossier. Il en existe "
              . $nb_directory );
        return 12;
    }

    # check that delivery directory does not contain files too big
    $logger->log( "INFO", "Vérification de la taille des fichiers déposés" );
    my $return_check_size_file = check_size( $delivery_dir, $max_file_size );
    if ( $return_check_size_file != 0 ) {
        $logger->log( "ERROR", "Au moins un fichier est trop volumineux" );
        return 13;
    }

# get the directory where to transfer data - Appel au web service pour récupérer la broadcastdata à effectuer
    my $ua = LWP::UserAgent->new;
    if ( $url_proxy ne "none" ) {
        $ua->proxy( [ 'http', 'ftp' ], $url_proxy );
    }

    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/delivery/generateBroadcastDataForUpload" );

    my $response =
      $ua->request( POST $url_ws_entrepot
          . "/delivery/generateBroadcastDataForUpload?deliveryId="
          . $delivery_id );

    if ( $response->is_success ) {
        $logger->log( "INFO",
            "Récupération de la boradcastdata pour la delivery d'identifiant "
              . $delivery_id );
    }
    else {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la récupération de la broadcastdata pour la livraison "
              . $delivery_id );
        $logger->log( "ERROR", "l'erreur est : " . $response->content );
        return 3;
    }

    # Conversion de la réponse JSON en structure PERL
    my $json_response = $response->decoded_content;
    my $hash_response = JSON::from_json($json_response);
    if ( !$hash_response ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la conversion de la réponse JSON"
        );
        return 4;
    }

    my $bd_id = $hash_response->{'id'};
    if ( !$bd_id ) {
        $logger->log( "ERROR", "La broadcastData n'a pas d'id" );
        return 5;
    }
    $logger->log( "DEBUG", "l'id de la broadcastData : " . $bd_id );

    my $storage = $hash_response->{'storage'};
    if ( !$storage ) {
        $logger->log( "ERROR", "La broadcastData n'a pas de storage" );
        return 6;
    }
    my $storage_logical_name = $storage->{'logicalName'};
    if ( !$storage_logical_name ) {
        $logger->log( "ERROR", "Le storage n'a pas de logical name" );
        return 7;
    }

    $logger->log( "DEBUG",
        "le nom du storage de la broadcastData : " . $storage_logical_name );

    my $storage_path = $root_path . $storage_logical_name . "/";
    $logger->log( "DEBUG",
        "le repertoire où créer la donnée est  : " . $storage_path );

    if ( !( -e $storage_path ) ) {
        $logger->log( "ERROR", "le répertoire du storage n'existe pas" );
        return 8;
    }

    my $bd_path = $storage_path . $bd_id . "/";
    $logger->log( "INFO", "le repertoire à créer est  : " . $bd_path );

    # copy data
    my $return_create_directory = create_folder($bd_path);
    if ( $return_create_directory != 0 ) {
        $logger->log( "ERROR", "Impossible de créer le dossier " . $bd_path );
        return 9;
    }

    my $return_copy_data = copy_folder_content_to( $delivery_dir, $bd_path );
    if ( $return_copy_data != 0 ) {
        $logger->log( "ERROR", "Impossible de copier les données" );
        return 10;
    }

    # collect data on files
    my $string_update = "";
    my @archives_md5  = `ls $bd_path*.md5`;
    $logger->log( "DEBUG",
        "Nombre de fichiers md5 dans le dossier :" . scalar @archives_md5 );

    foreach my $md5_file (@archives_md5) {
        chomp $md5_file;

        my $md5_handler;
        if ( !open $md5_handler, "<", $md5_file ) {
            $logger->log( "ERROR",
                "Impossible de lire le fichier  : " . $md5_file );
            return 1;
        }
        else {
            $logger->log( "INFO", "Lecture du fichier  : " . $md5_file );
            while ( my $line = <$md5_handler> ) {
                chomp($line);
                my @md5_and_file = split ' ', $line, 2;
                $logger->log( "DEBUG",
                    "Taille du tableau:" . scalar @md5_and_file );

                my $md5 = $md5_and_file[0];
                $logger->log( "DEBUG", "md5 :" . $md5 );
                my $file_name = $md5_and_file[1];
                chomp $file_name;
                $logger->log( "DEBUG", "filename :" . $file_name );

                my $file_path = $bd_path . $file_name;
                $logger->log( "DEBUG", "file_path :" . $file_path );
                my $size = -s $file_path;
                $logger->log( "DEBUG", "Taille de l'archive :" . $size );
                $string_update =
                  $string_update . $file_name . ',' . $size . ',' . $md5 . ";";
            }
        }

        if ( !close $md5_handler ) {
            $logger->log( "ERROR",
                "Impossible de fermer le fichier ouvert en Ã©criture : "
                  . $md5_file );

            return 5;
        }

        ###############

    }
    $logger->log( "DEBUG",
        "La chaine de mise à jour de la broadcastdata est : "
          . $string_update );

    #call to update with string_update
    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/extraction/updateExtraction" );

    my $response_update_broadcastdata =
      $ua->request( POST $url_ws_entrepot
          . "/extraction/updateExtraction?fileList="
          . $string_update
          . "&broadcastDataId="
          . $bd_id );

    if ( $response_update_broadcastdata->is_success ) {
        $logger->log( "DEBUG",
            "La broadcastData a été mise à  jour avec succès !" );
    }
    else {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à  jour de la broadcastdata: "
              . $response_update_broadcastdata->content );
        return 11;
    }

    return 0;
}
