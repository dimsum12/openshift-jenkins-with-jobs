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


require "check_md5.pl";


ok( check_md5() == 255, "Test sans paramètre" );
ok( check_md5($resources_path."check_md5_ok") == 255, "Test avec un seul paramètre" );
ok( check_md5($resources_path."check_md5_ok", $resources_path."delivery_no_exist") == 3, "Test avec un repertoire de base inexistant" );
ok( check_md5($resources_path."check_md5_ok", $resources_path."delivery_ok") == 0, "Test avec un md5 et une livraison valide" );
ok( check_md5($resources_path."check_md5_ok_incomplet", $resources_path."delivery_ok") == 1, "Test avec un md5 valide mais incomplet" );
ok( check_md5($resources_path."check_md5_ok_delivery_nok", $resources_path."check_md5_ok_delivery_nok") == 2, "Test avec un md5 valide et une livraison invalide" );
ok( check_md5($resources_path."check_md5_nok", $resources_path."delivery_ok") == 2, "Test avec un md5 invalide et une livraison valide" );

