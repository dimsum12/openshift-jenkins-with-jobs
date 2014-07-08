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
my $resources_path = $config->param("resources.path");

require "synchronize_metadatas_on_extern_zone.pl";



# test
{
local *duplicate_volume = sub { return 0 ;};
ok( synchronize_metadatas_on_extern_zone() == 0, "test ok" );
}



# test
{
local *duplicate_volume = sub { return 1 ;};
ok( synchronize_metadatas_on_extern_zone() == 1, "test duplicate volume failed" );
}




