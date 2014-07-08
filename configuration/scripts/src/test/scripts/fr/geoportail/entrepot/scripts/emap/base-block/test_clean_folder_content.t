#!/usr/bin/perl

## Loading GPP3 Perl test env. configuration
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
my $resources_path = $config->param("resources.path");
## End loading

# Loading script to test
require "clean_folder_content.pl";

# Creating sandbox for test purposes
my $sandbox_path = $config->param("emap.sandbox");
my $hide_command_output = " >/dev/null 2>/dev/null";

system("mkdir -p ".$sandbox_path."/folder_to_delete_content_from".$hide_command_output);
system("echo AAA > ".$sandbox_path."/folder_to_delete_content_from/aaa");
system("echo BBB > ".$sandbox_path."/folder_to_delete_content_from/bbb");

# Test without arguments
ok( clean_folder_content() == 255, "Test sans paramètres" );
ok( clean_folder_content($sandbox_path."/folder_to_delete_content_from","/tmp") == 255, "Test avec deux arguments");

# Test cleaning an access-forbidden folder
ok( clean_folder_content("/root") == 254, "Test de nettoyage dans un dossier parent non accessible");

# Test of "normal-cleaning".
my $clean_folder_content_result = clean_folder_content($sandbox_path."/folder_to_delete_content_from");
my $number_of_elements = `ls $sandbox_path/folder_to_delete_content_from | wc -l`;

ok( ( $clean_folder_content_result && $number_of_elements ) == 0, "Test de nettoyage d'un dossier dans la sandbox" );


# Deleting sandbox for cleaning purposes
system("rm -rf ".$sandbox_path);
