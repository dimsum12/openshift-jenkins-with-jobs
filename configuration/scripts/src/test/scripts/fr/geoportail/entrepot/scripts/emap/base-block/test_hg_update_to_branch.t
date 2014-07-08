#!/usr/bin/perl

## Loading GPP3 Perl test env. configuration
BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 7;
use Config::Simple;

use strict;
use warnings;
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
## End loading

# Loading script to test
require "hg_update_to_branch.pl";

# Getting env test params.
my $sandbox_path = $config->param("emap.sandbox");
system "mkdir -p ".$sandbox_path;
my $hide_command_output = " >/dev/null 2>/dev/null";
my $original_wksp = $sandbox_path."/original_wksp";
my $valid_wksp = $sandbox_path."/valid_wksp";
my $folder_no_wksp = $sandbox_path."/just_a_folder";
my $no_folder_nor_wksp = $sandbox_path."/folder_which_not_exists";
my $no_existing_branch = "azertyuiop";
my $url_of_working_repo = $config->param("emap.hg_repo_url");
my $existing_branch = $config->param("emap.hg_branch");
# Getting a valid repo
my $working_repo_prefix = $config->param("emap.hg_working_repo_prefix");
my $working_repo_user = $config->param("emap.hg_working_repo_user");
my $working_repo_password = $config->param("emap.hg_working_repo_password");
my $hg_config = "\n[auth]\ngpp3forge.prefix = ".$working_repo_prefix."\ngpp3forge.username = ".$working_repo_user."\ngpp3forge.password = ".$working_repo_password;
my $exists_user_hg_config = 0;
if ( system("test -f \$HOME/.hgrc") == 0) {
    $exists_user_hg_config = 1;
    system("cp \$HOME/.hgrc \$HOME/hgrc_bak");
}
system("echo \"$hg_config\" >> \$HOME/.hgrc");
if( system("hg -y clone ".$url_of_working_repo." ".$original_wksp) != 0) {
    return 1;
}

## Tests
system("cp -r ".$original_wksp." ".$valid_wksp.$hide_command_output);
ok( hg_update_to_branch() == 251, "Test avec aucun argument");
ok( hg_update_to_branch($valid_wksp) == 251, "Test avec un seul argument");
system("rm -rf ".$valid_wksp.$hide_command_output);

## Tests
system("rm -rf ".$no_folder_nor_wksp.$hide_command_output);
ok( hg_update_to_branch($no_folder_nor_wksp,$existing_branch) == 252, "Test un workspace inexistant sur le système de fichiers");

## Tests
system("mkdir -p ".$folder_no_wksp.$hide_command_output);
system("rm -rf ".$folder_no_wksp."/*".$hide_command_output);
ok( hg_update_to_branch($folder_no_wksp,$existing_branch) == 253, "Test un dossier vide qui n'est pas un workspace valide");
system("rm -rf ".$folder_no_wksp.$hide_command_output);

## Tests
system("cp -r ".$original_wksp." ".$valid_wksp.$hide_command_output);
ok( hg_update_to_branch($valid_wksp,$no_existing_branch) == 254, "Test avec une branche inexistante");
system("rm -rf ".$valid_wksp.$hide_command_output);

## Tests
system("cp -r ".$original_wksp." ".$valid_wksp.$hide_command_output);
my $hg_well_updated = hg_update_to_branch($valid_wksp,$existing_branch);
my $hg_current_branch = `cd $valid_wksp && hg branch 2>&1`;
$hg_current_branch =~ s/\r|\n//g;
ok( $hg_well_updated == 0 && $hg_current_branch eq $existing_branch, "Test avec une branche existante - cas normal");
system("rm -rf ".$valid_wksp.$hide_command_output);

## Tests
system("cp -r ".$original_wksp." ".$valid_wksp.$hide_command_output);
system("chmod -R 500 ".$valid_wksp.$hide_command_output);
ok( hg_update_to_branch($valid_wksp,$existing_branch) == 255, "Test avec une branche existante mais un workspace bloqué en écriture.");
system("chmod -R 777 ".$valid_wksp.$hide_command_output);
system("rm -rf ".$valid_wksp.$hide_command_output);


# Unsetting the hgrc params
if( $exists_user_hg_config == 1) {
    system("mv \$HOME/hgrc_bak \$HOME/.hgrc");
} else {
    system("rm -f \$HOME/.hgrc");
}
system("rm -rf ".$sandbox_path.$hide_command_output);
