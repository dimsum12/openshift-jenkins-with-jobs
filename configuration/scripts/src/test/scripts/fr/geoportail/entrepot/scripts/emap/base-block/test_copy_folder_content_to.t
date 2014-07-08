#!/usr/bin/perl

## Loading GPP3 Perl test env. configuration
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


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
## End loading

# Loading script to test
require "copy_folder_content_to.pl";

# Creating sandbox for test purposes
my $sandbox_path = $config->param("emap.sandbox");
my $hide_command_output = " >/dev/null 2>/dev/null";

system("mkdir -p ".$sandbox_path."/source_folder".$hide_command_output);
system("echo AAA > ".$sandbox_path."/source_folder/aaa");
system("echo BBB > ".$sandbox_path."/source_folder/bbb");
system("mkdir -p ".$sandbox_path."/destination_folder".$hide_command_output);

# Test with bad number of arguments provided
ok( copy_folder_content_to() == 255, "Test sans paramètres" );
ok( copy_folder_content_to("/tmp") == 255, "Test avec un seul paramètre" );

# Test with normal copy
my $copy_result = copy_folder_content_to($sandbox_path."/source_folder",$sandbox_path."/destination_folder");
my $count_source_content = `ls $sandbox_path/source_folder | wc -l`;
my $count_destination_content = `ls $sandbox_path/destination_folder | wc -l`;
ok( $copy_result == 0 && ($count_source_content == $count_destination_content) , "Test de copie normale et fonctionnelle" );

# Test with access-forbidden folder (read for source, write for destination)
my $read_forbidden_folder = $sandbox_path."/forbidden_read_folder";
system("mkdir -p ".$read_forbidden_folder);
system("chmod 000 ".$read_forbidden_folder);
ok( copy_folder_content_to($read_forbidden_folder,$sandbox_path."/destination_folder") == 254, "Test de copie depuis un emplacement non autorisé en lecture" );
ok( copy_folder_content_to($sandbox_path."/source_folder","/root") == 254, "Test de copie vers un emplacement non autorisé en écriture" );
system("chmod 777 ".$read_forbidden_folder);

# Deleting sandbox for cleaning purposes
system("rm -rf ".$sandbox_path);
