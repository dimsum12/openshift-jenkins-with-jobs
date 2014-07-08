#!/usr/bin/perl
BEGIN {
        push @INC, "lib";
}
use Classpath;
Classpath->load();
use Test::Simple tests =>3;
use Config::Simple;
use strict;
use warnings;
use Cwd;

my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path")."conditionnement";


require "retrieve_properties.pl";

ok(retrieve_properties()==255,"testWithoutParameters");

ok(retrieve_properties("/tmp/inexistingFile.t")==254,"testWithInexistingFile");


my %hash=retrieve_properties($resources_path.'/'.'testExtraction.properties');

ok(%hash,"testOKHashDefined");


