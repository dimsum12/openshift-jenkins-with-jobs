#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will generate a PgSQL broadcast data using the generation id
#       First it collect informations from service REST
#       Then it plays all SQL or SHP files from the delivery linked to the generation
#       Finally it update the broadcast data with schema information
# ARGS :
#   The generation ID
# RETURNS :
#   * 0 if generation is correct
#   * 1 if the REST service is not reacheable or if the ID is incorrect
#   * 2 if the generation is linked to many deliveries
#   * 3 if the generation is linked to many broadcast datas
#   * 4 if the delivery used does not contains an information file
#   * 5 if an error occured while creating and populating the schema
#   * 6 if the REST service for updating the braodcast data send an error
#   * 7 if an error occured while harvesting metadatas
#   * 8 if an error occured while calculating or updating bounding boxes
#   * 9 if an error occured while disconnecting from bdd
#   * 10 if an error occured while updating broadcastdata size
#   * 11 if an error occured while connecting the bdd
#   * 12 if the STATIC directory specified in infos.txt doesn't exist
#   * 13 if the STATIC directory cannot be copied
#   * 253 if the generation structure is incorrect
#   * 254 if the JSON return is not parseable
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/bdd_generation.pl $
#   $Date: 16/08/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#   $Author: Charles-Henri Biller (a149912) <charles-henri.biller@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use WebserviceTools;
use Logger;
use Deliveryconf;
use Database;
use Tools;
use Cwd;
use LWP::UserAgent;
use HTTP::Request::Common;
use Config::Simple;
use JSON;

require "generate_bdd_datas.pl";
require "harvest_generation.pl";
require "update_broadcastdata_size.pl";
require "get_bbox_dates.pl";
require "bbox_from_table.pl";
require "copy_data.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger =
  Logger->new( "bdd_generation.pl", $config->param("logger.levels") );

my $deliveries_path      = $config->param("filer.delivery-ftp");
my $auto_detect_filename = $config->param("auto-detect.filename");
my $url_ws_entrepot      = $config->param("resources.ws.url.entrepot");
my $url_proxy            = $config->param("proxy.url");
my $dbname               = $config->param("db-ent_donnees.dbname");
my $host                 = $config->param("db-ent_donnees.host");
my $port                 = $config->param("db-ent_donnees.port");
my $username             = $config->param("db-ent_donnees.username");
my $retry_attempts 		 = $config->param("resources.ws.entrepot.retry.attempts");
my $retry_waitingtime 	 =
  $config->param("resources.ws.entrepot.retry.waitingtime");
my $password 			 = $config->param("db-ent_donnees.password");
my $static_data_dir		 = $config->param("filer.static.storage");

