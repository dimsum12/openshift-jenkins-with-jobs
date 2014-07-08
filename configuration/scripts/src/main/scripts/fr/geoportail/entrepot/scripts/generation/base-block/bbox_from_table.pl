#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will generate a list of BBOX in WKT from a BDD table
# ARGS :
#   The DB schema's name where table is
#	The table's name to work on
#	The output SRID of the BBOXes (optionnal : using native SRID if not filed)
# RETURNS :
#   * A list of WKT BBOX if everything is ok
#   * 1 if an error occured connecting database (including table does not exist)
#   * 2 if the SRID spécified for the output is unknown
#   * 3 if there is no data in the table to work in
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/bbox_from_table.pl $
#   $Date: 09/11/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Config::Simple;
use Database;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "bbox_from_table.pl", $logger_levels );

my $dbname           = $config->param("db-ent_donnees.dbname");
my $host             = $config->param("db-ent_donnees.host");
my $port             = $config->param("db-ent_donnees.port");
my $username         = $config->param("db-ent_donnees.username");
my $password         = $config->param("db-ent_donnees.password");
my $first_last_level = $config->param("bboxes.first_level");
my $max_last_level   = $config->param("bboxes.max_level");
my $max_nb_bboxes    = $config->param("bboxes.max_nb");

sub bbox_from_table {

    # Validation des parametres
    my ( $schema, $table, $output_srid ) = @_;
    if ( !defined $schema || !defined $table ) {
        $logger->log( "ERROR",
"Le nombre de paramètres renseignés n'est pas celui attendu (2 ou 3)"
        );
        return 255;
    }

    # Prepare BDD
    $logger->log( "DEBUG",
            "Connection à la BDD : " 
          . $dbname . " sur " 
          . $host . ":" 
          . $port
          . " avec l'utilisateur "
          . $username );
    my $database =
      Database->connect( $dbname, $host, $port, $username, $password );

    if ( !defined $database ) {
        $logger->log( "ERROR",
                "Impossible de seconnecter à la base de données " 
              . $dbname . " sur "
              . $host . ":"
              . $port );
        return 1;
    }

    # Getting the table srid
    my $sql =
        "SELECT srid FROM geometry_columns WHERE f_table_schema = '" 
      . $schema
      . "' AND f_table_name = '"
      . $table . "'";
    ( my $srid ) = $database->select_one_row($sql);

    if ( !defined $srid ) {
        $logger->log( "ERROR",
                "Pas de colonne géométrique pour la table spécifiée : "
              . $schema . "."
              . $table );
        return 1;
    }
    $logger->log( "INFO", "SRID de la colonne géométrique : " . $srid );

    # Getting the table srid
    if ( defined $output_srid ) {
        $sql =
          "SELECT count(*) FROM spatial_ref_sys WHERE srid = " . $output_srid;
        ( my $count ) = $database->select_one_row($sql);

        if ( $count == 0 ) {
            $logger->log( "ERROR",
                    "Le srid de souhaité ("
                  . $output_srid
                  . ") n'est pas reconnu par la BDD" );
            return 2;
        }
    }
    else {
        $output_srid = $srid;
    }

    my $last_level = $first_last_level;

    my @final_results = ();
  LOOP: while (1) {
        $logger->log( "INFO",
                "Calcul des BBOX de la table " 
              . $schema . "." 
              . $table
              . " avec un niveau max à "
              . $last_level );

        # Récupération de la BBOX englobante des données
        $sql =
          "SELECT st_extent(the_geom) FROM " . $schema . "." . $table . ";";
        ( my $box ) = $database->select_one_row($sql);

        if ( !defined $box || "" eq $box ) {
            $logger->log( "WARN",
                    "Aucune données n'es présente dans : " 
                  . $schema . "."
                  . $table );
            return 3;
        }
        $logger->log( "DEBUG", "Resultat de st_extent : " . $box );

        # Extraction de la BBOX
        $box =~ s/^BOX\((.*)\)$/$1/;
        $logger->log( "DEBUG", "BBOX obtenue : " . $box );

        ( my $point1, my $point2 ) = split /,/, $box;
        ( my $x1,     my $y1 )     = split / /, $point1;
        ( my $x2,     my $y2 )     = split / /, $point2;
		$x1 = $x1 - 0.1;
        $y1 = $y1 - 0.1;
        $x2 = $x2 + 0.1;
        $y2 = $y2 + 0.1;
        
		# Calcul du point de coupure
        my $x_cut     = ( $x1 + $x2 ) / 2;
        my $y_cut     = ( $y1 + $y2 ) / 2;
        my $point_cut = $x_cut . " " . $y_cut;
        $logger->log( "DEBUG", "Point central : " . $point_cut );

        my @results = ();

        # Choix du premier découpage
        my @first_result;
        my @second_result;

        if ( $x2 - $x1 > $y2 - $y1 ) {
            $logger->log( "DEBUG", "Premier découpage : Axe vertical" );
            @first_result = box_recursive_control(
                "BOX(" . $x1 . " " . $y1 . "," . $x_cut . " " . $y2 . ")",
                $database, $schema, $table, $srid, 1, $last_level, 0 );
            @second_result = box_recursive_control(
                "BOX(" . $x_cut . " " . $y1 . "," . $x2 . " " . $y2 . ")",
                $database, $schema, $table, $srid, 1, $last_level, 0 );
        }
        else {
            $logger->log( "DEBUG", "Premier découpage : Axe horizontal" );
            @first_result = box_recursive_control(
                "BOX(" . $x1 . " " . $y1 . "," . $x2 . " " . $y_cut . ")",
                $database, $schema, $table, $srid, 1, $last_level, 1 );
            @second_result = box_recursive_control(
                "BOX(" . $x1 . " " . $y_cut . "," . $x2 . " " . $y2 . ")",
                $database, $schema, $table, $srid, 1, $last_level, 1 );
        }

        push @results, @first_result;
        push @results, @second_result;

        # Contrôle du résultat
        my $nb_bboxes = scalar @results;
        $logger->log( "INFO",
            "Nombre de bbox contenant de la donnée : " . $nb_bboxes );

        if ( $nb_bboxes > $max_nb_bboxes ) {
            $logger->log( "INFO",
"C'est supérieur au nombre d'éléments attendus : On récupère la valeur précédente"
            );
            last LOOP;
        }

        @final_results = @results;

        $last_level = $last_level + 1;
        if ( $last_level > $max_last_level ) {
            $logger->log( "INFO", "Dernier niveau atteint" );
            last LOOP;
        }
    }

    # Optimisation
    my $optimize = 1;
    $logger->log( "INFO", "Optimisation des BBOXes par ré-assemblage" );
    while ($optimize) {
        $optimize = 0;
        $logger->log( "DEBUG", "Passage dans la boucle d'assemblage" );

        # Tri du tableau par surface de BBOX
        $logger->log( "DEBUG", "Tri de la liste par surface" );
        @final_results = sort by_surface @final_results;

    # Parcours du tableau en commençant par la fin pour l'élément comparateur
      LOOP:
        for ( 0 .. scalar @final_results - 1 ) {
            my $index = $_;

            # Extraction de la BBOX
            my $box = $final_results[$index];
            $box =~ s/^BOX\((.*)\)$/$1/;

            ( my $box_point1, my $box_point2 ) = split /,/, $box;
            ( my $box_x1,     my $box_y1 )     = split / /, $box_point1;
            ( my $box_x2,     my $box_y2 )     = split / /, $box_point2;

            # Comparaison avec tous les éléments restants
            for ( $index + 1 .. scalar @final_results - 1 ) {
                my $index2 = $_;

                # Extraction de la BBOX
                my $box2 = $final_results[$index2];
                $box2 =~ s/^BOX\((.*)\)$/$1/;

                ( my $box2_point1, my $box2_point2 ) = split /,/, $box2;
                ( my $box2_x1,     my $box2_y1 )     = split / /, $box2_point1;
                ( my $box2_x2,     my $box2_y2 )     = split / /, $box2_point2;

                my $new_box = "";

                # Cas de jointure verticale
                if (   $box_x1 == $box2_x1
                    && $box_x2 == $box2_x2
                    && ( $box_y1 == $box2_y2 || $box_y2 == $box2_y1 ) )
                {
                    if ( $box_y1 == $box2_y2 ) {
                        $new_box =
                            "BOX(" 
                          . $box_x1 . " " 
                          . $box2_y1 . "," 
                          . $box_x2 . " "
                          . $box_y2 . ")";
                    }
                    else {
                        $new_box =
                            "BOX(" 
                          . $box_x1 . " " 
                          . $box_y1 . "," 
                          . $box_x2 . " "
                          . $box2_y2 . ")";
                    }
                }

                # Cas de jointure horizontale
                if (   $box_y1 == $box2_y1
                    && $box_y2 == $box2_y2
                    && ( $box_x1 == $box2_x2 || $box_x2 == $box2_x1 ) )
                {
                    if ( $box_x1 == $box2_x2 ) {
                        $new_box =
                            "BOX(" 
                          . $box2_x1 . " " 
                          . $box_y1 . "," 
                          . $box_x2 . " "
                          . $box_y2 . ")";
                    }
                    else {
                        $new_box =
                            "BOX(" 
                          . $box_x1 . " " 
                          . $box_y1 . "," 
                          . $box2_x2 . " "
                          . $box_y2 . ")";
                    }
                }

              # Mise à jour du tableau lorsqu'une optimisation a été trouvée
                if ( $new_box ne "" ) {
                    $logger->log( "DEBUG",
                            "Jointure des éléments " 
                          . $index . " et " 
                          . $index2
                          . ". Il reste "
                          . $#final_results
                          . " éléments" );
                    @final_results = (
                        @final_results[
                          0 .. ( $index - 1 ),
                          ( $index + 1 ) .. ( $index2 - 1 ),
                          ( $index2 + 1 ) .. $#final_results
                        ],
                        $new_box
                    );

                    # Coupure de la boucle
                    $optimize = 1;
                    last LOOP;
                }
            }
        }
    }
    $logger->log( "INFO",
        "Nombre d'éléments avec optimisation : " . scalar @final_results );

    # Conversion des BBOXes résultat
    my $polygon = "SRID=" . $srid . ";MULTIPOLYGON(";
    my $first   = 1;
    for ( 0 .. scalar @final_results - 1 ) {
        my $index = $_;

        # Conversion des BBOX
        $sql =
            "SELECT asewkt(transform(SetSRID('"
          . $final_results[$index]
          . "'::box2d,"
          . $srid . "), "
          . $output_srid . "));";
        ( my $output_box ) = $database->select_one_row($sql);

        $final_results[$index] = $output_box;
    }

    return @final_results;
}

