#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will generate a PgSQL broadcast data using the generation id
#       First it collect informations from service REST
#       Then it plays a script to transform a PGSQL BDD to a new one
#       Finally it update the broadcast data with schema information
# ARGS :
#   The generation ID
#	The transformation name (this name is used as the directory containing the SQL operations files)
#	The projection of the broadcastdata
# RETURNS :
#   * 0 if generation is correct
#   * 1 if the REST service is not reacheable or if the ID is incorrect
#   * 2 if the generation is linked to many input broadcast datas
#   * 3 if the generation is linked to many output broadcast datas
#   * 4 if transformation name is not linked to a directory
#   * 5 if an error occured while creating and populating the schema
#   * 6 if the REST service for updating the braodcast data send an error
#   * 7 if an error occured while harvesting metadatas
#   * 8 if an error occured while calculating or updating bounding boxes
#   * 9 if an error occured while disconnecting from bdd
#   * 10 if an error occured while updating broadcastdata size
#   * 11 if an error occured while disconnecting from bdd
#	* 252 if the given projection of the broadcastdata is incorrect
#   * 253 if the generation structure is incorrect
#   * 254 if the JSON return is not parseable
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/bdd_update_generation.pl $
#   $Date: 24/10/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
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

require "generate_bdd_from_existing_bdd.pl";
require "harvest_generation.pl";
require "update_broadcastdata_size.pl";
require "get_bbox_dates.pl";
require "bbox_from_table.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger =
  Logger->new( "bdd_update_generation.pl", $config->param("logger.levels") );

my $static_ref            = $config->param("static_ref.static_referentiel");
my $reprocessing_bdd_path = $config->param("static_ref.scripts_derivation");
my $deliveries_path       = $config->param("filer.delivery-ftp");
my $auto_detect_filename  = $config->param("auto-detect.filename");
my $url_ws_entrepot       = $config->param("resources.ws.url.entrepot");
my $url_proxy             = $config->param("proxy.url");
my $dbname                = $config->param("db-ent_donnees.dbname");
my $host                  = $config->param("db-ent_donnees.host");
my $port                  = $config->param("db-ent_donnees.port");
my $username              = $config->param("db-ent_donnees.username");
my $retry_attempts = $config->param("resources.ws.entrepot.retry.attempts");
my $retry_waitingtime =
  $config->param("resources.ws.entrepot.retry.waitingtime");
#Used to verify the validity of the projection parameter:
my $gdaltransform = $config->param("resources.gdaltransform");
my $gdaltransform_validator_pre ="echo '0 0 0' | " . $gdaltransform . " -s_srs '+init=";
my $gdaltransform_validator_post = " +wktext' 1> /dev/null 2>&1";

my $password = $config->param("db-ent_donnees.password");

