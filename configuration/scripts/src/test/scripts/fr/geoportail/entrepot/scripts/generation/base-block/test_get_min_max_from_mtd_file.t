#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 13;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
use Cwd;

use Database;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new("test_get_min_max_from_mtd_file.pl", $logger_levels);

my $resources_path = $config->param("resources.path");


require "get_min_max_from_mtd_file.pl";


ok( get_min_max_from_mtd_file() == 255, "Test sans paramètre" );

my $min ;
my $max;
my $edition;








($min, $max , $edition) = get_min_max_from_mtd_file($resources_path."generation_test_get_min_max_from_mtd_file/metadatanotknown.xml" );
ok( $min eq "null" , "Test mtd file inexistante");
ok( $max eq "null" , "Test mtd file inexistante");
ok( $edition eq "null" , "Test mtd file inexistante");


($min, $max , $edition) =  get_min_max_from_mtd_file($resources_path."generation_test_get_min_max_from_mtd_file/metadata1.xml" );
ok( $min eq "1980-08-20" , "Test avec temporal extent ");
ok( $max eq "1980-09-02" , "Test avec temporal extent ");
ok( $edition eq "null" , "Test avec temporal extent ");


($min, $max, $edition ) = get_min_max_from_mtd_file($resources_path."generation_test_get_min_max_from_mtd_file/metadata_with_only_edition.xml" );
ok( $min eq "null" , "Test avec edition date");
ok( $max eq  "null" , "Test avec edition date");
ok( $edition eq  "2011-10-01" , "Test avec edition date");

($min, $max , $edition) = get_min_max_from_mtd_file($resources_path."generation_test_get_min_max_from_mtd_file/metadata_with_nothing.xml" );
ok( $min eq "null" , "Test avec aucun champs");
ok( $max eq  "null" , "Test avec aucun champs");
ok( $edition eq  "null" , "Test avec aucun champs");















