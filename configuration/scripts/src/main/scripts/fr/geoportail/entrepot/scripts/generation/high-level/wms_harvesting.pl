#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will harvest a WMS Service and use Rok4 configuration for generating a pyramid
#       First it generates a grid to harvest
#		Then, it extracts tiles from grid by using a WMS service
#		Finally it calls rok4 to generate pyramid
# ARGS :
#   The generation ID
#	The output format for harvesting wms
#   The style for harvesting wms
#   The transparency for harvesting wms
#   The bachground color for harvesting wms
#	The image width for harvesting wms
#	The image height for harvesting wms
#	The .ewkt file containing a EWKT (without the extension), or directly a EWKT polygon, for harvesting wms
#   The TMS name to use (without extension)
#   The compression for the output datas
#   The compression options for the output datas
#   The images width in pixels for the output datas
#   The images height in pixels for the output datas
#   The bits per sample for the output datas
#   The sample format for the output datas
#   The photometric for the output datas
#   The samples per pixel for the output datas
#   The interpolation for the output datas
#   The gamma value for the output datas
#   The nodata color value for the output datas
#   A boolean ("true" or "false"), indicating if the new pyramid must be constructed from an ancestor pyramid
#	The minimum level of generation
#	The maximum level of generation
#	The definition for empty tile size (optionnal)
# RETURNS :
#   * 0 if generation is correct
#   * 1 if the REST service is not reacheable or if the ID is incorrect
#   * 2 if the generation is linked to many deliveries
#   * 3 if the generation is not linked to a resource
#   * 4 if the resource is not published in internal zone
#   * 5 if an error occured reading TMS file for extracting informations
#   * 6 if an error ocurred during calculating the grid for a harvesting level
#	* 7 if an error occured creating or writing in temporary directory
#   * 8 if an error writing be4 configuration file
#   * 9 if an error occured when updating the bboxes or broadcast data
#   * 10 if an error occured while calcuating the BBOX of the extraction polygon requested
#   * 11 if an error occured during reading in ewkt file
#   * 252 if the broadcast data ancestor structure is incorrect
#   * 253 if the generation structure is incorrect
#   * 254 if the JSON return is not parseable
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/wms_harvesting.pl $
#   $Date: 27/02/12 $
#   $Author: Charles-Henri BILLER(a149912) <charles-henri.biller@atos.net> $
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
use Tools;

require "grid_generator.pl";
require "create_be4_conf.pl";
require "bbox_from_ewkt.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger =
  Logger->new( "wms_harvesting.pl", $config->param("logger.levels") );

my $url_proxy        = $config->param("proxy.url");
my $url_ws_entrepot  = $config->param("resources.ws.url.entrepot");
my $tmp_path         = $config->param("resources.tmp.path");
my $tmp_moissonnage  = $config->param("resources.tmp.moissonnages");
my $tmp_generation   = $config->param("resources.tmp.generations");
my $cmd_cat          = $config->param("resources.cat");
my $static_ref       = $config->param("static_ref.static_referentiel");
my $config_file_name = $config->param("be4.specific_conf_filename");
my $pyramid_dir      = $config->param("be4.pyramid_dir");
my $pyr_extension    = $config->param("be4.pyramid_extension");
my $tms_path         = $config->param("be4.tms_path");
my $root_storage     = $config->param("filer.root.storage");
my $split_number     = $config->param("wmsharvesting.split.number");
my $wms_context      = $config->param("wmsharvesting.context");
my $ewkt_folder      = $config->param("wmsharvesting.ewkt_folder");
my $extraction_key   = $config->param("resources.extraction.key");
my $exec_script      = $config->param("resources.exec_script");
my $service_name_wmsvector =
  $config->param("wms_extraction_vector.service_name");
  
my $retry_attempts =
  $config->param("resources.ws.service.entrepot.retry.attempts");
my $retry_waitingtime =
  $config->param("resources.ws.service.entrepot.retry.waitingtime");
  

