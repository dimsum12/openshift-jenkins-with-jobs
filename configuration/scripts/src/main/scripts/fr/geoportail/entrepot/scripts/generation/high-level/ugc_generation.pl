#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will generate a UGC broadcast data using the generation id
#       First it collect informations from service REST
#       Then it generate both reference table, auto-fillin index and invert geocoding graph
# ARGS :
#   The generation ID
# RETURNS :
#   * 0 if generation is correct
#   * 1 if the REST service is not reacheable or if the ID is incorrect
#   * 2 if the specified language is uncompatible
#   * 3 if the generation is not linked to any input data
#   * 4 if the generation is linked to many broadcast datas
#   * 5 if an error occured with the filers
#   * 6 if an error occured while reading the process sources
#   * 7 if an error occured during generating the reference table or auto completion
#   * 8 if an error occured during cleaning generation files for reference table
#   * 9 if an error occured during cleaning generation files for auto completion
#   * 10 if an error occured during updating UGC broadcast data
#   * 253 if the generation structure is incorrect
#   * 254 if the JSON return is not parseable
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 2 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/ugc_generation.pl $
#   $Date: 25/11/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Database;
use Execute;
use Cwd;
use LWP::UserAgent;
use HTTP::Request::Common;
use Config::Simple;
use JSON;
use Tools;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger =
  Logger->new( "ugc_generation.pl", $config->param("logger.levels") );

# Chargement des configurations
my $resources_path           = $config->param("resources.path");
my $url_ws_entrepot          = $config->param("resources.ws.url.entrepot");
my $url_proxy                = $config->param("proxy.url");
my $root_storage             = $config->param("filer.root.storage");
my $tmp_path                 = $config->param("resources.tmp.path");
my $tmp_generation           = $config->param("resources.tmp.generations");
my $cmd_more                 = $config->param("resources.more");
my $cmd_cat                  = $config->param("resources.cat");
my $cmd_cp                   = $config->param("resources.cp");
my $cmd_cd                   = $config->param("resources.cd");
my $db_dbname                = $config->param("db-ent_donnees.dbname");
my $db_host                  = $config->param("db-ent_donnees.host");
my $db_port                  = $config->param("db-ent_donnees.port");
my $db_username              = $config->param("db-ent_donnees.username");
my $db_password              = $config->param("db-ent_donnees.password");
my $ugc_cmd_export           = $config->param("ugc.cmd_export");
my $ugc_cmd_tref_address     = $config->param("ugc.cmd_tref_address");
my $ugc_cmd_tref_nyme        = $config->param("ugc.cmd_tref_nyme");
my $ugc_cmd_autocomp         = $config->param("ugc.cmd_autocomp");
my $ugc_cmd_revert_geocoding = $config->param("ugc.cmd_revert_geocoding");
my $ugc_cmd_line             = $config->param("ugc.cmd_line");
my $ugc_metadatas            = $config->param("ugc.metadatas");
my $ugc_grammar              = $config->param("ugc.grammar");
my $ugc_nad_dir              = $config->param("ugc.nad_dir");
my $ugc_processes_dir        = $config->param("ugc.processes_dir");
my $ugc_references_dir       = $config->param("ugc.references_dir");
my $ugc_bin_dir              = $config->param("ugc.bin_dir");
my $dummy_level2_txt_file    = $config->param("ugc.dummy_level2_file");
my @ugc_languages            = split m/[:]/, $config->param("ugc.languages");

# Constantes globales
my $tref_level1_file_sql_name            = "tref_level1.sql";
my $tref_level2_point_file_sql_name      = "tref_level2_point.sql";
my $tref_level2_linestring_file_sql_name = "tref_level2_linestring.sql";
my $tref_links_file_sql_name             = "tref_links.sql";
my $autocomp_nyme_file_sql_name          = "autocomp_nyme.sql";
my $autocomp_pop_file_sql_name           = "autocomp_pop.sql";
my $autocomp_addresses_file_sql_name     = "autocomp_addresses.sql";
my $tref_dep_sql =
  "SELECT departement AS id FROM public.departement_territoire ORDER BY id";
my $autocomp_dep_sql                 = $tref_dep_sql;
my $public_schema                    = "public";
my $schemaname_key                   = "{SCHEMA}";
my $schema_union                     = "UNION ALL";
my $nyme_config_file_name            = "config_nyme.properties";
my $address_config_file_name         = "config_address.properties";
my $autocomp_config_file_name        = "config_autocomp.properties";
my $tref_dir_name                    = "TREF";
my $autocomp_dir_name                = "autocomp";
my $level1_txt_file_name             = "level1.txt";
my $level2_txt_file_name             = "level2.txt";
my $level2_txt_file_namebad          = "level2bad.txt";
my $links_txt_file_name              = "links.txt";
my $tableref_file_name               = "tref.ugc";
my $metadatas_file_name              = "metadatas.xml";
my $grammar_file_name                = "grammar.xml";
my $autocomp_ugccmdline              = "autocomp.ugccmdline";
my $autocomp_ab_ref_filename         = "autocomp.ab.ref.filename";
my $autocomp_ab_filename             = "autocomp.ab.filename";
my $autocomp_config_ref_filename     = "autocomp.config.ref.filename";
my $autocomp_config_filename         = "autocomp.config.filename";
my $autocomp_config_filename_key     = "autocomplete.xml";
my $autocomp_config_ref_filename_key = $autocomp_config_filename_key . "\.ref";
my $autocomp_ab_filename_key         = "abreviations.reference.txt";
my $autocomp_ab_ref_filename_key     = $autocomp_ab_filename_key . "\.ref";

