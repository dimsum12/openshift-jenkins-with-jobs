#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will generate a BBOX in WKT from a directory containing georeferenced images
# ARGS :
#   The source folder
#   The projection SRID of the datas (understood by gdal, syntax AUTHORITY:SRID)
# RETURNS :
#   * A WKT BBOX if everything is ok
#   * 1 if the source folder doesn't exist
#   * 2 if the source folder doesn't contain images
#   * 3 if the SRID specified is incorrect
#   * 4 if an error occured when reading the images files
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/bbox_from_images.pl $
#   $Date: 07/10/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Config::Simple;
use Execute;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "bbox_from_images.pl", $logger_levels );

my $proj4srid_ini = $config->param("resources.proj2srid");
my $gdalinfo      = $config->param("resources.gdalinfo");
my $gdaltransform = $config->param("resources.gdaltransform");

my $gdaltransform_validator_pre =
  "echo '0 0 0' | " . $gdaltransform . " -s_srs '+init=";
my $gdaltransform_validator_post = " +wktext' 1> /dev/null 2>&1";
my $pattern_srid                 = ".*[:].*";
my $pattern_origin               = ".*Origin.*";
my $pattern_lower_left           = ".*Lower Left.*";
my $pattern_extract_lower_left =
  ".*Lower Left[ ]*[(][ ]*\([0-9.-]+\)[ ]*[,][ ]*\([0-9.-]+\)[ ]*[)].*";
my $pattern_upper_right = ".*Upper Right.*";
my $pattern_extract_upper_right =
  ".*Upper Right[ ]*[(][ ]*\([0-9.-]+\)[ ]*[,][ ]*\([0-9.-]+\)[ ]*[)].*";
my $key_srid             = "SRID=";
my $start_polygon        = ";POLYGON((";
my $end_polygon          = "))";
my $coordinate_separator = " ";
my $point_separator      = ",";

