#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 11;
use Config::Simple;

use strict;
use warnings;
use Cwd;

my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");


require "check_georaster.pl";


ok( check_georaster() == 255, "Test sans paramètre" );
ok( check_georaster($resources_path."check_georaster_ok", 5) == 0, "Test avec des images correctes et un paramètre entier correct"); 
ok( check_georaster($resources_path."check_georaster_ok", "100%") == 0, "Test avec des images correctes et un paramètre pourcentage correct");
ok( check_georaster($resources_path."check_georaster_nok", 1) == 1, "Test avec une image incorrecte et un paramètre entier correct");
ok( check_georaster($resources_path."check_georaster_no_exist", 2) == 2, "Test avec un répertoire de données inexistant");
ok( check_georaster($resources_path."check_georaster_no_image", 2) == 3, "Test avec un répertoire de données sans images");
ok( check_georaster($resources_path."check_georaster_ok", 20) == 4, "Test avec un nombre d'image à vérifier plus grand que le nombre d'images disponibles");
ok( check_georaster($resources_path."check_georaster_ok", -2) == 5, "Test avec un nombre d'élément <= 0");
ok( check_georaster($resources_path."check_georaster_ok", "0%") == 5, "Test avec un nombre d'élément = 0%");
ok( check_georaster($resources_path."check_georaster_ok", "120%") == 4, "Test avec un nombre d'élément > 100%");
ok( check_georaster($resources_path."check_georaster_ok", "NaN") == 5, "Test avec un paramètre incorrect");
