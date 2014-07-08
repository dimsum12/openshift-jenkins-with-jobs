#!/usr/bin/perl

BEGIN {
    push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests =>3;
use Config::Simple;
use strict;
use warnings;
use Cwd;
use Execute;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path=$config->param("resources.path");


require "create_outlines.pl";




my @polygons = ();
push @polygons, "2,48 2,49 3,49 3,48 2,48";
push @polygons, "2,49 1,50 2,51 3,51 4,50 3,49 2,49";

my @polygon_names = ();
push @polygon_names, "Polygon1";
push @polygon_names, "Polygon2";


ok(create_outlines() == 255, "testWithoutParameters");


ok(create_outlines(\@polygons, \@polygon_names, "/tmp/polygon_file_test", "gml", "EPSG:4326") == 0, "testOkInsertPoints");
Execute->run( "rm /tmp/polygon_file_test.gml", "true" );


ok(create_outlines(\@polygons, \@polygon_names, "/tmp/polygon_file", "shp", "EPSG:4326") == 0, "testOkPolygoneSHP");
`cp /tmp/polygon_file* /media/sf_vboxshare/`; 
Execute->run( "rm /tmp/polygon_file.* ", "true" );