sub box_recursive_control {

    # Validation des parametres
    my ( $box, $database, $schema, $table, $srid, $level, $last_level, $en_x ) =
      @_;
    if (   !defined $box
        || !defined $database
        || !defined $schema
        || !defined $table
        || !defined $srid
        || !defined $level
        || !defined $last_level
        || !defined $en_x )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (4)"
        );
        return 255;
    }

    $logger->log( "DEBUG", " " x $level . "Niveau : " . $level );

    # Recherche d'éléments dans la BBOX
    my $sql =
        "SELECT count(*) FROM " 
      . $schema . "." 
      . $table
      . " WHERE the_geom && SetSRID('"
      . $box
      . "'::box2d,"
      . $srid
      . ") AND st_intersects(the_geom, SetSRID('"
      . $box
      . "'::box2d,"
      . $srid . "));";
    $logger->log( "DEBUG", " " x $level . "SQL : " . $sql );
    ( my $count ) = $database->select_one_row($sql);
    $logger->log( "DEBUG", " " x $level . "Résultat : " . $count );

    # Si des éléments sont présents
    if ( $count > 0 ) {
        $logger->log( "DEBUG",
                " " x $level 
              . $box
              . " contient de la donnee ("
              . $count
              . " élément(s))" );

        # Au dernier niveau, on retourne directement la BBOX complète
        if ( $level == $last_level ) {
            $logger->log( "DEBUG",
                " " x $level . " Ajout de " . $box . " à la liste" );
            return ($box);
        }
        else {

            # Extraction de la BBOX
            my $parse_box = $box;
            $parse_box =~ s/^BOX\((.*)\)$/$1/;
            $logger->log( "DEBUG",
                " " x $level . "box obtenue : " . $parse_box );

            ( my $point1, my $point2 ) = split /,/, $parse_box;
            ( my $x1,     my $y1 )     = split / /, $point1;
            ( my $x2,     my $y2 )     = split / /, $point2;

            # Calcul du point de coupure
            my $x_cut     = ( $x1 + $x2 ) / 2;
            my $y_cut     = ( $y1 + $y2 ) / 2;
            my $point_cut = $x_cut . " " . $y_cut;
            $logger->log( "DEBUG",
                " " x $level . "Point central : " . $point_cut );

            my @results;
            my $first_bbox;
            my $second_bbox;
            if ($en_x) {
                $first_bbox =
                  "BOX(" . $x1 . " " . $y1 . "," . $x_cut . " " . $y2 . ")";
                $second_bbox =
                  "BOX(" . $x_cut . " " . $y1 . "," . $x2 . " " . $y2 . ")";
            }
            else {
                $first_bbox =
                  "BOX(" . $x1 . " " . $y1 . "," . $x2 . " " . $y_cut . ")";
                $second_bbox =
                  "BOX(" . $x1 . " " . $y_cut . "," . $x2 . " " . $y2 . ")";
            }
            my @first_result =
              box_recursive_control( $first_bbox, $database, $schema, $table,
                $srid, $level + 1, $last_level, !$en_x );
            my @second_result =
              box_recursive_control( $second_bbox, $database, $schema, $table,
                $srid, $level + 1, $last_level, !$en_x );

            if (   scalar @first_result == 1
                && $first_result[0] eq $first_bbox
                && scalar @second_result == 1
                && $second_result[0] eq $second_bbox )
            {
                $logger->log( "DEBUG",
                        " " x $level
                      . "Toutes les BBOX filles contiennent de la donnée. Suppression du découpage"
                );
                return $box;
            }
            else {
                $logger->log( "DEBUG",
                        " " x $level
                      . "Au moins une BBOX fille ne contient pas de données. Découpage conservé"
                );
                push @results, @first_result;
                push @results, @second_result;

                return @results;
            }
        }

        # Si aucun élément n'est présent
    }
    else {
        $logger->log( "DEBUG",
            " " x $level . $box . " ne contient aucune donnée" );
        return ();
    }

}