sub bdd_generation {

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
    my $ws = WebserviceTools->new(
        'GET',
        $url_ws_entrepot
          . "/generation/getGeneration?generationId="
          . $generation_id,
        $url_proxy
    );

    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/generation/getGeneration?generationId="
          . $generation_id );

    my $result = $ws->run( $retry_attempts, $retry_waitingtime );

    if ( !$result ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la récupération de la génération d'identifiant :"
              . $generation_id );
        $logger->log( "ERROR", "l'erreur est : " . $ws->get_content() );
        return 1;
    }

    my $hash_response = $ws->get_json();
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
    if ( defined @{$input_datas} ) {
        if ( scalar( @{$input_datas} ) != 1 ) {
            $logger->log( "ERROR",
                    "La génération demandée est lié à "
                  . scalar( @{$input_datas} )
                  . " données en entrée alors que ce type de traitement n'en attend que 1"
            );
            return 2;
        }
    }
    else {
        $logger->log( "ERROR",
"La génération demandée n'est lié à aucune donnée en entrée alors que ce type de traitement en attend 1"
        );
        return 2;
    }
    $logger->log( "DEBUG",
        scalar( @{$input_datas} ) . " donnée(s) liée(s) à la génération" );

    my $delivery_login = $input_datas->[0]->{'login'};
    if ( !$delivery_login ) {
        $logger->log( "ERROR",
            "La donnée en entrée du processus n'est pas de type Delivery" );
        return 2;
    }
    $logger->log( "DEBUG",
        "Login de la livraison en base : " . $delivery_login );

    my $delivery_id = $input_datas->[0]->{'id'};
    if ( !$delivery_id ) {
        $logger->log( "ERROR", "La donnée en entrée n'a pas d'identifiant" );
        return 253;
    }
    $logger->log( "DEBUG",
        "Identifiant de la livraison en base : " . $delivery_id );

    $logger->log( "DEBUG",
"Récupération des informations depuis la données de diffusion liée à la génération"
    );

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

    $logger->log( "INFO",
        "Intégration en BDD à partir de la livraison " . $delivery_id );

    my $delivery_dir = $deliveries_path . $delivery_login;
    $logger->log( "INFO",
        "Récupération du repertoire de la livraison : " . $delivery_dir );

    # Récupération des informations du fichier d'informations complémentaires
    my $deliveryconf = Deliveryconf->new( $delivery_dir, $logger, $config );
    if ( !$deliveryconf ) {
        $logger->log( "ERROR",
"Impossible de trouver le fichier d'information complémentaire dans la livraison source : "
              . $delivery_dir );

        return 4;
    }

    my $originators = $deliveryconf->{values}{"PARTNERNAME"};
    my $projection  = $deliveryconf->{values}{"PROJECTION"};

    my $vector_dir =
      $delivery_dir . '/' . $deliveryconf->{values}{"DIR.DATA"} . '/';
    my $static_dir =
      $delivery_dir . '/' . $deliveryconf->{values}{"DIR.STATIC"} . '/';
	  
    my $schema_name = $bd_name;
    $schema_name =~ s/[^A-Za-z0-9_]/_/g;
    $schema_name = lc $schema_name;

    # Mise à jour de la donnée de diffusion
    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/generation/updatePgsqlBD" );
    my $ua = LWP::UserAgent->new;
    if ( $url_proxy ne "none" ) {
        $ua->proxy( [ 'http', 'ftp' ], $url_proxy );
    }

    my $response = $ua->request(
        POST $url_ws_entrepot. "/generation/updatePgsqlBD",
        [
            broadcastDataId => $bd_id,
            schemaName      => $schema_name,
            projection      => $projection
        ]
    );

    if ( $response->is_success ) {
        $logger->log( "INFO",
                "Mise à jour de la donnée de diffusion " 
              . $bd_id
              . " effectuée" );
    }
    else {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour de la donnée de diffusion "
              . $bd_id );
        return 6;
    }

    # Processus d'intégration des données en BDD
    $logger->log( "INFO",
        "Lancement du processus de génération de données de diffusion BDD" );
    my $return_generate_bdd_datas =
      generate_bdd_datas( $vector_dir, $schema_name, $projection );
    $logger->log( "DEBUG",
        " --> Valeur de retour : " . $return_generate_bdd_datas );

    if ( $return_generate_bdd_datas != 0 ) {
        $logger->log( "ERROR",
"Une erreur est survenue lors de la génération de données de diffusion BDD"
        );
        return 5;
    }

	# Copie de la partie statique
    if (defined $deliveryconf->{values}{"DIR.STATIC"}) {
		$logger->log( "INFO", "Copie des données statiques" );
		my $return_cp_static = copy_data( $static_dir, $static_data_dir . "/" . $bd_id, "false" );
		if ( $return_cp_static == 1 ) {
			$logger->log( "ERROR",
				"Le repertoire spécifié pour la partie STATIC n'existe pas dans la livraison" );
			$logger->log( "DEBUG", "Code retour : " . $return_cp_static );

			return 12;
		}
		if ( $return_cp_static != 0 ) {
			$logger->log( "ERROR",
				"Erreur lors de la copie du repertoire des données STATIC" );
			$logger->log( "DEBUG", "Code retour : " . $return_cp_static );

			return 13;
		}
	}
	
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
        return 11;
    }

    # récupération des dossiers de métadonnées
    my @mtd_folders     = ();
    my $mtd_src_dir_iso = $deliveryconf->{values}{"DIR.METADATA.ISO"};
    if ( defined $mtd_src_dir_iso ) {
        if ( "" ne $mtd_src_dir_iso ) {
            $mtd_src_dir_iso = $delivery_dir . "/" . $mtd_src_dir_iso;
            push( @mtd_folders, $mtd_src_dir_iso );
        }
    }
    my $mtd_src_dir_inspire = $deliveryconf->{values}{"DIR.METADATA.INSPIRE"};
    if ( defined $mtd_src_dir_inspire ) {
        if ( "" ne $mtd_src_dir_inspire ) {
            $mtd_src_dir_inspire = $delivery_dir . "/" . $mtd_src_dir_inspire;
            push( @mtd_folders, $mtd_src_dir_inspire );
        }
    }
    my $mtd_src_dir_pva = $deliveryconf->{values}{"DIR.METADATA.PVA"};
    if ( defined $mtd_src_dir_pva ) {
        if ( "" ne $mtd_src_dir_pva ) {
            $mtd_src_dir_pva = $delivery_dir . "/" . $mtd_src_dir_pva;
            push( @mtd_folders, $mtd_src_dir_pva );
        }
    }

    # récupération des dates min et max
    my ( $date_min, $date_max ) = get_bbox_dates(@mtd_folders);

    # Liste de toutes les tables géographiques dans le schema créé
    my $sql =
