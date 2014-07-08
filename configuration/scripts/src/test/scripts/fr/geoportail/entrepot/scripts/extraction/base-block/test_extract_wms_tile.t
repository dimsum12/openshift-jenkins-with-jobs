#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();
use Execute;
use Test::Simple tests => 6;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $tmp_path = $config->param("resources.tmp.path");
my $resources_path = $config->param("resources.path");

require ("extract_wms_tile.pl");


ok( extract_wms_tile() == 255, "testWithoutParameters"); 


ok( extract_wms_tile("/tmp/testExtractWmsTileOk.tif", "0", "0", "1", "1", "500", "500", "WMS", "key", "MYLAYER","tiff","EPSG:4326","normal","geoportail","2","1") == 2, "testExtractWmsTileBadService"); 


ok( extract_wms_tile("/tmp/testExtractWmsTileOk.tif", "0", "0", "1", "1", "500", "500", "WMSRASTER", "key", "MYLAYER","tiff","EPSG:4326","normal","geoportail","2","1") == 3, "testExtractWmsTileErrorService"); 


{
	my $mock         = Test::MockObject->new();
    $mock->fake_module(
        'HTTP::Response',
        is_success      => sub { return 1; },
        content 		=> sub { return "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"; }
    );
	
	ok( extract_wms_tile("/", "0", "0", "1", "1", "500", "500", "WMSVECTOR", "key", "MYLAYER","tiff","EPSG:4326","normal","geoportail","2","1") == 4, "testExtractWmsTileErrorWriting"); 

	ok( extract_wms_tile("/tmp/testExtractWmsTileOk.tif", "0", "0", "1", "1", "500", "500", "WMSVECTOR", "key", "MYLAYER","tiff","EPSG:4326","normal","geoportail","2","1","NONE","FFFFFF","35") == 5, "testExtractWmsTileBadImage"); 

	ok( extract_wms_tile("/tmp/testExtractWmsTileOk.tif", "0", "0", "1", "1", "500", "500", "WMSVECTOR", "key", "MYLAYER","tiff","EPSG:4326","normal","geoportail","2","1","NONE","FFFFFF","30") == 0, "testExtractWmsTileEmptyImage"); 
	
	Execute->run("rm -f /tmp/testExtractWmsTileOk.tif");
}