sub by_surface ($$) {
    my ( $gauche, $droit ) = @_;

    # Extraction de la BBOX gauche
    $gauche =~ s/^BOX\((.*)\)$/$1/;
    ( my $gauche_point1, my $gauche_point2 ) = split /,/, $gauche;
    ( my $gauche_x1,     my $gauche_y1 )     = split / /, $gauche_point1;
    ( my $gauche_x2,     my $gauche_y2 )     = split / /, $gauche_point2;
    my $gauche_surface =
      ( $gauche_x2 - $gauche_x1 ) * ( $gauche_y2 - $gauche_y1 );

    # Extraction de la BBOX droit
    $droit =~ s/^BOX\((.*)\)$/$1/;
    ( my $droit_point1, my $droit_point2 ) = split /,/, $droit;
    ( my $droit_x1,     my $droit_y1 )     = split / /, $droit_point1;
    ( my $droit_x2,     my $droit_y2 )     = split / /, $droit_point2;
    my $droit_surface = ( $droit_x2 - $droit_x1 ) * ( $droit_y2 - $droit_y1 );

    if ( $droit_surface > $gauche_surface ) {
        return 1;
    }
    elsif ( $droit_surface < $gauche_surface ) {
        return -1;
    }
    else {
        return 0;
    }
}
