#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();
use Test::Simple tests =>4;
use Config::Simple;
use strict;
use warnings;
use Cwd;
use Test::MockObject;
use Test::MockModule;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();

require ("grid_generator.pl");

ok( grid_generator("ppp") == 255, "testWithOneParameters");

ok( grid_generator("POLYGON EMPTY", 1000, 1000) == 1, "testWithEmptyPolygon");

my $module = new Test::MockModule('Database');
$module->mock('select_one_row', sub { return "BOX(4,4,4)"; });

ok( grid_generator("POLYGON EMPTY", 1000, 1000) == 2, "testWithBadBBox");

$module->unmock('select_one_row');

ok( scalar @{grid_generator("SRID=4326;POLYGON((0 0,0 2,2 2,2 0,0 0))", "1", "1")} == 4, "testOK");