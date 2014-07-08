#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will create a joincache configuration using the generation id
#       First it collect information from service REST
#		Then, it reads the input configuration file to collect
#			information on the bboxes used and the composition.
#		Then, it calls rest service to update broadcast data, bboxes, metadatas
#			and size of broadcast data.
#       Finally it creates the joincache configuration file.
# ARGS :
#   The generation ID
#	The configuration file name.
#	The compression
#	The number of samples per pixel
#	The photometric
#	The number of  bits per sample
#	The sample format
#
# RETURNS :
#	* 0 if generation is correct
#	* 1 if the REST service is not reacheable or if the ID is incorrect
#	* 2 if the generation doesn't have any input data
#	* 3 if all input datas don't have the same tms
#	* 4 if all input datas don't have the same format
#   * 5 if the generation is linked to no broadcast data
#   * 6 if the generation is linked to many broadcast datas
#	* 7 if an error occured while creating or writing the joincache configuration file
#   * 8 if an error occured while creating the pyramid directories in storage
#   * 9 if an error occured while creating the temporary directory
#	* 10 if an error occured with input configuration file
#	* 11 if one or more broadcast product of input cfg file is not present in input datas
#	* 12 if a pyramid not exists on disk
#	* 13 if an error occured when updating the BD
#	* 14 if an error occured while executing joincache
#	* 252 if the input configuration file is not correct
#   * 253 if the generation structure is incorrect
#   * 254 if the JSON return is not parseable
#   * 255 if the function is called an incorrect number of arguments
#
# KEYWORDS
#   $Revision 3 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/joincache_generation.pl $
#   $Date: 24/05/12 $
#   $Author: Kevin Ferrier (a536112) <kevin.ferrier@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Database;
use Execute;
use Cwd;
use LWP::UserAgent;
use HTTP::Request::Common;
use Config::Simple;
use JSON;
use Tools;
use Readonly;
use DateTime;

require "create_joincache_conf.pl";
require "update_broadcastdata_size.pl";

our $VERSION = "3.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger =
  Logger->new( "joincache_generation.pl", $config->param("logger.levels") );

my $tmp_path        = $config->param("resources.tmp.path");
my $tmp_generation  = $config->param("resources.tmp.generations");
my $url_ws_entrepot = $config->param("resources.ws.url.entrepot");
my $cmd_more        = $config->param("resources.more");

my $url_proxy = $config->param("proxy.url");

my $root_storage = $config->param("filer.root.storage");
chop $root_storage;

my $tmp_dir_name      = $config->param("joincache.tmp_dir_name");
my $scripts_dir_name  = $config->param("joincache.scripts_dir_name");
my $config_file_name  = $config->param("joincache.specific_conf_filename");
my $pyramid_dir       = $config->param("joincache.pyramid_dir");
my $pyramid_extension = $config->param("joincache.pyramid_extension");
my $image_dir         = $config->param("joincache.image_dir");
my $metadata_dir      = $config->param("joincache.metadata_dir");
my $nodata_dir        = $config->param("joincache.nodata_dir");
my $tms_dir           = $config->param("joincache.tms_dir");
my $job_number        = $config->param("joincache.job_number");
my $cmd_joincache     = $config->param("joincache.cmd");
my $tms_path          = $config->param("joincache.tms_path");

my $static_referentiel_dir = $config->param("static_ref.static_referentiel");
my $joincache_conf_dir     = $config->param("static_ref.joincache_conf");

my $tms_extension = ".tms";
my $xml_tag_crs   = "crs";

my $srid                 = "4326";
my $bbox_x1              = "-180";
my $bbox_y1              = "-90";
my $bbox_x2              = "180";
my $bbox_y2              = "90";
my $key_srid             = "SRID=";
my $start_polygon        = ";POLYGON((";
my $end_polygon          = "))";
my $coordinate_separator = " ";
my $point_separator      = ",";

