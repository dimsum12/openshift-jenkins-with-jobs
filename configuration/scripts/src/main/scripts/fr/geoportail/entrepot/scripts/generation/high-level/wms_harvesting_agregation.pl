#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will agregate N single level rok4 pyramids to make an unique pyramid
# ARGS :
#   The generation ID
# RETURNS :
#   * 0 if the execution is correct
#   * 1 if the REST service is not reacheable or if the ID is incorrect
#   * 2 if the generation is linked to many broadcast datas
#	* 3 if an error occured during creating folders
#   * 4 if an error occured copying levels datas to final directory
#   * 253 if the generation structure is incorrect
#   * 254 if the JSON return is not parseable
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/wms_harvesting_agregation.pl $
#   $Date: 28/03/12 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Execute;
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
  Logger->new( "wms_harvesting_agregation.pl",
    $config->param("logger.levels") );

my $url_proxy       = $config->param("proxy.url");
my $url_ws_entrepot = $config->param("resources.ws.url.entrepot");
my $root_storage    = $config->param("filer.root.storage");
my $pyramid_dir     = $config->param("be4.pyramid_dir");
my $pyr_extension   = $config->param("be4.pyramid_extension");
my $cmd_cat         = $config->param("resources.cat");

my $rok4_image_dir  = "IMAGE";
my $rok4_nodata_dir = "NODATA";

