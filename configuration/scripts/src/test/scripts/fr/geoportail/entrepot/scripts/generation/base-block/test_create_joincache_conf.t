#!/usr/bin/perl

#########################################################################################################################
# KEYWORDS
#   $Revision 1 $
#   $Source src/test/scripts/fr/geoportail/entrepot/scripts/generation/high_level/test_create_joincache_conf.t $
#   $Date: 30/05/12 $
#   $Author: Kevin Ferrier (a145972) <kevin.ferrier@atos.net> $
#########################################################################################################################

use strict;
use warnings;

BEGIN {
    push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 6;
use Config::Simple;
use Cwd;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/test/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $tmp_path         = $config->param("resources.tmp.path");
chop $tmp_path;
my $tmp_generation   = $config->param("resources.tmp.generations");
my $config_file_name = $config->param("joincache.specific_conf_filename");
my $root_storage     = $config->param("filer.root.storage");
my $pyramid_dir      = $config->param("joincache.pyramid_dir");
my $tms_dir          = $config->param("joincache.tms_dir");
my $storage_path     = "fake_storage";
my $tmp_dir_name     = $config->param("joincache.tmp_dir_name");
my $scripts_dir_name = $config->param("joincache.scripts_dir_name");
my $resources_path   = $config->param("resources.path");

my $broadcast_product_name = "SCAN100_ROK4_RAW";
my $pyr_path           = $root_storage . $storage_path . "/15/" . $pyramid_dir;
my $tms_path           = $root_storage . $storage_path . "/15/" . $pyramid_dir;
my $tms_name           = "RGR92UTM40S_10cm";
my $image_dir          = $config->param("joincache.image_dir");
my $metadata_dir       = $config->param("joincache.metadata_dir");
my $nodata_dir         = $config->param("joincache.nodata_dir");
my $compression        = "jpg";
my $samplesperpixel    = 3;
my $photometric        = "rgb";
my $bitspersample      = 8;
my $sampleformat       = "uint";
my $merge_method       = "replace";
my @bboxes             = ();
my $tmp_generation_dir = $tmp_path . "/" .  $tmp_generation . "/15/";
my $path_temp          = $tmp_generation_dir . $tmp_dir_name;
my $path_script        = $tmp_generation_dir . $scripts_dir_name;
my $job_number         = $config->param("joincache.job_number");
my @levels             = ();

require "create_joincache_conf.pl";

ok( create_joincache_conf() == 255, "testWithoutParameters" );

my $file_path = $tmp_path . "/" . $tmp_generation . "/15/" . $config_file_name;

ok(
    create_joincache_conf(
        $file_path,              "INFO",
        $broadcast_product_name, $pyr_path,
        $pyr_path,               $tms_path,
        $tms_name,               $image_dir,
        $metadata_dir,           $nodata_dir,
        $compression,            $samplesperpixel,
        $photometric,            $bitspersample,
        $sampleformat,           $merge_method,
        \@bboxes,                $path_script,
        $path_temp,              $job_number,
        \@levels
      ) == 1,
    "testWithoutAccessToOutputFile"
);

`mkdir $tmp_path/$tmp_generation/`;
`mkdir $tmp_path/$tmp_generation/15/`;
ok(
    create_joincache_conf(
        $file_path,              "INFO",
        $broadcast_product_name, $pyr_path,
        $pyr_path,               $tms_path,
        $tms_name,               $image_dir,
        $metadata_dir,           $nodata_dir,
        $compression,            $samplesperpixel,
        $photometric,            $bitspersample,
        $sampleformat,           $merge_method,
        \@bboxes,                $path_script,
        $path_temp,              $job_number,
        \@levels
      ) == 0
      && int(`more $tmp_path/$tmp_generation/15/$config_file_name | wc -l`) == (
        int(`more $resources_path/joincache/joincache_simple.conf | wc -l`) +
          @bboxes +
          @levels
      ),
    "testWithNoBboxesNeitherLevels"
);
`rm -r $tmp_path/$tmp_generation/15/`;

`mkdir $tmp_path/$tmp_generation/15/`;
$bboxes[0] = "WLD = -20037508.3,-20037508.3,20037508.3,20037508.3";
$levels[0] =
"0.WLD = /home/debian/workspace/storage/fake_storage/1002/PYRAMIDS/MONDE12F_V1.pyr";
ok(
    create_joincache_conf(
        $file_path,              "INFO",
        $broadcast_product_name, $pyr_path,
        $pyr_path,               $tms_path,
        $tms_name,               $image_dir,
        $metadata_dir,           $nodata_dir,
        $compression,            $samplesperpixel,
        $photometric,            $bitspersample,
        $sampleformat,           $merge_method,
        \@bboxes,                $path_script,
        $path_temp,              $job_number,
        \@levels
      ) == 0
      && int(`more $tmp_path/$tmp_generation/15/$config_file_name | wc -l`) == (
        int(`more $resources_path/joincache/joincache_simple.conf | wc -l`) +
          @bboxes +
          @levels
      ),
    "testWithOneBboxAndOneLevel"
);
`rm -r $tmp_path/$tmp_generation/15/`;

`mkdir $tmp_path/$tmp_generation/15/`;
$bboxes[1] = "FXX = -518548.8,5107913.5,978393,6614964.6";
$bboxes[2] = "REU = 6140645.1,-2433358.9,6224420.1,-2349936.0";
$bboxes[3] = "GUF = -6137587.6,210200.4,-5667958.5,692618.0";
$levels[1] = "1.WLD = MONDE12F";
$levels[2] = "2.FXX = SCAN25";
$levels[3] = "2.REU = SCAN25";
$levels[4] = "2.GUF = SCANREG";
ok(
    create_joincache_conf(
        $file_path,              "INFO",
        $broadcast_product_name, $pyr_path,
        $pyr_path,               $tms_path,
        $tms_name,               $image_dir,
        $metadata_dir,           $nodata_dir,
        $compression,            $samplesperpixel,
        $photometric,            $bitspersample,
        $sampleformat,           $merge_method,
        \@bboxes,                $path_script,
        $path_temp,              $job_number,
        \@levels
      ) == 0
      && int(`more $tmp_path/$tmp_generation/15/$config_file_name | wc -l`) == (
        int(`more $resources_path/joincache/joincache_simple.conf | wc -l`) +
          @bboxes +
          @levels
      ),
    "testWithBboxesAndLevelsWithoutSpace"
);
`rm -r $tmp_path/$tmp_generation/15/`;

`mkdir $tmp_path/$tmp_generation/15/`;
$levels[1] = "";
$levels[2] = "1.WLD = MONDE12F";
$levels[3] = "";
$levels[4] = "2.FXX = SCAN25";
$levels[5] = "2.REU = SCAN25";
$levels[6] = "2.GUF = SCANREG";
ok(
    create_joincache_conf(
        $file_path,              "INFO",
        $broadcast_product_name, $pyr_path,
        $pyr_path,               $tms_path,
        $tms_name,               $image_dir,
        $metadata_dir,           $nodata_dir,
        $compression,            $samplesperpixel,
        $photometric,            $bitspersample,
        $sampleformat,           $merge_method,
        \@bboxes,                $path_script,
        $path_temp,              $job_number,
        \@levels
      ) == 0
      && int(`more $tmp_path/$tmp_generation/15/$config_file_name | wc -l`) == (
        int(`more $resources_path/joincache/joincache_simple.conf | wc -l`) +
          @bboxes +
          @levels
      ),
    "testWithBboxesAndLevelsWithSpaces"
);
`rm -r $tmp_path/$tmp_generation/`;