Readonly my $GENERATION_SUCCESSFUL                         => 0;
Readonly my $ERROR_RESTSERVICE_UNREACHABLE_OR_ID_INCORRECT => 1;
Readonly my $ERROR_GENERATION_NO_INPUT_DATA                => 2;
Readonly my $ERROR_NOT_SAME_TMS                            => 3;
Readonly my $ERROR_NOT_SAME_FORMAT                         => 4;
Readonly my $ERROR_NO_BROADCAST_DATA                       => 5;
Readonly my $ERROR_TOO_MANY_BROADCAST_DATA                 => 6;
Readonly my $ERROR_CREATING_CFG_FILE                       => 7;
Readonly my $ERROR_CREATING_PYR_DIR                        => 8;
Readonly my $ERROR_CREATING_TMP_DIR                        => 9;
Readonly my $ERROR_INPUT_CFG_FILE                          => 10;
Readonly my $ERROR_PRODUIT_DIFFUSION_NON_PRESENT           => 11;
Readonly my $ERROR_PYRAMID_NOT_EXISTS                      => 12;
Readonly my $ERROR_UPDATING_BROADCAST_DATA                 => 13;
Readonly my $ERROR_EXECUTING_JOINCACHE                     => 14;
Readonly my $ERROR_INPUT_CFG_FILE_STRUCTURE_INCORRECT      => 252;
Readonly my $ERROR_GENERATION_STRUCTURE_INCORRECT          => 253;
Readonly my $ERROR_JSON_NOT_PARSEABLE                      => 254;
Readonly my $ERROR_INCORRECT_NUMBER_OF_ARGS                => 255;

