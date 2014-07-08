#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script write a rok4 configuration from input informations
# ARGS :
#   The file to write in (absolute path)
#   The source path of the datas
#   The source projection
#   The global directory to generate output
#   The pyramid path for the generate output
#   The pyramid name for the generate output
#   The WMS layer name to harvest (can be undefined)
#   The global directory of the ancestor
#   The pyramid path of the ancestor
#   The pyramid name of the ancestor
#   The TMS name used for the generation with extension
#	The compression for the output datas
#   The compression options for the output datas
#   The images width in pixels
#   The images height in pixels
#   The bits per sample for the images
#   The sample format for the images
#   The photometric for the images
#   The samples per pixel for the images
#   The interpolation for the resampling
# 	Path used for temporary
# 	Path used for creating the low level generation scripts
#   The nodata color value used for generation
#	Preprocessing to apply to source datas (or "none" if no preprocessing is necessary)
#	A boolean ("true" or "false"), indicating if the white will be ignored in source data
#	The minimum level used for the generation (optionnal)
#	The maximum level used for the generation (optionnal)
# RETURNS :
#   * 0 if the configuration file is correctly written
#   * 1 if an I/O error occured during writing the file
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/base-block/create_be4_conf.pl $
#   $Date: 27/02/12 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Execute;
use Config::Simple;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "create_be4_conf.pl", $logger_levels );

my $line_return                   = "\r\n";
my $key_value_sep                 = " = ";
my $rok4_key_namespace_logger     = "[ logger ]";
my $rok4_key_namespace_datasource = "[ datasource ]";
my $rok4_key_namespace_harvesting = "[ harvesting ]";
my $rok4_key_namespace_pyramid    = "[ pyramid ]";
my $rok4_key_namespace_process    = "[ process ]";
my $rok4_key_namespace_nodata     = "[ nodata ]";
my $rok4_key_log_file             = "log_file";
my $rok4_key_path_image           = "path_image";
my $rok4_key_srs                  = "srs";
my $rok4_key_wms_layer            = "wms_layer";
my $rok4_key_dir_root             = "pyr_data_path";
my $rok4_key_pyr_path             = "pyr_desc_path";
my $rok4_key_dir_root_old         = "pyr_data_path_old";
my $rok4_key_pyr_path_old         = "pyr_desc_path_old";
my $rok4_key_pyr_name_new         = "pyr_name_new";
my $rok4_key_pyr_name_old         = "pyr_name_old";
my $rok4_key_tms_name             = "tms_name";
my $rok4_key_min_level            = "pyr_level_top";
my $rok4_key_max_level            = "pyr_level_bottom";
my $rok4_key_compression          = "compression";
my $rok4_key_compression_option   = "compressionoption";
my $rok4_key_image_width          = "image_width";
my $rok4_key_image_height         = "image_height";
my $rok4_key_bitspersample        = "bitspersample";
my $rok4_key_sampleformat         = "sampleformat";
my $rok4_key_photometric          = "photometric";
my $rok4_key_samplesperpixel      = "samplesperpixel";
my $rok4_key_interpolation        = "interpolation";
my $rok4_key_gamma                = "gamma";
my $rok4_key_nowhite              = "nowhite";
my $rok4_key_path_temp            = "path_temp";
my $rok4_key_path_shell           = "path_shell";
my $rok4_key_nodata_color         = "color";

