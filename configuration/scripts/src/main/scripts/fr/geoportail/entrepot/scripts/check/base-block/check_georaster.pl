#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script check a directory of georaster by testing a part of its files
# ARGS :
#   The directory to check
#   The number of element to check (absolute value or percent value)
# RETURNS :
#   * 0 if verification is correct
#   * 1 if the schema name is incorrect
#   * 2 if the directory does not exist
#   * 3 if the directory does not contain any image
#   * 4 if the directory contain less images than the script had to test
#   * 5 if the number of element to check is not valid
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/verification/check_georaster.pl $
#   $Date: 17/08/11 $
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

our $logger =
  Logger->new( "check_georaster.pl", $config->param("logger.levels") );

my $gdalinfo           = $config->param("resources.gdalinfo");
my $pattern_origin     = ".*Origin.*";
my $pattern_pixel_size = ".*Pixel Size.*";

sub check_georaster {

    # Parameters number validation
    my ( $images_dir, $nb_images_brut ) = @_;
    if ( !defined $images_dir || !defined $nb_images_brut ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (2)"
        );
        return 255;
    }

    if ( !-d $images_dir ) {
        $logger->log( "ERROR",
            "Le répertoire des images " . $images_dir . " n'existe pas" );
        return 2;
    }

    my $is_percent = "false";

    # Test si la variable n'est pas numérique
    if ( !( $nb_images_brut =~ m/^[-]{0,1}\d+$/ ) ) {

        # Test si la variable n'est pas numérique suivie de %
        if ( !( $nb_images_brut =~ m/^\d+%$/ ) ) {
            $logger->log( "ERROR",
                    "Le nombre d'éléments à vérifier ("
                  . $nb_images_brut
                  . ") n'est ni un numérique, ni un pourcentage" );
            return 5;
        }
        elsif ( $nb_images_brut eq "0%" ) {
            $logger->log( "ERROR",
                "Le nombre d'éléments à vérifier est 0%" );
            return 5;
        }
        else {
            $is_percent = "true";
        }
    }
    elsif ( $nb_images_brut <= 0 ) {
        $logger->log( "ERROR",
                "Le nombre d'éléments à vérifier ("
              . $nb_images_brut
              . ") est égal ou inférieur à 0" );
        return 5;
    }

# Listage via l'entête des fichiers images contenus dans le repertoire spécifié
    my $cmd_list_files = "find " . $images_dir . " -mindepth 1";
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
    }
    my $nb_images = scalar @list_images;
    $logger->log( "INFO",
        $nb_images
          . " fichiers images ont été trouvés dans le répertoire spécifié"
    );

    if ( $nb_images == 0 ) {
        $logger->log( "ERROR",
            "Le répertoire spécifié \"$images_dir\" ne contient pas d'images"
        );
        return 3;
    }

    # Calcul du nombre d'éléments à vérifier
    my $nb_images_to_check;
    if ( $is_percent eq "false" ) {
        $nb_images_to_check = $nb_images_brut;
    }
    else {

# Calcul du nombre d'images à traiter si un pourcentage est spécifié (arrondi)
        $nb_images_to_check = $nb_images_brut;
        $nb_images_to_check =~ s/\%//g;
        $nb_images_to_check =
          int( ( $nb_images * $nb_images_to_check / 100 ) + 0.5 );
    }

    if ( $nb_images < $nb_images_to_check ) {
        $logger->log( "ERROR",
            "Le répertoire spécifié \"$images_dir\"contient moins d'images ("
              . $nb_images
              . ") que la vérification en demande ("
              . $nb_images_to_check
              . ")" );
        return 4;
    }

    my $nb_errors = 0;
    $logger->log( "INFO", $nb_images_to_check . " vont être vérifiées" );
    for ( 1 .. $nb_images_to_check ) {
        my $current_check = $_;

        my $element_to_check = int rand scalar @list_images;
        $logger->log( "INFO",
                "Vérification "
              . $current_check . " / "
              . $nb_images_to_check . " : "
              . $list_images[$element_to_check] );

        my $result = `$gdalinfo $list_images[$element_to_check]`;
        $logger->log( "DEBUG", "Résultat de gdalinfo : " . $result );

        if (   ( !( $result =~ /$pattern_origin/ ) )
            || ( !( $result =~ /$pattern_pixel_size/ ) ) )
        {
            $logger->log( "ERROR",
                    " Impossible de trouver les valeurs pour "
                  . $pattern_origin . " et "
                  . $pattern_pixel_size );
            $nb_errors = $nb_errors + 1;
        }
        else {
            $logger->log( "INFO", " Vérification OK" );
        }

        # Supprime l'élément vérifié du tableau
        @list_images = @list_images[
          0 .. ( $element_to_check - 1 ),
          ( $element_to_check + 1 ) .. $#list_images
        ];
    }

    if ( $nb_errors == 0 ) {
        $logger->log( "INFO",
            $nb_images_to_check . " vérification(s) effectuée(s)" );
        return 0;
    }
    else {
        $logger->log( "ERROR",
                $nb_errors
              . " vérification(s) en erreur sur "
              . $nb_images_to_check
              . " effectuée(s)" );
        return 1;
    }
}

