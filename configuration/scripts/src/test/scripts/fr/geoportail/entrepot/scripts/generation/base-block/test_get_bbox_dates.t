#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 10;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
use Cwd;

use Database;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new("test_get_bbox_dates.pl", $logger_levels);

my $resources_path = $config->param("resources.path");


require "get_bbox_dates.pl";




my $min ;
my $max;


($min, $max ) = get_bbox_dates($resources_path."generation_test_get_min_max_from_mtd_file" );
ok( $min eq "1980-08-20" , "Test avec extent");
ok( $max eq "1980-09-02" , "Test avec extent");


($min, $max ) =  get_bbox_dates($resources_path."generation_test_get_min_max_from_mtd_file2/" );
ok( $min eq "2011-10-01" , "Test avec edition dat ");
ok( $max eq "2011-10-01" , "Test avec edition dat ");


my ($sec,$minute,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
$year += 1900;
$mon++;
if($mon<10){
	$mon = "0" . $mon;
}
if($mday<10){
	$mday = "0" . $mday;
}

my $today = $year . "-" . $mon . "-" . $mday ;

($min, $max ) = get_bbox_dates($resources_path."generation_test_get_min_max_from_mtd_file3/" );
ok( $min eq $today , "Test avec aucun champs");
ok( $max eq  $today , "Test avec aucun champs");

($min, $max ) = get_bbox_dates($resources_path."unknow_folder" );
ok( $min eq $today , "Test avec unknown folder");
ok( $max eq  $today , "Test avec unknown folder");

($min, $max ) = get_bbox_dates();
ok( $min eq $today , "Test sans champs");
ok( $max eq  $today , "Test sans champs");















