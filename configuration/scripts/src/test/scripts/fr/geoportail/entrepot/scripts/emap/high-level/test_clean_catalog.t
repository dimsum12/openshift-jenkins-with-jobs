#!/usr/bin/perl

### Loading GPP3 Perl test env. configuration
BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 4;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
use Cwd;
use Database;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
### End loading

### Custom preliminaries actions
require "clean_catalog.pl";

my $backup_path = $config->param("emap.backuppath");
system "mkdir -p ".$backup_path;
my $db_catalog_name = $config->param("db-emap_catalog.dbname");
my $db_host = $config->param("db-emap_catalog.host");
my $db_port =  $config->param("db-emap_catalog.port");
my $normal_username = $config->param("db-emap_catalog.username");
my $normal_password = $config->param("db-emap_catalog.password");
my $db_superuser_username = $config->param("db-emap_catalog.admin_username");
my $db_superuser_password = $config->param("db-emap_catalog.admin_password");

my $database;
my $result_cleancatalog;
my $last_backup;
my $size_last_backup;
my $mock;

sub db_superuser_query {
    my $query = $_[0];
    $database = Database->connect($db_catalog_name, $db_host, $db_port, $db_superuser_username, $db_superuser_password);
    $database->start_transaction();
    $database->execute_without_return($query);
    $database->stop_transaction();
    $database->disconnect();
}
### End custom loading

### tesing function's call topology
ok( clean_catalog("FooParameter") == 1, "testWithParameters");

### Testing with failing backup
system "chmod -R 500 ".$backup_path;
ok( clean_catalog() == 2, "testWithNoBackup");
system "chmod -R 755 ".$backup_path;


### Testing with no rights to reinitialize catalog's database
## Initialisation à vide du dossier de backup
system "rm -rf ".$backup_path;
system "mkdir -p ".$backup_path;
## Mock du database
$mock = Test::MockObject->new();
$mock->fake_module(
        'Database',
        disconnect => sub { return 0; },
        start_transaction => sub { return 0; },
        stop_transaction => sub { return 0; },
        rollback_transaction => sub { return 0; },
        exec_pg_dump => sub { return 0; },
        run_sql_dump => sub { return 1; },
        get_user_defined_schemas => sub { my @array_to_return = (); return @array_to_return },
);
## Validation
ok( clean_catalog() == 3,"testWithNoGeneratingTable");

### Testing in normal Case
## Initialisation à vide du dossier de backup
system "rm -rf ".$backup_path;
system "mkdir -p ".$backup_path;
## Mock du database
$mock = Test::MockObject->new();
$mock->fake_module(
        'Database',
        disconnect => sub { return 0; },
        start_transaction => sub { return 0; },
        stop_transaction => sub { return 0; },
        rollback_transaction => sub { return 0; },
        exec_pg_dump => sub { return 0; },
        run_sql_dump => sub { return 0; },
);
## Validation
ok( clean_catalog() == 0 ,"testNormalCase");


### Custom cleaning
system "rm -rf ".$backup_path;
### End custom cleaning
