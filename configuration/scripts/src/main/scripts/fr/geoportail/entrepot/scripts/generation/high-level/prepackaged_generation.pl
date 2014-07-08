#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will generate a prepackaged broadcast data using the generation id
#       First it collect informations from service REST
#       Then it calculate all the prepackages units to generate, from the informations given
#       Then for each prepackaged :
#			it prepared the generation of the package
#			it launch the generation
#			it update the braodcast data with the generated package
# ARGS :
#   The generation ID
#	The Ecommerce identifier of product (sample : BDORTHO), used for packaging
#	Base package name, using only for naming
#	Shapefile for the emprises to generate (must have a field "ID", used for naming)
#	Projections to generate (separated by a pipe |)
#	Formats to generate (separated by a pipe |)
#	Origins points for WMS cutting (formatted "X,Y" separated by a pipe |)
#	Geographic image size for WMS (formated "Width,Height" in geographical units)
#	Real image size for WMS (formated "Width,Height" in pixel)
#	Generic formatting for WMS possibly using :
#		%PROJ% 		--> The current projection
#		%Xn% 		--> X current value, where unit of X is 10^n meters (for kilometer, use %X3%)
#		%Yn% 		--> Y current value, where unit of Y is 10^n meters (for hectometer, use %Y2%)
# RETURNS :
#   * 0 if generation is correct
#   * 1 if the REST service is not reacheable or if the ID is incorrect
#   * 2 if the generation is linked to no resource
#   * 3 if the generation is linked to many broadcast datas
#   * 4 if at least an input resource is not published in internal zone
#   * 5 if an error occured during reading or controlling parameters
#   * 6 if an error occured during creating or writing generations files
#   * 253 if the generation structure is incorrect
#   * 254 if the JSON return is not parseable
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/prepackaged_generation.pl $
#   $Date: 13/12/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Execute;
use Tools;
use Cwd;
use LWP::UserAgent;
use HTTP::Request::Common;
use Config::Simple;
use JSON;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger =
  Logger->new( "prepackaged_generation.pl", $config->param("logger.levels") );

# Configuration
my $url_ws_entrepot   = $config->param("resources.ws.url.entrepot");
my $url_proxy         = $config->param("proxy.url");
my $tmp_path          = $config->param("resources.tmp.path");
my $tmp_generation    = $config->param("resources.tmp.generations");
my $exec_script       = $config->param("resources.exec_script");
my $prepackaged_filer = $config->param("prepackaged.filer");
my $resources_path    = $config->param("resources.path");
my $emprises_dir      = $config->param("prepackaged.emprises_dir");
my $packaging_id      = $config->param("prepackaged.packaging_id");
my $manager_id        = $config->param("prepackaged.zip_size");
my $zip_max_size      = $config->param("prepackaged.manager_id");
my $split_number      = $config->param("prepackaged.split_number");
my $wms_style         = $config->param("prepackaged.wms_style");
my $ogr2ogr           = $config->param("resources.ogr2ogr");
my $service_name_wmsraster =
  $config->param("wms_extraction_raster.service_name");
my $service_name_wmsvector =
  $config->param("wms_extraction_vector.service_name");
my $service_name_wfs = $config->param("wfs_extraction.service_name");

# Clés statiques
my $shp_extension              = ".shp";
my $opt_gml                    = "-f \"GML\"";
my $dev_stdout                 = "/dev/stdout";
my $emprise_id_pattern         = ".*<ogr:ID>.*<\/ogr:ID>.*";
my $emprise_id_extract_pattern = ".*<ogr:ID>\(.*\)<\/ogr:ID>.*";
my $emprise_geom_pattern =
  ".*<ogr:geometryProperty>.*<\/ogr:geometryProperty>.*";
my $emprise_geom_extract_pattern =
  ".*<ogr:geometryProperty>\(.*\)<\/ogr:geometryProperty>.*";
my $tmp_dir_name            = "tmp";
my $scripts_dir_name        = "scripts";
my $base_split_script_name  = "split_";
my $end_split_script_name   = ".sh";
my $unit_prepackaging_sub   = "unit_prepackaging";
my $line_return             = "\r\n";
my $bash_controlling_return = "if [[ \$? != \"0\" ]]; then exit 1; fi;";

