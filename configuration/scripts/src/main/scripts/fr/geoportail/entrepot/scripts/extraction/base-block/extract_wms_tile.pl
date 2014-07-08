#!/usr/bin/perl
#########################################################################################################################
#
# USAGE :
#   This script extract a WMS tile from an internal WMS service
# ARGS :
#	The absolute file name used for writing the image
#	X1 value for the BBOX to extract
#	Y1 value for the BBOX to extract
#	X2 value for the BBOX to extract
#	Y2 value for the BBOX to extract
#	Image out width in pixels
#	Image out height in pixels
#	Extraction type : May be "WMSRaster" or "WMSVecteur"
#	CDA key used to extract the tile
#	Layer name used in the service to do WMS request
#	Format used in the service to do WMS request
#	Projection used in the service to do WMS request
#	Style used in the service to do WMS request
#	Context : used to build service url
#	retry attemps : number of times we retry the request
#	waiting time : time we wait before each attempt
#	A boolean value for transparence using (optionnal)
#	A value for background color (optionnal)
#	The definition for empty tile size (optionnal)
# RETURNS :
#   * 0 if the extraction is correct
#   * 1 if an error occured during writing georef file
#   * 2 if the service type specified is unknown
#   * 3 if the WMS request generate an error
#   * 4 if an error occured during writing image file
#   * 5 if the number maximum of attempts are reached, without getting a correct image
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 2 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/extraction/base-block/extract_wms_tile.pl $
#   $Date: 22/03/12 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;
use LWP::UserAgent;
use HTTP::Request::Common;
use File::Basename;
use WebserviceTools;

our $VERSION = "1.0";

require "create_georef.pl";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger =
  Logger->new( "extract_wms_tile.pl", $config->param("logger.levels") );

# Configuration
my $wms_scheme_vector  = $config->param("wms_extraction_vector.scheme");
my $wms_host_vector    = $config->param("wms_extraction_vector.host");
my $wms_port_vector    = $config->param("wms_extraction_vector.port");
my $wms_path_vector    = $config->param("wms_extraction_vector.path");
my $wms_service_vector = $config->param("wms_extraction_vector.service");
my $wms_version_vector = $config->param("wms_extraction_vector.version");
my $wms_request_vector = $config->param("wms_extraction_vector.request");
my $wms_scheme_raster  = $config->param("wms_extraction_raster.scheme");
my $wms_host_raster    = $config->param("wms_extraction_raster.host");
my $wms_port_raster    = $config->param("wms_extraction_raster.port");
my $wms_path_raster    = $config->param("wms_extraction_raster.path");
my $wms_service_raster = $config->param("wms_extraction_raster.service");
my $wms_version_raster = $config->param("wms_extraction_raster.version");
my $wms_request_raster = $config->param("wms_extraction_raster.request");
my $service_name_wmsraster =
  $config->param("wms_extraction_raster.service_name");
my $service_name_wmsvector =
  $config->param("wms_extraction_vector.service_name");

my $url_proxy = $config->param("proxy.url");
my $gdalinfo = $config->param("resources.gdalinfo");


# Clés statiques
my $parameter_key_layers         = "?LAYERS=";
my $parameter_key_version        = "&VERSION=";
my $parameter_key_format         = "&FORMAT=";
my $parameter_key_service        = "&SERVICE=";
my $parameter_key_request        = "&REQUEST=";
my $parameter_key_spatial_raster = "&CRS=";
my $parameter_key_spatial_vector = "&SRS=";
my $parameter_key_width          = "&WIDTH=";
my $parameter_key_height         = "&HEIGHT=";
my $parameter_key_styles         = "&STYLES=";
my $parameter_key_bbox           = "&BBOX=";
my $parameter_key_transparent    = "&TRANSPARENT=";
my $parameter_key_bg_color       = "&BGCOLOR=";
my $coordinate_separator         = ",";

