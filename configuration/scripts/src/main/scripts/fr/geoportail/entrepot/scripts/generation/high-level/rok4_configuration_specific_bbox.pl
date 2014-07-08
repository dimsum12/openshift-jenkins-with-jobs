#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will create a Rok4 configuration using the generation id
#       First it collect informations from service REST
#		Then, if a broadcast data is set for input datas, collect informations from the service REST about the WMS layer
#			for harvesting
#		Then, if it exists, collect informations from the service REST about the ancestor broadcast data
#       Finally it create the rok4 configuration, using a delivery and potentialy, the previous broadcast data of the
#			product
# ARGS :
#   The generation ID
#   The TMS name to use (without extension)
#   The compression for the output datas
#   The compression options for the output datas
#   The images width in pixels
#   The images height in pixels
#   The bits per sample for the images
#   The sample format for the images
#   The photometric for the images
#   The samples per pixel for the images
#   The interpolation for the resampling
#   The gamma value for the images
#   The nodata color value used for generation
#	Preprocessing to apply to source datas (or "none" if no preprocessing is necessary)
#   A boolean ("true" or "false"), indicating if the new pyramid must be constructed from an ancestor pyramid
#	A boolean ("true" or "false"), indicating if the white will be ignored in source data
#	The minimum level used for the generation (optionnal)
#	The maximum level used for the generation (optionnal)
# RETURNS :
#   * 0 if generation is correct
#   * 1 if the REST service is not reacheable or if the ID is incorrect
#   * 2 if the generation is linked to many deliveries
#   * 3 if the generation is linked to many broadcast datas
#   * 4 if the delivery used does not contains an information file
#   * 5 if an error occured while creating or writing the configuration file
#   * 6 if an error occured while creating the pyramid directories in storage
#	* 7 if the ancestor pyramid descriptor doesn't exist
#	* 8 if the resource to harvest is not published on intern zone
#	* 9 if an error occured when updating the bboxes
#	* 10 if an error occured when calculating the data sources bounding box
#	* 11 if an error during harvesting metadatas
#   * 12 if an error occured during preprocessing datas
#   * 13 if the storage of the ancestor and of the broadcast data to generate are not equals
#   * 14 if an error occured during creating the temporary directory
#   * 15 if an error occured during copying mtds from ancestor to new bd
#   * 252 if the broadcast data ancestor structure is incorrect
#   * 253 if the generation structure is incorrect
#   * 254 if the JSON return is not parseable
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 3 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/rok4_configuration.pl $
#   $Date: 29/09/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Deliveryconf;
use Database;
use Execute;
use Tools;
use Cwd;
use LWP::UserAgent;
use HTTP::Request::Common;
use Config::Simple;
use JSON;

require "bbox_from_images_standalone.pl";
require "bbox_from_images.pl";
require "harvest_generation.pl";
require "preprocessing_images.pl";
require "get_bbox_dates.pl";
require "create_be4_conf.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger =
  Logger->new( "rok4_configuration_specific_bbox.pl", $config->param("logger.levels") );

my $root_storage     = $config->param("filer.root.storage");
my $deliveries_path  = $config->param("filer.delivery-ftp");
my $url_ws_entrepot  = $config->param("resources.ws.url.entrepot");
my $url_proxy        = $config->param("proxy.url");
my $tmp_path         = $config->param("resources.tmp.path");
my $tmp_generation   = $config->param("resources.tmp.generations");
my $config_file_name = $config->param("be4.specific_conf_filename");
my $pyramid_dir      = $config->param("be4.pyramid_dir");
my $pyr_extension    = $config->param("be4.pyramid_extension");
my $tms_path         = $config->param("be4.tms_path");
my $cmd_more         = $config->param("resources.more");

my $tmp_dir_name           = "tmp";
my $scripts_dir_name       = "scripts";
my $preprocessing_dir_name = "preprocessing";
my $tms_extension          = ".tms";
my $xml_tag_crs            = "crs";

