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
require "clean_tmp_files.pl";

my $emap_tmp_path = $config->param("emap.tmppath");
system "mkdir -p ".$emap_tmp_path;
my $emap_backup_path = $config->param("emap.backuppath");
system "mkdir -p ".$emap_backup_path;
## Creating contents for sandboxing tests.
system "mkdir -p ".$emap_tmp_path."/test";
system "mkdir -p ".$emap_tmp_path."/test/dirCCC";
system "echo AAA > ".$emap_tmp_path."/test/aaa";
system "echo BBB > ".$emap_tmp_path."/test/bbb";
system "echo CCC > ".$emap_tmp_path."/test/dirCCC/ccc";

my $count_orig_tmp_elements = `cd $emap_tmp_path && find . | wc -l`;

# Testing with arguments
ok( clean_tmp_files("bla") == 253, "testWithParameters");

# Testing normal case : backup
my $result_cleaning_tmp = clean_tmp_files();
my $last_backup_name = `ls -tr $emap_backup_path | tail -n 1`;
chomp($last_backup_name);
my $last_backup_full_path = $emap_backup_path."/".$last_backup_name;
my $count_last_backup_elements = `tar tzf $last_backup_full_path | wc -l`;
my $count_tmp_elements = `ls $emap_tmp_path | wc -l`;


ok( ($result_cleaning_tmp == 0) && ($count_last_backup_elements == $count_orig_tmp_elements) , "testBackupInNormalCase");
ok( ($result_cleaning_tmp == 0) && ($count_tmp_elements == 0), "testCleaningInNormalCase");


# Testing with no accesse into tmp or backups folders.
system("mkdir -p ".$emap_tmp_path."/test");
system("mkdir -p ".$emap_tmp_path."/test/dirCCC");
system("echo AAA > ".$emap_tmp_path."/test/aaa");
system("echo BBB > ".$emap_tmp_path."/test/bbb");
system("echo CCC > ".$emap_tmp_path."/test/dirCCC/ccc");
system("chmod -R 000 ".$emap_tmp_path."/* 2>&1");
ok( clean_tmp_files() == 255, "testWithNoAccessToTmp");

system("chmod -R 555 ".$emap_tmp_path."/* 2>&1");
ok( clean_tmp_files() == 254, "testWithNoWriteInTmp");

## Nettoyage du dernier backup
system("chmod -R 755 ".$emap_tmp_path."/* 2>&1");
system("rm -rf  ".$emap_tmp_path." 2>&1");
system("rm -rf ".$emap_backup_path." 2>&1");
