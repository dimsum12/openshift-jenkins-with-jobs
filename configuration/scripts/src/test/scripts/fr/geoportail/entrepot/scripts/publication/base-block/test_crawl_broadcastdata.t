#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 3;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
no warnings 'redefine';
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
my $catalog_folder = $config->param("filer.catalog.repository");

require "crawl_broadcastdata.pl";

#   * 0 if success
#	* 1 if crawl failed
#   * 255 if the function is called an incorrect number of arguments

system("mkdir -p ".$catalog_folder);
system("mkdir -p ".$catalog_folder."/ISOAP/");
system("mkdir -p ".$catalog_folder."/ISOAP/1/");
system("mkdir -p ".$catalog_folder."/INSPIRE/");
system("mkdir -p ".$catalog_folder."/INSPIRE/1/");
system("touch ".$catalog_folder."/ISOAP/1/test.xml");
system("touch ".$catalog_folder."/INSPIRE/1/test.xml");


# test
{
local *harvest_directory = sub { return 0 ;};
ok( crawl_broadcastdata("url", "ghfu-fr,gfur-frf") == 0, "test ok" );
}

# test
{
local *harvest_directory = sub { return 1 ;};
ok( crawl_broadcastdata("url", "gfur-frf,1") == 1, "test crawl failed" );
}


# test
ok( crawl_broadcastdata() == 255, "testWithoutParameters" );


system("rm -rf ".$catalog_folder);