sub extract_wms_tile {

    # Extraction des paramètres
    my (
        $image_file_name, $bbox_x1,         $bbox_y1,
        $bbox_x2,         $bbox_y2,         $image_width,
        $image_height,    $type_extraction, $cda_key,
        $layer_name,      $format,          $projection,
        $style,           $context, $retry_attempts, 
		$retry_waitingtime, $transparent,
        $bg_color, $empty_tile_size 
    ) = @_;
    if (   !defined $image_file_name
        || !defined $bbox_x1
        || !defined $bbox_y1
        || !defined $bbox_x2
        || !defined $bbox_y2
        || !defined $image_width
        || !defined $image_height
        || !defined $type_extraction
        || !defined $cda_key
        || !defined $layer_name
        || !defined $format
        || !defined $projection
        || !defined $style
        || !defined $context
		|| !defined $retry_attempts
		|| !defined $retry_waitingtime
		)
    {
        $logger->log( "ERROR",
"Le nombre de paramètres renseignés n'est pas celui attendu (14, 15, 16 ou 17)"
        );
        return 255;
    }

    $logger->log( "DEBUG",
        "Paramètre 1 : image_file_name = " . $image_file_name );
    $logger->log( "DEBUG", "Paramètre 2 : bbox_x1 = " . $bbox_x1 );
    $logger->log( "DEBUG", "Paramètre 3 : bbox_y1 = " . $bbox_y1 );
    $logger->log( "DEBUG", "Paramètre 4 : bbox_x2 = " . $bbox_x2 );
    $logger->log( "DEBUG", "Paramètre 5 : bbox_y2 = " . $bbox_y2 );
    $logger->log( "DEBUG", "Paramètre 6 : image_width = " . $image_width );
    $logger->log( "DEBUG", "Paramètre 7 : image_height = " . $image_height );
    $logger->log( "DEBUG",
        "Paramètre 8 : type_extraction = " . $type_extraction );
    $logger->log( "DEBUG", "Paramètre 9 : cda_key = " . $cda_key );
    $logger->log( "DEBUG", "Paramètre 10 : layer_name = " . $layer_name );
    $logger->log( "DEBUG", "Paramètre 11 : format = " . $format );
    $logger->log( "DEBUG", "Paramètre 12 : projection = " . $projection );
    $logger->log( "DEBUG", "Paramètre 13 : style = " . $style );
    $logger->log( "DEBUG", "Paramètre 14 : context = " . $context );
	$logger->log( "DEBUG", "Paramètre 15 : retry_attempts = " . $retry_attempts );
    $logger->log( "DEBUG", "Paramètre 16 : retry_waitingtime = " . $retry_waitingtime );

    if ( defined $transparent ) {
        $logger->log( "DEBUG",
            "Paramètre 17 : transparent = " . $transparent );
    }
    if ( defined $bg_color ) {
        $logger->log( "DEBUG", "Paramètre 18 : bg_color = " . $bg_color );
    }
    if ( defined $empty_tile_size ) {
        $logger->log( "DEBUG", "Paramètre 19 : empty_tile_size = " . $empty_tile_size );
    }
	
    # Récupération des paramètres du service à contacter
    my $spatial_key_url;
    my $wms_scheme;
    my $wms_host;
    my $wms_port;
    my $wms_path;
    my $wms_service;
    my $wms_version;
    my $wms_request;

    if ( $service_name_wmsraster eq $type_extraction ) {
        $spatial_key_url = $parameter_key_spatial_raster;
        $wms_scheme      = $wms_scheme_raster;
        $wms_host        = $wms_host_raster;
        $wms_port        = $wms_port_raster;
        $wms_path        = $wms_path_raster;
        $wms_service     = $wms_service_raster;
        $wms_version     = $wms_version_raster;
        $wms_request     = $wms_request_raster;
    }
    else {
        if ( $service_name_wmsvector eq $type_extraction ) {
            $spatial_key_url = $parameter_key_spatial_vector;
            $wms_scheme      = $wms_scheme_vector;
            $wms_host        = $wms_host_vector;
            $wms_port        = $wms_port_vector;
            $wms_path        = $wms_path_vector;
            $wms_service     = $wms_service_vector;
            $wms_version     = $wms_version_vector;
            $wms_request     = $wms_request_vector;
        }
        else {
            $logger->log( "ERROR",
                "Le type de service " . $type_extraction . " est inconnu" );
            return 2;
        }
    }

    # Creation du repertoire cible
    my $out_dir_name = dirname $image_file_name;
    $logger->log( "INFO", "Creation du repertoire cible : " . $out_dir_name );
    my $cmd_create_dir = "mkdir -p " . $out_dir_name;
    $logger->log( "DEBUG", "Execution de : " . $cmd_create_dir );
    my $create_dir_return = Execute->run($cmd_create_dir);

    # Création de la requête WMS
    my $request =
        $wms_scheme . "://"
      . $wms_host . "/"
      . $cda_key . "/"
      . lc($context)
      . $wms_path
      . $parameter_key_layers
      . $layer_name
      . $parameter_key_version
      . $wms_version
      . $parameter_key_format
      . $format
	  # attention, ici le format peut etre suivi de &FORMAT_OPTIONS=xxx defini dans extraction_wms.pl
      . $parameter_key_service
      . $wms_service
      . $parameter_key_request
      . $wms_request
      . $spatial_key_url
      . $projection
      . $parameter_key_width
      . $image_width
      . $parameter_key_height
      . $image_height
      . $parameter_key_styles
      . $style
      . $parameter_key_bbox
      . $bbox_x1
      . $coordinate_separator
      . $bbox_y1
      . $coordinate_separator
      . $bbox_x2
      . $coordinate_separator
      . $bbox_y2;

    if ( defined $transparent ) {
        $request = $request . $parameter_key_transparent . $transparent;
    }

    if ( defined $bg_color ) {
        $request = $request . $parameter_key_bg_color . $bg_color;
    }

    $logger->log( "INFO", "requete WMS  : " . $request );

    # Péparation de la requête WMS
	my $attempts = 0;
    while ( $attempts < $retry_attempts ) {
        $attempts += 1;
		my $ws = WebserviceTools->new( 'GET', $request, $url_proxy );

		# Requête WMS
		my $result = $ws->run( $retry_attempts, $retry_waitingtime );

		if ( !$result ) {

			# Erreur de requête WMS
			$logger->log( "ERROR",
	"Une erreur s'est produite lors de la requête sur le service WMS : "
				  . $request );
			return 3;
		}

		$logger->log( "DEBUG", "requête WMS exécutée avec succés" );

		# Si le contenu vaut une certaine taille, on ne l'écrit pas (cas de la tuile vide pour le moissonnage)
		$logger->log( "DEBUG",
				"Le contenu récupéré fait " . (length $ws->get_content()) . " octets" );
		if ( defined $empty_tile_size && length $ws->get_content() == $empty_tile_size ) {
			$logger->log( "DEBUG",
				"La tuile fait exactement " . $empty_tile_size . " octets, ce qui correspond à une tuile vide. Elle n'est donc pas écrite" );
			return 0;
		}
		
		# Ecriture du fichier image de sortie
		my $hdl_image_file;
		if ( !open $hdl_image_file, ">", $image_file_name ) {
			$logger->log( "ERROR",
				"Impossible de créer le fichier image " . $image_file_name );
			return 4;
		}

		print {$hdl_image_file} $ws->get_content();

		if ( !close $hdl_image_file ) {
			$logger->log( "ERROR",
				"Impossible de fermer le fichier image " . $image_file_name );
			return 4;
		}

		my $cmd_file = $gdalinfo . " " . $image_file_name;
		$logger->log( "DEBUG", "Execution de : " . $cmd_file );
		my $return_file = Execute->run($cmd_file);

		if ( 0 == $return_file->get_return() ) {		
			return 0;
		} else {
			$logger->log( "WARN",
					"Le fichier téléchargé "
				  . $image_file_name
				  . " n'est pas une image correcte" );
			$logger->log( "INFO",
					"Attente de "
				  . $retry_waitingtime
				  . " avant l'essai " . $attempts . " sur " . $retry_attempts );
				  
			# Suppression de l'image écrite
			my $cmd_delete = "rm -f " . $image_file_name;
			$logger->log( "DEBUG", "Execution de : " . $cmd_delete );
			my $result_delete = Execute->run($cmd_delete);
			if ( 0 != $result_delete->get_return() ) {
			    $logger->log( "ERROR",
                    "La commande à renvoyé " . $result_delete->get_return() );
                $logger->log( "ERROR", "Sortie complète du processus :" );
                $result_delete->log_all( $logger, "ERROR" );
				return 4;
			}
		
			sleep $retry_waitingtime;
		}
	}
	
	$logger->log( "ERROR",
		"Les " . $retry_attempts . " essais de téléchargement WMS n'ont pas donné lieu à une image correcte" );  
	return 5;
}
