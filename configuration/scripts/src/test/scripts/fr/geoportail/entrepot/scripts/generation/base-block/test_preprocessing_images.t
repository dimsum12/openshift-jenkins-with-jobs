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

my $config_path = cwd() . "/src/test/config/local";
our $config = new Config::Simple( $config_path . "/config_perl.ini" )
  or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
my $tmp_path = $config->param("resources.tmp.path");

require "preprocessing_images.pl";


ok( preprocessing_images() == 255, "Test sans paramètre" );


ok( preprocessing_images($resources_path . "convert_georaster_ok_nb", $tmp_path . "out", "tiff2gray") == 0, "Test correct en tiff2gray");
`rm -rf $tmp_path"out"`;


ok( preprocessing_images($resources_path . "convert_georaster_ok_pal", $tmp_path . "out", "pal2rgb") == 0, "Test correct en pal2rgb");
`rm -rf $tmp_path"out"`;


ok( preprocessing_images($resources_path . "convert_georaster_ok_png", $tmp_path . "out", "png2tiff") == 0, "Test correct en png2tiff");
`rm -rf $tmp_path"out"`;


`cp -r $resources_path"convert_georaster_ok_nb" $tmp_path`;
ok( preprocessing_images($tmp_path . "convert_georaster_ok_nb", $tmp_path . "out", "tiff2gray", "false") == 0, "Test correct avec suppression de la source");
`rm -rf $tmp_path"convert_georaster_ok_nb"`;
`rm -rf $tmp_path"out"`;


ok( preprocessing_images($resources_path . "don_t_exist", $tmp_path . "out", "tiff2gray") == 1, "Test avec un repertoire source inexistant");


ok( preprocessing_images($resources_path . "check_md5_ok", $tmp_path . "out", "tiff2gray") == 2, "Test avec un repertoire source sans image");


ok( preprocessing_images($resources_path . "convert_georaster_ok_nb", "/don_t_exist", "tiff2gray") == 3, "Test avec un repertoire cible inexistant");


ok( preprocessing_images($resources_path . "convert_georaster_ok_nb", $tmp_path . "out", "tiff2rgb") == 4, "Test avec une processus non supporté");


my $mock = Test::MockObject->new();
$mock->fake_module(
        'Execute',
        get_return => sub { return 1; }
);
ok( preprocessing_images($resources_path . "convert_georaster_ok_nb", $tmp_path . "out", "tiff2gray") == 5, "Test avec une erreur lors du traitement");


`rm -rf $tmp_path"out"`;
