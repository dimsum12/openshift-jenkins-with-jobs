#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 4;
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

require "rollback_generate_bdd_datas.pl";


my $database = Database->connect($dbname, $host, $port, $username, $password);
$database->create_schema("test_generate_bdd_datas_ok");


ok( rollback_generate_bdd_datas() == 255, "Test sans paramètre" );
ok( rollback_generate_bdd_datas("test_generate_bdd_datas_ok") == 0, "Test avec un nom de schéma correct" );
ok( rollback_generate_bdd_datas("pg_test") == 1, "Test avec un nom de schéma incorrect" );
ok( rollback_generate_bdd_datas("test_generate_bdd_datas_no_exist") == 2, "Test avec un nom de schéma inexistant" );


$database->disconnect();

