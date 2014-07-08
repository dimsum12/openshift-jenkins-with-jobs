#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 5;
use Config::Simple;

use strict;
use warnings;
use Cwd;

my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");

require "check_uncompress.pl";
system('cp -r '.$resources_path.'"check_uncompress_ok" /tmp/'); 
ok( check_uncompress($resources_path."check_uncompress_ok") == 0, "Test avec des archives valides" );
system('rm -rf '.$resources_path.'"check_uncompress_ok"/*');
system('cp -r /tmp/check_uncompress_ok/* '.$resources_path.'"check_uncompress_ok"/');

system('cp -r '.$resources_path.'"check_uncompress_nok" /tmp/'); 
ok( check_uncompress($resources_path."check_uncompress_nok") == 1, "Test avec une erreur de décompression" );
system('rm -rf '.$resources_path.'"check_uncompress_nok"/*');
system('cp -r /tmp/check_uncompress_nok/* '.$resources_path.'"check_uncompress_nok"/');

system('cp -r '.$resources_path.'"check_uncompress_bad_type" /tmp/');
ok( check_uncompress($resources_path."check_uncompress_bad_type") == 2, "Test avec un type inconnu" );
system('rm -rf '.$resources_path.'"check_uncompress_bad_type"/*');
system('cp -r /tmp/check_uncompress_bad_type/* '.$resources_path.'"check_uncompress_bad_type"/');

ok( check_uncompress("/rep/not/exist") == 3, "Test avec un répertoire qui n'existe pas");

ok( check_uncompress() == 255, "Test sans paramètre" );