# Clés de configuration globales
my $line_return              = "\r\n";
my $key_value_sep            = " = ";
my $ugc_key_db_hostname      = "db.hostname";
my $ugc_key_db_port          = "db.port";
my $ugc_key_db_database      = "db.database";
my $ugc_key_db_user          = "db.user";
my $ugc_key_db_password      = "db.password";
my $ugc_key_db_driverclass   = "db.driverclass";
my $ugc_value_db_driverclass = "org.postgresql.Driver";

# Clés de configuration NYME
my $ugc_key_nyme_schema           = "nyme.schema";
my $ugc_key_nyme_query            = "nyme.query";
my $ugc_key_nyme_listdep          = "nyme.listdep";
my $ugc_key_nyme_filename         = "nyme.filename";
my $ugc_key_nyme_streets_filename = "nyme.streets.filename";
my $ugc_key_ugc_nyme_ugccmdline   = "ugc.nyme.ugccmdline";
my $ugc_key_ugc_nyme_tableref     = "ugc.nyme.tableref";
my $ugc_key_ugc_nyme_grammar      = "ugc.nyme.grammar";
my $ugc_key_ugc_nyme_proj         = "ugc.nyme.proj";
my $ugc_key_ugc_nyme_metadatas    = "ugc.nyme.metadatas";
my $autocomp_nyme_schema          = "autocomp.toponyme.schema";
my $autocomp_nyme_query           = "autocomp.toponyme.query";
my $autocomp_nyme_file_name       = "autocomp.toponyme.filename";
my $autocomp_nyme_out             = "toponyme.out";
my $autocomp_population_schema    = "autocomp.population.schema";
my $autocomp_population_query     = "autocomp.population.query";
my $autocomp_population_filename  = "autocomp.population.filename";
my $autocomp_population_out       = "population.out";
my $autocomp_addresses_schema     = "autocomp.addresses.schema";
my $autocomp_addresses_listdep    = "autocomp.addresses.listdep";
my $autocomp_addresses_query      = "autocomp.addresses.query";
my $autocomp_addresses_filename   = "autocomp.addresses.filename";
my $autocomp_addresses_out        = "adresses.out";

# Clés de configuration ADDRESS
my $ugc_key_cities_schema            = "cities.schema";
my $ugc_key_cities_query             = "cities.query";
my $ugc_key_cities_filename          = "cities.filename";
my $ugc_key_links_schema             = "links.schema";
my $ugc_key_links_query              = "links.query";
my $ugc_key_links_filename           = "links.filename";
my $ugc_key_streets_schema           = "streets.schema";
my $ugc_key_streets_point_query      = "streets.query";
my $ugc_key_streets_linestring_query = "streets.route.query";
my $ugc_key_streets_filename         = "streets.filename";
my $ugc_key_streets_filenamebad      = "streets.filenamebad";
my $ugc_key_streets_listdep          = "streets.listdep";
my $ugc_key_ugc_address_ugccmdline   = "ugc.address.ugccmdline";
my $ugc_key_ugc_address_tableref     = "ugc.address.tableref";
my $ugc_key_ugc_address_grammar      = "ugc.address.grammar";
my $ugc_key_ugc_address_proj         = "ugc.address.proj";
my $ugc_key_ugc_address_metadatas    = "ugc.address.metadatas";

