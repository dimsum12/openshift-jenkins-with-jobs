#!/usr/bin/perl
##########################################################################################################################################
#
# USAGE :
#   This script will extract data from a given Web Service
# ARGS :
#   The extraction id
# RETURNS :
#   * 0 if the extraction is Ok
#   * 1 if the REST service is not reacheable or if the ID is incorrect
#   * 2 if the process is not linked to only one output broadcast data
#   * 3 if an error occured during extraction process
#   * 4 if an error occured during calculating md5 and size values for packaged files
#   * 5 if an error occured updating the broadcast data using REST service
#	* 6 if an error occured deleting temporary files
#	* 7 if an error occured when updating data size
#   * 253 if the extraction structure is incorrect
#   * 254 if the json response cannot be decoded
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 3 $
#   $Source src/main/scripts/fr/geoportail/entrepot/extraction/high-level/extraction_boutique.pl $
#   $Date: 22/12/11 $
#   $Author: Maimouna Deme (a510440) <maimouna.deme@atos.net> $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
############################################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use WebserviceTools;
use Cwd;
use HTTP::Request::Common;
use Config::Simple;
use Execute;
use Tools;
use POSIX qw(strftime);
use IO::File;
use List::Util qw(max);
use List::Util qw(min);
use XML::XPath;
use XML::XPath::XMLParser;
use LWP::UserAgent;

## Importing perl scripts

require "extraction.pl";
require "update_broadcastdata_size.pl";

## Script Version

our $VERSION = "1.0";

## Configuration file loading

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger =
  Logger->new( "extraction_boutique.pl", $config->param("logger.levels") );

## Configuration values

my $url_ws_entrepot = $config->param("resources.ws.url.entrepot");
my $url_proxy       = $config->param("proxy.url");
my $resources_path  = $config->param("resources.path");
my $java_bin        = $config->param("resources.java");
my $tmp_path        = $config->param("resources.tmp.path");
my $tmp_extraction  = $config->param("resources.tmp.extractions");
my $download_filer  = $config->param("download.filer");
my $extraction_key  = $config->param("resources.extraction.key");
my $root_storage    = $config->param("filer.root.storage");
my $retry_attempts  = $config->param("resources.ws.entrepot.retry.attempts");
my $retry_waitingtime =
  $config->param("resources.ws.entrepot.retry.waitingtime");

###############
# Main Method #
###############

sub extraction_boutique {

## Parsing des parametres en entree

    my ($extraction_id) = @_;
    if ( !defined $extraction_id ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : extraction_id = " . $extraction_id );

## Appel au web service de l'entrepot pour recuperer le detail de la demande d'extraction

    my $ws = WebserviceTools->new(
        'GET',
        $url_ws_entrepot
          . "/extraction/getExtraction?extractionId="
          . $extraction_id,
        $url_proxy
    );

    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/extraction/getExtraction" );

    my $result = $ws->run( $retry_attempts, $retry_waitingtime );

    if ( !$result ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la récupération de l'extraction d'identifiant :"
              . $extraction_id );
        $logger->log( "ERROR", "l'erreur est : " . $ws->get_content() );
        return 1;
    }

    my $hash_response = $ws->get_json();

    if ( !$hash_response ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la conversion de la réponse JSON"
        );
        return 254;
    }
    $logger->log( "DEBUG", "Récupération des informations de l'extraction" );

## Lecture de la partie de la demande concernant les donnees a produire en sortie

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

