#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 6;
use Logger;

use strict;
use warnings;
use Cwd;

my $logger = Logger->new("test_Logger.t", "INFO:WARN:ERROR:DEBUG");

ok( $logger->log("TEST", "Test") == 1, "Test de niveau non existant");
ok( $logger->log("", "Test") == 1, "Test sans niveau");
ok( $logger->log("INFO", "Test") == 0, "Test de niveau INFO");
ok( $logger->log("WARN", "Test") == 0, "Test de niveau WARN");
ok( $logger->log("ERROR", "Test") == 0, "Test de niveau ERROR");
ok( $logger->log("DEBUG", "Test") == 0, "Test de niveau DEBUG");
