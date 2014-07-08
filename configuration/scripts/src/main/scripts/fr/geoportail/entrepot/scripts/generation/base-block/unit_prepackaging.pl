
#########################################################################################################################
#
# USAGE :
#   This script generate an unique prepackaged from parameters given
# ARGS :
#   The source directory for SQL and SHP
#   The schema name to create for the datas
#   The SRS of the shapefiles (optionnal, if shapefiles are present in the directory)
# RETURNS :
#   * 0 if generation is correct
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/base-block/unit_prepackaging.pl $
#   $Date: 29/12/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Database;
use Config::Simple;
use DBI;

require "extraction.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "unit_prepackaging.pl", $logger_levels );

# Configuration
my $service_name_wmsraster =
  $config->param("wms_extraction_raster.service_name");
my $service_name_wmsvector =
  $config->param("wms_extraction_vector.service_name");
my $service_name_wfs = $config->param("wfs_extraction.service_name");
my $dbname           = $config->param("db-ent_donnees.dbname");
my $host             = $config->param("db-ent_donnees.host");
my $port             = $config->param("db-ent_donnees.port");
my $username         = $config->param("db-ent_donnees.username");
my $password         = $config->param("db-ent_donnees.password");

my $pattern_extract_bbox = ".*[(]\(.*\)[)].*";

