#!/usr/bin/perl

## Loading GPP3 Perl test env. configuration
BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 5;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
## End loading

require "clean_db.pl";

my $backup_path = $config->param("emap.backuppath");

my $dbname = $config->param("db-emap.dbname");
my $host = $config->param("db-emap.host");
my $port =  $config->param("db-emap.port");
my $username = $config->param("db-emap.username");
my $password = $config->param("db-emap.password");

my $mock;
my $result_cleand_db;
my $last_backup;
my $taille_backup;

## Test de prototypage
system "rm -rf ".$backup_path." && mkdir -p ".$backup_path;
ok( clean_db("Foo") == 4 , "testWithParameters");

## Test avec un dossier de backup non accessible en écriture
system "rm -rf ".$backup_path." && mkdir -p ".$backup_path;
system "chmod 500 ".$backup_path;
ok( clean_db() == 1 , "testWithNoBackup");
system "chmod 700 ".$backup_path;

## Test sur une BDD qui n'a aucun schéma utilisateur autre que public
$mock = Test::MockObject->new();
$mock->fake_module(
        'Database',
        disconnect => sub { return 0; },
        start_transaction => sub { return 0; },
        stop_transaction => sub { return 0; },
        rollback_transaction => sub { return 0; },
        exec_pg_dump => sub { return 0; },
        get_user_defined_schemas => sub { return []; },
);
system "rm -rf ".$backup_path." && mkdir -p ".$backup_path;
$result_cleand_db = clean_db();
$last_backup = `ls -t $backup_path | grep bdd | head -n1`;
chomp $last_backup;
$taille_backup = `du $backup_path/$last_backup | cut -f1`;
ok( $result_cleand_db == 2 && $taille_backup > 0, "testWithNoPgsqlSchema");

# Cas où un schéma a été interdit de suppression.
$mock = Test::MockObject->new();
$mock->fake_module(
        'Database',
        disconnect => sub { return 0; },
        start_transaction => sub { return 0; },
        stop_transaction => sub { return 0; },
        rollback_transaction => sub { return 0; },
        get_user_defined_schemas => sub { return [ ["Foo"] , ["Bar"] ]; },
        drop_schema => sub { return 1; },
);
system "rm -rf ".$backup_path." && mkdir -p ".$backup_path;
$result_cleand_db = clean_db();
$last_backup = `ls -t $backup_path | grep bdd | head -n1`;
chomp $last_backup;
$taille_backup = `du $backup_path/$last_backup | cut -f1`;
ok( $result_cleand_db == 3 && $taille_backup > 0, "testCouldNotDeleteSchema");

## Cas normal
$mock = Test::MockObject->new();
$mock->fake_module(
        'Database',
        disconnect => sub { return 0; },
        start_transaction => sub { return 0; },
        stop_transaction => sub { return 0; },
        rollback_transaction => sub { return 0; },
        get_user_defined_schemas => sub { return [ ["Foo"] , ["Bar"] ]; },
        drop_schema => sub { return 0; },
);
system "rm -rf ".$backup_path." && mkdir -p ".$backup_path;
$result_cleand_db = clean_db();
$last_backup = `ls -t $backup_path | grep bdd | head -n1`;
chomp $last_backup;
$taille_backup = `du $backup_path/$last_backup | cut -f1`;
ok( $result_cleand_db == 0 && $taille_backup > 0, "testNormalCase");


# Nettoyage
system "rm -rf ".$backup_path;
