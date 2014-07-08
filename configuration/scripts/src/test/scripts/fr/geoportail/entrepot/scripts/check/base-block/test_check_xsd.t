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

my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");

require "check_xsd.pl";
system('cp -r '.$resources_path.'"xsd" /tmp/xsd'); 
ok( check_xsd($resources_path."check_xsd_ok") == 0, "Test avec des XML valides " );
ok( check_xsd($resources_path."check_xsd_nok_bad_xml") == 1, "Test avec un fichier XML en erreur." );
ok( check_xsd($resources_path."dir_not_exist") == 2, "Test avec un répertoire de métadonnées qui n'existe pas" );
ok( check_xsd() == 255 , "Test sans paramètres" );
system('rm -rf /tmp/xsd'); 