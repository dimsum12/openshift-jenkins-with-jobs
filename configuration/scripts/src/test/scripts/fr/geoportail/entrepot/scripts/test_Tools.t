#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 6;
use Tools;
use Logger;

use strict;
use warnings;
use Cwd;
use Config::Simple;

my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");

ok (Tools->is_numeric() == 0, "Test sans parametres");

ok (Tools->is_numeric("a") == 0, "Test avec une chaine de caracteres");

ok (Tools->is_numeric("a1") == 0, "Test avec une chaine alphanumerique");

ok (Tools->is_numeric(1) == 1, "Test avec un numerique");

ok (Tools->is_numeric(1.1) == 1, "Test avec un decimal avec un point");

ok (Tools->is_numeric("1,1") == 1, "Test avec un decimal avec une virgule");