my $tmp_dir_name           = "tmp";
my $data_source_dir_name   = "data_source";
my $scripts_dir_name       = "scripts";
my $script_base_name       = "split_harvest_";
my $script_extension       = ".sh";
my $tms_extension          = ".tms";
my $ewkt_extension         = ".ewkt";
my $xml_tag_crs            = "crs";
my $xml_tag_id             = "id";
my $xml_tag_resolution     = "resolution";
my $wms_extraction_style   = "";
my $wms_extraction_context = "geoportail";

sub wms_harvesting {

    # Extraction des paramètres
    my (
        $generation_id,           $output_format,
        $wms_style,               $transparence,
        $bg_color,                $image_width_harvesting,
        $image_height_harvesting, $polygon_wkt,
        $tms_name,                $compression,
        $compression_option,      $image_width,
        $image_height,            $bitspersample,
        $sampleformat,            $photometric,
        $samplesperpixel,         $interpolation,
        $gamma,                   $nodata_value,
        $check_ancestor,          $min_level,
        $max_level,               $empty_tile_size
    ) = @_;
    if (   !defined $generation_id
        || !defined $output_format
        || !defined $wms_style
        || !defined $transparence
        || !defined $bg_color
        || !defined $image_width_harvesting
        || !defined $image_height_harvesting
        || !defined $polygon_wkt
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
        || !defined $check_ancestor
        || !defined $min_level
        || !defined $max_level )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (23 ou 24)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : generation_id = " . $generation_id );
    $logger->log( "DEBUG", "Paramètre 2 : output_format = " . $output_format );
    $logger->log( "DEBUG", "Paramètre 3 : wms_style = " . $wms_style );
    $logger->log( "DEBUG", "Paramètre 4 : transparence = " . $transparence );
    $logger->log( "DEBUG", "Paramètre 5 : bg_color = " . $bg_color );
    $logger->log( "DEBUG",
        "Paramètre 6 : image_width_harvesting = " . $image_width_harvesting );
    $logger->log( "DEBUG",
        "Paramètre 7 : image_height_harvesting = "
          . $image_height_harvesting );
    $logger->log( "DEBUG", "Paramètre 8 : polygon_wkt = " . $polygon_wkt );
    $logger->log( "DEBUG", "Paramètre 9 : tms_name = " . $tms_name );
    $logger->log( "DEBUG", "Paramètre 10 : compression = " . $compression );
    $logger->log( "DEBUG",
        "Paramètre 11 : compression_option = " . $compression_option );
    $logger->log( "DEBUG", "Paramètre 12 : image_width = " . $image_width );
    $logger->log( "DEBUG", "Paramètre 13 : image_height = " . $image_height );
    $logger->log( "DEBUG",
        "Paramètre 14 : bitspersample = " . $bitspersample );
    $logger->log( "DEBUG", "Paramètre 15 : sampleformat = " . $sampleformat );
    $logger->log( "DEBUG", "Paramètre 16 : photometric = " . $photometric );
    $logger->log( "DEBUG",
        "Paramètre 17 : samplesperpixel = " . $samplesperpixel );
    $logger->log( "DEBUG",
        "Paramètre 18 : interpolation = " . $interpolation );
    $logger->log( "DEBUG", "Paramètre 19 : gamma = " . $gamma );
    $logger->log( "DEBUG", "Paramètre 20 : nodata_value = " . $nodata_value );
    $logger->log( "DEBUG",
        "Paramètre 21 : check_ancestor = " . $check_ancestor );
    $logger->log( "DEBUG", "Paramètre 22 : min_level = " . $min_level );
    $logger->log( "DEBUG", "Paramètre 23 : max_level = " . $max_level );
	
	if ( defined $empty_tile_size ) {
		$logger->log( "DEBUG", "Paramètre 24 : $empty_tile_size = " . $empty_tile_size );
	} else {
		$empty_tile_size = "0";
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

    my $resource;
    my $input_datas = $hash_response->{'inputDatas'};
    if ( defined @{$input_datas} ) {
        if ( scalar( @{$input_datas} ) == 1 ) {
            $resource = $input_datas->[0];
        }
        else {
            $logger->log( "ERROR",
                    "La génération demandée est lié à "
                  . scalar( @{$input_datas} )
                  . " données en entrée alors que ce type de traitement en attend 1"
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

    # Lecture des information de la données de diffusion rok4 en entrée
    my $layer_name;
    my $resource_id;
    if ( defined $resource ) {
        $layer_name  = $resource->{'layerName'};
        $resource_id = $resource->{'id'};
        if ( !$layer_name ) {
            $logger->log( "ERROR",
                "La donnée en entrée du processus n'est pas de type Resource"
            );
            return 2;
        }
        $logger->log( "DEBUG",
            "Nom de la resource à moissonner : " . $layer_name );

        my $layer_released = $resource->{'releasedOnInternZone'};
        if ( !$layer_released || "true" ne $layer_released ) {
            $logger->log( "ERROR",
                "La resource à moissonner n'est pas publiée en interne" );
            return 4;
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
            "La données en sortie du processus ne possède pas d'identifiant"
        );
        return 253;
    }
    $logger->log( "DEBUG", "Identifiant de la donnée de sortie : " . $bd_id );

    my $bd_name = $broadcast_datas->[0]->{'name'};
    if ( !$bd_name ) {
        $logger->log( "ERROR",
            "La données en sortie du processus ne possède pas de nom" );
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
"Récupération de la broadcast data ancêtre de celle d'identifiant "
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
                    "La données ancêtre ne possède pas d'identifiant" );
                return 252;
            }
            else {
                $logger->log( "DEBUG",
                    "Identifiant de la donnée ancêtre : " . $old_bd_id );

                $old_bd_name = $hash_response->{'name'};
                if ( !$old_bd_name ) {
                    $logger->log( "ERROR",
                        "La données ancêtre ne possède pas de nom" );
                    return 252;
                }
                $logger->log( "DEBUG",
                    "Nom de la donnée ancêtre : " . $old_bd_name );

                my $old_storage = $hash_response->{'storage'};
                if ( !$old_storage ) {
                    $logger->log( "ERROR",
"La données ancêtre n'est pas associé à un stockage "
                    );
                    return 252;
                }

                $old_storage_path = $old_storage->{'logicalName'};
                if ( !$old_storage_path ) {
                    $logger->log( "ERROR",
"Le stockage associé à la donnée ancêtre ne contient pas de chemin "
                    );
                    return 252;
                }
                $logger->log( "DEBUG",
                    "Chemin de stockage de la donnée ancêtre : "
                      . $old_storage_path );

                if ( $old_storage_path ne $storage_path ) {
                    $logger->log( "ERROR",
                            "Le stockage associé à la donnée ancêtre ("
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
                  . " ne possède pas d'ancêtre" );
        }
    }

    my $tmp_moissonnage_dir =
      $tmp_path . $tmp_generation . "/" . $generation_id . "/";

    # Récupération de la projection cible dans le TMS
    my $cmd_read_srs =
        $cmd_cat . " "
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

# Récupération de l'emprise EWKT dans le referentiel statique, si un fichier existant a été spécifié
    my $ewkt_file =
      $static_ref . "/" . $ewkt_folder . "/" . $polygon_wkt . $ewkt_extension;
    if ( -f $ewkt_file ) {
        $logger->log( "INFO",
            "Un fichier EWKT a été passé au processus : Lecture de l'emprise"
        );
        my $cmd_read_ewkt = $cmd_cat . " " . $ewkt_file;
        $logger->log( "DEBUG", "Appel à la commande : " . $cmd_read_ewkt );
        my $execution_read_ewkt = Execute->run($cmd_read_ewkt);
        if ( $execution_read_ewkt->get_return() != 0 ) {
            $logger->log( "ERROR",
"Erreur lors de la lecture du polygon EWKT dans le fichier via la commande : "
                  . $cmd_read_ewkt );
            return 11;
        }
        @return_lines = $execution_read_ewkt->get_log();
        $polygon_wkt  = $return_lines[0];
        chomp $polygon_wkt;

        $logger->log( "INFO",
                "On utilise le polygon "
              . $polygon_wkt
              . " trouvé dans le fichier comme emprise à moissonner" );
    }
    else {
        $logger->log( "INFO",
"Le paramètre en entrée n'est pas un fichier EWKT, on utilise donc "
              . $polygon_wkt
              . " comme emprise à moissonner" );
    }

    # Définition de l'extension de l'image et du fichier de géoréférencement
    my $image_extension;
    my $georef_extension;
    if ( $output_format =~ /png/i ) {
        $image_extension  = ".png";
        $georef_extension = ".wld";
        $output_format    = "image/png";
    }
    elsif ( $output_format =~ /jpeg/i ) {
        $image_extension  = ".jpg";
        $georef_extension = ".wld";
        $output_format    = "image/jpeg";
    }
    elsif ( $output_format =~ /tif/i ) {
        $image_extension  = ".tif";
        $georef_extension = ".tfw";
        $output_format    = "image/tiff";
    }
    else {
        $logger->log( "ERROR",
                "Le format "
              . $output_format
              . " n'est pas reconnu par l'extraction" );
        return 4;
    }
    $logger->log( "DEBUG",
        "Extension utilisée pour les images : " . $image_extension );
    $logger->log( "DEBUG",
        "Extension utilisée pour les fichiers de géoréférencement : "
          . $georef_extension );

    # Création du repertoire de travail des scripts splittés		
	$logger->log( "DEBUG",
			"Création de l'arborescence temporaire "
		  . $tmp_moissonnage_dir
		  . $scripts_dir_name );
	if (
		system( "mkdir -p " . $tmp_moissonnage_dir . $scripts_dir_name ) !=
		0 )
	{
		$logger->log( "ERROR",
"Impossible de créer le repertoire des scripts de moissonnage : "
			  . $tmp_moissonnage_dir
			  . $scripts_dir_name );

		return 7;
	}
		
	# Préparation des différents moissonnages à effectuer, fichier par fichier
    my @tab_hdl_split = ();
	my $current_split_num;
	for ( $current_split_num = 1 ; $current_split_num <= $split_number ; $current_split_num += 1 ) {
	    my $current_script_file =
                $tmp_moissonnage_dir
              . $scripts_dir_name . "/"
              . $script_base_name
              . $current_split_num
              . $script_extension;
        
		$logger->log( "DEBUG",
                    "Ouverture de "
                  . $current_script_file . " en écriture");
		
		if ( !open $tab_hdl_split[$current_split_num - 1], ">", $current_script_file ) {
			$logger->log( "ERROR",
				"Impossible de créer le fichier de script " . $current_script_file );
			return 4;
		}
	}
	
	$current_split_num = 1;
	
    for ( my $level = $min_level ; $level <= $max_level ; $level += 1 ) {
        my $path_image =
          $tmp_moissonnage_dir . $level . "/" . $data_source_dir_name . "/";

        # Récupération de la résolution cible dans le TMS
        my $cmd_read_resol =
            $cmd_cat . " "
          . $tms_path . "/"
          . $tms_name
          . $tms_extension
          . " | xargs | sed -e 's/^.*<"
          . $xml_tag_id . ">"
          . $level . "<\\/"
          . $xml_tag_id
          . ">\\s*<"
          . $xml_tag_resolution
          . ">\\([0-9.]*\\)<\\/"
          . $xml_tag_resolution
          . ">.*\$/\\1/g'";
        $logger->log( "DEBUG", "Appel à la commande : " . $cmd_read_resol );
        my $execution_read_resol = Execute->run($cmd_read_resol);
        if ( $execution_read_resol->get_return() != 0 ) {
            $logger->log( "ERROR",
"Erreur lors de la lecture de la résolution cible dans le TMS : "
                  . $cmd_read_resol );
            return 5;
        }
        @return_lines = $execution_read_resol->get_log();
        my $resolution = $return_lines[0];
        chomp $resolution;
        $logger->log( "INFO",
                "Résolution cible lu dans le TMS pour le niveau " 
              . $level . " : "
              . $resolution );

        # Génération de la grille de dalles à requêter
        my $bboxes = grid_generator(
            $polygon_wkt,
            $image_width_harvesting * $resolution,
            $image_height_harvesting * $resolution
        );
        if ( Tools->is_numeric($bboxes) && 0 != $bboxes ) {
            $logger->log( "ERROR",
                "Impossible de générer la grille de dalles à requêter" );
            $logger->log( "ERROR",
                "Code retour de la fonction grid_generator : " . $bboxes );
            return 6;
        }

        # Création de l'arborescence temporaire
        $logger->log( "DEBUG",
            "Création de l'arborescence temporaire " . $path_image );
        if ( system( "mkdir -p " . $path_image ) != 0 ) {
            $logger->log( "ERROR",
"Impossible de créer le repertoire temporaire de la génération : "
                  . $path_image );

            return 7;
        }

      # Ecriture des bounding box à moissonner dans les différents découpages
        foreach my $bbox ( @{$bboxes} ) {

            # Creation de la commande de moissonnage de chaque dalle
            my $cmd_harvesting =
                $exec_script
              . " extract_wms_tile \""
              . $path_image
              . $current_split_num . "/"
              . $bbox->{'name'}
              . $image_extension . "\" \""
              . $bbox->{'x1'} . "\" \""
              . $bbox->{'y1'} . "\" \""
              . $bbox->{'x2'} . "\" \""
              . $bbox->{'y2'} . "\" \""
              . $image_width_harvesting . "\" \""
              . $image_height_harvesting . "\" \""
              . $service_name_wmsvector . "\" \""
              . $extraction_key . "\" \""
              . $layer_name . "\" \""
              . $output_format . "\" \""
              . $target_srs . "\" \""
              . $wms_style . "\" \""
              . $wms_context . "\" \""
			  . $retry_attempts . "\" \""
			  . $retry_waitingtime . "\" \""
              . $transparence . "\" \""
              . $bg_color . "\" \""
              . $empty_tile_size
              . "\";if [[ 0 != \$? ]]; then exit 1; fi;"
              . $exec_script
              . " create_georef \""
              . $path_image
              . $current_split_num . "/"
              . $bbox->{'name'}
              . $georef_extension . "\" \"" . "TFW" . "\" \""
              . $bbox->{'name'}
              . $image_extension . "\" \""
              . $bbox->{'x1'} . "\" \""
              . $bbox->{'y1'} . "\" \""
              . $bbox->{'x2'} . "\" \""
              . $bbox->{'y2'} . "\" \""
              . $image_width_harvesting . "\" \""
              . $image_height_harvesting . "\" \""
              . $target_srs
              . "\";if [[ 0 != \$? ]]; then exit 1; fi;\n";

            print {$tab_hdl_split[$current_split_num - 1]} $cmd_harvesting;

            # Passage au plit suivant
            $current_split_num = $current_split_num + 1;
            if ( $current_split_num > $split_number ) {
                $current_split_num = 1;
            }
        }

  # Ecriture des preprocess d'images pour repasser en tiff avant pasage dans be4
        for (
            my $current_split_num_for_preprocess = 1 ;
            $current_split_num_for_preprocess <= $split_number ;
            $current_split_num_for_preprocess++
          )
        {

            # Creation de la commande de preprocessing
            my $cmd_preprocessing =
                $exec_script
              . " preprocessing_images \""
              . $path_image
              . $current_split_num_for_preprocess . "\" \""
              . $path_image
              . $current_split_num_for_preprocess . "\" "
              . "\"png2tiff\" \"false\""
              . ";if [[ 0 != \$? && 1 != \$? && 2 != \$? ]]; then exit 1; fi;\n";

            print {$tab_hdl_split[$current_split_num_for_preprocess - 1]} $cmd_preprocessing;
        }

        # Mise en forme des informations
        my $source_srs = $target_srs;
        my $dir_root =
          $root_storage . "/" . $storage_path . "/" . $bd_id;
        my $pyr_path     = $dir_root . "/" . $level . "/" . $pyramid_dir;
        my $pyr_name_new = $level;
        my $path_temp =
          $tmp_moissonnage_dir . "/" . $level . "/" . $tmp_dir_name;
        my $path_shell =
          $tmp_moissonnage_dir . "/" . $level . "/" . $scripts_dir_name;
        my $cfg_file =
          $tmp_moissonnage_dir . "/" . $level . "/" . $config_file_name;
        my $dir_root_old;
        my $pyr_path_old;

        if ( defined $old_bd_name && "" ne $old_bd_name ) {
            $dir_root_old =
              $root_storage . "/" . $old_storage_path . "/" . $old_bd_id;
            $pyr_path_old = $dir_root_old . "/" . $pyramid_dir;

            # Vérification de l'existence de la pyramide de données ancetre
            if ( !-e ( $pyr_path_old . "/" . $old_bd_name . $pyr_extension ) ) {
                $logger->log( "ERROR",
                        "Le descripteur de la pyramide ancêtre n'existe pas : "
                      . $pyr_path_old . "/"
                      . $old_bd_name
                      . $pyr_extension );

                return 7;
            }
        }

        # Ecriture de la configuration
        $logger->log( "INFO", "Ecriture de la configuration be4" );
        my $return_create_be4_conf = create_be4_conf(
            $cfg_file,                  $path_image,
            $source_srs,                $dir_root,
            $pyr_path,                  $pyr_name_new,
            undef,                      $dir_root_old,
            $pyr_path_old,              $old_bd_name,
            $tms_name . $tms_extension, $compression,
            $compression_option,        $image_width,
            $image_height,              $bitspersample,
            $sampleformat,              $photometric,
            $samplesperpixel,           $interpolation,
            $gamma,                     $path_temp,
            $path_shell,                $nodata_value,
            "false",                    $level,
            $level
        );
        if ( $return_create_be4_conf != 0 ) {
            $logger->log( "ERROR",
"Erreur lors de l'écriture de la configuration rok4 spécifique"
            );
            $logger->log( "DEBUG", "Code retour : " . $return_create_be4_conf );

            return 8;
        }
    }

	# Fermeture des fichiers de script
	for ( $current_split_num = 1 ; $current_split_num <= $split_number ; $current_split_num += 1 ) {
		$logger->log( "DEBUG",
                    "Fermeture du script "
                  . $current_split_num );
		
		if ( !close $tab_hdl_split[$current_split_num - 1] ) {
			$logger->log( "ERROR",
				"Impossible de fermer le script " . $current_split_num );
			return 4;
		}
	}
	
    # Récupération des originators, startDate endDate
    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/generation/getOriginators" );
    $response =
      $ua->request( GET $url_ws_entrepot
          . "/generation/getOriginators?resourceId="
          . $resource_id );

    if ( $response->is_success ) {
        $logger->log( "INFO",
            "Récupération des originators de la resource dont l'id est "
              . $resource_id );
    }
    else {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la récupération de la resource dont l'id est "
              . $resource_id );
        return 9;
    }

    # Conversion de la réponse JSON en structure PERL
    $json_response = $response->decoded_content;
    $hash_response = JSON::from_json($json_response);
    if ( !$hash_response ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la conversion de la réponse JSON"
        );
        return 254;
    }

    my $originators = $hash_response->{'originators'};
    my $start_date  = $hash_response->{'startDate'};
    my $end_date    = $hash_response->{'endDate'};
    $logger->log( "INFO",
            "Récupération des information de la resource, originators : "
          . $originators
          . ", startDate : "
          . $start_date
          . ", endDate : "
          . $end_date );

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
                "Mise à jour de la donnée de diffusion " 
              . $bd_id
              . " effectuée" );
    }
    else {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour de la donnée de diffusion "
              . $bd_id );
        return 9;
    }

    # Bounding box
    $logger->log( "INFO", "Calcul de la BBOX des données à générer" );
    my $return_bbox_from_ewkt = bbox_from_ewkt( $polygon_wkt, $target_srs );
    if ( Tools->is_numeric($return_bbox_from_ewkt)
        && 0 != $return_bbox_from_ewkt )
    {
        $logger->log( "ERROR",
            "Erreur lors du calcul de la BBOX de la donnée à générer" );
        $logger->log( "DEBUG", "Code retour : " . $return_bbox_from_ewkt );

        return 10;
    }

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
            startDate       => $start_date,
            endDate         => $end_date,
            bboxes          => $return_bbox_from_ewkt,
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

    # Copy mtds from ancestor broadcastdata to new broadcastdata
    if ( defined $old_bd_id ) {

        $logger->log( "INFO",
"recopie des metadonnées de la donnée ancêtre vers la nouvelle donnée "
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

    return 0;
}