sub ugc_generation {

    # Extraction des paramètres
    my ( $generation_id, $process, $language ) = @_;
    if ( !defined $generation_id || !defined $process || !defined $language ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (3)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : generation_id = " . $generation_id );
    $logger->log( "DEBUG", "Paramètre 2 : sql_cities = " . $process );
    $logger->log( "DEBUG", "Paramètre 3 : sql_links = " . $language );

    # Vérification du langage demandé
    my $finded = "false";
    foreach my $ugc_language (@ugc_languages) {
        $logger->log( "DEBUG",
            "On compare " . $language . " à " . $ugc_language );
        if ( $ugc_language eq $language ) {
            $logger->log( "DEBUG", " --> Ce sont les mêmes !" );
            $finded = "true";
        }
    }

    if ( "false" eq $finded ) {
        $logger->log( "ERROR",
                "Le langage "
              . $language
              . " n'est pas reconnu par la génération" );
        return 2;
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
"La génération demandée n'est lié à aucune donnée en entrée alors que ce type de traitement en attend plusieurs"
        );
        return 3;
    }
    $logger->log( "DEBUG",
        scalar( @{$input_datas} ) . " donnée(s) liée(s) à la génération" );

    my @input_datas_ids = ();
    my @schemas_names   = ();
    foreach my $input_data ( @{$input_datas} ) {
        my $input_data_id = $input_data->{'id'};
        if ( !$input_data_id ) {
            $logger->log( "ERROR",
"Une donnée en entrée du processus ne possède pas d'identifiant"
            );
            return 253;
        }
        $logger->log( "DEBUG",
            "identifiant de la données de diffusion en base : "
              . $input_data_id );

        push @input_datas_ids, $input_data_id;

        my $schema_name = $input_data->{'schemaName'};
        if ( !$schema_name ) {
            $logger->log( "ERROR",
"Une donnée en entrée du processus n'est pas de type BroadcastDataPgsql"
            );
            return 253;
        }
        $logger->log( "DEBUG",
            "Schema de la données de diffusion en base : " . $schema_name );

        push @schemas_names, $schema_name;
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
            return 4;
        }
    }
    else {
        $logger->log( "ERROR",
"La génération demandée n'est lié à aucune donnée en sortie alors que ce type de traitement en attend 1"
        );
        return 4;
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

    # Mise en forme des informations
    my $tmp_generation_dir =
      $tmp_path . $tmp_generation . "/" . $generation_id . "/";
    $logger->log( "INFO", "Répertoire temporaire : " . $tmp_generation_dir );

    my $destination_dir = $root_storage . $storage_path . "/" . $bd_id;
    $logger->log( "INFO", "Répertoire de destination : " . $destination_dir );

    my $tref_dir     = $destination_dir . "/" . $tref_dir_name;
    my $autocomp_dir = $destination_dir . "/" . $autocomp_dir_name;

    my $configuration_dir = $ugc_processes_dir . "/" . $process;
    $logger->log( "INFO",
        "Répertoire de configuration du process : " . $configuration_dir );

    # Création du fichier de l'arborescence temporaire
    $logger->log( "INFO",
        "Création de l'arborescence temporaire " . $tmp_generation_dir );
    my $cmd_create_tmp = "mkdir -p " . $tmp_generation_dir;
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd_create_tmp );
    my $execution_create_tmp = Execute->run($cmd_create_tmp);
    if ( $execution_create_tmp->get_return() != 0 ) {
        $logger->log( "ERROR",
"Impossible de créer le repertoire temporaire de la génération : "
              . $tmp_generation_dir );
        return 5;
    }

    # Lecture de la requête LEVEL1
    my $tref_level1_file_sql =
      $configuration_dir . '/' . $tref_level1_file_sql_name;
    my $cmd = $cmd_cat . " " . $tref_level1_file_sql;
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd );
    my $execution_more_level1 = Execute->run($cmd);
    if ( !-e $tref_level1_file_sql
        || $execution_more_level1->get_return() != 0 )
    {
        $logger->log( "ERROR",
            "Impossible d'ouvrir le fichier de la requête SQL NYME : "
              . $tref_level1_file_sql );
        return 6;
    }

    # Dans quel cas se trouve t-on ?
    my $hdl_tref_config_file;
    my $hd1_autocomp_config_file;
    my $tref_config_file;
    my $autocomp__config_file;
    my $ugc_cmd_tref;
    my @logs;

    my $tref_level2_point_file_sql =
      $configuration_dir . '/' . $tref_level2_point_file_sql_name;
    my $tref_level2_linestring_file_sql =
      $configuration_dir . '/' . $tref_level2_linestring_file_sql_name;
    if (   !-e $tref_level2_point_file_sql
        && !-e $tref_level2_linestring_file_sql )
    {

        # UN SEUL NIVEAU DE TRAITEMENT

        # Creation de la configuration
        $tref_config_file = $tmp_generation_dir . '/' . $nyme_config_file_name;
        $logger->log( "DEBUG",
            "Ouverture en écriture du fichier " . $tref_config_file );
        if ( !open $hdl_tref_config_file, ">", $tref_config_file ) {
            $logger->log( "ERROR",
                "Impossible de créer le fichier de configuration de la TREF : "
                  . $tref_config_file );

            return 5;
        }
        $logger->log( "INFO",
            "Création du fichier de configuration de la TREF : "
              . $tref_config_file );

        # Ecriture des informations NYME dans le fichier
        $logger->log( "INFO",
            "Ecriture de la configuration spécifique pour la génération NYME"
        );

        print {$hdl_tref_config_file} $ugc_key_ugc_nyme_ugccmdline
          . $key_value_sep . "'"
          . $ugc_cmd_line . "'"
          . $line_return;
        print {$hdl_tref_config_file} $ugc_key_ugc_nyme_tableref
          . $key_value_sep . "'"
          . $tref_dir . "/"
          . $tableref_file_name . "'"
          . $line_return;
        print {$hdl_tref_config_file} $ugc_key_ugc_nyme_grammar
          . $key_value_sep . "'"
          . $language . "@"
          . $configuration_dir . "/"
          . $grammar_file_name . "'"
          . $line_return;
        print {$hdl_tref_config_file} $ugc_key_ugc_nyme_proj
          . $key_value_sep . "'"
          . $ugc_nad_dir . "'"
          . $line_return;
        print {$hdl_tref_config_file} $ugc_key_ugc_nyme_metadatas
          . $key_value_sep . "'"
          . $configuration_dir . "/"
          . $metadatas_file_name . "'"
          . $line_return;
        print {$hdl_tref_config_file} $line_return;

        # Ecriture de la partie NYME dans le fichier
        print {$hdl_tref_config_file} $ugc_key_nyme_filename
          . $key_value_sep . "'"
          . $tref_dir . "/"
          . $level1_txt_file_name . "'"
          . $line_return;
        print {$hdl_tref_config_file} $ugc_key_nyme_schema
          . $key_value_sep . "'"
          . $public_schema . "'"
          . $line_return;
        print {$hdl_tref_config_file} $ugc_key_nyme_query
          . $key_value_sep
          . "\"\"\""
          . $line_return;
        @logs = $execution_more_level1->get_log();
        for my $schemaname (@schemas_names) {
            print {$hdl_tref_config_file} "(";
            for my $line (@logs) {
                my $tmpline = $line;
                $tmpline =~ s/$schemaname_key/$schemaname/g;
                print {$hdl_tref_config_file} $tmpline;
            }
            print {$hdl_tref_config_file} ")";

            if ( $schemaname ne @schemas_names[ scalar @schemas_names - 1 ] ) {
                print {$hdl_tref_config_file} $line_return
                  . $schema_union
                  . $line_return;
            }
        }
        print {$hdl_tref_config_file} "\"\"\"" . $line_return;
        print {$hdl_tref_config_file} $line_return;

        # Ecriture de la partie STREETS dans le fichier
        print {$hdl_tref_config_file} $ugc_key_nyme_streets_filename
          . $key_value_sep . "'"
          . $dummy_level2_txt_file . "'"
          . $line_return;
        print {$hdl_tref_config_file} $line_return;

        # Ecriture de la partie DEPARTEMENT dans le fichier
        print {$hdl_tref_config_file} $ugc_key_nyme_listdep
          . $key_value_sep
          . "\"\"\""
          . $line_return;
        print {$hdl_tref_config_file} $tref_dep_sql . $line_return;
        print {$hdl_tref_config_file} "\"\"\"" . $line_return;
        print {$hdl_tref_config_file} $line_return;

        # Preparation de la commande à executer
        $ugc_cmd_tref = $ugc_cmd_tref_nyme;
    }
    else {

        # DEUX NIVEAUX DE TRAITEMENT

        # Lecture de la requête LINKS
        my $tref_links_file_sql =
          $configuration_dir . '/' . $tref_links_file_sql_name;
        $cmd = $cmd_cat . " " . $tref_links_file_sql;
        $logger->log( "DEBUG", "Appel à la commande : " . $cmd );
        my $execution_more_links = Execute->run($cmd);
        if ( !-e $tref_links_file_sql
            || $execution_more_links->get_return() != 0 )
        {
            $logger->log( "ERROR",
                "Impossible d'ouvrir le fichier de la requête SQL NYME : "
                  . $tref_links_file_sql );
            return 6;
        }

        # Lecture de la requête LEVEL2-POINT
        $tref_level2_point_file_sql =
          $configuration_dir . '/' . $tref_level2_point_file_sql_name;
        $cmd = $cmd_cat . " " . $tref_level2_point_file_sql;
        $logger->log( "DEBUG", "Appel à la commande : " . $cmd );
        my $execution_more_level2_point = Execute->run($cmd);
        if ( !-e $tref_level2_point_file_sql
            || $execution_more_level2_point->get_return() != 0 )
        {
            $logger->log( "ERROR",
                "Impossible d'ouvrir le fichier de la requête SQL NYME : "
                  . $tref_level2_point_file_sql );
            return 6;
        }

        # Lecture de la requête LEVEL2-LINESTRING
        $tref_level2_linestring_file_sql =
          $configuration_dir . '/' . $tref_level2_linestring_file_sql_name;
        $cmd = $cmd_cat . " " . $tref_level2_linestring_file_sql;
        $logger->log( "DEBUG", "Appel à la commande : " . $cmd );
        my $execution_more_level2_linestring = Execute->run($cmd);
        if ( !-e $tref_level2_linestring_file_sql
            || $execution_more_level2_linestring->get_return() != 0 )
        {
            $logger->log( "ERROR",
                "Impossible d'ouvrir le fichier de la requête SQL NYME : "
                  . $tref_level2_linestring_file_sql );
            return 6;
        }

        # Creation de la configuration
        $tref_config_file =
          $tmp_generation_dir . '/' . $address_config_file_name;
        $logger->log( "DEBUG",
            "Ouverture en écriture du fichier " . $tref_config_file );
        if ( !open $hdl_tref_config_file, ">", $tref_config_file ) {
            $logger->log( "ERROR",
                "Impossible de créer le fichier de configuration ADDRESS : "
                  . $tref_config_file );

            return 6;
        }
        $logger->log( "INFO",
            "Création du fichier de configuration ADDRESS : "
              . $tref_config_file );

        # Ecriture des informations ADDRESS dans le fichier
        $logger->log( "INFO",
"Ecriture de la configuration spécifique pour la génération ADDRESS"
        );

        print {$hdl_tref_config_file} $ugc_key_ugc_address_ugccmdline
          . $key_value_sep . "'"
          . $ugc_cmd_line . "'"
          . $line_return;
        print {$hdl_tref_config_file} $ugc_key_ugc_address_tableref
          . $key_value_sep . "'"
          . $tref_dir . "/"
          . $tableref_file_name . "'"
          . $line_return;
        print {$hdl_tref_config_file} $ugc_key_ugc_address_grammar
          . $key_value_sep . "'"
          . $language . "@"
          . $configuration_dir . "/"
          . $grammar_file_name . "'"
          . $line_return;
        print {$hdl_tref_config_file} $ugc_key_ugc_address_proj
          . $key_value_sep . "'"
          . $ugc_nad_dir . "'"
          . $line_return;
        print {$hdl_tref_config_file} $ugc_key_ugc_address_metadatas
          . $key_value_sep . "'"
          . $configuration_dir . "/"
          . $metadatas_file_name . "'"
          . $line_return;
        print {$hdl_tref_config_file} $line_return;

        # Ecriture de la partie CITIES dans le fichier
        print {$hdl_tref_config_file} $ugc_key_cities_filename
          . $key_value_sep . "'"
          . $tref_dir . "/"
          . $level1_txt_file_name . "'"
          . $line_return;
        print {$hdl_tref_config_file} $ugc_key_cities_schema
          . $key_value_sep . "'"
          . $public_schema . "'"
          . $line_return;
        print {$hdl_tref_config_file} $ugc_key_cities_query
          . $key_value_sep
          . "\"\"\""
          . $line_return;
        @logs = $execution_more_level1->get_log();
        for my $schemaname (@schemas_names) {
            print {$hdl_tref_config_file} "(";
            for my $line (@logs) {
                my $tmpline = $line;
                $tmpline =~ s/$schemaname_key/$schemaname/g;
                print {$hdl_tref_config_file} $tmpline;
            }
            print {$hdl_tref_config_file} ")";

            if ( $schemaname ne @schemas_names[ scalar @schemas_names - 1 ] ) {
                print {$hdl_tref_config_file} $line_return
                  . $schema_union
                  . $line_return;
            }
        }
        print {$hdl_tref_config_file} "\"\"\"" . $line_return;
        print {$hdl_tref_config_file} $line_return;

        # Ecriture de la partie LINKS dans le fichier
        print {$hdl_tref_config_file} $ugc_key_links_filename
          . $key_value_sep . "'"
          . $tref_dir . "/"
          . $links_txt_file_name . "'"
          . $line_return;
        print {$hdl_tref_config_file} $ugc_key_links_schema
          . $key_value_sep . "'"
          . $public_schema . "'"
          . $line_return;
        print {$hdl_tref_config_file} $ugc_key_links_query
          . $key_value_sep
          . "\"\"\""
          . $line_return;
        @logs = $execution_more_links->get_log();
        for my $schemaname (@schemas_names) {
            print {$hdl_tref_config_file} "(";
            for my $line (@logs) {
                my $tmpline = $line;
                $tmpline =~ s/$schemaname_key/$schemaname/g;
                print {$hdl_tref_config_file} $tmpline;
            }
            print {$hdl_tref_config_file} ")";

            if ( $schemaname ne @schemas_names[ scalar @schemas_names - 1 ] ) {
                print {$hdl_tref_config_file} $line_return
                  . $schema_union
                  . $line_return;
            }
        }
        print {$hdl_tref_config_file} "\"\"\"" . $line_return;
        print {$hdl_tref_config_file} $line_return;

        # Ecriture de la partie STREETS-POINT dans le fichier
        print {$hdl_tref_config_file} $ugc_key_streets_filename
          . $key_value_sep . "'"
          . $tref_dir . "/"
          . $level2_txt_file_name . "'"
          . $line_return;
        print {$hdl_tref_config_file} $ugc_key_streets_filenamebad
          . $key_value_sep . "'"
          . $tref_dir . "/"
          . $level2_txt_file_namebad . "'"
          . $line_return;
        print {$hdl_tref_config_file} $ugc_key_streets_schema
          . $key_value_sep . "'"
          . $public_schema . "'"
          . $line_return;
        print {$hdl_tref_config_file} $ugc_key_streets_point_query
          . $key_value_sep
          . "\"\"\""
          . $line_return;
        @logs = $execution_more_level2_point->get_log();
        for my $schemaname (@schemas_names) {
            print {$hdl_tref_config_file} "(";
            for my $line (@logs) {
                my $tmpline = $line;
                $tmpline =~ s/$schemaname_key/$schemaname/g;
                print {$hdl_tref_config_file} $tmpline;
            }
            print {$hdl_tref_config_file} ")";

            if ( $schemaname ne @schemas_names[ scalar @schemas_names - 1 ] ) {
                print {$hdl_tref_config_file} $line_return
                  . $schema_union
                  . $line_return;
            }
        }
        print {$hdl_tref_config_file} "\"\"\"" . $line_return;

        # Ecriture de la partie STREETS-LINESTRING dans le fichier
        print {$hdl_tref_config_file} $ugc_key_streets_linestring_query
          . $key_value_sep
          . "\"\"\""
          . $line_return;
        @logs = $execution_more_level2_linestring->get_log();
        for my $schemaname (@schemas_names) {
            print {$hdl_tref_config_file} "(";
            for my $line (@logs) {
                my $tmpline = $line;
                $tmpline =~ s/$schemaname_key/$schemaname/g;
                print {$hdl_tref_config_file} $tmpline;
            }
            print {$hdl_tref_config_file} ")";

            if ( $schemaname ne @schemas_names[ scalar @schemas_names - 1 ] ) {
                print {$hdl_tref_config_file} $line_return
                  . $schema_union
                  . $line_return;
            }
        }
        print {$hdl_tref_config_file} "\"\"\"" . $line_return;
        print {$hdl_tref_config_file} $line_return;

        # Ecriture de la partie DEPARTEMENT dans le fichier
        print {$hdl_tref_config_file} $ugc_key_streets_listdep
          . $key_value_sep
          . "\"\"\""
          . $line_return;
        print {$hdl_tref_config_file} $tref_dep_sql . $line_return;
        print {$hdl_tref_config_file} "\"\"\"" . $line_return;
        print {$hdl_tref_config_file} $line_return;

        # Preparation de la commande à executer
        $ugc_cmd_tref = $ugc_cmd_tref_address;
    }

    # Ecriture des informations BDD dans le fichier
    write_db_config($hdl_tref_config_file);

    # Fermeture du fichier
    if ( !close $hdl_tref_config_file ) {
        $logger->log( "ERROR",
            "Impossible de fermer le fichier de configuration de la TREF : "
              . $tref_config_file );

        return 5;
    }

    # Création du fichier pour l'autocomplétion
    $autocomp__config_file =
      $tmp_generation_dir . '/' . $autocomp_config_file_name;
    $logger->log( "DEBUG",
        "Ouverture en écriture du fichier " . $autocomp__config_file );
    if ( !open $hd1_autocomp_config_file, ">", $autocomp__config_file ) {
        $logger->log( "ERROR",
            "Impossible de créer le fichier de configuration de l'AUTOCOMP : "
              . $autocomp__config_file );
        return 5;
    }

    # Lecture du fichier sql pour les nymes
    my $autocomp_nyme_file_sql =
      $configuration_dir . '/' . $autocomp_nyme_file_sql_name;

    $cmd = $cmd_cat . " " . $autocomp_nyme_file_sql;
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd );
    my $execution_more_autocomp_nyme = Execute->run($cmd);
    if ( !-e $autocomp_nyme_file_sql
        || $execution_more_autocomp_nyme->get_return() != 0 )
    {
        $logger->log( "ERROR",
            "Impossible d'ouvrir le fichier de la requête SQL NYME : "
              . $autocomp_nyme_file_sql );
        return 6;

    }

    # Lecture du fichier sql pour la population
    my $execution_more_autocomp_pop =
      read_conf_sql( $configuration_dir, $autocomp_pop_file_sql_name );
    if ( Tools->is_numeric($execution_more_autocomp_pop) ) {
        return $execution_more_autocomp_pop;
    }

    # Lecture du fichier sql pour les adresses
    my $execution_more_autocomp_addresses =
      read_conf_sql( $configuration_dir, $autocomp_addresses_file_sql_name );
    if ( Tools->is_numeric($execution_more_autocomp_addresses) ) {
        return $execution_more_autocomp_addresses;
    }

    # Ecriture de la configuration globale
    print {$hd1_autocomp_config_file} $autocomp_ugccmdline
      . $key_value_sep . "'"
      . $ugc_cmd_line . "'"
      . $line_return;
    print {$hd1_autocomp_config_file} $autocomp_ab_ref_filename
      . $key_value_sep . "'"
      . $ugc_references_dir . "/"
      . $autocomp_ab_ref_filename_key . "'"
      . $line_return;
    print {$hd1_autocomp_config_file} $autocomp_ab_filename
      . $key_value_sep . "'"
      . $autocomp_dir . "/"
      . $autocomp_ab_filename_key . "'"
      . $line_return;
    print {$hd1_autocomp_config_file} $autocomp_config_ref_filename
      . $key_value_sep . "'"
      . $ugc_references_dir . "/"
      . $autocomp_config_ref_filename_key . "'"
      . $line_return;
    print {$hd1_autocomp_config_file} $autocomp_config_filename
      . $key_value_sep . "'"
      . $autocomp_dir . "/"
      . $autocomp_config_filename_key . "'"
      . $line_return
      . $line_return;

    # Ecriture de la configuration pour les adresses
    print {$hd1_autocomp_config_file} $autocomp_addresses_schema
      . $key_value_sep . "''"
      . $line_return;
    print {$hd1_autocomp_config_file} $autocomp_addresses_filename
      . $key_value_sep . "'"
      . $autocomp_dir . "/"
      . $autocomp_addresses_out . "'"
      . $line_return;
    print {$hd1_autocomp_config_file} $autocomp_addresses_query
      . $key_value_sep
      . $line_return;
    print {$hd1_autocomp_config_file} "\"\"\"" . $line_return . $line_return;
    @logs = $execution_more_autocomp_addresses->get_log();
    write_schema( $hd1_autocomp_config_file, \@schemas_names, \@logs );

    # Ecriture de la partie DEPARTEMENT dans le fichier
    print {$hd1_autocomp_config_file} $autocomp_addresses_listdep
      . $key_value_sep
      . "\"\"\""
      . $line_return;
    print {$hd1_autocomp_config_file} $autocomp_dep_sql . $line_return;
    print {$hd1_autocomp_config_file} "\"\"\"" . $line_return;
    print {$hd1_autocomp_config_file} $line_return;

    # Ecriture de la configuration pour les nymes
    print {$hd1_autocomp_config_file} $autocomp_population_schema
      . $key_value_sep . "''"
      . $line_return;
    print {$hd1_autocomp_config_file} $autocomp_population_filename
      . $key_value_sep . "'"
      . $autocomp_dir . "/"
      . $autocomp_population_out . "'"
      . $line_return;
    print {$hd1_autocomp_config_file} $autocomp_population_query
      . $key_value_sep
      . $line_return;
    print {$hd1_autocomp_config_file} "\"\"\"" . $line_return;
    @logs = $execution_more_autocomp_pop->get_log();
    write_schema( $hd1_autocomp_config_file, \@schemas_names, \@logs );

    print {$hd1_autocomp_config_file} $autocomp_nyme_schema
      . $key_value_sep . "''"
      . $line_return;
    print {$hd1_autocomp_config_file} $autocomp_nyme_file_name
      . $key_value_sep . "'"
      . $autocomp_dir . "/"
      . $autocomp_nyme_out . "'"
      . $line_return;
    print {$hd1_autocomp_config_file} $autocomp_nyme_query
      . $key_value_sep
      . $line_return;
    print {$hd1_autocomp_config_file} "\"\"\"" . $line_return;
    @logs = $execution_more_autocomp_nyme->get_log();
    write_schema( $hd1_autocomp_config_file, \@schemas_names, \@logs );

    # Ecriture de la configuration de la base de données
    write_db_config($hd1_autocomp_config_file);

    # Fermeture du fichier
    if ( !close $hd1_autocomp_config_file ) {
        $logger->log( "ERROR",
            "Impossible de fermer le fichier de configuration de l'AUTOCOMP : "
              . $autocomp_config_file_name );

        return 5;
    }

    # Copie des binaires dans le tmp
    my $cmd_copy_bin =
      $cmd_cp . " " . $ugc_bin_dir . "/groovy/* " . $tmp_generation_dir;
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd_copy_bin );
    my $execution_copy_bin = Execute->run($cmd_copy_bin);
    if ( $execution_copy_bin->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Impossible de copier les binaires UGC dans : "
              . $tmp_generation_dir );
        return 5;
    }

