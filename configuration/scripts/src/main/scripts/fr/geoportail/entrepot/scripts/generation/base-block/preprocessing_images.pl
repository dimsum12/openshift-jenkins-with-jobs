#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will generate temporaries images, result of the conversion from source directory and a specified type
#	 of conversion
# ARGS :
#   The source folder
#	The target folder
#   Type of conversion needed :
#	  	tiff2gray : [B&W 1bit pp] to [grey 8bits pp].
#		pal2rgb : [Palette 8bit pp] to [rgb 24bits pp].
#		removeWhite : [white pixel #FFFFFF] to [nearby white pixel #FEFEFE].
#		png2tiff : Convert from png to tiff.
#	If source data must be keeped : "true" or "false" (optionnal, default is true)
# RETURNS :
#   * 0 if everything is OK
#   * 1 if the source folder doesn't exist
#   * 2 if the source folder doesn't contain images
#   * 3 if the target folder doesn't exist
#   * 4 if the type of conversion is unknown
#   * 5 if an error occured during conversion process
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 2 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/preprocessing_images.pl $
#   $Date: 22/03/12 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Config::Simple;
use Execute;
use File::Basename;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "preprocessing_images.pl", $logger_levels );

my $tiff2gray    = $config->param("resources.tiff2gray");
my $pal2rgb      = $config->param("resources.pal2rgb");
my $remove_white = $config->param("resources.removeWhite");
my $png2tiff     = $config->param("resources.png2tiff");
my $cp           = $config->param("resources.cp");

sub preprocessing_images {

    # Parameters validation
    my ( $source_dir, $target_dir, $process, $keep_input ) = @_;
    if ( !defined $source_dir || !defined $target_dir || !defined $process ) {
        $logger->log( "ERROR",
"Le nombre de paramètres renseignés n'est pas celui attendu (3 ou 4)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : source_dir = " . $source_dir );
    $logger->log( "DEBUG", "Paramètre 2 : target_dir = " . $target_dir );
    $logger->log( "DEBUG", "Paramètre 3 : process = " . $process );
    if ( defined $keep_input ) {
        $logger->log( "DEBUG", "Paramètre 4 : keep_input = " . $keep_input );
    }
    else {
        $keep_input = "true";
    }

    # Test du repertoire source
    if ( !-d $source_dir ) {
        $logger->log( "ERROR",
                "Le répertoire source des données "
              . $source_dir
              . " n'existe pas" );
        return 1;
    }

    # Creation du repertoire cible
    $logger->log( "INFO", "Creation du repertoire cible : " . $target_dir );
    my $cmd_create_dir = "mkdir -p " . $target_dir;
    $logger->log( "DEBUG", "Execution de : " . $cmd_create_dir );
    my $create_dir_return = Execute->run($cmd_create_dir);

    # Test du repertoire cible
    if ( !-d $target_dir ) {
        $logger->log( "ERROR",
                "Le répertoire cible des données "
              . $target_dir
              . " n'existe pas" );
        return 3;
    }

# Listage via l'entête des fichiers images contenus dans le repertoire spécifié
    my $cmd_list_files = "find " . $source_dir . " -mindepth 1 -type f";
    $logger->log( "DEBUG", "Execution de : " . $cmd_list_files );
    my $return_list_files = Execute->run($cmd_list_files);
    my @list_files        = $return_list_files->get_log();

    my @list_images = ();
    foreach my $current_file (@list_files) {
        chomp $current_file;

        my $cmd_file = "identify -quiet " . $current_file;
        $logger->log( "DEBUG", "Execution de : " . $cmd_file );
        my $return_file = Execute->run($cmd_file);

        if ( 0 == $return_file->get_return() ) {
            $logger->log( "DEBUG",
                    "Le fichier "
                  . $current_file
                  . " est une image et est donc ajouté à la liste" );
            push @list_images, $current_file;
        }
        else {
            my $target_file = $current_file;
            $target_file =~ s/$source_dir/$target_dir/;

            if ( "png2tiff" eq $process ) {
                $target_file =~ s/^(.*)[.]wld$/$1.tfw/;
            }

            my $cmd_cp = $cp . " " . $current_file . " " . $target_file;
            $logger->log( "DEBUG", "Appel à la commande : " . $cmd_cp );
            my $result_cp = Execute->run( $cmd_cp, "true" );

            if ( $result_cp->get_return() != 0 ) {
                $logger->log( "ERROR",
                    "La commande à renvoyé " . $result_cp->get_return() );
                $logger->log( "DEBUG", "Sortie complète du processus :" );
                $result_cp->log_all( $logger, "DEBUG" );

                return 5;
            }
        }
    }
    my $nb_images = scalar @list_images;
    $logger->log( "INFO",
        $nb_images
          . " fichiers images ont été trouvés dans le répertoire spécifié"
    );

    if ( $nb_images == 0 ) {
        $logger->log( "ERROR",
                "Le répertoire spécifié "
              . $source_dir
              . " ne contient pas d'images" );
        return 2;
    }

    # Vérification du process demandé
    my $cmd_base_convert;
    if ( "tiff2gray" eq $process ) {
        $cmd_base_convert = $tiff2gray . " ";
    }
    elsif ( "pal2rgb" eq $process ) {
        $cmd_base_convert = $pal2rgb . " ";
    }
    elsif ( "removeWhite" eq $process ) {
        $cmd_base_convert = $remove_white . " ";
    }
    elsif ( "png2tiff" eq $process ) {
        $cmd_base_convert = $png2tiff . " ";
    }
    else {
        $logger->log( "ERROR",
            "Le process spécifié " . $process . " n'est pas supporté" );
        return 4;
    }

    # Parcours de l'ensemble des images du repertoire
    for my $source_file (@list_images) {
        $logger->log( "DEBUG", "Traitement de : " . $source_file );
        my $target_file = $source_file;
        $target_file =~ s/$source_dir/$target_dir/;

        if ( "png2tiff" eq $process ) {
            $logger->log( "DEBUG",
                "Calcul du nom de fichier de sortie à partir de "
                  . $target_file );
            $target_file =~ s/^(.*)[.]png$/$1.tif/;
        }

        my $cmd_convert =
          $cmd_base_convert . " " . $source_file . " " . $target_file;

        $logger->log( "DEBUG", "Appel à la commande : " . $cmd_convert );
        my $result_convert = Execute->run( $cmd_convert, "true" );

        if ( $result_convert->get_return() != 0 ) {
            $logger->log( "ERROR",
                "La commande à renvoyé " . $result_convert->get_return() );
            $logger->log( "ERROR", "Sortie complète du processus :" );
            $result_convert->log_all( $logger, "ERROR" );

            return 5;
        }

        if ( "false" eq $keep_input ) {
            $logger->log( "DEBUG",
                "Suppression de la source de : " . $source_file );
            my $cmd_delete = "rm -f " . " " . $source_file;

            $logger->log( "DEBUG", "Appel à la commande : " . $cmd_delete );
            my $result_delete = Execute->run( $cmd_delete, "true" );

            if ( $result_delete->get_return() != 0 ) {
                $logger->log( "ERROR",
                    "La commande à renvoyé " . $result_delete->get_return() );
                $logger->log( "ERROR", "Sortie complète du processus :" );
                $result_delete->log_all( $logger, "ERROR" );

                return 5;
            }
        }
    }

    $logger->log( "INFO", "Conversion des images terminée" );

    return 0;
}