"SELECT DISTINCT f_table_name FROM geometry_columns WHERE f_table_schema = '"
      . $schema_name . "'";
    ( my @tables ) = @{ $database->select_all_row($sql) };
    if ( $database->disconnect() != 0 ) {
        $logger->log( "ERROR",
                "Impossible de se déconnecter à la base de données " 
              . $dbname . " sur "
              . $host . ":"
              . $port );
        return 9;

    }
    for my $table (@tables) {

        # Calcul des BBOXes
        my @result = bbox_from_table( $schema_name, $table->[0] );
        if (   scalar @result == 1
            && Tools->is_numeric( $result[0] )
            && $result[0] != 3 )
        {
            $logger->log( "ERROR",
                "Erreur lors du calcul des BBOXes du jeu de données." );
            $logger->log( "ERROR", "Code retour : " . $result[0] );

            return 8;
        }

        if ( !Tools->is_numeric( $result[0] ) ) {
            if ( 0 != scalar @result ) {

            # Mise à jour de la donnée de diffusion avec les bboxes associées
                $logger->log( "DEBUG",
                        "Appel au service REST : "
                      . $url_ws_entrepot
                      . "/generation/updateBboxes" );
                my $response = $ua->request(
                    POST $url_ws_entrepot. "/generation/updateBboxes",
                    [
                        broadcastDataId => $bd_id,
                        bboxes          => \@result,
                        startDate       => $date_min,
                        endDate         => $date_max,
                        info            => $table->[0],
                        originators     => $originators,
                        projection      => $projection
                    ]
                );

                if ( $response->is_success ) {
                    $logger->log( "INFO",
                            "Mise à jour des BBOXes de la table "
                          . $table->[0]
                          . " effectuée" );
                }
                else {
                    $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour des BBOXes de la table "
                          . $table->[0] );
                    return 8;
                }
            }
        }
    }

    # Harvest des métadonnées
    $logger->log( "INFO", "Moissonage des métadonnées" );
    my $return_harvest_generation = harvest_generation( $delivery_dir, $bd_id );
    if ( $return_harvest_generation != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors du moissonnage des métadonnées." );
        $logger->log( "DEBUG", "Code retour : " . $return_harvest_generation );

        return 7;
    }
	
    # MAJ de la taille totale de la donnée de diffusion
    if ( update_broadcastdata_size( $schema_name, $bd_id, 1 ) ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour de la taille de la donnée de diffusion "
              . $bd_id );
        return 10;

    }

    return 0;
}

