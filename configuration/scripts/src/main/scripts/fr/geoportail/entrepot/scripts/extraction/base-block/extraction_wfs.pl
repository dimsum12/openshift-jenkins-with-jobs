#!/usr/bin/perl
#########################################################################################################################
#
# USAGE :
#   This script extract a complete WFS dataset
# ARGS :
#	Output folder for the extracted files
#	GML Polygon styled for the extraction
#	Polygon name, for file naming
#	Key for requesting the WFS services
#	Layer name to extract
#	Output format of the extracted files
#	Output projection of the extracted datas
#	context : used to buidl url of service
# RETURNS :
#   * 0 if the extraction is correct
#   * 1 if an error occured during creating ouptut directory
#   * 2 if an error occured during polygon converion
#   * 3 if an error occured during unzipping output file or cleaning contents
#   * 4 if an error occured copying avl and lyr files from static ref
#   * 5 if an error occured copying prj file from static ref
#   * 6 if an error occured renaming and moving files or cleaning tmp-directory
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 2 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/extraction/base-block/extraction_wfs.pl $
#   $Date: 13/02/12 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;
use Tools;
use File::Basename;

require "extract_wfs_file.pl";
require "convert_points.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger =
  Logger->new( "extraction_wfs.pl", $config->param("logger.levels") );

# Configuration
my $conditionnement_path = $config->param("resources.conditionnement_paths");
my $static_referentiel   = $config->param("static_ref.static_referentiel");
my $ogrinfo = $config->param("resources.ogrinfo");
my $ogr2ogr = $config->param("resources.ogr2ogr");

# print "$conditionnement_path";

my $config_conditionnement = Config::Simple->new($conditionnement_path);
my $legendes_wfs_path =
  $config_conditionnement->param("resources.legendes.wfs");
my $prj_path = $config_conditionnement->param("resources.prj");

my $prj_extension = ".prj";

sub extraction_wfs {

    # Extraction des paramètres
    my (
        $output_folder, $polygon,    $polygon_name,
        $manager_id,    $layer_name, $product_id,
        $output_format, $output_crs, $context
    ) = @_;
    if (   !defined $output_folder
        || !defined $polygon
        || !defined $polygon_name
        || !defined $manager_id
        || !defined $layer_name
        || !defined $product_id
        || !defined $output_format
        || !defined $output_crs
        || !defined $context )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (8)"
        );
        return 255;
    }

    $polygon =~ s/>\n.*</></g;

    $logger->log( "DEBUG", "Paramètre 1 : output_folder = " . $output_folder );
    $logger->log( "DEBUG", "Paramètre 2 : polygon = " . $polygon );
    $logger->log( "DEBUG", "Paramètre 3 : polygon_name = " . $polygon_name );
    $logger->log( "DEBUG", "Paramètre 4 : manager_id = " . $manager_id );
    $logger->log( "DEBUG", "Paramètre 5 : layer_name = " . $layer_name );
    $logger->log( "DEBUG", "Paramètre 6 : product_id = " . $product_id );
    $logger->log( "DEBUG", "Paramètre 7 : output_format = " . $output_format );
    $logger->log( "DEBUG", "Paramètre 8 : output_crs = " . $output_crs );
    $logger->log( "DEBUG", "Paramètre 9 : context = " . $context );

    # Création du répertoire des fichiers
    $logger->log( "DEBUG",
        "Création du répertoire des fichiers : " . $output_folder );
    if ( !-d $output_folder ) {
        my $create_folder_cmd = "mkdir -p " . $output_folder;
        my $create_folder_return = Execute->run( $create_folder_cmd, "true" );
        if ( $create_folder_return->get_return() != 0 ) {
            $logger->log( "ERROR",
                "Impossible de créer le répertoire des fichiers : "
                  . $output_folder );
            $create_folder_return->log_all( $logger, "DEBUG" );
            return 1;
        }
    }

    # Suppression de la version du gml dans la balise polygon si elle existe
    $polygon =~ s/xmlns:gml="\S*"/ /;

    # Définition de l'extension de l'image et du fichier de géoréférencement
    my $file_extension = "";
    my $post_dezip     = "false";
    if ( $output_format =~ /gml/i ) {
        $file_extension = ".gml";
        $output_format  = "GML32";
        $post_dezip     = "false";
    }
    elsif ( $output_format =~ /shp/i ) {
        $file_extension = ".zip";
        $output_format  = "shape-zip";
        $post_dezip     = "true";
    }

    # Génération des noms de fichiers
    my $file_name = $output_folder . $polygon_name . $file_extension;

    # Lancement de l'extraction WFS
    my $return_extract_wfs_file = extract_wfs_file(
        $file_name,     $polygon,    $manager_id, $layer_name,
        $output_format, $output_crs, $context
    );

