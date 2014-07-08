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


require "check_sql.pl";


ok( check_sql() == 255, "Test sans paramètre");
ok( check_sql($resources_path."check_sql_ok") == 0, "Test de fichiers SQL corrects");
ok( check_sql($resources_path."check_sql_no_exist") == 3, "Test avec un répertoire spécifié inexistant");
ok( check_sql($resources_path."check_sql_no_sql") == 1, "Test avec un répertoire ne contenant pas de .sql");
ok( check_sql($resources_path."check_sql_bad_construct") == 2, "Test avec des instructions SQL mal construite");
ok( check_sql($resources_path."check_sql_bad_schemas") == 2, "Test avec des instructions SQL contenant des références à de schema");
ok( check_sql($resources_path."check_sql_bad_users") == 2, "Test avec des instructions SQL contenant des références à des utilisateurs spécifiques");
