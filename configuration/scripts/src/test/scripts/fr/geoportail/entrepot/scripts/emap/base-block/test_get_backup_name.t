#!/usr/bin/perl

## Loading GPP3 Perl test env. configuration
BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 8;
use Config::Simple;

use strict;
use warnings;
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
## End loading

# Loading script to test
require "get_backup_name.pl";

## Testing with not enough or too much arguments
ok(get_backup_name() == 255, "Test sans paramètres");
ok(get_backup_name("tmp","bdd") == 255, "Test avec trop de paramètres");

## Testing with not known backup type
ok(get_backup_name("bla") == 254, "Test avec un type de sauvegarde chaîne de texte inconnu");
ok(get_backup_name(5) == 254, "Test avec un type de sauvegarde entier inconnu");

## Testing all normal cases with all backup types
my $backupname_result = "";
my $retour_commande = -1;

$backupname_result = get_backup_name("tmp");
$retour_commande = $?;
ok( $retour_commande == 0 && length($backupname_result) == 18 && substr($backupname_result, 0, 3) eq "tmp" && substr($backupname_result, 12, 1) eq "_", "Test d'un nom de backup de tmp");
$backupname_result = get_backup_name("bdd");
$retour_commande = $?;
ok(  $retour_commande == 0 && length($backupname_result) == 18 && substr($backupname_result, 0, 3) eq "bdd" && substr($backupname_result, 12, 1) eq "_", "Test d'un nom de backup de bdd");
$backupname_result = get_backup_name("chain");
$retour_commande = $?;
ok(  $retour_commande == 0 && length($backupname_result) == 20 && substr($backupname_result, 0, 5) eq "chain" && substr($backupname_result, 14, 1) eq "_", "Test d'un nom de backup de chaine");
$backupname_result = get_backup_name("catalog");
$retour_commande = $?;
ok(  $retour_commande == 0 && length($backupname_result) == 22 && substr($backupname_result, 0, 7) eq "catalog" && substr($backupname_result, 16, 1) eq "_", "Test d'un nom de backup de chaine");
