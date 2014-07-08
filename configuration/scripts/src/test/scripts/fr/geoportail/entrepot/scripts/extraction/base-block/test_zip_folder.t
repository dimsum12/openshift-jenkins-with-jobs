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


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $tmp_path = $config->param("resources.tmp.path");
my $resources_path = $config->param("resources.path");

require ("zip_folder.pl");


ok( zip_folder() == 255, "testWithoutParameters"); 


ok( zip_folder('/abcdefgh',50,1,"archive",'/tmp/') == 253, "testWithInexistingInputFolder");


ok( zip_folder($resources_path . '/conditionnement/okdirectory', 0, 1, $tmp_path, "archive") == 252, "testWithNullSize"); 
 

my $output_folder = $tmp_path . "conditionned_folder";
my $cmd_create_output_folder = `mkdir -p $output_folder 2>&1`;
	
ok( zip_folder($resources_path . '/conditionnement/okdirectory', 50, 1, $tmp_path, "archive") == 0, "testokZip");

system('rm -f ' . $tmp_path . "archive*");	