# Création de l'arborescence de la donnée de diffusion pour les tables de références
    my $result = create_directories($tref_dir);
    if ( 0 != $result ) {
        return $result;
    }

# Création de l'arborescence de la donnée de diffusion pour les fichiers d'autocomplétion
    $result = create_directories($autocomp_dir);
    if ( 0 != $result ) {
        return $result;
    }

    # Execution de la commande de creation des tables de référence
    $result = execute_generation( $ugc_cmd_tref, $tmp_generation_dir,
        "Tables de références" );
    if ( 0 != $result ) {
        return $result;
    }

    # Execution de la commande de génération des fichiers d'auto complétion
    $result = execute_generation( $ugc_cmd_autocomp, $tmp_generation_dir,
        "Autocompletion" );
    if ( 0 != $result ) {
        return $result;
    }

    # Nettoyage des dossiers temporaires de génération
    my $cmd_clean = "rm -rf " . $tmp_generation_dir;
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd_clean );
    my $execution_clean = Execute->run($cmd_clean);
    if ( $execution_clean->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors du nettoyage des dossiers temporaires : "
              . $cmd_clean );
        return 8;
    }
    $logger->log( "INFO", "Nettoyage des dossiers temporaires" );

# Nettoyage des fichiers ne contenant pas d'informations au niveau du répertoire de la donnée de diffusion
    $cmd_clean = "ls "
      . $autocomp_dir
      . "/ | while read line; do nb_line=`$cmd_cat $autocomp_dir\/\$line | wc -l`; if [ \$nb_line -lt 2 ]; then echo $autocomp_dir\/\$line; fi; done";
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd_clean );
    my $execution_find = Execute->run($cmd_clean);
    $execution_find->log_all( $logger, "DEBUG" );
    if ( $execution_find->get_return() != 0 ) {
        $logger->log( "ERROR",
"Impossible de trouver les fichiers vides lors de la génération de l'auto complétion dans : "
              . $autocomp_dir );
        return 9;
    }
    my @files_to_clean = $execution_find->get_log();
    my $file_to_clean_tmp;
    for my $file_to_clean (@files_to_clean) {
        chomp $file_to_clean;
        $cmd_clean = "rm " . $file_to_clean;
        $logger->log( "DEBUG", "Appel à la commande : " . $cmd_clean );
        if ( $file_to_clean_tmp ne $file_to_clean ) {
            my $execution_clean_autocomp = Execute->run( $cmd_clean, "true" );
            $execution_clean_autocomp->log_all( $logger, "DEBUG" );
            if ( $execution_clean_autocomp->get_return() != 0 ) {
                $logger->log( "ERROR",
                    "Impossible de supprimer le fichier vide : "
                      . $file_to_clean );
                return 9;
            }
        }
        $file_to_clean_tmp = $file_to_clean;
    }

    # Mise à jour de la donnée de diffusion
    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/generation/updateUGC" );
    $response = $ua->request(
        POST $url_ws_entrepot. "/generation/updateUGC",
        [
            broadcastDataId => $bd_id,
            ugcFile         => $tableref_file_name,
            ugcType         => $process,
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
        return 10;
    }

    my $return_update_bd_size =
      update_broadcastdata_size( $destination_dir, $bd_id, 0 );

    # MAJ de la taille totale de la donnée de diffusion
    if ( $return_update_bd_size != 0 ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour de la taille de la donnée de diffusion "
              . $bd_id );
        return 11;
    }

    return 0;
}

