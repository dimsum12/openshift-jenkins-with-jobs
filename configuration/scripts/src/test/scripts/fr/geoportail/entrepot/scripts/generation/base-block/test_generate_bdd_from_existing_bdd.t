#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 12;
use Config::Simple;

use strict;
use warnings;
use Cwd;

use Database;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");

my $dbname = $config->param("db-ent_donnees.dbname");
my $host = $config->param("db-ent_donnees.host");
my $port =  $config->param("db-ent_donnees.port");
my $username = $config->param("db-ent_donnees.username");
my $password = $config->param("db-ent_donnees.password");

require "generate_bdd_from_existing_bdd.pl";
require "generate_bdd_datas.pl";


my $database = Database->connect($dbname, $host, $port, $username, $password);

ok( generate_bdd_from_existing_bdd() == 255, "Test sans paramètre" );
ok( generate_bdd_from_existing_bdd($resources_path."test_reprocess_existing_bdd/reprocess_scripts_not_exist", "test_source_schema_ok", "test_existing_bdd_ok") == 1, "Test avec un repertoire de données inexistant" );
ok( generate_bdd_from_existing_bdd($resources_path."test_reprocess_existing_bdd/reprocess_scripts_no_sql", "test_source_schema_ok", "test_existing_bdd_ok") == 2, "Test avec un repertoire de données ne contenant pas de fichier SQL" );
ok( generate_bdd_from_existing_bdd($resources_path."test_reprocess_existing_bdd/reprocess_scripts_ok", "", "test_existing_bdd_ok") == 3, "Test avec un nom de schéma source vide" );
ok( generate_bdd_from_existing_bdd($resources_path."test_reprocess_existing_bdd/reprocess_scripts_ok", "test_source_schema_ok", "") == 5, "Test avec un nom de schema cible vide" );
ok( generate_bdd_from_existing_bdd($resources_path."test_reprocess_existing_bdd/reprocess_scripts_ok", "pg_test_source_schema_nok", "test_existing_bdd_ok") == 3, "Test avec un nom de schéma source érroné commençant par pg_" );
ok( generate_bdd_from_existing_bdd($resources_path."test_reprocess_existing_bdd/reprocess_scripts_ok", "test_source_schema_ok", "pg_test_existing_bdd_nok") == 5, "Test avec un nom de schéma cible érroné commençant par pg_" );
ok( generate_bdd_from_existing_bdd($resources_path."test_reprocess_existing_bdd/reprocess_scripts_ok", "test_source_schema_nok_?", "test_existing_bdd_ok") == 3, "Test avec un nom de schéma source érroné contenant un caractère spécial" );
ok( generate_bdd_from_existing_bdd($resources_path."test_reprocess_existing_bdd/reprocess_scripts_ok", "test_source_schema_ok", "test_existing_bdd_?") == 5, "Test avec un nom de schéma cible érroné contenant un caractère spécial" );
ok( generate_bdd_from_existing_bdd($resources_path."test_reprocess_existing_bdd/reprocess_scripts_ok", "test_schema_not_exist", "test_existing_bdd_ok") == 4, "Test avec un nom de schéma source inexistant" );

# generate test source schema
generate_bdd_datas($resources_path."complete_delivery_vector_ok/DATAS/", "test_source_schema_ok");

ok( generate_bdd_from_existing_bdd($resources_path."test_reprocess_existing_bdd/reprocess_scripts_ok", "test_source_schema_ok", "test_existing_bdd_ok") == 0, "Test avec une livraison en SQL et un nom de schema valide" );
$database->drop_schema("test_existing_bdd_ok", "true");
#ok( generate_bdd_from_existing_bdd($resources_path."complete_delivery_vector_nok/Livraison1/DATAS/", "test_source_schema_ok") == 5, "Test avec une erreur d'intégration SQL" );
ok( generate_bdd_from_existing_bdd($resources_path."test_reprocess_existing_bdd/reprocess_scripts_ok", "test_source_schema_ok", "public") == 6, "Test avec un nom de schéma cible déjà existant" );

$database->drop_schema("test_source_schema_ok", "true");

$database->disconnect();

