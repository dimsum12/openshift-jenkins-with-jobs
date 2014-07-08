#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script write a joincache configuration from input information
# ARGS :
#   The file to write in (absolute path)
#	The log level
#	The pyramid name
#	The pyramid desc path
#	The pyramid data path
#	The tms path
# 	The tms name
#	The image directory
#	The metadata directory
#	The nodata directory
#	The compression
#	The number of samples per pixel
#	The photometric
#	The number of  bits per sample
#	The sample format
#	The merge method
#	Bboxes array reference
#	The path shell
#	The path temp
#	The job number
#	Composition array reference
# RETURNS :
#   * 0 if the configuration file is correctly written
#   * 1 if an I/O error occured during writing the file
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/base-block/create_joincache_conf.pl $
#   $Date: 25/05/12 $
#   $Author: Kevin Ferrier (a145972) <kevin.ferrier@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Execute;
use Config::Simple;
use Readonly;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "create_joincache_conf.pl", $logger_levels );

my $line_return   = "\r\n";
my $key_value_sep = " = ";

my $joincache_key_namespace_logger = "[ logger ]";
my $joincache_key_log_level        = "log_level";

my $joincache_namespace_pyramid = "[ pyramid ]";
my $joincache_key_pyr_name      = "pyr_name";
my $joincache_key_pyr_desc_path = "pyr_desc_path";
my $joincache_key_pyr_data_path = "pyr_data_path";

my $joincache_key_tms_path = "tms_path";
my $joincache_key_tms_name = "tms_name";

my $joincache_key_image_dir    = "image_dir ";
my $joincache_key_metadata_dir = "metadata_dir";
my $joincache_key_nodata_dir   = "nodata_dir";

my $joincache_key_compression     = "compression";
my $joincache_key_samplesperpixel = "samplesperpixel";
my $joincache_key_photometric     = "photometric";
my $joincache_key_bitspersample   = "bitspersample";
my $joincache_key_sampleformat    = "sampleformat";

my $joincache_key_merge_method = "merge_method";

my $joincache_namespace_bboxes = "[ bboxes ]";

my $joincache_namespace_process = "[ process ]";
my $joincache_key_path_shell    = "path_shell";
my $joincache_key_path_temp     = "path_temp";
my $joincache_key_job_number    = "job_number";

my $joincache_namespace_composition = "[ composition ]";

Readonly my $CFG_FILE_CORRECTLY_WRITTEN     => 0;
Readonly my $ERROR_IO_WRITING_FILE          => 1;
Readonly my $ERROR_INCORRECT_NUMBER_OF_ARGS => 255;

