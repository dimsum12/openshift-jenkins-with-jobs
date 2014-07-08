#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();
use Test::Simple tests =>5;
use Config::Simple;
use strict;
use warnings;
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();

require ("max_dates.pl");

my @empty = ();
ok( max_dates(@empty) == 255, "testWithEmptyArray");

my @t = ("20111204");
ok( max_dates(@t) == 254, "testWithUnregularExpression");


my @two_dates = ('2011-12-04','2012-12-05');
ok( max_dates(@two_dates) eq '2012-12-5', "testWithTwoDates");


my @three_dates = ('2010-12-14','2010-10-14','2010-11-14');
ok( max_dates(@three_dates) eq '2010-12-14', "testWithThreeDates");


my @four_dates = ('2010-12-14','2010-10-14','2011-11-14','2012-11-14');
ok( max_dates(@four_dates) eq '2012-11-14', "testWithFourDates");