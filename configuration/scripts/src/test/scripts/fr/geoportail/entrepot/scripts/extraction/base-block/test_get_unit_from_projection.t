#!/usr/bin/perl
BEGIN {
    push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 4;
use Config::Simple;
use strict;
use warnings;
use Cwd;
use Execute;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();


require "get_unit_from_projection.pl";


# Préparation de l'envrionnement

# Test without parameters
ok(get_unit_from_projection() == 255, "testWithoutParameters");

# Test with wrong projection
ok(get_unit_from_projection("EPSG:123456789") == 1, "testWithWrongProjection");

# Test with degres projection
ok(get_unit_from_projection("EPSG:4326") eq "d", "testWithWDegres");

# Test with meter projection
ok(get_unit_from_projection("EPSG:2154") eq "m", "testWithMeter");