sub bbox_from_images {

    # Parameters validation
    my ( $source_dir, $srid ) = @_;
    if ( !defined $source_dir || !defined $srid ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (2)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : source_dir = " . $source_dir );
    $logger->log( "DEBUG", "Paramètre 2 : srid = " . $srid );

    # Does the source directory exist ?
    if ( !-d $source_dir ) {
        $logger->log( "ERROR",
                "Le répertoire source des données "
              . $source_dir
              . " n'existe pas" );
        return 1;
    }

# Listage via l'entête des fichiers images contenus dans le repertoire spécifié
    my $cmd_list_files = "find " . $source_dir . " -mindepth 1";
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
            "Le répertoire spécifié \"$source_dir\" ne contient pas d'images"
        );
        return 2;
    }

    # Projection verification using gdaltransform
    if ( ( lc $srid ) =~ /epsg.*/ ) {
        $srid = lc $srid;
    }

    my $cmd_validation =
      $gdaltransform_validator_pre . $srid . $gdaltransform_validator_post;
    $logger->log( "DEBUG", "Execution de : " . $cmd_validation );
    my $validation_return = Execute->run($cmd_validation);
    if (   $validation_return->get_return() != 0
        || $srid !~ /$pattern_srid/ )
    {
        $logger->log( "ERROR",
                "La projection " 
              . $srid
              . " n'est pas reconnue par gdaltransform" );
        return 3;
    }
    my @srid_split = split /:/, $srid;
    $srid = $srid_split[1];
    $logger->log( "DEBUG", "SRID extrait après split : #" . $srid . "#" );

    if ( $srid !~ /^[0-9]+$/ ) {
        $logger->log( "DEBUG",
            "Ouverture du fichier de projections : " . $proj4srid_ini );
        my $proj4srid = Config::Simple->new($proj4srid_ini)
          or croak Config::Simple->error();

        $logger->log( "DEBUG",
            "Récupération du srid correspondant à : " . $srid );
        $srid = $proj4srid->param($srid);

        if ( !defined $srid || "" eq $srid ) {
            $logger->log( "ERROR",
"La projection n'est pas un SRID et est introuvable dans le fichier de projection : "
                  . $proj4srid_ini );

            return 3;
        }
    }

    my $bbox_x1;
    my $bbox_x2;
    my $bbox_y1;
    my $bbox_y2;

    # Parcours de l'ensemble des images du repertoire
    for my $image_file (@list_images) {

        # Appel à gdalinfo
        my $cmd = $gdalinfo . " " . $image_file;

        $logger->log( "DEBUG", "Appel à la commande : " . $cmd );
        my $result = Execute->run( $cmd, "true" );

        if ( $result->get_return() != 0 ) {
            $logger->log( "ERROR",
                "La commande à renvoyé " . $result->get_return() );
            $logger->log( "DEBUG", "Sortie complète du processus :" );
            $result->log_all( $logger, "DEBUG" );

            return 4;
        }

        my @logs          = $result->get_log();
        my $georeferenced = "false";
        my $x1;
        my $y1;
        my $x2;
        my $y2;

        # Parcours des lignes de log de gdalinfo
        for my $log_line (@logs) {

            # Detection du champ Origin
            if ( $log_line =~ /$pattern_origin/ ) {
                $logger->log( "DEBUG",
                        "La ligne "
                      . $log_line
                      . " a été reconnue par "
                      . $pattern_origin );
                $georeferenced = "true";
            }

            # Detection du champ Lower Left
            elsif ( $log_line =~ /$pattern_lower_left/ ) {
                $logger->log( "DEBUG",
                        "La ligne "
                      . $log_line
                      . " a été reconnue par "
                      . $pattern_lower_left );
                $logger->log( "DEBUG",
                    "Application de la Regex " . $pattern_extract_lower_left );
                $log_line =~ s/$pattern_extract_lower_left/$1 $2/;

                my @point = split / /, $log_line;
                if ( scalar @point < 2 ) {
                    $logger->log( "ERROR",
                        "Impossible d'extraire un X1 et Y1 pour l'image "
                          . $image_file );
                    $logger->log( "DEBUG",
                        "Extraction intermédiaire : " . $log_line );
                    return 4;
                }

                $x1 = $point[0];
                $y1 = $point[1];
                chomp $x1;
                chomp $y1;
            }

            # Detection du champ Upper Right
            elsif ( $log_line =~ /$pattern_upper_right/ ) {
                $logger->log( "DEBUG",
                        "La ligne "
                      . $log_line
                      . " a été reconnue par "
                      . $pattern_upper_right );
                $logger->log( "DEBUG",
                    "Application de la Regex " . $pattern_extract_upper_right );
                $log_line =~ s/$pattern_extract_upper_right/$1 $2/;

                my @point = split / /, $log_line;
                if ( scalar @point < 2 ) {
                    $logger->log( "ERROR",
                        "Impossible d'extraire un X2 et Y2 pour l'image "
                          . $image_file );
                    $logger->log( "DEBUG",
                        "Extraction intermédiaire : " . $log_line );
                    return 4;
                }

                $x2 = $point[0];
                $y2 = $point[1];
                chomp $x2;
                chomp $y2;
            }
        }

        # Cas d'erreur
        if (   $georeferenced ne "true"
            || !defined $x1
            || !defined $x2
            || !defined $y1
            || !defined $y2 )
        {
            $logger->log( "ERROR",
                    "L'image "
                  . $image_file
                  . " n'est pas correctement géoréférencée" );

            return 4;
        }

        # Aggrégation des résultats
        $logger->log( "DEBUG", "Image " . $image_file . " - X1 : " . $x1 );
        if ( !defined $bbox_x1 || $x1 < $bbox_x1 ) {
            $logger->log( "DEBUG", " X1 est la nouvelle valeur minimale" );
            $bbox_x1 = $x1;
        }

        $logger->log( "DEBUG", "Image " . $image_file . " - Y1 : " . $y1 );
        if ( !defined $bbox_y1 || $y1 < $bbox_y1 ) {
            $logger->log( "DEBUG", " Y1 est la nouvelle valeur minimale" );
            $bbox_y1 = $y1;
        }

        $logger->log( "DEBUG", "Image " . $image_file . " - X2 : " . $x2 );
        if ( !defined $bbox_x2 || $x2 > $bbox_x2 ) {
            $logger->log( "DEBUG", " X2 est la nouvelle valeur maximale" );
            $bbox_x2 = $x2;
        }

        $logger->log( "DEBUG", "Image " . $image_file . " - Y2 : " . $y2 );
        if ( !defined $bbox_y2 || $y2 > $bbox_y2 ) {
            $logger->log( "DEBUG", " Y2 est la nouvelle valeur maximale" );
            $bbox_y2 = $y2;
        }
    }

    $logger->log( "DEBUG", "Valeur X1 finale : " . $bbox_x1 );
    $logger->log( "DEBUG", "Valeur Y1 finale : " . $bbox_y1 );
    $logger->log( "DEBUG", "Valeur X2 finale : " . $bbox_x2 );
    $logger->log( "DEBUG", "Valeur Y2 finale : " . $bbox_y2 );

    my $bbox_wkt =
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
    $logger->log( "DEBUG", "WKT du polygon : " . $bbox_wkt );

    return $bbox_wkt;
}