## Lecture des parametres propres a la demande d'extraction

    ## Parametres delivery

    my $purchase_id = $hash_response->{'purchaseId'};
    if ( !defined $purchase_id ) {
        $purchase_id = $bd_id . strftime "%d-%m-%y", localtime;
        $logger->log( "WARN",
"l'identifiant de la commande n'est pas défini dans la demande, il est mis à "
              . $purchase_id );
    }
    $logger->log( "DEBUG", "Identifiant de la commande : " . $purchase_id );

    my $zip_name = $hash_response->{'zipName'};
    if ( !defined $zip_name ) {
        $zip_name = $bd_id . strftime "%d-%m-%y", localtime;
        $logger->log( "INFO",
            "Le nom du package à créer n'est pas défini, il est mis à "
              . $zip_name );
    }
    $logger->log( "DEBUG", "Nom du package à créer : " . $zip_name );

    my $zip_max_size = $hash_response->{'zipMaxSize'};
    if ( !defined $zip_max_size ) {
        $logger->log( "ERROR",
            "L'extraction ne possède pas de taille de découpe des zip" );
        return 253;
    }
    $logger->log( "DEBUG", "Taille de découpe des zip : " . $zip_max_size );

    my $product_id = $hash_response->{'productId'};
    if ( !defined $product_id ) {
        $logger->log( "ERROR",
            "L'extraction ne possède pas d'identifiant de produit" );
        return 253;
    }
    $logger->log( "DEBUG",
        "Identifiant de produit de l'extraction : " . $product_id );

    my $packaging_id = $hash_response->{'packagingId'};
    if ( !defined $packaging_id ) {
        $logger->log( "ERROR",
            "L'extraction ne possède pas d'identifiant de packaging" );
        return 253;
    }
    $logger->log( "DEBUG", "Identifiant de packaging : " . $packaging_id );

    my $root_folder = $hash_response->{'rootFolder'};
    if ( !defined $root_folder ) {
        $logger->log( "ERROR", "L'extraction ne possède pas de rootFolder" );
        return 253;
    }
    $logger->log( "DEBUG", "Identifiant de rootFolder : " . $root_folder );

    #my $manager_id = $hash_response->{'managerId'};
    #if ( !defined $manager_id ) {
    #    $logger->log( "ERROR",
    #        "L'extraction ne possède pas d'identifiant de manager (clé)" );
    #    return 253;
    #}
    #$logger->log( "DEBUG", "Identifiant du manager : " . $manager_id );
    $logger->log( "DEBUG", "Identifiant du manager : " . $extraction_key );

    ## Parametres des extractions WMS et WFS	

    my $wfs_extraction_array = $hash_response->{'extractionsWFS'};
    my $wms_extraction_array = $hash_response->{'extractionsWMS'};
    if (   !defined @{$wfs_extraction_array}
        && !defined @{$wms_extraction_array} )
    {
        $logger->log( "ERROR",
            "La demande d'extraction ne possède aucune extraction" );
        return 253;
    }

## Creation du nom du repertoire de travail temporaire de l'extraction

    my $tmp_output_storage =
      $tmp_path . $tmp_extraction . "/" . $extraction_id . "/" . $root_folder;
    $logger->log( "INFO",
        "L'extraction temporaire sera effectuée vers : "
          . $tmp_output_storage );

## Creation du nom du repertoire de destination de l'extraction

    my $extraction_output_storage =
      $root_storage . $storage_path . "/" . $bd_id;
    $logger->log( "INFO",
        "Le packaging final sera effectué vers : "
          . $extraction_output_storage );

    
## APPEL AU SCRIPT REALISANT LES EXTRACTIONS ##
#--------------------#------------------------#

    my $return_extraction = extraction(
        $packaging_id,         $product_id,
        $purchase_id,          $extraction_key,
        $zip_name,             $zip_max_size,
        $wfs_extraction_array, $wms_extraction_array,
        $tmp_output_storage,   $extraction_output_storage,
        $extraction_id
    );

    if ( 0 != $return_extraction ) {
        $logger->log( "ERROR",
            "Impossible d'extraire les données demandées" );
        $logger->log( "ERROR",
            "Code retour de la fonction extraction : " . $return_extraction );
        return 3;
    }

## Préparation des informations pour la mis a jour de la donnée de diffusn finale

    my $string_update = "";

    my $cmd_list_md5 = "ls " . $extraction_output_storage . "/*.md5";
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

            return 4;
        }
        else {
            $logger->log( "DEBUG",
                "Ouverture du fichier en lecture : " . $md5_file );
            while ( my $line = <$md5_file_handler> ) {
                chomp $line;

                my @md5_and_file = split / \*/, $line;
                my $size =
                  -s ( $extraction_output_storage . "/" . $md5_and_file[1] );
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

            return 4;
        }
    }
    $logger->log( "DEBUG",
        "La chaine de mise à jour de la broadcastdata est :"
          . $string_update );

 ## Appel au service REST de mise a jour de la donnée de diffusion

    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/extraction/updateExtraction" );

    my $ua = LWP::UserAgent->new;
    if ( $url_proxy ne "none" ) {
        $logger->log( "DEBUG", "Utilisation du proxy : " . $url_proxy );
        $ua->proxy( [ 'http', 'ftp' ], $url_proxy );
    }

    my $response_update_broadcastdata = $ua->request(
        POST $url_ws_entrepot. "/extraction/updateExtraction",
        [
            broadcastDataId => $bd_id,
            fileList        => $string_update
        ]
    );

    if ( $response_update_broadcastdata->is_success ) {
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

## MAJ de la taille totale de la donnée de diffusion

    if ( update_broadcastdata_size( $extraction_output_storage, $bd_id, 0 ) ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour de la taille de la donnée de diffusion "
              . $bd_id );
        return 7;

    }

## Suppression du dossier temporaire

    $logger->log( "INFO",
        "Suppression du répertoire temporaire " . $tmp_output_storage );
    my $delete_tmp_cmd = "rm -rf " . $tmp_output_storage;
    my $delete_tmp_return = Execute->run( $delete_tmp_cmd, "true" );
    if ( $delete_tmp_return->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Impossible de supprimer le répertoire temporaire "
              . $tmp_output_storage );
        $delete_tmp_return->log_all( $logger, "DEBUG" );
        return 6;
    }

    return 0;
}
1;
