#!/usr/bin/perl

## Loading GPP3 Perl test env. configuration
BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 6;
use Config::Simple;

use strict;
use warnings;
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
## End loading

# Loading script to test
require "compress_folder.pl";

# Creating sandbox for test purposes
my $sandbox_path = $config->param("emap.sandbox");
my $hide_command_output = " >/dev/null 2>/dev/null";
my $current_working_dir = `pwd`;

system("mkdir -p ".$sandbox_path."/folder_to_compress".$hide_command_output);
system("echo AAA > ".$sandbox_path."/folder_to_compress/aaa");
system("echo BBB > ".$sandbox_path."/folder_to_compress/bbb");
system("mkdir -p ".$sandbox_path."/folder_to_compress/some_folder".$hide_command_output);
system("echo CCC > ".$sandbox_path."/folder_to_compress/some_folder/ccc");


## Testing with not enough or too much arguments
ok(compress_folder() == 255, "Test sans paramètres");
ok(compress_folder($sandbox_path."/folder_to_compress") == 255, "Test avec un seul paramètre"); 

## Testing normal functionnality
my $result_normal_compress = compress_folder($sandbox_path."/folder_to_compress",$sandbox_path."/archive.tgz");
my $compressed_content = `tar tzf $sandbox_path/archive.tgz 2>&1`;
my $check_archive_exists = $?;
my $original_content = `cd $sandbox_path/folder_to_compress && find . && cd $current_working_dir`;
my $check_archive_content = 1;
if (chomp($compressed_content) eq chomp($original_content)){
    $check_archive_content = 0;
}

print "--".$check_archive_content."==".$check_archive_exists."--\n";

ok( $result_normal_compress == 0 && $check_archive_exists == 0 && $check_archive_content == 0, "Test de compression normale");

## Testing different errors
ok( compress_folder("/root",$sandbox_path."/root.tgz") == 254, "Test de compression d'un dossier non accessible en lecture");
ok( compress_folder($sandbox_path."/folder_to_compress","/root/archive.tgz") == 254, "Test de compression dans un dossier non accessible en écriture");
ok( compress_folder( "/tmp/non_existing_folder",$sandbox_path."/non_existing_folder.tgz") == 254, "Test avec un dossier non existant");


# Deleting sandbox for cleaning purposes
system("rm -rf ".$sandbox_path);