sub rok4_configuration_specific_bbox {

    # Extraction des paramÃ¨tres
    my (
        $generation_id,      $tms_name,      $compression,
        $compression_option, $image_width,   $image_height,
        $bitspersample,      $sampleformat,  $photometric,
        $samplesperpixel,    $interpolation, $gamma,
        $nodata_value,       $preprocessing, $check_ancestor,
        $nowhite,            $min_level,     $max_level
    ) = @_;
    if (   !defined $generation_id
        || !defined $tms_name
        || !defined $compression
        || !defined $compression_option
        || !defined $image_width
        || !defined $image_height
        || !defined $bitspersample
        || !defined $sampleformat
        || !defined $photometric
        || !defined $samplesperpixel
        || !defined $interpolation
        || !defined $gamma
        || !defined $nodata_value
        || !defined $preprocessing
        || !defined $check_ancestor
        || !defined $nowhite
        || ( defined $min_level && !defined $max_level ) )
    {
        $logger->log( "ERROR",
"Le nombre de paramÃ¨tres renseignés n'est pas celui attendu (16 ou 18)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "ParamÃ¨tre 1 : generation_id = " . $generation_id );
    $logger->log( "DEBUG", "ParamÃ¨tre 2 : tms_name = " . $tms_name );
    $logger->log( "DEBUG", "ParamÃ¨tre 3 : compression = " . $compression );
    $logger->log( "DEBUG",
        "ParamÃ¨tre 4 : compression_option = " . $compression_option );
    $logger->log( "DEBUG", "ParamÃ¨tre 5 : image_width = " . $image_width );
    $logger->log( "DEBUG", "ParamÃ¨tre 6 : image_height = " . $image_height );
    $logger->log( "DEBUG", "ParamÃ¨tre 7 : bitspersample = " . $bitspersample );
    $logger->log( "DEBUG", "ParamÃ¨tre 8 : sampleformat = " . $sampleformat );
    $logger->log( "DEBUG", "ParamÃ¨tre 9 : photometric = " . $photometric );
    $logger->log( "DEBUG",
        "ParamÃ¨tre 10 : samplesperpixel = " . $samplesperpixel );
    $logger->log( "DEBUG",
        "ParamÃ¨tre 11 : interpolation = " . $interpolation );
    $logger->log( "DEBUG", "ParamÃ¨tre 12 : gamma = " . $gamma );
    $logger->log( "DEBUG", "ParamÃ¨tre 13 : nodata_value = " . $nodata_value );
    $logger->log( "DEBUG",
        "ParamÃ¨tre 14 : preprocessing = " . $preprocessing );
    $logger->log( "DEBUG",
        "ParamÃ¨tre 15 : check_ancestor = " . $check_ancestor );
    $logger->log( "DEBUG", "Paramètre 16 : nowhite = " . $nowhite );

    if ( defined $min_level && defined $max_level ) {
        $logger->log( "DEBUG", "ParamÃ¨tre 17 : min_level = " . $min_level );
        $logger->log( "DEBUG", "ParamÃ¨tre 18 : max_level = " . $max_level );
    }

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

    my $delivery;
    my $resource;
    my $input_datas = $hash_response->{'inputDatas'};
    if ( defined @{$input_datas} ) {
        if ( scalar( @{$input_datas} ) == 2 ) {

            # Cas avec moissonnage
            if ( defined $input_datas->[0]->{'login'} ) {
                $delivery = $input_datas->[0];
                $resource = $input_datas->[1];
            }
            else {
                $delivery = $input_datas->[1];
                $resource = $input_datas->[0];
            }
        }
        elsif ( scalar( @{$input_datas} ) == 1 ) {

            # Cas classique sans moissonnage
            $delivery = $input_datas->[0];
        }
        else {
            $logger->log( "ERROR",
                    "La génération demandée est lié à "
                  . scalar( @{$input_datas} )
                  . " données en entrée alors que ce type de traitement en attend 1 ou 2"
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

    my $delivery_login = $delivery->{'login'};
    if ( !$delivery_login ) {
        $logger->log( "ERROR",
            "La donnée en entrée du processus n'est pas de type Delivery" );
        return 2;
    }
    $logger->log( "DEBUG",
        "Login de la livraison en base : " . $delivery_login );

    # Lecture des information de la données de diffusion rok4 en entrée
    my $wms_layer;
    if ( defined $resource ) {
        $wms_layer = $resource->{'layerName'};
        if ( !$wms_layer ) {
            $logger->log( "ERROR",
"La seconde donnée en entrée du processus n'est pas de type Resource"
            );
            return 2;
        }
        $logger->log( "DEBUG",
            "Nom de la resource à moissonner : " . $wms_layer );

        my $layer_released = $resource->{'releasedOnInternZone'};
        if ( !$layer_released || "true" ne $layer_released ) {
            $logger->log( "ERROR",
                "La resource à moissonner n'est pas publiée en interne" );
            return 8;
        }
    }

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

    my $bd_id = $broadcast_datas->[0]->{'id'};
    if ( !$bd_id ) {
        $logger->log( "ERROR",
            "La données en sortie du processus ne possÃ¨de pas d'identifiant"
        );
        return 253;
    }
    $logger->log( "DEBUG", "Identifiant de la donnée de sortie : " . $bd_id );

    my $bd_name = $broadcast_datas->[0]->{'name'};
    if ( !$bd_name ) {
        $logger->log( "ERROR",
            "La données en sortie du processus ne possÃ¨de pas de nom" );
        return 253;
    }
    $logger->log( "DEBUG", "Nom de la donnée de sortie : " . $bd_name );

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

    my $old_bd_id;
    my $old_bd_name;
    my $old_storage_path;
    if ( "true" eq $check_ancestor ) {

# Appel au web service pour récupérer eventuellement la donnée de diffusion précédente
        $logger->log( "DEBUG",
                "Appel au service REST : "
              . $url_ws_entrepot
              . "/generation/getPreviousBroadcastData" );
        $response =
          $ua->request( GET $url_ws_entrepot
              . "/generation/getPreviousBroadcastData?broadcastDataId="
              . $bd_id );

        if ( $response->is_success ) {
            $logger->log( "INFO",
"Récupération de la broadcast data ancÃªtre de celle d'identifiant "
                  . $bd_id );

            # Conversion de la réponse JSON en structure PERL
            $json_response = $response->decoded_content;
            $hash_response = JSON::from_json($json_response);
            if ( !$hash_response ) {
                $logger->log( "ERROR",
"Une erreur s'est produite lors de la conversion de la réponse JSON"
                );
                return 254;
            }

            $old_bd_id = $hash_response->{'id'};
            if ( !$old_bd_id ) {
                $logger->log( "ERROR",
                    "La données ancÃªtre ne possÃ¨de pas d'identifiant" );
                return 252;
            }
            else {
                $logger->log( "DEBUG",
                    "Identifiant de la donnée ancÃªtre : " . $old_bd_id );

                $old_bd_name = $hash_response->{'name'};
                if ( !$old_bd_name ) {
                    $logger->log( "ERROR",
                        "La données ancÃªtre ne possÃ¨de pas de nom" );
                    return 252;
                }
                $logger->log( "DEBUG",
                    "Nom de la donnée ancÃªtre : " . $old_bd_name );

                my $old_storage = $hash_response->{'storage'};
                if ( !$old_storage ) {
                    $logger->log( "ERROR",
"La données ancÃªtre n'est pas associé à un stockage "
                    );
                    return 252;
                }

                $old_storage_path = $old_storage->{'logicalName'};
                if ( !$old_storage_path ) {
                    $logger->log( "ERROR",
"Le stockage associé à la donnée ancÃªtre ne contient pas de chemin "
                    );
                    return 252;
                }
                $logger->log( "DEBUG",
                    "Chemin de stockage de la donnée ancÃªtre : "
                      . $old_storage_path );

                if ( $old_storage_path ne $storage_path ) {
                    $logger->log( "ERROR",
                            "Le stockage associé à la donnée ancÃªtre ("
                          . $old_storage_path
                          . ") ne correspond pas à celui de la donnée à générer ("
                          . $storage_path
                          . ")" );
                    return 13;
                }
            }
        }
        else {
            $logger->log( "INFO",
                    "La donnée de diffusion " 
                  . $bd_id
                  . " ne possÃ¨de pas d'ancÃªtre" );
        }
    }

    # Récupération des informations du fichier d'informations complémentaires
    my $delivery_dir = $deliveries_path . $delivery_login;
    $logger->log( "INFO", "Repertoire de la livraison : " . $delivery_dir );

    my $deliveryconf = Deliveryconf->new( $delivery_dir, $logger, $config );
    if ( !$deliveryconf ) {
        $logger->log( "ERROR",
"Impossible de trouver le fichier d'information complémentaire dans la livraison source : "
              . $delivery_dir );

        return 4;
    }

    # Mise en forme des informations
    my $originators = $deliveryconf->{values}{"PARTNERNAME"};
    my $source_srs  = $deliveryconf->{values}{"PROJECTION"};
    my $path_image  = $delivery_dir . "/" . $deliveryconf->{values}{"DIR.DATA"};
    my $dir_root    = $root_storage . "/" . $storage_path . "/" . $bd_id;
    my $pyr_path    = $dir_root . "/" . $pyramid_dir;
    my $pyr_name_new = $bd_name;
    my $tmp_generation_dir =
      $tmp_path . $tmp_generation . "/" . $generation_id . "/";
    my $path_temp  = $tmp_generation_dir . $tmp_dir_name;
    my $path_shell = $tmp_generation_dir . $scripts_dir_name;
    my $cfg_file   = $tmp_generation_dir . $config_file_name;

    my $dir_root_old;
    my $pyr_path_old;
    if ( defined $old_bd_name && "" ne $old_bd_name ) {
        $dir_root_old =
          $root_storage . "/" . $old_storage_path . "/" . $old_bd_id;
        $pyr_path_old = $dir_root_old . "/" . $pyramid_dir;

        # Vérification de l'existence de la pyramide de données ancetre
        if ( !-e $pyr_path_old . "/" . $old_bd_name . $pyr_extension ) {
            $logger->log( "ERROR",
                    "Le descripteur de la pyramide ancÃªtre n'existe pas : "
                  . $pyr_path_old . "/"
                  . $old_bd_name
                  . $pyr_extension );

            return 7;
        }
    }

	# Test si le fichier bbox_wkt.txt existe. Si oui: on l'utilise, sinon: erreur
	my $bboxFileName = "bbox_wkt.txt";
	my $bboxFilePath = $path_image."/../".$bboxFileName;
	my $wkt_bbox = "";
	
	$logger->log( "DEBUG", " Recherche du fichier contenant la BBOX dans $bboxFilePath");
	if ( !-e $bboxFilePath){
	
		$logger->log( "DEBUG", "Le fichier n'existe pas.");
		
		# Calcul de la BBOX de la donnée livrée
		$logger->log( "DEBUG",
				"Calcul de la BBOX des données contenues dans "
			  . $path_image
			  . " avec la projection "
			  . $source_srs );

		$wkt_bbox = bbox_from_images( $path_image, $source_srs );
	
	}else{
	
		# le fichier existe, lire la bbox
		$logger->log( "DEBUG", "Le fichier existe. Lecture du contenu...");
		open(BBOXFILE,$bboxFilePath) or die ("Erreur d'ouverture en lecture du fichier $bboxFileName");
		$wkt_bbox = <BBOXFILE>;
		chomp($wkt_bbox);
		close(BBOXFILE);
	
	}
	
    if ( Tools->is_numeric($wkt_bbox) && $wkt_bbox > 0 ) {
        $logger->log( "ERROR",
                "Erreur lors du calcul de la BBOX des données contenues dans "
              . $path_image
              . " avec la projection "
              . $source_srs );
        $logger->log( "ERROR", "Code de retour obtenu : " . $wkt_bbox );

        return 10;
    }
    my @bboxes = ($wkt_bbox);

    # Preprocessing de la donnée livrée
    my $src_path;
    if ( "none" eq $preprocessing ) {
        $src_path = $path_image;
    }
    else {
        my $return_preprocessing =
          preprocessing_images( $path_image,
            $tmp_generation_dir . $preprocessing_dir_name . "/",
            $preprocessing );
        if ( $return_preprocessing > 0 ) {
            $logger->log( "ERROR",
                "Erreur lors du pretraitement des données par le processus "
                  . $preprocessing );

            return 12;
        }

        $src_path = $tmp_generation_dir . "/" . $preprocessing_dir_name;
    }

    # Récupération de la projection cible dans le TMS
    my $cmd_read_srs =
        $cmd_more . " "
      . $tms_path . "/"
      . $tms_name
      . $tms_extension
      . " | grep '"
      . $xml_tag_crs
      . "' | sed -e 's/^.*<"
      . $xml_tag_crs
      . ">\\(.*\\)<\\/"
      . $xml_tag_crs
      . ">.*\$/\\1/g'";
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd_read_srs );
    my $execution_read_srs = Execute->run($cmd_read_srs);
    if ( $execution_read_srs->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de la lecture du CRS cible dans le TMS : "
              . $cmd_read_srs );
        return 5;
    }
    my @return_lines = $execution_read_srs->get_log();
    my $target_srs   = $return_lines[0];
    chomp $target_srs;
    $logger->log( "INFO", "CRS cible lu dans le TMS : " . $target_srs );

    # Mise à jour de la donnée de diffusion
    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/generation/updateRok4BD" );
    $response = $ua->request(
        POST $url_ws_entrepot. "/generation/updateRok4BD",
        [
            broadcastDataId => $bd_id,
            pyrFile         => $bd_name,
            ancestorId      => $old_bd_id,
            tmsName         => $tms_name,
            format          => $compression . "#" . $sampleformat,
            projection      => $target_srs,
			noDataValue      => $nodata_value
        ]
    );

    if ( $response->is_success ) {
        $logger->log( "INFO",
                "Mise à  jour de la donnée de diffusion " 
              . $bd_id
              . " effectuée" );
    }
    else {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à  jour de la donnée de diffusion "
              . $bd_id );
        return 9;
    }

    # récupération des dossiers de métadonnées
    my @mtd_folders     = ();
    my $mtd_src_dir_iso = $deliveryconf->{values}{"DIR.METADATA.ISO"};
    if ( defined $mtd_src_dir_iso ) {
        if ( "" ne $mtd_src_dir_iso ) {
            $mtd_src_dir_iso = $delivery_dir . "/" . $mtd_src_dir_iso;
            push( @mtd_folders, $mtd_src_dir_iso );
        }
    }
    my $mtd_src_dir_inspire = $deliveryconf->{values}{"DIR.METADATA.INSPIRE"};
    if ( defined $mtd_src_dir_inspire ) {
        if ( "" ne $mtd_src_dir_inspire ) {
            $mtd_src_dir_inspire = $delivery_dir . "/" . $mtd_src_dir_inspire;
            push( @mtd_folders, $mtd_src_dir_inspire );
        }
    }
    my $mtd_src_dir_pva = $deliveryconf->{values}{"DIR.METADATA.PVA"};
    if ( defined $mtd_src_dir_pva ) {
        if ( "" ne $mtd_src_dir_pva ) {
            $mtd_src_dir_pva = $delivery_dir . "/" . $mtd_src_dir_pva;
            push( @mtd_folders, $mtd_src_dir_pva );
        }
    }

    # récupération des dates min et max
    my ( $min, $max ) = get_bbox_dates(@mtd_folders);

    # Mise à jour de la donnée de diffusion avec les bboxes associées
    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/generation/updateBboxes" );
    $response = $ua->request(
        POST $url_ws_entrepot. "/generation/updateBboxes",
        [
            broadcastDataId => $bd_id,
            ancestorId      => $old_bd_id,
            startDate       => $min,
            endDate         => $max,
            bboxes          => \@bboxes,
            originators     => $originators,
            projection      => $target_srs
        ]
    );

    if ( $response->is_success ) {
        $logger->log( "INFO", "Mise à jour des BBOXes effectuée" );
    }
    else {
        $logger->log( "ERROR",
            "Une erreur s'est produite lors de la mise à jour des BBOXes" );
        return 9;
    }

    # copy mtds from ancestor broadcastdata to new broadcastdata
    if ( defined $old_bd_id ) {

        $logger->log( "INFO",
"recopie des metadonnées de la donnée ancÃªtre vers la nouvelle donnée "
        );
        $logger->log( "DEBUG",
                "Appel au service REST : "
              . $url_ws_entrepot
              . "/generation/copyMetadatasFromBD" );
        $response = $ua->request(
            POST $url_ws_entrepot. "/generation/copyMetadatasFromBD",
            [
                sourceBroadcastDataId => $old_bd_id,
                targetBroadcastDataId => $bd_id
            ]
        );

        if ( $response->is_success ) {
            $logger->log( "INFO",
                    "Copie des références au metadatas de la broadcast data "
                  . $old_bd_id
                  . " dans la broadcast data "
                  . $bd_id
                  . " effectuée" );
        }
        else {
            $logger->log( "ERROR",
"Une erreur s'est produite lors de la copie des références au metadatas de la broadcast data "
                  . $old_bd_id
                  . " dans la broadcast data "
                  . $bd_id );
            return 15;
        }

    }

    # Harvest des métadonnées
    $logger->log( "INFO", "Moissonage des métadonnées" );
    my $return_harvest_generation = harvest_generation( $delivery_dir, $bd_id );
    if ( $return_harvest_generation != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors du moissonnage des métadonnées." );
        $logger->log( "DEBUG", "Code retour : " . $return_harvest_generation );

        return 11;
    }

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

        return 14;
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

        return 6;
    }
    else {
        $logger->log( "INFO",
            "Création du répertoire destination de la pyramide : "
              . $pyr_path );
    }

    # Ecriture de la configuration
    $logger->log( "INFO", "Moissonage des métadonnées" );
    my $return_create_be4_conf = create_be4_conf(
        $cfg_file,                  $src_path,
        $source_srs,                $dir_root,
        $pyr_path,                  $pyr_name_new,
        $wms_layer,                 $dir_root_old,
        $pyr_path_old,              $old_bd_name,
        $tms_name . $tms_extension, $compression,
        $compression_option,        $image_width,
        $image_height,              $bitspersample,
        $sampleformat,              $photometric,
        $samplesperpixel,           $interpolation,
        $gamma,                     $path_temp,
        $path_shell,                $nodata_value,
        $nowhite,                   $min_level,
        $max_level
    );
    if ( $return_create_be4_conf != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de l'écriture de la configuration rok4 spécifique" );
        $logger->log( "DEBUG", "Code retour : " . $return_create_be4_conf );

        return 5;
    }

    return 0;
}

