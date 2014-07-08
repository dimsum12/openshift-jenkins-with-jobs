#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 3;
use Config::Simple;

use strict;
use warnings;
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
my $tmp_path = $config->param("resources.tmp.path");

require "delete_data.pl";

# create destination directories used for tests
`mkdir -p $tmp_path/test_copy_data/destination_folder_ok`;

ok( delete_data() == 255, "Test sans paramètre" );
ok( delete_data($tmp_path."test_copy_data/destination_folder_ok") == 0, "Test rollback valide" );
ok( delete_data($tmp_path."test_copy_data/destination_folder_not_exist") == 1, "Test repertoire destination n'existe pas" );

# delete destination directories used for tests
`rm -rf $tmp_path/test_copy_data`;
