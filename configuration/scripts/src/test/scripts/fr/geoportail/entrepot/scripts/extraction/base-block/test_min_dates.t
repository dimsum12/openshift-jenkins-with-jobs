#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();
use Test::Simple tests =>5;
use strict;
use warnings;
use Config::Simple;
use Cwd;

my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();

require ("min_dates.pl");

my @empty = ();
ok( min_dates(@empty) == 255, "testWithEmptyArray");

my @t = ('20111204');
ok( min_dates(@t) == 254, "testWithUnregularExpression");


my @two_dates = ('2011-12-04','2012-12-04');
ok( min_dates(@two_dates) eq '2011-12-4', "testWithTwoDates");


my @three_dates = ('2010-12-14','2010-10-14','2010-11-14');
ok( min_dates(@three_dates) eq '2010-10-14', "testWithThreeDates");


my @four_dates = ('2010-12-14','2010-10-14','2010-11-14','2010-09-14');
ok( min_dates(@four_dates) eq '2010-9-14', "testWithFourDates");