sub joincache_generation {

    # Extraction des paramètres
    my ( $generation_id, $configuration_file_name, $compression,
        $samplesperpixel, $photometric, $bitspersample, $sampleformat,
        $merge_method )
      = @_;
    if (   !defined $generation_id
        || !defined $configuration_file_name
        || !defined $compression
        || !defined $samplesperpixel
        || !defined $photometric
        || !defined $bitspersample
        || !defined $sampleformat
        || !defined $merge_method )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (8)"
        );
        return $ERROR_INCORRECT_NUMBER_OF_ARGS;
    }

    $logger->log( "DEBUG", "Paramètre 1 : generation_id = " . $generation_id );
    $logger->log( "DEBUG",
        "Paramètre 2 : configuration_file_name = "
          . $configuration_file_name );
    $logger->log( "DEBUG", "Paramètre 3 : compression = " . $compression );
    $logger->log( "DEBUG",
        "Paramètre 4 : samplesperpixel = " . $samplesperpixel );
    $logger->log( "DEBUG", "Paramètre 5 : photometric = " . $photometric );
    $logger->log( "DEBUG", "Paramètre 6 : bitspersample = " . $bitspersample );
    $logger->log( "DEBUG", "Paramètre 7 : sampleformat = " . $sampleformat );
    $logger->log( "DEBUG", "Paramètre 8 : merge_method = " . $merge_method );

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
        return $ERROR_RESTSERVICE_UNREACHABLE_OR_ID_INCORRECT;
    }

    # Conversion de la réponse JSON en structure PERL
    my $json_response = $response->decoded_content;
    my $hash_response = JSON::from_json($json_response);
    if ( !$hash_response ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la conversion de la réponse JSON"
        );
        return $ERROR_JSON_NOT_PARSEABLE;
    }

    # Lecture des données en entrée
    $logger->log( "DEBUG",
"Récupération des informations depuis la livraison liée à la génération"
    );

    my $input_datas = $hash_response->{'inputDatas'};

    my $return_check_same_information = check_same_information($input_datas);
    if ( $return_check_same_information != 0 ) {
        return $return_check_same_information;
    }

    my $tms_name = $input_datas->[0]->{'tmsName'};

    $logger->log( "DEBUG",
        scalar( @{$input_datas} ) . " donnée(s) liée(s) à la génération" );

    # Lecture des données en sortie
    my $broadcast_datas = $hash_response->{'broadcastDatas'};
    if ( defined @{$broadcast_datas} ) {
        if ( scalar( @{$broadcast_datas} ) != 1 ) {
            $logger->log( "ERROR",
                    "La génération demandée est liée à "
                  . scalar( @{$broadcast_datas} )
                  . " données en sortie alors que ce type de traitement n'en attend que 1"
            );
            return $ERROR_TOO_MANY_BROADCAST_DATA;
        }
    }
    else {
        $logger->log( "ERROR",
"La génération demandée n'est liée à aucune donnée en sortie alors que ce type de traitement en attend 1"
        );
        return $ERROR_NO_BROADCAST_DATA;
    }
    $logger->log( "DEBUG",
        scalar( @{$broadcast_datas} )
          . " donnée(s) de diffusion en sortie de la génération" );

    my $bd_id = $broadcast_datas->[0]->{'id'};
    if ( !$bd_id ) {
        $logger->log( "ERROR",
            "La données en sortie du processus ne possède pas d'identifiant"
        );
        return $ERROR_GENERATION_STRUCTURE_INCORRECT;
    }
    $logger->log( "DEBUG", "Identifiant de la donnée de sortie : " . $bd_id );

    my $bd_name = $broadcast_datas->[0]->{'name'};
    if ( !$bd_name ) {
        $logger->log( "ERROR",
            "La données en sortie du processus ne possède pas de nom" );
        return $ERROR_GENERATION_STRUCTURE_INCORRECT;
    }
    $logger->log( "DEBUG", "Nom de la donnée de sortie : " . $bd_name );

    my $storage = $broadcast_datas->[0]->{'storage'};
    if ( !$storage ) {
        $logger->log( "ERROR",
"La donnée en sortie du processus n'est pas associée àun stockage "
        );
        return $ERROR_GENERATION_STRUCTURE_INCORRECT;
    }

    my $storage_path = $storage->{'logicalName'};
    if ( !$storage_path ) {
        $logger->log( "ERROR",
"Le stockage associé àla donnée de diffusion ne contient pas de chemin "
        );
        return $ERROR_GENERATION_STRUCTURE_INCORRECT;
    }
    $logger->log( "DEBUG",
        "Chemin de stockage de la donnée de sortie : " . $storage_path );

    my @bboxes = ();
    my @levels = ();
    my $return_read_input_cfg_file =
      read_input_configuration_file( $configuration_file_name, \@bboxes,
        \@levels );
    if ( $return_read_input_cfg_file != 0 ) {
        return $return_read_input_cfg_file;
    }

    my $dir_root = $root_storage . "/" . $storage_path . "/" . $bd_id;
    my $pyr_path = $dir_root . "/" . $pyramid_dir;

    my $tmp_generation_dir =
      $tmp_path . $tmp_generation . "/" . $generation_id . "/";
    my $path_temp   = $tmp_generation_dir . $tmp_dir_name;
    my $path_script = $tmp_generation_dir . $scripts_dir_name;
    my $cfg_file    = $tmp_generation_dir . $config_file_name;

    # Création de l'arborescence temporaire
    $logger->log( "DEBUG",
        "Création de l'arborescence temporaire " . $tmp_generation_dir );
    if (
        system(
                "mkdir -p "
              . $tmp_generation_dir
              . ";chmod a+r "
              . $tmp_generation_dir
        ) != 0
      )
    {
        $logger->log( "ERROR",
"Impossible de créer le repertoire temporaire de la génération : "
              . $tmp_generation_dir );

        return $ERROR_CREATING_TMP_DIR;
    }
    else {
        $logger->log( "INFO",
            "Création du repertoire temporaire de la génération : "
              . $tmp_generation_dir );
    }

    # Création de l'arborescence de la pyramide
    $logger->log( "DEBUG",
        "Création de l'arborescence de pyramide " . $pyr_path );
    if ( system( "mkdir -p " . $pyr_path . ";chmod a+r " . $pyr_path ) != 0 ) {
        $logger->log( "ERROR",
            "Impossible de créer le repertoire destination de la pyramide : "
              . $pyr_path );

        return $ERROR_CREATING_PYR_DIR;
    }
    else {
        $logger->log( "INFO",
            "Création du répertoire destination de la pyramide : "
              . $pyr_path );
    }