sub create_be4_conf {

    # Validation des paramètres
    my (
        $file_path,          $src_path,      $source_srs,
        $dir_root,           $pyr_path,      $pyr_name_new,
        $wms_layer,          $dir_root_old,  $pyr_path_old,
        $pyr_name_old,       $tms_name,      $compression,
        $compression_option, $image_width,   $image_height,
        $bitspersample,      $sampleformat,  $photometric,
        $samplesperpixel,    $interpolation, $gamma,
        $path_temp,          $path_shell,    $nodata_value,
        $nowhite,            $min_level,     $max_level
    ) = @_;

    if (
           !defined $file_path
        || !defined $src_path
        || !defined $source_srs
        || !defined $dir_root
        || !defined $pyr_path
        || !defined $pyr_name_new
        || ( defined $pyr_name_old
            && ( !defined $pyr_path_old || !defined $dir_root_old ) )
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
        || !defined $path_temp
        || !defined $path_shell
        || !defined $nodata_value
        || !defined $nowhite
        || ( defined $min_level && !defined $max_level )
      )
    {
        $logger->log( "ERROR",
"Le nombre de paramètres renseignés n'est pas celui attendu (25 ou 27)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : file_path = " . $file_path );
    $logger->log( "DEBUG", "Paramètre 2 : src_path = " . $src_path );
    $logger->log( "DEBUG", "Paramètre 3 : source_srs = " . $source_srs );
    $logger->log( "DEBUG", "Paramètre 4 : dir_root = " . $dir_root );
    $logger->log( "DEBUG", "Paramètre 5 : pyr_path = " . $pyr_path );
    $logger->log( "DEBUG", "Paramètre 6 : pyr_name_new = " . $pyr_name_new );
    if ( defined $wms_layer ) {
        $logger->log( "DEBUG", "Paramètre 7 : wms_layer = " . $wms_layer );
    }
    if (   defined $dir_root_old
        && defined $pyr_path_old
        && defined $pyr_name_old )
    {
        $logger->log( "DEBUG",
            "Paramètre 8 : dir_root_old = " . $dir_root_old );
        $logger->log( "DEBUG",
            "Paramètre 9 : pyr_path_old = " . $pyr_path_old );
        $logger->log( "DEBUG",
            "Paramètre 10 : pyr_name_old = " . $pyr_name_old );
    }
    $logger->log( "DEBUG", "Paramètre 11 : tms_name = " . $tms_name );
    $logger->log( "DEBUG", "Paramètre 12 : compression = " . $compression );
    $logger->log( "DEBUG",
        "Paramètre 13 : compression_option = " . $compression_option );
    $logger->log( "DEBUG", "Paramètre 14 : image_width = " . $image_width );
    $logger->log( "DEBUG", "Paramètre 15 : image_height = " . $image_height );
    $logger->log( "DEBUG",
        "Paramètre 16 : bitspersample = " . $bitspersample );
    $logger->log( "DEBUG", "Paramètre 17 : sampleformat = " . $sampleformat );
    $logger->log( "DEBUG", "Paramètre 18 : photometric = " . $photometric );
    $logger->log( "DEBUG",
        "Paramètre 19 : samplesperpixel = " . $samplesperpixel );
    $logger->log( "DEBUG",
        "Paramètre 20 : interpolation = " . $interpolation );
    $logger->log( "DEBUG", "Paramètre 21 : gamma = " . $gamma );
    $logger->log( "DEBUG", "Paramètre 22 : path_temp = " . $path_temp );
    $logger->log( "DEBUG", "Paramètre 23 : path_shell = " . $path_shell );
    $logger->log( "DEBUG", "Paramètre 24 : nodata_value = " . $nodata_value );
    $logger->log( "DEBUG", "Paramètre 25 : nowhite = " . $nowhite );

    if ( defined $min_level && defined $max_level ) {
        $logger->log( "DEBUG", "Paramètre 26 : min_level = " . $min_level );
        $logger->log( "DEBUG", "Paramètre 27 : max_level = " . $max_level );
    }

    $logger->log( "DEBUG", "Ouverture en écriture du fichier " . $file_path );
    my $hdl_cfgfile;
    if ( !open $hdl_cfgfile, ">", $file_path ) {
        $logger->log( "ERROR",
            "Impossible de créer le fichier de configuration Be4 : "
              . $file_path );

        return 1;
    }
    else {
        $logger->log( "INFO",
            "Création du fichier de configuration Be4 : " . $file_path );
    }

    # Ecriture des informations dans le fichier
    $logger->log( "INFO", "Ecriture de la configuration spécifique pour BE4" );
    print {$hdl_cfgfile} $rok4_key_namespace_datasource . $line_return;
    print {$hdl_cfgfile} $rok4_key_path_image
      . $key_value_sep
      . $src_path
      . $line_return;
    print {$hdl_cfgfile} $rok4_key_srs
      . $key_value_sep
      . $source_srs
      . $line_return;
    print {$hdl_cfgfile} $line_return;

    if ( defined $wms_layer ) {
        print {$hdl_cfgfile} $rok4_key_namespace_harvesting . $line_return;
        print {$hdl_cfgfile} $rok4_key_wms_layer
          . $key_value_sep
          . $wms_layer
          . $line_return;
        print {$hdl_cfgfile} $line_return;
    }

    print {$hdl_cfgfile} $rok4_key_namespace_pyramid . $line_return;
    print {$hdl_cfgfile} $rok4_key_dir_root
      . $key_value_sep
      . $dir_root
      . $line_return;
    print {$hdl_cfgfile} $rok4_key_pyr_path
      . $key_value_sep
      . $pyr_path
      . $line_return;
    print {$hdl_cfgfile} $rok4_key_pyr_name_new
      . $key_value_sep
      . $pyr_name_new
      . $line_return;
    if ( defined $pyr_name_old ) {
        print {$hdl_cfgfile} $rok4_key_dir_root_old
          . $key_value_sep
          . $dir_root_old
          . $line_return;

        print {$hdl_cfgfile} $rok4_key_pyr_path_old
          . $key_value_sep
          . $pyr_path_old
          . $line_return;

        print {$hdl_cfgfile} $rok4_key_pyr_name_old
          . $key_value_sep
          . $pyr_name_old
          . $line_return;
    }
    print {$hdl_cfgfile} $rok4_key_tms_name
      . $key_value_sep
      . $tms_name
      . $line_return;
    if ( defined $min_level && defined $max_level ) {
        print {$hdl_cfgfile} $rok4_key_min_level
          . $key_value_sep
          . $min_level
          . $line_return;
        print {$hdl_cfgfile} $rok4_key_max_level
          . $key_value_sep
          . $max_level
          . $line_return;
    }
    print {$hdl_cfgfile} $rok4_key_compression
      . $key_value_sep
      . $compression
      . $line_return;
    print {$hdl_cfgfile} $rok4_key_compression_option
      . $key_value_sep
      . $compression_option
      . $line_return;
    print {$hdl_cfgfile} $rok4_key_image_width
      . $key_value_sep
      . $image_width
      . $line_return;
    print {$hdl_cfgfile} $rok4_key_image_height
      . $key_value_sep
      . $image_height
      . $line_return;
    print {$hdl_cfgfile} $rok4_key_bitspersample
      . $key_value_sep
      . $bitspersample
      . $line_return;
    print {$hdl_cfgfile} $rok4_key_sampleformat
      . $key_value_sep
      . $sampleformat
      . $line_return;
    print {$hdl_cfgfile} $rok4_key_photometric
      . $key_value_sep
      . $photometric
      . $line_return;
    print {$hdl_cfgfile} $rok4_key_samplesperpixel
      . $key_value_sep
      . $samplesperpixel
      . $line_return;
    print {$hdl_cfgfile} $rok4_key_interpolation
      . $key_value_sep
      . $interpolation
      . $line_return;
    print {$hdl_cfgfile} $rok4_key_gamma
      . $key_value_sep
      . $gamma
      . $line_return;
    print {$hdl_cfgfile} $rok4_key_nowhite
      . $key_value_sep
      . $nowhite
      . $line_return;
    print {$hdl_cfgfile} $line_return;

    print {$hdl_cfgfile} $rok4_key_namespace_process . $line_return;
    print {$hdl_cfgfile} $rok4_key_path_temp
      . $key_value_sep
      . $path_temp
      . $line_return;
    print {$hdl_cfgfile} $rok4_key_path_shell
      . $key_value_sep
      . $path_shell
      . $line_return;
    print {$hdl_cfgfile} $line_return;

    print {$hdl_cfgfile} $rok4_key_namespace_nodata . $line_return;
    print {$hdl_cfgfile} $rok4_key_nodata_color
      . $key_value_sep
      . $nodata_value
      . $line_return;
    print {$hdl_cfgfile} $line_return;

    if ( !close $hdl_cfgfile ) {
        $logger->log( "ERROR",
"Impossible de fermer le fichier de configuration Be4 ouvert en écriture : "
              . $file_path );

        return 1;
    }

    return 0;
}
