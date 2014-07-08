#!/usr/bin/perl

BEGIN {
    push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 8;
use Config::Simple;

use strict;
use warnings;
use Cwd;

my $config_path = cwd() . "/src/test/config/local";
our $config = new Config::Simple( $config_path . "/config_perl.ini" )
  or die Config::Simple->error();
my $resources_path = $config->param("resources.path");

require "bbox_from_images.pl";


ok( bbox_from_images() == 255, "Test sans paramètre" );
ok( bbox_from_images($resources_path . "don_t_exist", "EPSG:4326") == 1, "Test avec un repertoire source inexistant");
ok( bbox_from_images($resources_path . "check_sql_ok", "EPSG:4326") == 2, "Test avec un repertoire source sans image");
ok( bbox_from_images($resources_path . "check_georaster_ok", "EPSG:43264326") == 3, "Test avec un SRID incorrect");
ok( bbox_from_images($resources_path . "check_georaster_nok", "EPSG:4326") == 4, "Test avec une erreur lors de l'execution de gdalinfo");
ok( bbox_from_images($resources_path . "check_georaster_ok", "IGNF:LAMB933") == 3, "Test avec une projection IGNF inconnue");
ok( bbox_from_images($resources_path . "check_georaster_ok", "EPSG:4326") eq "SRID=4326;POLYGON((535000.000 6389500.000,536500.000 6389500.000,536500.000 6391000.000,535000.000 6391000.000,535000.000 6389500.000))", "Test avec un calcul OK");
ok( bbox_from_images($resources_path . "check_georaster_ok", "IGNF:LAMB93") eq "SRID=310024140;POLYGON((535000.000 6389500.000,536500.000 6389500.000,536500.000 6391000.000,535000.000 6391000.000,535000.000 6389500.000))", "Test avec un calcul OK et conversion SRID IGNF");
