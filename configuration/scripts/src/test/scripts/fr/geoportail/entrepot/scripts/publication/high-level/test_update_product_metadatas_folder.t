#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 2;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
no warnings 'redefine';
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();


require "update_product_metadatas_folder.pl";

#   * 0 if success
#	* 1 if crawl failed


# test
{
local *harvest_directory = sub { return 0 ;};
local *harvest_directory_validation = sub { return 0 ;};
ok( update_product_metadatas_folder() == 0, "test ok" );
}

# test
{
local *harvest_directory_validation = sub { return 1 ;};
local *harvest_directory = sub { return 1 ;};
ok( update_product_metadatas_folder() == 0, "test crawl failed" );
}


