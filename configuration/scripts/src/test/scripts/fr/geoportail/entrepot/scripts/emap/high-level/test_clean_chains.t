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
no warnings 'redefine';
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
## End loading

# Loading script to test
require "clean_chains.pl";

ok( clean_chains("An argument is provided") == 254, "testWithParameters");

{
	local *compress_folder = sub { return 1; };
    ok( clean_chains() == 251, "TestWithNoBackupDone");
}

{
	local *compress_folder = sub { return 0; };
    local *clean_folder_content = sub { return 1; };
    ok( clean_chains() == 252, "TestWithNoCleaning");
}

{
	local *compress_folder = sub { return 0; };
    local *clean_folder_content = sub { return 0; };
    local *hg_clone_chain = sub { return 1; };
    ok( clean_chains() == 253, "TestWithNoCleaning");
}


{
	local *compress_folder = sub { return 0; };
    local *clean_folder_content = sub { return 0; };
    local *hg_clone_chain = sub { return 0; };
    local *hg_update_to_branch = sub { return 1;};
    ok( clean_chains() == 255, "TestWithNoCleaning");
}


{
	local *compress_folder = sub { return 0; };
    local *clean_folder_content = sub { return 0; };
    local *hg_clone_chain = sub { return 0; };
    local *hg_update_to_branch = sub { return 0;};
    ok( clean_chains() == 0, "TestWithNoCleaning");
}