sub unit_prepackaging {

    # Extraction des paramètres
    my (
        $bd_id,                 $packaging_id,
        $ecom_product_id,       $purchase_id,
        $manager_id,            $wms_style,
        $geom_id,               $package_name,
        $zip_max_size,          $format,
        $projection,            $origin,
        $geo_size,              $pixel_size,
        $geom,                  $layers_wmsraster_list,
        $layers_wmsvector_list, $layers_wfs_list,
        $tmp_output_storage,    $extraction_output_storage
    ) = @_;
    if (   !defined $bd_id
        || !defined $packaging_id
        || !defined $ecom_product_id
        || !defined $purchase_id
        || !defined $manager_id
        || !defined $wms_style
        || !defined $geom_id
        || !defined $package_name
        || !defined $zip_max_size
        || !defined $format
        || !defined $projection
        || !defined $origin
        || !defined $geo_size
        || !defined $pixel_size
        || !defined $geom
        || !defined $layers_wmsraster_list
        || !defined $layers_wmsvector_list
        || !defined $layers_wfs_list
        || !defined $tmp_output_storage
        || !defined $extraction_output_storage )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (10)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : bd_id = " . $bd_id );
    $logger->log( "DEBUG", "Paramètre 2 : packaging_id = " . $packaging_id );
    $logger->log( "DEBUG",
        "Paramètre 2 : ecom_product_id = " . $ecom_product_id );
    $logger->log( "DEBUG", "Paramètre 3 : purchase_id = " . $purchase_id );
    $logger->log( "DEBUG", "Paramètre 4 : manager_id = " . $manager_id );
    $logger->log( "DEBUG", "Paramètre 4 : wms_style = " . $wms_style );
    $logger->log( "DEBUG", "Paramètre 5 : geom_id = " . $geom_id );
    $logger->log( "DEBUG", "Paramètre 6 : package_name = " . $package_name );
    $logger->log( "DEBUG", "Paramètre 7 : zip_max_size = " . $zip_max_size );
    $logger->log( "DEBUG", "Paramètre 7 : format = " . $format );
    $logger->log( "DEBUG", "Paramètre 7 : projection = " . $projection );
    $logger->log( "DEBUG", "Paramètre 7 : origin = " . $origin );
    $logger->log( "DEBUG", "Paramètre 7 : geo_size = " . $geo_size );
    $logger->log( "DEBUG", "Paramètre 7 : pixel_size = " . $pixel_size );
    $logger->log( "DEBUG", "Paramètre 7 : geom = " . $geom );
    $logger->log( "DEBUG",
        "Paramètre 7 : layers_wmsraster_list = " . $layers_wmsraster_list );
    $logger->log( "DEBUG",
        "Paramètre 7 : layers_wmsvector_list = " . $layers_wmsvector_list );
    $logger->log( "DEBUG",
        "Paramètre 7 : layers_wfs_list = " . $layers_wfs_list );
    $logger->log( "DEBUG",
        "Paramètre 8 : tmp_output_storage = " . $tmp_output_storage );
    $logger->log( "DEBUG",
        "Paramètre 9 : extraction_output_storage = "
          . $extraction_output_storage );

    # Extraction des noms de couche à extraire
    my @layers_wmsraster_array = split /\|/, $layers_wmsraster_list;
    my @layers_wmsvector_array = split /\|/, $layers_wmsvector_list;
    my @layers_wfs_array       = split /\|/, $layers_wfs_list;

    my $pixel_size_x;
    my $pixel_size_y;
    if ( 0 != scalar @layers_wmsraster_array + scalar @layers_wmsvector_array )
    {

        # Connexion à la BDD ent_donnees
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
                    "Impossible de se connecter à la base de données " 
                  . $dbname . " sur "
                  . $host . ":"
                  . $port );
            return 1;
        }

        # Récupération de la BBOX de la géométrie à traiter
        my $sql_bbox_from_geom =
          "SELECT st_box2d(st_geomfromgml('" . $geom . "'))";
        my ($bbox) = $database->select_one_row($sql_bbox_from_geom);
        $logger->log( "DEBUG",
            "Bounding box de la géométrie à traiter : " . $bbox );

        # Split et contrôle de la BBOX fournie
        $bbox =~ s/$pattern_extract_bbox/$1/g;
        my @bbox_points_splitted = split /,/, $bbox;
        if ( 2 != scalar @bbox_points_splitted ) {
            $logger->log( "ERROR",
                    "La bounding box reçue " 
                  . $bbox
                  . " ne contient pas 2 points" );
            return 1;
        }

        my @first_point_splitted = split / /, $bbox_points_splitted[0];
        if ( 2 != scalar @first_point_splitted ) {
            $logger->log( "ERROR",
                    "La premier point "
                  . $bbox_points_splitted[0]
                  . " ne contient pas 2 coordonnées" );
            return 1;
        }
        my ( $bbox_minx, $bbox_miny ) = @first_point_splitted;

        my @second_point_splitted = split / /, $bbox_points_splitted[1];
        if ( 2 != scalar @second_point_splitted ) {
            $logger->log( "ERROR",
                    "La second point "
                  . $bbox_points_splitted[1]
                  . " ne contient pas 2 coordonnées" );
            return 1;
        }
        my ( $bbox_maxx, $bbox_maxy ) = @second_point_splitted;

        # Split de la taille d'image en unités géographique
        my ( $geo_size_x, $geo_size_y ) = split /,/, $geo_size;

        # Split de la taille d'image en pixels
        ( $pixel_size_x, $pixel_size_y ) = split /,/, $pixel_size;

        # Split de l'origine en unités géographique
        my ( $origin_x, $origin_y ) = split /,/, $origin;

        my $tile_index_minx =
          int( ( ( $bbox_minx - $origin_x ) / $geo_size_x ) );
        my $tile_index_miny =
          int( ( ( $bbox_miny - $origin_y ) / $geo_size_y ) );
        my $tile_index_maxx =
          int( ( ( $bbox_maxx - $origin_x ) / $geo_size_x ) );
        my $tile_index_maxy =
          int( ( ( $bbox_maxy - $origin_y ) / $geo_size_y ) );
        $logger->log( "DEBUG",
            "Index X de la première tuile à extraire : " . $tile_index_minx );
        $logger->log( "DEBUG",
            "Index Y de la première tuile à extraire : " . $tile_index_miny );
        $logger->log( "DEBUG",
            "Index X de la dernière tuile à extraire : " . $tile_index_maxx );
        $logger->log( "DEBUG",
            "Index Y de la dernière tuile à extraire : " . $tile_index_maxy );
    }
    elsif ( 0 == scalar @layers_wfs_array ) {
        $logger->log( "ERROR", "Aucune couche n'est définie dans les listes" );
        return 2;
    }

    # Préparation des extractions unitaires
    my @wfs_extraction_array;
    my @wms_extraction_array;
    for my $layer_wmsraster (@layers_wmsraster_array) {
        my %wms_extraction = ();
        $wms_extraction{'layerName'}    = $layer_wmsraster;
        $wms_extraction{'dataFolder'}   = $ecom_product_id;
        $wms_extraction{'themeFolder'}  = $layer_wmsraster;
        $wms_extraction{'outputCrs'}    = $projection;
        $wms_extraction{'outputFormat'} = $format;
        $wms_extraction{'imageWidth'}   = $pixel_size_x;
        $wms_extraction{'imageHeight'}  = $pixel_size_y;
        $wms_extraction{'style'}        = $wms_style;
        $wms_extraction{'bboxes'}       = "";
        $wms_extraction{'type'}         = $service_name_wmsraster;
        $wms_extraction{'idsMetadatasIsoApToRequest'}   = "";    #TODO
        $wms_extraction{'idsMetadatasInspireToRequest'} = "";    #TODO
    }

    my $return_extraction = extraction(
        $packaging_id,                                           #OK
        $ecom_product_id,                                        #OK
        $purchase_id,                                            #OK
        $manager_id,                                             #OK
        $package_name,                                           #OK
        $zip_max_size,                                           #OK
        \@wfs_extraction_array,
        \@wms_extraction_array,
        $tmp_output_storage,                                     #OK
        $extraction_output_storage                               #OK
    );
    if ( 0 != $return_extraction ) {
        $logger->log( "ERROR", "Erreur lors de la fonction d'extraction" );
        $logger->log( "ERROR",
            "Code retour de la fonction extraction : " . $return_extraction );
        return 1;
    }

    return 0;
}

