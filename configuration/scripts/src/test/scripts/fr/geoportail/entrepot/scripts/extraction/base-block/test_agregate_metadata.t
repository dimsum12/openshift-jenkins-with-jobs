#!/usr/bin/perl
BEGIN {
    push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 5;
use Config::Simple;
use strict;
use warnings;
use Cwd;
use Execute;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path")."conditionnement";
my $tmp_root_path = $config->param("resources.tmp.path");

require "agregate_metadata.pl";

# Préparation de l'envrionnement


my $metadata_folder = $tmp_root_path . "/BDORTHO_007/metadataBDORTHO/";
my $metadata_folder_ko = $tmp_root_path . "/BDORTHO_007_wrong/metadataBDORTHO/";
my @files = `ls $metadata_folder*.xml`;
my $agregated_file = 'my_metadata_agregated.xml';
my $agregated_file_fullpath = $metadata_folder . $agregated_file;


#   * 0 if the agregation is Ok or any metadatas can be found
#   * 1 if mtds folder is not a folder or does not exists
#   * 2 if cannot create XML agregated metadata (bad name, no rights, other error)
#   * 3 if cannot determine extraction type (RATS ? VECT ?)
#   * 4 if min date, max date or edition date could not be defined
#   * 255 if the function is called with an incorrect number of arguments



# Test without parameters
ok(agregate_metadata() == 255, "testWithoutParameters");

# Test with no extraction type well--determined from format
ok(agregate_metadata($metadata_folder, "TIFF", "EPSG:4326", -2, 5, 45, 50, "2011-05-21", $agregated_file, "purchase_id", "product_name") == 3, "testWithNoTypeDetermined");

# Test with no extraction type well--determined from format
ok(agregate_metadata("/unknwnfolder/", "VECT-TIFF", "EPSG:4326", -2, 5, 45, 50, "2011-05-21", $agregated_file, "purchase_id", "product_name") == 1, "testWithWrongFolder");

# Test with unknwon edition date
# Execute->run( "rm -rf " . $metadata_folder_ko, "true" );
# Execute->run( "mkdir -p " . $metadata_folder_ko, "true" );
# local *get_min_max_from_mtd_file = sub { "2010-05-05","2010-05-05","null"};
# Execute->run( "cp -r " . $resources_path . "/BDORTHO_007_wrong/metadataBDORTHO/* "   . $metadata_folder_ko, "true" );
#ok(agregate_metadata($metadata_folder_ko, "VECT-TIFF", "EPSG:4326", -2, 5, 45, 50, "2011-05-21", $agregated_file, "purchase_id", "product_name") == 4, "testWithNoEdItionDate");
# Execute->run( "rm -rf " . $metadata_folder_ko, "true" );

# Test with agregated file name  wrong 
Execute->run( "rm -rf " . $metadata_folder, "true" );
Execute->run( "mkdir -p " . $metadata_folder, "true" );
Execute->run( "cp -r " . $resources_path . "/BDORTHO_007/metadataBDORTHO/* " . $metadata_folder, "true" );
local *get_min_max_from_mtd_file = sub { "2010-05-05","2010-05-05","2010-05-05"};
ok(agregate_metadata($metadata_folder, "VECT-TIFF", "EPSG:4326", -2, 5, 45, 50, "2011-05-21", "test?:/.xml", "purchase_id", "product_name") == 2, "testWithAgregatedFilenameWrong");
Execute->run( "rm -rf " . $metadata_folder_ko, "true" );

# Normal test with vecteur
Execute->run( "rm -rf " . $metadata_folder, "true" );
Execute->run( "mkdir -p " . $metadata_folder, "true" );
Execute->run( "cp -r " . $resources_path . "/BDORTHO_007/metadataBDORTHO/* " . $metadata_folder, "true" );
local *get_min_max_from_mtd_file = sub { "2010-05-05","2010-05-05","2010-05-05"};
ok(agregate_metadata($metadata_folder, "VECT_SHP", "EPSG:4326", -2, 5, 45, 50, "2011-05-21", $agregated_file, "purchase_id", "product_name") eq $agregated_file_fullpath, "testOkCaseVector");
#Execute->run( "rm -rf " . $metadata_folder_ko, "true" );



