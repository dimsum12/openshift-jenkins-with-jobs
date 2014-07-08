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

my $config_path = cwd() . "/src/test/config/local";
our $config = new Config::Simple( $config_path . "/config_perl.ini" )
  or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
my $tmp_path = $config->param("resources.tmp.path");

require "copy_data.pl";

# create destination directories used for tests
`mkdir -p $tmp_path/test_copy_data/destination_folder_ok`;
`mkdir -p $tmp_path/test_copy_data/destination_folder_not_empty`;
`touch $tmp_path/test_copy_data/destination_folder_not_empty/test`;

ok( copy_data() == 255, "Test sans paramètre" );
ok(
    copy_data(
        $resources_path . "test_copy_data/source_folder",
        $tmp_path . "test_copy_data/destination_folder_ok"
      ) == 0,
    "Test de copie valide"
);
system(
    'rm -rf ' . $tmp_path . '"test_copy_data/destination_folder_ok"/*' );
ok(
    copy_data(
        $resources_path . "test_copy_data/source_folder_not_exist",
        $tmp_path . "test_copy_data/destination_folder_ok"
      ) == 1,
    "Test repertoire source n'existe pas"
);
ok(
    copy_data( $resources_path . "test_copy_data/source_folder",
        "/nexistepas" ) == 2,
    "Test repertoire destination n'existe pas"
);

# delete destination directories used for tests
`rm -rf $tmp_path/test_copy_data`;