sub create_joincache_conf {

    # Extraction des paramètres
    my (
        $file_path,     $log_level,     $pyr_name,     $pyr_desc_path,
        $pyr_data_path, $tms_path,      $tms_name,     $image_dir,
        $metadata_dir,  $nodata_dir,    $compression,  $samplesperpixel,
        $photometric,   $bitspersample, $sampleformat, $merge_method,
        $bboxes_ref,    $path_shell,    $path_temp,    $job_number,
        $levels_ref
    ) = @_;

    # Vérification du nombre de paramètres
    if (   !defined $file_path
        || !defined $log_level
        || !defined $pyr_name
        || !defined $pyr_desc_path
        || !defined $pyr_data_path
        || !defined $tms_path
        || !defined $tms_name
        || !defined $image_dir
        || !defined $metadata_dir
        || !defined $nodata_dir
        || !defined $compression
        || !defined $samplesperpixel
        || !defined $photometric
        || !defined $bitspersample
        || !defined $sampleformat
        || !defined $merge_method
        || !defined $bboxes_ref
        || !defined $path_shell
        || !defined $path_temp
        || !defined $job_number
        || !defined $levels_ref )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (21)"
        );
        return $ERROR_INCORRECT_NUMBER_OF_ARGS;
    }

    $logger->log( "DEBUG", "Paramètre 1 : file_path = " . $file_path );
    $logger->log( "DEBUG", "Paramètre 2 : log_level = " . $log_level );
    $logger->log( "DEBUG", "Paramètre 3 : pyr_name = " . $pyr_name );
    $logger->log( "DEBUG", "Paramètre 4 : pyr_desc_path = " . $pyr_desc_path );
    $logger->log( "DEBUG", "Paramètre 5 : pyr_data_path = " . $pyr_data_path );
    $logger->log( "DEBUG", "Paramètre 6 : tms_path = " . $tms_path );
    $logger->log( "DEBUG", "Paramètre 7 : tms_name = " . $tms_name );
    $logger->log( "DEBUG", "Paramètre 8 : image_dir = " . $image_dir );
    $logger->log( "DEBUG", "Paramètre 9 : metadata_dir = " . $metadata_dir );
    $logger->log( "DEBUG", "Paramètre 10 : nodata_dir = " . $nodata_dir );
    $logger->log( "DEBUG", "Paramètre 11 : compression = " . $compression );
    $logger->log( "DEBUG",
        "Paramètre 12 : samplesperpixel = " . $samplesperpixel );
    $logger->log( "DEBUG", "Paramètre 13 : photometric = " . $photometric );
    $logger->log( "DEBUG",
        "Paramètre 14 : bitspersample = " . $bitspersample );
    $logger->log( "DEBUG", "Paramètre 15 : sampleformat = " . $sampleformat );
    $logger->log( "DEBUG", "Paramètre 16 : merge_method = " . $merge_method );
    $logger->log( "DEBUG", "Paramètre 17 : bboxes = " . @{$bboxes_ref} );
    $logger->log( "DEBUG", "Paramètre 18 : path_shell = " . $path_shell );
    $logger->log( "DEBUG", "Paramètre 19 : path_temp = " . $path_temp );
    $logger->log( "DEBUG", "Paramètre 20 : job_number = " . $job_number );
    $logger->log( "DEBUG", "Paramètre 21 : levels = " . @{$levels_ref} );

    $logger->log( "DEBUG", "Ouverture en écriture du fichier " . $file_path );
    my $hdl_cfgfile;
    if ( !open $hdl_cfgfile, ">", $file_path ) {
        $logger->log( "ERROR",
            "Impossible de créer le fichier de configuration joincache : "
              . $file_path );
        return $ERROR_IO_WRITING_FILE;
    }
    else {
        $logger->log( "INFO",
            "Création du fichier de configuration joincache : " . $file_path );
    }

    # Ecriture des informations dans le fichier
    $logger->log( "INFO",
        "Début de l'écriture de la configuration spécifique pour joincache" );

    print {$hdl_cfgfile} $joincache_key_namespace_logger . $line_return;
    print {$hdl_cfgfile} $joincache_key_log_level
      . $key_value_sep
      . $log_level
      . $line_return;
    print {$hdl_cfgfile} $line_return;

    print {$hdl_cfgfile} $joincache_namespace_pyramid . $line_return;
    print {$hdl_cfgfile} $joincache_key_pyr_name
      . $key_value_sep
      . $pyr_name
      . $line_return;
    print {$hdl_cfgfile} $joincache_key_pyr_desc_path
      . $key_value_sep
      . $pyr_desc_path
      . $line_return;
    print {$hdl_cfgfile} $joincache_key_pyr_data_path
      . $key_value_sep
      . $pyr_data_path
      . $line_return;
    print {$hdl_cfgfile} $line_return;
    print {$hdl_cfgfile} $joincache_key_tms_path
      . $key_value_sep
      . $tms_path
      . $line_return;
    print {$hdl_cfgfile} $joincache_key_tms_name
      . $key_value_sep
      . $tms_name
      . $line_return;
    print {$hdl_cfgfile} $line_return;
    print {$hdl_cfgfile} $joincache_key_image_dir
      . $key_value_sep
      . $image_dir
      . $line_return;
    print {$hdl_cfgfile} $joincache_key_metadata_dir
      . $key_value_sep
      . $metadata_dir
      . $line_return;
    print {$hdl_cfgfile} $joincache_key_nodata_dir
      . $key_value_sep
      . $nodata_dir
      . $line_return;
    print {$hdl_cfgfile} $line_return;
    print {$hdl_cfgfile} $joincache_key_compression
      . $key_value_sep
      . $compression
      . $line_return;
    print {$hdl_cfgfile} $joincache_key_samplesperpixel
      . $key_value_sep
      . $samplesperpixel
      . $line_return;
    print {$hdl_cfgfile} $joincache_key_photometric
      . $key_value_sep
      . $photometric
      . $line_return;
    print {$hdl_cfgfile} $joincache_key_bitspersample
      . $key_value_sep
      . $bitspersample
      . $line_return;
    print {$hdl_cfgfile} $joincache_key_sampleformat
      . $key_value_sep
      . $sampleformat
      . $line_return;
    print {$hdl_cfgfile} $line_return;
    print {$hdl_cfgfile} $joincache_key_merge_method
      . $key_value_sep
      . $merge_method
      . $line_return;
    print {$hdl_cfgfile} $line_return;

    print {$hdl_cfgfile} $joincache_namespace_bboxes . $line_return;
    my $value;
    foreach my $value ( @{$bboxes_ref} ) {
        if ( !defined $value ) {
            $value = "";
        }
        print {$hdl_cfgfile} $value . $line_return;
    }
    print {$hdl_cfgfile} $line_return;

    print {$hdl_cfgfile} $joincache_namespace_process . $line_return;
    print {$hdl_cfgfile} $joincache_key_path_shell
      . $key_value_sep
      . $path_shell
      . $line_return;
    print {$hdl_cfgfile} $joincache_key_path_temp
      . $key_value_sep
      . $path_temp
      . $line_return;
    print {$hdl_cfgfile} $joincache_key_job_number
      . $key_value_sep
      . $job_number
      . $line_return;
    print {$hdl_cfgfile} $line_return;

    print {$hdl_cfgfile} $joincache_namespace_composition . $line_return;
    foreach my $value ( @{$levels_ref} ) {
        if ( !defined $value ) {
            $value = "";
        }
        print {$hdl_cfgfile} $value . $line_return;
    }
    if ( !close $hdl_cfgfile ) {
        $logger->log( "ERROR",
"Impossible de fermer le fichier de configuration joincache ouvert en écriture : "
              . $file_path );
        return $ERROR_IO_WRITING_FILE;
    }

    return $CFG_FILE_CORRECTLY_WRITTEN;
}
