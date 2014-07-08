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
require "hg_clone_chain.pl";

# Getting env test params.
my $sandbox_path = $config->param("emap.sandbox");
my $hide_command_output = " >/dev/null 2>/dev/null";
my $url_of_working_repo = $config->param("emap.hg_repo_url");
my $url_of_inexistent_repo = $config->param("emap.hg_url_of_inexistent_repo");

my $working_repo_prefix = $config->param("emap.hg_working_repo_prefix");
my $working_repo_user = $config->param("emap.hg_working_repo_user");
my $working_repo_password = $config->param("emap.hg_working_repo_password");
my $hg_config = "\n[auth]\ngpp3forge.prefix = ".$working_repo_prefix."\ngpp3forge.username = ".$working_repo_user."\ngpp3forge.password = ".$working_repo_password;

# Testing with bad number of parameters
ok( hg_clone_chain() == 252, "Test de hg_clone_chain avec aucun paramètres");
ok( hg_clone_chain($url_of_working_repo) == 252, "Test de hg_clone_chain avec seulement 1 paramètre");

# Testing with normal behaviour and no existing folder
system("mkdir -p ".$sandbox_path." ".$hide_command_output);
system("rm -rf ".$sandbox_path."/entrepot_scripts ".$hide_command_output);
ok( hg_clone_chain($url_of_working_repo , $sandbox_path."/entrepot_scripts") == 253, "Test de hg_clone_chain avec un dossier de destination inexistant");
system("rm -rf ".$sandbox_path." ".$hide_command_output);

# Testing with non empty folder into destination
system("mkdir -p ".$sandbox_path."/entrepot_scripts");
system("mkdir -p ".$sandbox_path."/entrepot_scripts/test_folder");
system("echo aaa > ".$sandbox_path."/entrepot_scripts/AAA.txt");
system("echo bbb > ".$sandbox_path."/entrepot_scripts/test_folder/BBB.txt");
ok( hg_clone_chain($url_of_working_repo , $sandbox_path) == 254, "Test de hg_clone_chain avec un dossier de destination non vide");
system("rm -rf ".$sandbox_path." ".$hide_command_output);

# Testing with normal behaviour and existing-but empty-folder
system("mkdir -p ".$sandbox_path."/entrepot_scripts");
my $exists_user_hg_config = 0;
if ( system("test -f \$HOME/.hgrc") == 0) {
    $exists_user_hg_config = 1;
    system("cp \$HOME/.hgrc \$HOME/hgrc_bak");
}
system("echo \"$hg_config\" >> \$HOME/.hgrc");
my $result_hg_clone_to_empty = hg_clone_chain($url_of_working_repo , $sandbox_path."/entrepot_scripts");
my $file_count_into_repo_to_empty = `find $sandbox_path/entrepot_scripts -type f | wc -l`;
ok( ($result_hg_clone_to_empty == 0) && ($file_count_into_repo_to_empty > 2) , "Test de hg_clone_chain avec un dossier existant mais vide -cas normal-.");
if( $exists_user_hg_config == 1) {
    system("mv \$HOME/hgrc_bak \$HOME/.hgrc");
} else {
    system("rm -f \$HOME/.hgrc");
}
system("rm -rf ".$sandbox_path." ".$hide_command_output);


# Testing with a non existing repo (near to non accessible)
system("mkdir -p ".$sandbox_path);
ok( hg_clone_chain($url_of_inexistent_repo , $sandbox_path) == 255, "Test de hg_clone_chain avec une URL de dépôt inexistant");
system("rm -rf ".$sandbox_path." ".$hide_command_output);
