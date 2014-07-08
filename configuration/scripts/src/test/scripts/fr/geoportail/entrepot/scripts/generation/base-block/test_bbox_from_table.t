#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 6;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
no warnings 'redefine';
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

require "bbox_from_table.pl";
require "generate_bdd_datas.pl";


# Insertion d'une base source
if (generate_bdd_datas($resources_path . "complete_delivery_vector_ok/DATAS/", "test_bdd_update_generation") != 0) {
	print "ERREUR LORS DE L'INSERTION DU SCHEMA DE TEST : IMPOSSIBLE DE CONTINUER LES TESTS";
	exit 1;
}

my $database = Database->connect($dbname, $host, $port, $username, $password);



ok( bbox_from_table() == 255, "testWithoutParameters" );
ok( scalar bbox_from_table("test_bdd_update_generation", "ebm_a", 4326) == 4, "testWithGoodTable" );
ok( scalar bbox_from_table("test_bdd_update_generation", "ebm_a") == 4, "testWithGoodTableNoSrid" );
ok( bbox_from_table("test_bdd_update_generation", "ebm_chr", 4326) == 1, "testWithBadTable" );
ok( bbox_from_table("test_bdd_update_generation", "ebm_a", 432) == 2, "testWithBadSrid" );
ok( bbox_from_table("test_bdd_update_generation", "ebm_p", 4326) == 3, "testWithEmptyTable" );



# Nettoyage des données créées en BDD
$database->drop_schema("test_bdd_update_generation", "true");
$database->disconnect();
