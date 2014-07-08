#!/usr/bin/perl

## Loading GPP3 Perl test env. configuration
BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 3;
use Config::Simple;

use strict;
use warnings;
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
## End loading

# Loading script to test
require "create_folder.pl";

# Creating sandbox for test purposes
my $sandbox_path = $config->param("emap.sandbox");
my $good_folder_to_create = $sandbox_path."/essai_create_folder";
my $bad_folder_to_create = "/root/bla";
my $hide_command_output = " >/dev/null 2>/dev/null";

system("mkdir ".$sandbox_path.$hide_command_output);

# Test without arguments
ok( create_folder() == 255, "Test sans paramètres" );

# Test creating new folder into access-forbidden parent folder.
ok( create_folder($bad_folder_to_create) == 254, "Test de création dans un dossier parent non accessible");

# Test of "normal-creation" of new folder.
my $create_folder_result = create_folder($good_folder_to_create);
system("ls ".$good_folder_to_create.$hide_command_output);
my $check_folder_result = $?;
ok( ( $create_folder_result && $check_folder_result ) == 0, "Test de création d'un dossier dans la sandbox" );


# Deleting sandbox for cleaning purposes
system("rm -rf ".$sandbox_path);