# Modification de la composition : nom du produit de diffusion -> chemin vers la pyramide
    my $return_modify_composition =
      modify_composition( $input_datas, \@levels );
    if ( $return_modify_composition != 0 ) {
        return $return_modify_composition;
    }

    # Ecriture de la configuration
    $logger->log( "INFO",
        "Ecriture du fichier de configuration pour joincache" );
    my $return_create_joincache_conf = create_joincache_conf(
        $cfg_file,                  "INFO",
        $bd_name,                   $pyr_path,
        $dir_root,                  $tms_path,
        $tms_name . $tms_extension, $image_dir,
        $metadata_dir,              $nodata_dir,
        $compression,               $samplesperpixel,
        $photometric,               $bitspersample,
        $sampleformat,              $merge_method,
        \@bboxes,                   $path_script,
        $path_temp,                 $job_number,
        \@levels
    );
    if ( $return_create_joincache_conf != 0 ) {
        $logger->log( "ERROR",
"Erreur lors de l'écriture de la configuration joincache spécifique"
        );
        $logger->log( "DEBUG",
            "Code retour : " . $return_create_joincache_conf );

        return $ERROR_CREATING_CFG_FILE;
    }

    # Exécution de joincache
    my $cmd_exec_joincache = $cmd_joincache . " --conf=" . $cfg_file;

    $logger->log( "DEBUG", "Appel à la commande : " . $cmd_exec_joincache );
    my $execution_exec_joincache = Execute->run($cmd_exec_joincache);
    if ( $execution_exec_joincache->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de l'exécution de joincache : "
              . $cmd_exec_joincache );
        $execution_exec_joincache->log_all( $logger, "ERROR" );

        return $ERROR_EXECUTING_JOINCACHE;
    }
    $logger->log( "INFO", "Execution de joincache terminée." );

    my $input_data_projection = $input_datas->[0]->{'projection'};
    if ( !defined $input_data_projection ) {
        $logger->log( "ERROR",
            "La donnée de diffusion en entrée n'a pas de projection : " );
        return $ERROR_GENERATION_STRUCTURE_INCORRECT;
    }
    my $input_data_no_data_value = $input_datas->[0]->{'noDataValue'};
    if ( !defined $input_data_no_data_value ) {
        $logger->log( "ERROR",
            "La donnée de diffusion en entrée n'a pas de nodatavalue : " );
        return $ERROR_GENERATION_STRUCTURE_INCORRECT;
    }

    # Mise à jour de la donnée de diffusion
    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/generation/updateRok4BD" );
    $response = $ua->request(
        POST $url_ws_entrepot. "/generation/updateRok4BD",
        [
            broadcastDataId => $bd_id,
            pyrFile         => $bd_name,
            ancestorId      => "",
            tmsName         => $tms_name,
            format          => $compression . "#" . $sampleformat,
            projection      => $input_data_projection,
            noDataValue     => $input_data_no_data_value
        ]
    );

    if ( $response->is_success ) {
        $logger->log( "INFO",
                "Mise à jour de la donnée de diffusion " 
              . $bd_id
              . " effectuée" );
    }
    else {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour de la donnée de diffusion "
              . $bd_id );
        return $ERROR_UPDATING_BROADCAST_DATA;
    }

    # Mise à jour de la donnée de diffusion avec les bboxes associées
    # Restriction temporaire :
    # 		- bbox monde et projection EPSG:4326
    #		- date de début et de fin renseignées à la date courante
    my $wkt_bbox =
        $key_srid 
      . $srid
      . $start_polygon
      . $bbox_x1
      . $coordinate_separator
      . $bbox_y1
      . $point_separator
      . $bbox_x2
      . $coordinate_separator
      . $bbox_y1
      . $point_separator
      . $bbox_x2
      . $coordinate_separator
      . $bbox_y2
      . $point_separator
      . $bbox_x1
      . $coordinate_separator
      . $bbox_y2
      . $point_separator
      . $bbox_x1
      . $coordinate_separator
      . $bbox_y1
      . $end_polygon;

    my @bbox_monde = ($wkt_bbox);

    my $projection = "EPSG:4326";

    my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) =
      localtime time;
    $year = sprintf "%04d", $year + 1900;
    $mon  = sprintf "%02d", $mon + 1;
    $mday = sprintf "%02d", $mday;

    my $current_date = $year . '-' . $mon . '-' . $mday;

    my $originators_array = get_originators($input_datas);