sub bdd_update_generation {

    # Extraction des paramètres
    my ( $generation_id, $transformation_name, $projection_parameter ) = @_;
    if ( !defined $generation_id || !defined $transformation_name || !defined $projection_parameter) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (3)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : generation_id = " . $generation_id );
    $logger->log( "DEBUG",
        "Paramètre 2 : transformation_name = " . $transformation_name );
	$logger->log( "DEBUG", "Paramètre 3 : projection_parameter = " . $projection_parameter );

    # Construction et vérification du chemin vers les scripts SQL à jouer
    my $sql_path =
      $static_ref . $reprocessing_bdd_path . "/" . $transformation_name;
    $logger->log( "DEBUG",
        "VCérification du repertoire de scripts " . $sql_path );
    if ( !-d $sql_path ) {
        $logger->log( "ERROR",
                "Le nom de transformation SQL spécifié : "
              . $transformation_name
              . " n'est pas reconnu (pas de répertoire de scripts associé)" );
        return 4;
    }

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

    my $input_data_id = $input_datas->[0]->{'id'};
    if ( !$input_data_id ) {
        $logger->log( "ERROR",
            "La donnée en entrée du processus ne possède pas d'identifiant"
        );
        return 253;
    }
    $logger->log( "DEBUG",
        "Identifiant de la donnée en entrée : " . $input_data_id );

    my $input_data_schema_name = $input_datas->[0]->{'schemaName'};
    if ( !$input_data_schema_name ) {
        $logger->log( "ERROR",
"La donnée en entrée du processus n'est pas de type Broadcast Data PGSQL"
        );
        return 2;
    }
    $logger->log( "DEBUG",
        "Nom de schema de la livraison en base : " . $input_data_schema_name );

    $logger->log( "DEBUG",
"Récupération des informations depuis la données de diffusion liée à la génération"
    );

    my $projection = $input_datas->[0]->{'projection'};
    if ( !$projection ) {
        $logger->log( "ERROR",
            "La donnée en entrée du processus ne possède pas de projection"
        );
        return 2;
    }
    $logger->log( "DEBUG", "Projection de la donnée en entrée du processus : " . $projection );
	$logger->log( "DEBUG", "Projection passée en argument : " . $projection_parameter );
	
	# Check if the given projection is correct or not
	my $pattern_srid  = ".*[:].*";
	my $cmd_validation = $gdaltransform_validator_pre . $projection_parameter . $gdaltransform_validator_post;
    
	$logger->log( "DEBUG", "Execution de : " . $cmd_validation );
    my $validation_return = Execute->run($cmd_validation);
    
	if (   $validation_return->get_return() != 0
        || $projection_parameter !~ /$pattern_srid/ )
    {
        $logger->log( "ERROR", "La projection " . $projection_parameter . " n'est pas reconnue par gdaltransform" );
        return 252;
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
            "La donnée de diffusion de sortie n'a pas de nom" );
        return 253;
    }
    $logger->log( "DEBUG",
        "Nom de la donnée de diffusion de sortie : " . $bd_name );

    # Récupération des informations du fichier d'informations complémentaires
    my $schema_name = $bd_name;
    $schema_name =~ s/[^A-Za-z0-9_]/_/g;
    $schema_name = lc $schema_name;

    # Mise à jour de la donnée de diffusion
    my $ua = LWP::UserAgent->new;
    if ( $url_proxy ne "none" ) {
        $ua->proxy( [ 'http', 'ftp' ], $url_proxy );
    }

    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/generation/updatePgsqlBD" );
    my $response = $ua->request(
        POST $url_ws_entrepot. "/generation/updatePgsqlBD",
        [
            broadcastDataId => $bd_id,
            schemaName      => $schema_name,
            projection      => $projection_parameter
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
"Lancement du processus de génération de données de diffusion BDD à partir d'un traitement SQL"
    );
    my $return_generate_bdd_datas =
      generate_bdd_from_existing_bdd( $sql_path, $input_data_schema_name,
        $schema_name );
    $logger->log( "DEBUG",
        " --> Valeur de retour : " . $return_generate_bdd_datas );

    if ( $return_generate_bdd_datas != 0 ) {
        $logger->log( "ERROR",
"Une erreur est survenue lors de la génération de données de diffusion BDD"
        );
        return 5;
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
                "Impossible de seconnecter à la base de données " 
              . $dbname . " sur "
              . $host . ":"
              . $port );
        return 11;
    }

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

           # récupération des dates min et max (no mtds folders available here
            my ( $min, $max ) = get_bbox_dates();

            # Mise à jour de la donnée de diffusion avec les bboxes associées
            $logger->log( "DEBUG",
                    "Appel au service REST : "
                  . $url_ws_entrepot
                  . "/generation/updateBboxes" );
            my $response = $ua->request(
                POST $url_ws_entrepot. "/generation/updateBboxes",
                [
                    broadcastDataId          => $bd_id,
                    bboxes                   => \@result,
                    startDate                => $min,
                    endDate                  => $max,
                    info                     => $table->[0],
                    ancestorIdForOriginators => $input_data_id,
                    projection               => $projection_parameter
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

    # Harvest des métadonnées
    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/generation/copyMetadatasFromBD" );
    $response = $ua->request(
        POST $url_ws_entrepot. "/generation/copyMetadatasFromBD",
        [
            sourceBroadcastDataId => $input_data_id,
            targetBroadcastDataId => $bd_id
        ]
    );

    if ( $response->is_success ) {
        $logger->log( "INFO",
                "Copie des références au metadatas de la broadcast data "
              . $input_data_id
              . " dans la broadcast data "
              . $bd_id
              . " effectuée" );
    }
    else {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la copie des références au metadatas de la broadcast data "
              . $input_data_id
              . " dans la broadcast data "
              . $bd_id );
        return 7;
    }

    # MAJ de la taille totale de la donnée de diffusion
    if ( update_broadcastdata_size( $schema_name, $bd_id, 1 ) != 0 ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour de la taille de la donnée de diffusion "
              . $bd_id );
        return 10;

    }

    return 0;
}

