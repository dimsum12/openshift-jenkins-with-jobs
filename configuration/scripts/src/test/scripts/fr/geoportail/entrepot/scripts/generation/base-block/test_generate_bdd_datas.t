#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 15;
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

require "generate_bdd_datas.pl";


my $database = Database->connect($dbname, $host, $port, $username, $password);

ok( generate_bdd_datas() == 255, "Test sans paramètre" );
ok( generate_bdd_datas($resources_path."complete_delivery_vector_ok/DATAS/", "test_generate_bdd_datas_ok") == 0, "Test avec une livraison en SQL et un nom de schema valide" );
$database->drop_schema("test_generate_bdd_datas_ok", "true");
ok( generate_bdd_datas($resources_path."complete_delivery_vector_ok/Livraison1/", "test_generate_bdd_datas_recursive_ok", "EPSG:4326") == 0, "Test avec une livraison en SQL recursive et un nom de schema valide" );
$database->drop_schema("test_generate_bdd_datas_recursive_ok", "true");
ok( generate_bdd_datas($resources_path."complete_delivery_vector_shp_ok/DATAS/", "test_generate_bdd_datas_shp_ok", "EPSG:2154") == 0, "Test avec une livraison en SHP, un nom de schema valide et une projection valide" );
$database->drop_schema("test_generate_bdd_datas_shp_ok", "true");
ok( generate_bdd_datas($resources_path."complete_delivery_vector_no_exist/DATAS_no_exist/", "test_generate_bdd_datas") == 1, "Test avec un repertoire de données inexistant" );
ok( generate_bdd_datas($resources_path."complete_delivery_raster_ok/Livraison1/DATAS/", "test_generate_bdd_datas") == 2, "Test avec un repertoire de données ne contenant ni SQL ni SHP" );
ok( generate_bdd_datas($resources_path."complete_delivery_vector_ok/DATAS/", "") == 3, "Test avec un nom de schéma vide" );
ok( generate_bdd_datas($resources_path."complete_delivery_vector_ok/DATAS/", "pg_test_generate_bdd_datas_ok") == 3, "Test avec un nom de schéma érroné commençant par pg_" );
ok( generate_bdd_datas($resources_path."complete_delivery_vector_ok/DATAS/", "test_generate_bdd_datas_?") == 3, "Test avec un nom de schéma érroné contenant un caractère spécial" );
ok( generate_bdd_datas($resources_path."complete_delivery_vector_shp_ok/DATAS/", "test_generate_bdd_datas") == 4, "Test avec des shapefiles et sans projection spécifiée" );
ok( generate_bdd_datas($resources_path."complete_delivery_vector_shp_ok/DATAS/", "test_generate_bdd_datas", "") == 4, "Test avec des shapefiles et une projection vide" );
ok( generate_bdd_datas($resources_path."complete_delivery_vector_shp_ok/DATAS/", "test_generate_bdd_datas", "UNRECOGNIZED_PROJ") == 4, "Test avec des shapefiles et une projection inconnue" );
ok( generate_bdd_datas($resources_path."complete_delivery_vector_shp_nok/Livraison1/DATAS/", "test_generate_bdd_datas", "EPSG:2154") == 5, "Test avec une erreur lors de la conversion SHP vers SQL" );
$database->drop_schema("test_generate_bdd_datas", "true");
ok( generate_bdd_datas($resources_path."complete_delivery_vector_nok/Livraison1/DATAS/", "test_generate_bdd_datas") == 6, "Test avec une erreur d'intégration SQL" );
$database->drop_schema("test_generate_bdd_datas", "true");
ok( generate_bdd_datas($resources_path."complete_delivery_vector_ok/DATAS/", "public") == 7, "Test avec un nom de schéma déjà existant" );

$database->disconnect();