# Ecriture de configurations pour la base de données
sub write_db_config {
    my ($config_file_name) = @_;

    # Ecriture des informations BDD dans le fichier
    print {$config_file_name} $ugc_key_db_hostname
      . $key_value_sep . "'"
      . $db_host . "'"
      . $line_return;
    print {$config_file_name} $ugc_key_db_port
      . $key_value_sep . "'"
      . $db_port . "'"
      . $line_return;
    print {$config_file_name} $ugc_key_db_database
      . $key_value_sep . "'"
      . $db_dbname . "'"
      . $line_return;
    print {$config_file_name} $ugc_key_db_user
      . $key_value_sep . "'"
      . $db_username . "'"
      . $line_return;
    print {$config_file_name} $ugc_key_db_password
      . $key_value_sep . "'"
      . $db_password . "'"
      . $line_return;
    print {$config_file_name} $ugc_key_db_driverclass
      . $key_value_sep . "'"
      . $ugc_value_db_driverclass . "'"
      . $line_return;

    return 0;
}

# Replancement des {SCHEMA} par une valeur de substitution
sub write_schema {
    my ( $config_file, $ref_schemas_names, $ref_logs ) = @_;
    my @schemas_names = @{$ref_schemas_names};
    my @logs          = @{$ref_logs};

    for my $schemaname (@schemas_names) {
        for my $line (@logs) {
            my $tmpline = $line;
            $tmpline =~ s/$schemaname_key/$schemaname/g;
            print {$config_file} $tmpline . " ";
        }

        if ( $schemaname ne @schemas_names[ scalar @schemas_names - 1 ] ) {
            print {$config_file} $line_return . $schema_union . $line_return;
        }
    }
    print {$config_file} $line_return . "\"\"\"" . $line_return;
    print {$config_file} $line_return;

    return 0;
}