sub prepackaged_generation {

    # Extraction des paramètres
    my (
        $generation_id,      $ecom_product_id, $base_name,
        $emprises_file_name, $projections,     $formats,
        $origins,            $geo_size,        $pixel_size,
        $formatter
    ) = @_;
    if (   !defined $generation_id
        || !defined $ecom_product_id
        || !defined $base_name
        || !defined $emprises_file_name
        || !defined $projections
        || !defined $formats
        || !defined $origins
        || !defined $geo_size
        || !defined $pixel_size
        || !defined $formatter )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (10)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : generation_id = " . $generation_id );
    $logger->log( "DEBUG",
        "Paramètre 2 : ecom_product_id = " . $ecom_product_id );
    $logger->log( "DEBUG", "Paramètre 3 : base_name = " . $base_name );
    $logger->log( "DEBUG",
        "Paramètre 4 : emprises_file_name = " . $emprises_file_name );
    $logger->log( "DEBUG", "Paramètre 5 : projections = " . $projections );
    $logger->log( "DEBUG", "Paramètre 6 : formats = " . $formats );
    $logger->log( "DEBUG", "Paramètre 7 : origins = " . $origins );
    $logger->log( "DEBUG", "Paramètre 8 : geo_size = " . $geo_size );
    $logger->log( "DEBUG", "Paramètre 9 : pixel_size = " . $pixel_size );
    $logger->log( "DEBUG", "Paramètre 10 : formatter = " . $formatter );

    # Validation des paramètres
    my $emprises_file =
        $resources_path . "/"
      . $emprises_dir . "/"
      . $emprises_file_name
      . $shp_extension;
    if ( !-f $emprises_file ) {
        $logger->log( "ERROR",
            "Le fichier d'emprises " . $emprises_file . " n'existe pas" );
        return 5;
    }

    # Lecture du fichier des emprises : Passage de shapefile à GML
    $logger->log( "INFO", "Lecture des emprises dans le fichier" );
    my $cmd_ogr2ogr =
      $ogr2ogr . " " . $opt_gml . " " . $dev_stdout . " " . $emprises_file;
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd_ogr2ogr );
    my $result_ogr2ogr = Execute->run( $cmd_ogr2ogr, "false" );

    if ( $result_ogr2ogr->get_return() != 0 ) {
        $logger->log( "ERROR",
            "La commande à renvoyé " . $result_ogr2ogr->get_return() );
        $logger->log( "DEBUG", "Sortie complète du processus :" );
        $result_ogr2ogr->log_all( $logger, "DEBUG" );

        return 5;
    }

    # Lecture du GML en 2 temps : Geometrie, et champ ID
    my @gml_return          = $result_ogr2ogr->get_log();
    my %extraction_polygons = ();
    my $current_id          = "";
    my $current_geom        = "";
    foreach my $gml_line (@gml_return) {
        chomp $gml_line;

        # Lecture de l'ID
        if ( $gml_line =~ /$emprise_id_pattern/ ) {
            if ( "" ne $current_id ) {
                $logger->log( "ERROR",
"Aucun élément de géométrie n'a été trouvé pour l'ID "
                      . $current_id );
                return 5;
            }
            $current_id = $gml_line;
            $current_id =~ s/$emprise_id_extract_pattern/$1/;
            $logger->log( "DEBUG", "ID trouvé : " . $current_id );
        }

        # Lecture de la géométrie
        if ( $gml_line =~ /$emprise_geom_pattern/ ) {
            if ( "" ne $current_geom ) {
                $logger->log( "ERROR",
                    "Aucun ID n'a été trouvé pour l'élément "
                      . $current_geom );
                return 5;
            }
            $current_geom = $gml_line;
            $current_geom =~ s/$emprise_geom_extract_pattern/$1/;
            $logger->log( "DEBUG", "Géométrie trouvé : " . $current_geom );
        }

        # Ajout du couple au hash
        if ( "" ne $current_id && "" ne $current_geom ) {
            $extraction_polygons{$current_id} = $current_geom;
            $current_id                       = "";
            $current_geom                     = "";
            $logger->log( "DEBUG", "Couple ID/geom ajouté à la liste" );
        }
    }

    if ( "" ne $current_id || "" ne $current_geom ) {
        $logger->log( "ERROR",
"Le nombre d'IDs et le nombre de géométries dans le fichier shapefile ne sont pas identiques"
        );
        return 5;
    }
    $logger->log( "INFO",
            ( keys %extraction_polygons )
          . " élément(s) trouvé(s) dans le shapefile "
          . $emprises_file_name );

    # Split des projections
    $logger->log( "DEBUG", "Split de des projections : " . $projections );
    my @projections_tab = split /\|/, $projections;
    $logger->log( "DEBUG",
        scalar @projections_tab . " projections à traiter" );

    # Split des formats
    $logger->log( "DEBUG", "Split de des formats : " . $formats );
    my @formats_tab = split /\|/, $formats;
    $logger->log( "DEBUG", scalar @formats_tab . " formats à traiter" );

    # Split des origines
    $logger->log( "DEBUG", "Split de des origines : " . $origins );
    my @origins_tab = split /\|/, $origins;
    $logger->log( "DEBUG", scalar @origins_tab . " origines trouvées" );

    if ( scalar @projections_tab != scalar @origins_tab ) {
        $logger->log( "ERROR",
                "Il n'y a pas autant d'origines de grilles ("
              . scalar @origins_tab
              . ") que de projections ("
              . scalar @projections_tab
              . ") en entrée" );
        return 5;
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

    my $input_datas = $hash_response->{'inputDatas'};
    if ( !defined @{$input_datas} ) {
        $logger->log( "ERROR",
"La génération demandée n'est lié à aucune donnée en entrée alors que ce type de traitement en attend au moins une"
        );
        return 2;
    }
    $logger->log( "DEBUG",
        scalar( @{$input_datas} ) . " donnée(s) liée(s) à la génération" );

    my $layers_wmsraster_list = "";
    my $layers_wmsvector_list = "";
    my $layers_wfs_list       = "";
    foreach my $input_data ( @{$input_datas} ) {
        my $released = $input_data->{'releasedOnInternal'};
        if ( !$released ) {
            $logger->log( "ERROR",
                "Une donnée en entrée du processus n'est pas une ressource" );
            return 253;
        }
        if ( "false" eq $released ) {
            $logger->log( "ERROR",
"Une ressource en entrée du processus n'est pas publiée sur la zone interne"
            );
            return 4;
        }

        my $layer_name = $input_data->{'layerName'};
        if ( !$layer_name ) {
            $logger->log( "ERROR",
"Une donnée en entrée du processus ne possède pas de nom de couche"
            );
            return 253;
        }
        $logger->log( "DEBUG",
            "Nom de couche de la ressource en base : " . $layer_name );

        my $resource_family = $input_data->{'resourceFamily'};
        if ( !$resource_family ) {
            $logger->log( "ERROR",
                "Une donnée en entrée du processus ne possède pas de famille"
            );
            return 253;
        }
        my $service = $resource_family->{'service'};
        if ( !$service ) {
            $logger->log( "ERROR",
"Une donnée en entrée du processus ne possède pas de nom de service"
            );
            return 253;
        }
        if ( $service_name_wmsraster eq $service ) {
            $logger->log( "DEBUG",
                    "Ajout de "
                  . $layer_name
                  . " à la liste des couches WMS raster" );

            if ( "" eq $layers_wmsraster_list ) {
                $layers_wmsraster_list = $layer_name;
            }
            else {
                $layers_wmsraster_list =
                  $layers_wmsraster_list . "|" . $layer_name;
            }
        }
        elsif ( $service_name_wmsvector eq $service ) {
            $logger->log( "DEBUG",
                    "Ajout de "
                  . $layer_name
                  . " à la liste des couches WMS vector" );

            if ( "" eq $layers_wmsvector_list ) {
                $layers_wmsvector_list = $layer_name;
            }
            else {
                $layers_wmsvector_list =
                  $layers_wmsvector_list . "|" . $layer_name;
            }
        }
        elsif ( $service_name_wfs eq $service ) {
            $logger->log( "DEBUG",
                "Ajout de " . $layer_name . " à la liste des couches WFS" );

            if ( "" eq $layers_wfs_list ) {
                $layers_wfs_list = $layer_name;
            }
            else {
                $layers_wfs_list = $layers_wfs_list . "|" . $layer_name;
            }
        }
        else {
            $logger->log( "ERROR",
                    "Une donnée en entrée du processus est liée au service "
                  . $service
                  . ", qui n'est pas géré par cette génération" );
            return 253;
        }
        $logger->log( "DEBUG",
            "Nom du service de la ressource en base : " . $service );
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

    # Calcul du repertoire de travail temporaire du package
    my $tmp_output_storage = $tmp_path . $tmp_generation . "/" . $generation_id;
    $logger->log( "INFO",
        "Les extractions temporaires seront effectuées vers : "
          . $tmp_output_storage );

    # Calcul de la destination du package
    my $final_output_storage = $prepackaged_filer . "/" . $bd_id;
    $logger->log( "INFO",
        "Le packaging final sera effectué vers : " . $final_output_storage );

    # Création des répertoires temporaires
    my $tmp_generation_dir = $tmp_output_storage . "/" . $scripts_dir_name;
    $logger->log( "DEBUG",
        "Création de l'arborescence temporaire " . $tmp_generation_dir );
    if ( system( "mkdir -p " . $tmp_generation_dir ) != 0 ) {
        $logger->log( "ERROR",
"Impossible de créer le repertoire temporaire de la génération : "
              . $tmp_generation_dir );

        return 6;
    }
    else {
        $logger->log( "INFO",
            "Création du repertoire temporaire de la génération : "
              . $tmp_generation_dir );
    }

    my $base_split_script_file =
        $tmp_output_storage . "/"
      . $scripts_dir_name . "/"
      . $base_split_script_name;

    # Creation des ouverture des fichiers de splitting
    my @hgl_split_tab = ();
    for ( 0 .. $split_number - 1 ) {
        my $split_script_file =
          $base_split_script_file . $_ . $end_split_script_name;

        $logger->log( "DEBUG",
            "Ouverture en écriture du fichier " . $split_script_file );
        my $hdl_splitfile;
        if ( !open $hdl_splitfile, ">", $split_script_file ) {
            $logger->log( "ERROR",
"Impossible de créer le fichier de génération de prépackagés : "
                  . $split_script_file );

            return 6;
        }
        else {
            $logger->log( "INFO",
                "Création du fichier de génération de prépackagés : "
                  . $split_script_file );
        }

        $hgl_split_tab[$_] = $hdl_splitfile;
    }

    # Boucle sur les packages à préparer
    my $current_split = 0;
    my $purchase_id   = "";
    foreach my $format (@formats_tab) {
        for ( 0 .. scalar(@projections_tab) - 1 ) {
            while ( my ( $geom_id, $geom ) = each(%extraction_polygons) ) {
                my $split_script_file =
                    $base_split_script_file
                  . $current_split
                  . $end_split_script_name;

                my $package_name =
                    $base_name . "_" 
                  . $format . "_"
                  . $projections_tab[$_] . "_"
                  . $geom_id;
                $logger->log( "INFO",
                    "Ecriture du script de génération du package : "
                      . $package_name );

                # Ecriture de la commande unitaire
                my $cmd_prepackaging_unit =
                    $exec_script . " "
                  . $unit_prepackaging_sub . " " . "\""
                  . $bd_id . "\" " . "\""
                  . $packaging_id . "\" " . "\""
                  . $ecom_product_id . "\" " . "\""
                  . $purchase_id . "\" " . "\""
                  . $manager_id . "\" " . "\""
                  . $wms_style . "\" " . "\""
                  . $geom_id . "\" " . "\""
                  . $package_name . "\" " . "\""
                  . $zip_max_size . "\" " . "\""
                  . $format . "\" " . "\""
                  . $projections_tab[$_] . "\" " . "\""
                  . $origins_tab[$_] . "\" " . "\""
                  . $geo_size . "\" " . "\""
                  . $pixel_size . "\" " . "\""
                  . $geom . "\" " . "\""
                  . $layers_wmsraster_list . "\" " . "\""
                  . $layers_wmsvector_list . "\" " . "\""
                  . $layers_wfs_list . "\" " . "\""
                  . $tmp_output_storage . "/"
                  . $package_name . "\" " . "\""
                  . $final_output_storage . "/"
                  . $package_name . "\"";

                $logger->log( "DEBUG",
                        "Ecriture dans "
                      . $split_script_file
                      . " de : "
                      . $cmd_prepackaging_unit );

                print { $hgl_split_tab[$current_split] } $cmd_prepackaging_unit
                  . $line_return;
                print { $hgl_split_tab[$current_split] }
                  $bash_controlling_return . $line_return;

                # Passage au sous-script suivant
                $current_split = $current_split + 1;
                if ( $current_split >= $split_number ) {
                    $current_split = 0;
                }
            }
        }
    }

    # Fermeture des fichiers de split
    for ( 0 .. $split_number - 1 ) {
        my $split_script_file =
          $base_split_script_file . $_ . $end_split_script_name;

        if ( !close $hgl_split_tab[$_] ) {
            $logger->log( "ERROR",
"Impossible de fermer le fichier de génération de prépackagés ouvert en écriture : "
                  . $split_script_file );

            return 6;
        }
    }

    return 0;
}

