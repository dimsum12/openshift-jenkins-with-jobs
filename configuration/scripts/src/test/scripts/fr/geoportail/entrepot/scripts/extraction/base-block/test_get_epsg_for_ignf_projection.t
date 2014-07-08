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

require "get_epsg_for_ignf_projection.pl";




# Mock permettant de ne pas appeler les services REST.
# Le retour des appels est simulé par un mock spécifique à chaque test (ci dessous)
my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
	'LWP::UserAgent',
	request => sub { return HTTP::Response->new() }
);




#   * 0 if success
#	* 1 error when calling entrepot webservice 
#   * 255 if the function is called an incorrect number of arguments




# test
my $mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		content => sub { return 'EPSG:4326'; }
);


ok( get_epsg_for_ignf_projection("IGNF:WGS84G") eq "EPSG:4326", "test ok" );


# test
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 0; },
		content => sub { return '["ghfu-fr,gfur-frf","456-8552,4782-fd458","2,3","2,3","INTEAL"]'; }
);


ok( get_epsg_for_ignf_projection("IGNF:WGS84G") == 1, "test error when calling entrepot WS" );



# test
ok( get_epsg_for_ignf_projection() == 255, "testWithoutParameters" );