# Lecture des fichiers de configuration SQL
sub read_conf_sql {
    my ( $configuration_dir, $file_sql_name ) = @_;

    my $file_sql = $configuration_dir . '/' . $file_sql_name;
    my $cmd      = $cmd_cat . " " . $file_sql;
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd );
    my $execution_more_file = Execute->run($cmd);
    $execution_more_file->log_all( $logger, "DEBUG" );
    if ( !-e $file_sql
        || $execution_more_file->get_return() != 0 )
    {
        $logger->log( "ERROR",
            "Impossible d'ouvrir le fichier de requête(s) SQL : "
              . $file_sql );
        return 6;
    }

    return $execution_more_file;
}

# Fonction pour la création des arborescences des données de diffusion
sub create_directories {
    my ($autocomp_dir) = @_;
    my $cmd_create_arbo = "mkdir -p " . $autocomp_dir;
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd_create_arbo );
    my $execution_create_arbo = Execute->run($cmd_create_arbo);
    $execution_create_arbo->log_all( $logger, "DEBUG" );
    if ( $execution_create_arbo->get_return() != 0 ) {
        $logger->log( "ERROR",
"Erreur lors de la création de l'arborescence de la donnée de diffusion : "
              . $cmd_create_arbo );
        return 5;
    }
    $logger->log( "INFO",
        "Arborescence de la donnée de diffusion créée : " . $autocomp_dir );
    return 0;
}

# Exécution des générations pour la chaine UGC
sub execute_generation {
    my ( $ugc_cmd_gen, $tmp_generation_dir, $log ) = @_;
    my $cmd =
      "cd " . $tmp_generation_dir . ";" . $ugc_cmd_export . ";" . $ugc_cmd_gen;
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd );
    my $execution_autocomp = Execute->run($cmd);
    $execution_autocomp->log_all( $logger, "DEBUG" );
    if ( $execution_autocomp->get_return() != 0 ) {
        $logger->log( "ERROR",
                "Erreur lors de l'execution de la commande de génération (" 
              . $log . ") : "
              . $cmd );
        return 7;
    }
    $logger->log( "INFO", $log . " généré(es) avec succès" );

    return 0;
}