sub wms_harvesting_agregation {

    # Extraction des paramètres
    my ($generation_id) = @_;
    if ( !defined $generation_id ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : generation_id = " . $generation_id );

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

    # Lecture des données en sortie
    my $broadcast_datas = $hash_response->{'broadcastDatas'};
    if ( defined @{$broadcast_datas} ) {
        if ( scalar( @{$broadcast_datas} ) != 1 ) {
            $logger->log( "ERROR",
                    "La génération demandée est lié à "
                  . scalar( @{$broadcast_datas} )
                  . " données en sortie alors que ce type de traitement n'en attend que 1"
            );
            return 2;
        }
    }
    else {
        $logger->log( "ERROR",
"La génération demandée n'est lié à aucune donnée en sortie alors que ce type de traitement en attend 1"
        );
        return 2;
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

    my $storage = $broadcast_datas->[0]->{'storage'};
    if ( !$storage ) {
        $logger->log( "ERROR",
"La données en sortie du processus n'est pas associé à un stockage "
        );
        return 253;
    }

    my $storage_path = $storage->{'logicalName'};
    if ( !$storage_path ) {
        $logger->log( "ERROR",
"Le stockage associé à la donnée de diffusion ne contient pas de chemin "
        );
        return 253;
    }
    $logger->log( "DEBUG",
        "Chemin de stockage de la donnée de sortie : " . $storage_path );

    my $dir_root          = $root_storage . "/" . $storage_path . "/" . $bd_id;
    my $final_image_dir   = $dir_root . "/" . $bd_name . "/" . $rok4_image_dir;
    my $final_nodata_dir  = $dir_root . "/" . $bd_name . "/" . $rok4_nodata_dir;
    my $final_pyramid_dir = $dir_root . "/" . $pyramid_dir;
    my $final_pyramid_file =
      $final_pyramid_dir . "/" . $bd_name . $pyr_extension;

    # Parcours des différentes pyramides générées
    my $cmd_find_pyramids = "ls -1 " . $dir_root;
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd_find_pyramids );
    my $execution_find_pyramids = Execute->run($cmd_find_pyramids);
    if ( $execution_find_pyramids->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors du listage des pyramides générées : "
              . $cmd_find_pyramids );
        return 4;
    }

    my @levels = $execution_find_pyramids->get_log();
    if ( 0 == scalar @levels ) {
        $logger->log( "ERROR",
            "Aucun niveau n'a été detecté dans le repertoire de sortie : "
              . $dir_root );
        return 4;
    }

    # Créé l'arborescence définitive
    my $cmd_create_arbo = "mkdir -p " . $final_image_dir;
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd_create_arbo );
    my $execution_create_arbo = Execute->run($cmd_create_arbo);
    if ( $execution_create_arbo->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de la création de l'arborescence : "
              . $final_image_dir );
        return 3;
    }

    $cmd_create_arbo = "mkdir -p " . $final_nodata_dir;
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd_create_arbo );
    $execution_create_arbo = Execute->run($cmd_create_arbo);
    if ( $execution_create_arbo->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de la création de l'arborescence : "
              . $final_nodata_dir );
        return 3;
    }

    $cmd_create_arbo = "mkdir -p " . $final_pyramid_dir;
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd_create_arbo );
    $execution_create_arbo = Execute->run($cmd_create_arbo);
    if ( $execution_create_arbo->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de la création de l'arborescence : "
              . $final_pyramid_dir );
        return 3;
    }

    # Copie des éléments commun des pyramides (basé sur la première)
    my $first_level = $levels[0];
    chomp($first_level);
    my $first_pyramid =
        $dir_root . "/"
      . $first_level . "/"
      . $pyramid_dir . "/"
      . $first_level
      . $pyr_extension;
    my $cmd_copy_pyramid =
        $cmd_cat . " "
      . $first_pyramid
      . " | grep -B 1000 \"<level>\" | head -n -1 1>> "
      . $final_pyramid_file;
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd_copy_pyramid );
    my $execution_copy_pyramid = Execute->run($cmd_copy_pyramid);
    if ( $execution_copy_pyramid->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de la copie de l'entête du fichier pyramide : "
              . $cmd_copy_pyramid );
        return 4;
    }
	
	# Copie des niveaux "ancetres" à partir de la première pyramide
    my $cmd_find_first_level_levels = "ls -1 " . $dir_root . "/" . $first_level . "/" . $rok4_image_dir;;
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd_find_first_level_levels );
    my $execution_find_first_level_levels = Execute->run($cmd_find_first_level_levels);
    if ( $execution_find_first_level_levels->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors du listage des niveaux de la première pyramide générée : "
              . $cmd_find_first_level_levels );
        return 4;
    }
	my @first_level_levels = $execution_find_first_level_levels->get_log();
	
	my $first_image_dir =
          $dir_root . "/" . $first_level . "/" . $rok4_image_dir;
	my $first_nodata_dir =
          $dir_root . "/" . $first_level . "/" . $rok4_nodata_dir;	  
	my $first_pyramid_file =
            $dir_root . "/" 
          . $first_level . "/"
          . $pyramid_dir . "/"
          . $first_level
          . $pyr_extension;
		  
	for my $first_current_level (@first_level_levels) {
		chomp($first_current_level);
		my $level_finded = "false";
		for my $level (@levels) {
			chomp($level);
			if ($level eq $first_current_level) {
				$level_finded = "true";
			}
		}
		
		if ("false" eq $level_finded) {
			# Copie des éléments de niveau des pyramides
			$cmd_copy_pyramid =
				$cmd_cat . " "
			  . $first_pyramid_file
			  . " | grep -A 1000 \"<level>\" | grep -B 1000 \"</level>\""
		      . " | grep -B1 -A14 \"<tileMatrix>" . $first_current_level . "</tileMatrix>\""
			  . " | sed -e 's#<baseDir>[.][.]\/" . $rok4_image_dir . "#<baseDir>..\/" . $bd_name . "\/" . $rok4_image_dir . "#g'" 
			  . " | sed -e 's#<filePath>[.][.]\/" . $rok4_nodata_dir . "#<filePath>..\/" . $bd_name . "\/" . $rok4_nodata_dir . "#g'" 
			  . " 1>> "
			  . $final_pyramid_file;
			$logger->log( "DEBUG", "Appel à la commande : " . $cmd_copy_pyramid );
			$execution_copy_pyramid = Execute->run($cmd_copy_pyramid);
			if ( ! -e $first_pyramid_file || $execution_copy_pyramid->get_return() != 0 ) {
				$logger->log( "ERROR",
						"Erreur lors de la copie du niveau " 
					  . $first_current_level
					  . " du fichier pyramide : "
					  . $cmd_copy_pyramid );
				return 4;
			}
			
			# Copie des données de niveau
			my $cmd_copy_level =
			  "mv " . $first_image_dir . "/" . $first_current_level . " " . $final_image_dir;
			$logger->log( "DEBUG", "Appel à la commande : " . $cmd_copy_level );
			my $execution_copy_level = Execute->run($cmd_copy_level);
			if ( $execution_copy_level->get_return() != 0 ) {
				$logger->log( "ERROR",
						"Erreur lors de la copie des "
					  . $rok4_image_dir
					  . " du niveau . "
					  . $first_current_level . " : "
					  . $cmd_copy_level );
				return 4;
			}

			$cmd_copy_level =
			  "mv " . $first_nodata_dir . "/" . $first_current_level . " " . $final_nodata_dir;
			$logger->log( "DEBUG", "Appel à la commande : " . $cmd_copy_level );
			$execution_copy_level = Execute->run($cmd_copy_level);
			if ( $execution_copy_level->get_return() != 0 ) {
				$logger->log( "ERROR",
						"Erreur lors de la copie des "
					  . $rok4_nodata_dir
					  . " du niveau . "
					  . $first_current_level . " : "
					  . $cmd_copy_level );
				return 4;
			}
		}
	}
	
    # Parcours des niveaux générés
    for my $level (@levels) {
        chomp $level;
        my $current_image_dir =
          $dir_root . "/" . $level . "/" . $rok4_image_dir;
        my $current_nodata_dir =
          $dir_root . "/" . $level . "/" . $rok4_nodata_dir;
        my $current_pyramid_file =
            $dir_root . "/" 
          . $level . "/"
          . $pyramid_dir . "/"
          . $level
          . $pyr_extension;

        # Copie des éléments de niveau des pyramides
        $cmd_copy_pyramid =
            $cmd_cat . " "
          . $current_pyramid_file
          . " | grep -A 1000 \"<level>\" | grep -B 1000 \"</level>\""
		  . " | grep -B1 -A14 \"<tileMatrix>" . $level . "</tileMatrix>\""
		  . " | sed -e 's#<baseDir>[.][.]\/" . $rok4_image_dir . "#<baseDir>..\/" . $bd_name . "\/" . $rok4_image_dir . "#g'" 
		  . " | sed -e 's#<filePath>[.][.]\/" . $rok4_nodata_dir . "#<filePath>..\/" . $bd_name . "\/" . $rok4_nodata_dir . "#g'" 
		  . " 1>> "
          . $final_pyramid_file;
        $logger->log( "DEBUG", "Appel à la commande : " . $cmd_copy_pyramid );
        $execution_copy_pyramid = Execute->run($cmd_copy_pyramid);
        if ( ! -e $current_pyramid_file || $execution_copy_pyramid->get_return() != 0 ) {
            $logger->log( "ERROR",
                    "Erreur lors de la copie du niveau " 
                  . $level
                  . " du fichier pyramide : "
                  . $cmd_copy_pyramid );
            return 4;
        }

        # Copie des données de niveau, puis suppression du reste des données
        my $cmd_copy_level =
          "mv " . $current_image_dir . "/" . $level . " " . $final_image_dir;
        $logger->log( "DEBUG", "Appel à la commande : " . $cmd_copy_level );
        my $execution_copy_level = Execute->run($cmd_copy_level);
        if ( $execution_copy_level->get_return() != 0 ) {
            $logger->log( "ERROR",
                    "Erreur lors de la copie des "
                  . $rok4_image_dir
                  . " du niveau . "
                  . $level . " : "
                  . $cmd_copy_level );
            return 4;
        }

        $cmd_copy_level =
          "mv " . $current_nodata_dir . "/" . $level . " " . $final_nodata_dir;
        $logger->log( "DEBUG", "Appel à la commande : " . $cmd_copy_level );
        $execution_copy_level = Execute->run($cmd_copy_level);
        if ( $execution_copy_level->get_return() != 0 ) {
            $logger->log( "ERROR",
                    "Erreur lors de la copie des "
                  . $rok4_nodata_dir
                  . " du niveau . "
                  . $level . " : "
                  . $cmd_copy_level );
            return 4;
        }

        my $cmd_delete_level = "rm -rf " . $dir_root . "/" . $level;
        $logger->log( "DEBUG", "Appel à la commande : " . $cmd_delete_level );
        my $execution_delete_level = Execute->run($cmd_delete_level);
        if ( $execution_delete_level->get_return() != 0 ) {
            $logger->log( "ERROR",
                    "Erreur lors de la suppression du niveau . " 
                  . $level . " : "
                  . $cmd_delete_level );
            return 4;
        }
    }

    # Copie des éléments commun des pyramides (basé sur la première)
    $cmd_copy_pyramid = "echo \"</Pyramid>\" 1>> " . $final_pyramid_file;
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd_copy_pyramid );
    $execution_copy_pyramid = Execute->run($cmd_copy_pyramid);
    if ( $execution_copy_pyramid->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de l'écriture de la fin du fichier pyramide : "
              . $cmd_copy_pyramid );
        return 4;
    }

    return 0;
}

