#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 7;
use Config::Simple;

use strict;
use warnings;
use Cwd;

my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");


require "check_shp.pl";


ok( check_shp() == 255, "Test sans paramètre");
ok( check_shp($resources_path."check_shp_ok") == 0, "Test de fichiers SHP corrects");
ok( check_shp($resources_path."check_shp_no_exist") == 3, "Test avec un répertoire spécifié inexistant");
ok( check_shp($resources_path."check_shp_no_shp") == 1, "Test avec un répertoire ne contenant pas de .shp");
ok( check_shp($resources_path."check_shp_no_shx") == 2, "Test avec un fichier SHX manquant");
ok( check_shp($resources_path."check_shp_no_dbf") == 2, "Test avec des instructions DBF manquant");
ok( check_shp($resources_path."check_shp_ko") == 2, "Test avec un shape erroné");