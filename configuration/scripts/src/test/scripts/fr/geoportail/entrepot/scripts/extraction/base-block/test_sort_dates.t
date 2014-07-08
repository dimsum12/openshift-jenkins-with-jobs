#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();
use Test::Simple tests => 16;
use strict;
use warnings;
use Config::Simple;
use Cwd;

my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();

require ("sort_dates.pl");

my @dates = ();
my $retour;

ok( sort_dates("min",@dates) == 254, "testWithMinAndEmptyArray");

ok( sort_dates("max",@dates) == 254, "testWithMaxAndEmptyArray");

push(@dates,"2012-05-11");
ok( sort_dates(@dates) == 255, "testWithNoFirstParam");

ok( sort_dates(0, @dates) == 255, "testWithFirstParamInteger");

ok( sort_dates("titi", @dates) == 255, "testWithFirstParamNoAttendedValue");

ok( sort_dates("maxi", @dates) == 255, "testWithFirstParamNoAttendedValue2");

push(@dates,"201205-11");
ok( sort_dates("min", @dates) == 254, "testWithUnregularExpression");

@dates = ("1900-01-00");
ok( sort_dates("min", @dates) == 254, "testWithMinLimitDay");

@dates = ("1900-01-32");
ok( sort_dates("min", @dates) == 254, "testWithMaxLimitDay");

@dates = ("1900-00-01");
ok( sort_dates("min", @dates) == 254, "testWithMinLimitMont");

@dates = ("1900-13-01");
ok( sort_dates("min", @dates) == 254, "testWithMaxLimitMonth");

@dates = ("2011-02-29");
ok( sort_dates("min", @dates) == 254, "testWith29FevrNoBisex");

@dates = ("2012-02-29");
ok( sort_dates("min", @dates) eq "2012-02-29", "testWith29FevrBisex");

@dates = ("1900-01-00");
ok( sort_dates("min", @dates) == 254, "testWithBadDay");

@dates = ("1980-06-18","2012-02-01","2010-04-03");
ok( sort_dates("min",@dates) eq "1980-06-18", "testWithMin");
ok( sort_dates("max",@dates) eq '2012-02-01', "testWithMax");
