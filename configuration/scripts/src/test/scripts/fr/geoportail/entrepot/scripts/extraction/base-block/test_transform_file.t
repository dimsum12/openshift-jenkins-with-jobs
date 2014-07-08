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


require("transform_file.pl");


ok(transform_file()==255,"testWithoutParameters");

ok(transform_file('/tmp/unknown','kml','shp',1)==1,"testWithUnknownFile");

#copie du fichier test.tif sous /tmp
my $tmp_resource_folder="/tmp/";
my $resource_file_shp=$resources_path.'conditionnement/test.shp';
my $resource_file_shx=$resources_path.'conditionnement/test.shx';
my $resource_file_dbf=$resources_path.'conditionnement/test.dbf';

my $cmd_copy="cp $resource_file_shp $tmp_resource_folder";
Execute->run( "$cmd_copy", "true" ); 
$cmd_copy="cp $resource_file_shx $tmp_resource_folder";
Execute->run( "$cmd_copy", "true" ); 
$cmd_copy="cp $resource_file_dbf $tmp_resource_folder";
Execute->run( "$cmd_copy", "true" ); 
ok(transform_file('/tmp/test','shp','gml',1)==0,"testOkVectorise");

Execute->run( "rm /tmp/test.*", "true" ); 