# Transformation du tableau en chaine de caractère composée des originators séparés par des virgules
    if ( @{$originators_array} == 0 ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour des BBOXes : pas d'originators dans les BD en entrée"
        );
        return $ERROR_GENERATION_STRUCTURE_INCORRECT;
    }

    my $originators       = @{$originators_array}[0];
    my $originators_index = 1;
    while ( $originators_index < @{$originators_array} ) {
        $originators .= ',' . @{$originators_array}[$originators_index];
        $originators_index++;
    }

    $logger->log( "DEBUG",
        "La liste des originators a été récupérée : " . $originators );

    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/generation/updateBboxes" );
    $response = $ua->request(
        POST $url_ws_entrepot. "/generation/updateBboxes",
        [
            broadcastDataId => $bd_id,
            ancestorId      => "",
            startDate       => $current_date,
            endDate         => $current_date,
            bboxes          => \@bbox_monde,
            originators     => $originators,
            projection      => $projection
        ]
    );

    if ( $response->is_success ) {
        $logger->log( "INFO", "Mise à jour des BBOXes effectuée" );
    }
    else {
        $logger->log( "ERROR",
            "Une erreur s'est produite lors de la mise à jour des BBOXes" );
        return $ERROR_UPDATING_BROADCAST_DATA;
    }

    # Mise à jour des métadonnées de la donnée de diffusion
    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/generation/copyMetadatasFromBD" );
    foreach my $input_data ( @{$input_datas} ) {
        if ( defined $input_data->{'id'} ) {
            $response = $ua->request(
                POST $url_ws_entrepot. "/generation/copyMetadatasFromBD",
                [
                    sourceBroadcastDataId => $input_data->{'id'},
                    targetBroadcastDataId => $bd_id
                ]
            );

            if ( $response->is_success ) {
                $logger->log( "INFO",
"Mise à jour des métadonnées de la donnée de diffusion "
                      . $bd_id
                      . " effectuée à partir de la donnée de diffusion "
                      . $input_data->{'id'} );
            }
            else {
                $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour des métadonnées de la donnée de diffusion "
                      . $bd_id
                      . " à partir de la donnée de diffusion "
                      . $input_data->{'id'} );
                return $ERROR_UPDATING_BROADCAST_DATA;
            }
        }
        else {
            $logger->log( "ERROR",
                "Au moins une donnée en entrée n'a pas d'identifiant." );
            return $ERROR_GENERATION_STRUCTURE_INCORRECT;
        }
    }

    # Mise à jour de la taille de la donnée de diffusion
    if ( update_broadcastdata_size( $dir_root, $bd_id, 0 ) != 0 ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour de la taille de la donnée de diffusion "
              . $bd_id );
        return $ERROR_UPDATING_BROADCAST_DATA;
    }

    return $GENERATION_SUCCESSFUL;
}

# check_same_information()
#
# USAGE :
#   Checks if the information are the same between the input data.
# ARGS :
#   The input data
# RETURNS :
#	* 0 if the information are the same in all input data
#	* 2 if the generation doesn't have any input data
#	* 3 if all input datas don't have the same tms
#	* 4 if all input datas don't have the same format
sub check_same_information() {
    my ($input_datas) = @_;

    if ( defined @{$input_datas} ) {
        my $same_tms         = 1;
        my $same_format      = 1;
        my $first_input_data = $input_datas->[0];

# Vérificiation que toutes les données de diffusion en entrée aient le même tms
        foreach my $input_data ( @{$input_datas} ) {
            if ( ( $input_data->{'tmsName'} cmp $first_input_data->{'tmsName'} )
                != 0 )
            {
                $same_tms = 0;
            }
            if (
                ( $input_data->{'format'} cmp $first_input_data->{'format'} ) !=
                0 )
            {
                $same_format = 0;
            }
        }
        if ( !$same_tms ) {
            $logger->log( "ERROR",
                "Les données en entrée n'ont pas le même tms." );
            return $ERROR_NOT_SAME_TMS;
        }
        if ( !$same_format ) {
            $logger->log( "ERROR",
                "Les données en entrée n'ont pas le même format." );
            return $ERROR_NOT_SAME_FORMAT;
        }
        $logger->log( "DEBUG",
            "Les données en entrée ont le même tms : "
              . $first_input_data->{'tmsName'} );
        $logger->log( "DEBUG",
            "Les données en entrée ont le même format : "
              . $first_input_data->{'format'} );
    }
    else {
        $logger->log( "ERROR",
"La génération demandée n'est liée à aucune donnée en entrée alors que ce type de traitement en attend"
        );
        return $ERROR_GENERATION_NO_INPUT_DATA;
    }

    return 0;
}

# get_originators()
#
# USAGE :
#   Gets originators from input data
# ARGS :
#   The input data
# RETURNS :
#	An array containing the originators
sub get_originators() {
    my ($input_datas) = @_;

    # Recupération des originators de toutes les BD en entrée
    my @originators_array = ();
    my $originators_index;
    foreach my $input_data ( @{$input_datas} ) {
        if ( defined $input_data->{'bboxList'} ) {
            foreach my $bbox ( @{ $input_data->{'bboxList'} } ) {
                if ( defined $bbox ) {
                    foreach my $owner ( @{ $bbox->{'owners'} } ) {
                        $originators_index = 0;
                        while (
                            $originators_index < @originators_array
                            && ( $originators_array[$originators_index]
                                cmp $owner->{'name'} ) != 0
                          )
                        {
                            $originators_index++;
                        }
                        if ( $originators_index == @originators_array ) {
                            $originators_array[$originators_index] =
                              $owner->{'name'};
                        }
                    }
                }
            }
        }
    }
    return \@originators_array;
}