# PATCH POUR REPROJECTION LAMBE #
    my $srs_for_reprojection;
    if($return_extract_wfs_file=~/\D/)
    {
        $logger->log("DEBUG", "On va devoir reprojeter le fichier shapefile fourni");
	$srs_for_reprojection = $return_extract_wfs_file;
    }
# END PATCH #
    elsif ( 0 != $return_extract_wfs_file )
    {
	$logger->log( "ERROR",
            "Impossible d'extraire le fichier " . $file_name . " en WFS" );
        $logger->log( "ERROR",
            "Code retour de la fonction extract_wfs_file : "
              . $return_extract_wfs_file );
        return 2;
    } 

    my $data_dir = ( dirname $file_name);

    # Extraction eventuel du fichier zippé de résultat, puis nettoyage
    if ( "true" eq $post_dezip ) {

        my $tmp_folder = $data_dir . "/" . $polygon_name;
        mkdir $tmp_folder;

        my $unzip_cmd = "unzip -o " . $file_name . " -d " . $tmp_folder;
        $logger->log( "DEBUG", "La commande appelée est : " . $unzip_cmd );
        my $unzip_cmd_return = Execute->run( $unzip_cmd, "true" );
        if ( $unzip_cmd_return->get_return() != 0 ) {
            $logger->log( "ERROR",
                "Impossible de décompresser " . $file_name );
            $unzip_cmd_return->log_all( $logger, "DEBUG" );
            return 3;
        }

	my @layer_name_splitted = split /:/, $layer_name;

# PATCH REPROJECTION LAMBE

	if($srs_for_reprojection)
	{
    	    my $transform_cmd = $ogr2ogr
    	    . " -f \"ESRI Shapefile\" -t_srs "
    	    . $srs_for_reprojection
    	    . " "
    	    . $tmp_folder
    	    . "/"
    	    . $layer_name_splitted[1]
    	    . "_tmp.shp "
   	    . $tmp_folder
    	    . "/"
    	    . $layer_name_splitted[1]
    	    . ".shp";
    	    $logger->log("DEBUG", "On reprojette le shapefile final : " . $transform_cmd );
    	    my $transform_cmd_result = Execute->run( $transform_cmd, "true");
	    my $move_shape_cmd = "mv "
	    . $tmp_folder
            . "/"
            . $layer_name_splitted[1]
            . "_tmp.shp "
            . $tmp_folder
            . "/"
            . $layer_name_splitted[1]
	    . ".shp";
	    my $move_shape_result = Execute->run( $move_shape_cmd, "true");
	    my $delete_temp_file_cmd = "rm "
            . $tmp_folder
            . "/"
            . $layer_name_splitted[1]
            . "_tmp.*";
            my $delete_temp_file_result = Execute->run($delete_temp_file_cmd, "true");
	}

# FIN PATCH 


        my $clean_cmd =
            "rm -f "
          . $file_name . " "
          . $tmp_folder
          . "/*.cst "
          . $tmp_folder
          . "/*.txt "
          . $tmp_folder
          . "/*.prj";
        $logger->log( "DEBUG", "La commande appelée est : " . $clean_cmd );
        my $clean_cmd_return = Execute->run( $clean_cmd, "true" );
        if ( $clean_cmd_return->get_return() != 0 ) {
            $logger->log( "ERROR",
                "Impossible de supprimer les fichiers .cst, .txt et .prj"
                  . $file_name );
            $clean_cmd_return->log_all( $logger, "DEBUG" );
            return 3;
        }


        # Copie des fichiers AVL et LYR
        my $src_legend_files =
            $static_referentiel . "/"
          . $legendes_wfs_path . "/"
          . $product_id . "/"
          . uc( $layer_name_splitted[1] ) . ".*";

        my $copy_legends_cmd = "cp -f " . $src_legend_files . " " . $tmp_folder;
        $logger->log( "DEBUG",
            "La commande appelée est : " . $copy_legends_cmd );
        my $copy_legends_cmd_return = Execute->run( $copy_legends_cmd, "true" );
        if ( $copy_legends_cmd_return->get_return() != 0 ) {
            $logger->log( "ERROR",
"Impossible de copier les fichiers légendes spécifiques de la couche "
                  . $layer_name
                  . " pour le produit "
                  . $product_id
                  . " depuis "
                  . $src_legend_files );
            $copy_legends_cmd_return->log_all( $logger, "DEBUG" );
            return 4;
        }

        # Copie du fichier PRJ
        my $prj_dir = $output_crs;
        $prj_dir =~ s/:/\//;
        my $src_prj_file =
            $static_referentiel . "/"
          . $prj_path . "/"
          . $prj_dir
          . $prj_extension;

        my $copy_prj_cmd = "cp -f " . $src_prj_file . " " . $tmp_folder . "/";
        $logger->log( "DEBUG", "La commande appelée est : " . $copy_prj_cmd );
        my $copy_prj_cmd_return = Execute->run( $copy_prj_cmd, "true" );
        if ( $copy_prj_cmd_return->get_return() != 0 ) {
            $logger->log( "ERROR",
                    "Impossible de copier le fichier de projection de "
                  . $output_crs
                  . " depuis "
                  . $src_prj_file );
            $copy_prj_cmd_return->log_all( $logger, "DEBUG" );
            return 5;
        }

        my $file;
        $logger->log( "DEBUG", "Renommage des fichiers :" );

# PATCH MANU POUR PASSER LES NOMS ATTRIBUTS SHAPEFILE EN MAJUSCULE #

        my $get_shapeinfo_cmd = $ogrinfo 
          . " -so -al "
          .  $tmp_folder 
          . "/" 
          . $layer_name_splitted[1] 
	  . ".shp"; 

	$logger->log("DEBUG","Recuperation des infos du shapefile : " . $get_shapeinfo_cmd ); 
        my $get_shapeinfo_result = Execute->run( $get_shapeinfo_cmd, "true" );	
	my @shape_info = $get_shapeinfo_result->get_log();

	# On ne passe en majuscule que les noms des champs attributaires

	foreach (@shape_info) {
		
		# Si ce n'est pas une colonne du shape on vire		
		my @i = split(/:/, $_);
		my $sizei = scalar @i;
		if($sizei != 2){ 
			next;
		}
		
		# Nom de la colonne
		my $column_name = $i[0];
		chomp $column_name;

		# On ne passe en majuscule que les noms des champs attributaires
		if ( !(lc($column_name) eq "layer name")
	             && !(lc($column_name) eq "geometry")
		     && !(lc($column_name) eq "feature count")
                     && !(lc($column_name) eq "extent")
		     && !(lc($column_name) eq "layer srs wkt"))
		{	
		 	my $rename_cmd = $ogrinfo 
			. " " 
			. $tmp_folder 
			. "/" 
			.  $layer_name_splitted[1] 
			. ".shp -sql \"ALTER TABLE " 
			. uc($layer_name_splitted[1]) 
			." RENAME COLUMN " 
			. $column_name 
			. " TO " 
			. uc($column_name) 
			. "\"";

			$logger->log("DEBUG", "Passage de" . $column_name . " en majuscule : " .  $rename_cmd);
		 	my $rename_cmd_result = Execute->run( $rename_cmd, "true" );
			#TODO:Verifier retour de la commande	
		}
	}

        # rename all files
        opendir( BIN, $tmp_folder ) or die "Can't open tmp_folder: $!";
        while ( defined( $file = readdir BIN ) ) {
            next if $file =~ /^\.\.?$/;    # skip . and .. in the folder

            $logger->log( "DEBUG",
                "Renommage du fichier  " . $tmp_folder . "/" . $file );
            my @parts = fileparse( $tmp_folder . "/" . $file, qr/\.[^.]*/ );

            my $partsname = $parts[0];
            my $extension = $parts[2];
            $logger->log( "DEBUG", "nom du fichier  : '" . $partsname . "'" );
            $logger->log( "DEBUG", "extension  : '" . $extension . "'" );

            my $rename_cmd = "mv "
              . $tmp_folder . "/"
              . $file . " "
              . $data_dir . "/"
              . $polygon_name
              . $extension;
            $logger->log( "DEBUG",
                "La commande appelée est : " . $rename_cmd );
            my $rename_cmd_return = Execute->run( $rename_cmd, "true" );

            if ( $rename_cmd_return->get_return() != 0 ) {
                $logger->log( "ERROR",
                        "Impossible de renommer le fichier "
                      . $tmp_folder . "/"
                      . $file . " en "
                      . $data_dir . "/"
                      . $polygon_name
                      . $parts[2] );
                $rename_cmd_return->log_all( $logger, "DEBUG" );
                return 6;
            }
        }
        closedir(BIN);



        my $clean_cmd_2 = "rmdir " . $tmp_folder;
        $logger->log( "DEBUG", "La commande appelée est : " . $clean_cmd_2 );
        my $clean_cmd_return_2 = Execute->run( $clean_cmd_2, "true" );
        if ( $clean_cmd_return_2->get_return() != 0 ) {
            $logger->log( "ERROR",
                "Impossible de supprimer le dossier " . $tmp_folder );
            $clean_cmd_return_2->log_all( $logger, "DEBUG" );
            return 6;
        }

    }

    return 0;
}
1;