# modify_composition()
#
# USAGE :
#   Modifies the composition in order to altering the product name
#	by the the pyramid path for each levels.
# ARGS :
#   The input data to check if the product name is present in these data
#	A reference to the array containing the levels
#	The pyramid path
#
# RETURNS :
#	* 0 if the composition was properly modified
#	* 11 if one or more broadcast product of input cfg file is not present in input datas
#	* 12 if a pyramid not exists on disk
#   * 253 if the generation structure is incorrect
sub modify_composition() {
    my ( $input_datas, $levels ) = @_;

# Modification de la composition : nom du produit de diffusion -> chemin vers la pyramide
    my $levels_index = 0;
    while ( $levels_index < @{$levels} ) {
        if ( defined @{$levels}[$levels_index] ) {
            my $index_comment = index @{$levels}[$levels_index], ";";
            my $comment = undef;
            if ( $index_comment != -1 ) {
                $comment = substr @{$levels}[$levels_index], $index_comment;
            }
            my @comment_split_res = split /;/, @{$levels}[$levels_index];

            @{$levels}[$levels_index] = "";

            my @equal_split_res = split /=/, $comment_split_res[0];
            if ( @equal_split_res > 1 ) {
                my @pyrs = split /,/, $equal_split_res[1];
                my $pyrs_index = 0;
                @{$levels}[$levels_index] = $equal_split_res[0] . "= ";

# Modification de l'ensemble des produits d'une ligne par le chemin vers la pyramide
                while ( $pyrs_index < @pyrs ) {

                   # Supression des espaces au début et à la fin de la chaine.
                    $pyrs[$pyrs_index] =~ s/^\s+//;
                    $pyrs[$pyrs_index] =~ s/\s+$//;

# Vérification que chaque produit de diffusion présent dans le fichier de conf est présent dans les input datas
                    my $present_input    = 0;
                    my $input_data_index = 0;
                    foreach my $input_data ( @{$input_datas} ) {
                        if ( defined $input_data->{'broadcastProduct'} ) {
                            if (
                                (
                                    $input_data->{'broadcastProduct'}->{'name'}
                                    cmp $pyrs[$pyrs_index]
                                ) == 0
                              )
                            {
                                $present_input = 1;
                            }
                            if ( !$present_input ) {
                                $input_data_index++;
                            }
                        }
                    }
                    if ( !$present_input ) {
                        $logger->log( "ERROR",
                                "Le produit de diffusion "
                              . $pyrs[$pyrs_index]
                              . " n'est pas présent dans les input datas." );
                        return $ERROR_PRODUIT_DIFFUSION_NON_PRESENT;
                    }

                    # Vérification de l'existance de la pyramide
                    if ( !defined $input_datas->[$input_data_index]
                        ->{'pyrFile'} )
                    {
                        $logger->log( "ERROR",
                                "Le produit de diffusion "
                              . $pyrs[$pyrs_index]
                              . " n'a pas de pyramide." );
                        return $ERROR_GENERATION_STRUCTURE_INCORRECT;
                    }
                    if ( !defined $input_datas->[$input_data_index]->{'id'} ) {
                        $logger->log( "ERROR",
"Une donnée de diffusion en entrée n'a pas d'identifiant."
                        );
                        return $ERROR_GENERATION_STRUCTURE_INCORRECT;
                    }

                    my $storage =
                      $input_datas->[$input_data_index]->{'storage'};
                    my $logical_name = $storage->{'logicalName'};
                    my $bd_id = $input_datas->[$input_data_index]->{'id'};

                    my $pyr_path =
                        $root_storage . "/"
                      . $logical_name . "/"
                      . $bd_id . "/"
                      . $pyramid_dir;
                    my $pyr_absolute_path =
                        $pyr_path . "/"
                      . $input_datas->[$input_data_index]->{'pyrFile'}
                      . $pyramid_extension;
                    if ( !( -e $pyr_absolute_path ) ) {
                        $logger->log( "ERROR",
                                "La pyramide "
                              . $pyr_absolute_path
                              . " n'existe pas physiquement." );
                        return $ERROR_PYRAMID_NOT_EXISTS;
                    }
                    if ( $pyrs_index == @pyrs - 1 ) {
                        @{$levels}[$levels_index] .= $pyr_absolute_path . " ";
                    }
                    else {
                        @{$levels}[$levels_index] .= $pyr_absolute_path . ", ";
                    }
                    $pyrs_index++;
                }
            }

            # Si la ligne contient des commentaires
            if ( $index_comment != -1 ) {
                @{$levels}[$levels_index] .= $comment;
            }
        }
        $levels_index++;
    }

    return 0;
}

# read_input_configuration_file()
#
# USAGE :
#   Reads the input configuration file to get bboxes and levels
# ARGS :
#   The configuration file name
#	A reference to an empty array which will contain bboxes
#	A reference to an empty array which will contain levels
#
# RETURNS :
#	* 0 if the file was read properly
#	* 10 if an error occured with input configuration file
#	* 252 if the input configuration file is not correct
sub read_input_configuration_file() {
    my ( $configuration_file_name, $bboxes, $levels ) = @_;

    # Lecture du fichier de configuration en entrée
    my $cfg_file_path =
      $static_referentiel_dir . $joincache_conf_dir . $configuration_file_name;
    my $config_file;
    if ( !open $config_file, '<', $cfg_file_path ) {
        $logger->log( "ERROR",
"Impossible d'ouvrir en lecture le fichier de configuration en entrée"
        );
        return $ERROR_INPUT_CFG_FILE;
    }

    # Avancer jusqu'à la partie consacrée aux bboxes
    my $line = readline $config_file;
    my @line_splitted = split /\n/, $line;
    while ( defined $line && $line_splitted[0] cmp "[bboxes]" ) {
        $line = readline $config_file;
        if ( defined $line ) {
            @line_splitted = split /\n/, $line;

         # renseignement de $line_splitted[0] pour éviter la non initialisation
            if ( @line_splitted == 0 ) {
                $line_splitted[0] = "";
            }
        }
    }
    if ( $line_splitted[0] cmp "[bboxes]" ) {
        $logger->log( "ERROR",
"Le fichier de configuration en entrée n'a pas d'entête : [bboxes]"
        );
        return $ERROR_INPUT_CFG_FILE_STRUCTURE_INCORRECT;
    }

    # Récupérer toutes les bboxes
    my $bboxes_index = 0;
    $line = readline $config_file;
    @line_splitted = split /\n/, $line;
    while ( defined $line && $line_splitted[0] cmp "[composition]" ) {
        @{$bboxes}[$bboxes_index] = $line_splitted[0];
        $bboxes_index++;
        $line = readline $config_file;
        if ( defined $line ) {
            @line_splitted = split /\n/, $line;
            if ( @line_splitted == 0 ) {
                $line_splitted[0] = "";
            }
        }
    }
    if ( $bboxes_index == 0 ) {
        $logger->log( "ERROR",
            "Le fichier de configuration en entrée n'a pas de bbox." );
        return $ERROR_INPUT_CFG_FILE_STRUCTURE_INCORRECT;
    }
    if ( $line_splitted[0] cmp "[composition]" ) {
        $logger->log( "ERROR",
"Le fichier de configuration en entrée n'a pas d'entête : [composition]"
        );
        return $ERROR_INPUT_CFG_FILE_STRUCTURE_INCORRECT;
    }

    # Récupérer tous les niveaux
    my $levels_index = 0;
    $line = readline $config_file;
    while ( defined $line ) {
        @line_splitted = split /\n/, $line;
        @{$levels}[$levels_index] = $line_splitted[0];
        $levels_index++;
        $line = readline $config_file;
    }
    if ( $levels_index == 0 ) {
        $logger->log( "ERROR",
            "Le fichier de configuration en entrée n'a pas de composition." );
        return $ERROR_INPUT_CFG_FILE_STRUCTURE_INCORRECT;
    }

    if ( !close $config_file ) {
        $logger->log( "ERROR",
            "Impossible de fermer le fichier de configuration en entrée" );
        return $ERROR_INPUT_CFG_FILE;
    }
    return 0;
}
