#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 10;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
use Cwd;
use LWP::UserAgent;

use Database;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new("test_update_broadcastdata_size.pl", $logger_levels);



my $mock_global = Test::MockObject->new();
$mock_global->fake_module( 'LWP::UserAgent',
    request => sub { return HTTP::Response->new() } );

my $mock = Test::MockObject->new();
$mock->fake_module(
	'HTTP::Response',
	is_success      => sub { return 1; }
);


	

require "update_broadcastdata_size.pl";


ok( update_broadcastdata_size() == 255, "Test sans paramètre" );


my $mock_database = Test::MockObject->new();
$mock_database->fake_module(
	'Database',
	connect      => sub { return ; }
);

ok( update_broadcastdata_size("/tmp/", 35, 1) == 5  , "Test ko connection failed");

$mock_database = Test::MockObject->new();
$mock_database->fake_module(
	'Database',
	connect      => sub { my $this = {};
    bless $this, 'Database'; return $this;},
	get_schema_size =>sub { return -2; },
	disconnect =>sub { return 0; }
);

ok( update_broadcastdata_size("/tmp/", 35, 1) == 6  , "Test ko when getting size of schema");

$mock_database = Test::MockObject->new();
$mock_database->fake_module(
	'Database',
	connect      => sub { my $this = {};
    bless $this, 'Database'; return $this; },
	get_schema_size =>sub { return 562; },
	disconnect =>sub { return 1; }
);

ok( update_broadcastdata_size("/tmp/", 35, 1) == 7  , "Test KO when disconnecting");



$mock_database = Test::MockObject->new();
$mock_database->fake_module(
	'Database',
	connect      => sub { return 0; },
	get_schema_size =>sub { return 562; },
	disconnect =>sub { return 0; }
);

ok( update_broadcastdata_size("/tmp/", 35, 0) == 0  , "Test OK folder");

ok( update_broadcastdata_size("/tmp/", 35, 0) == 0  , "Test OK schema");

ok( update_broadcastdata_size("unknwonfolder", 35, 0) == 1  , "Test folder does not exists");

ok( update_broadcastdata_size("/tmp/", "hdj", 0) == 2  , "Test bd_id is not numeric");

$mock->fake_module(
	'HTTP::Response',
	is_success      => sub { return 0; }
);



ok( update_broadcastdata_size("/tmp/", 35, 0) == 4  , "Test error when calling webservice");


$mock->fake_module(
			'Execute',
			get_log => sub { return 'sgdfg	/tmp/' }
);

ok( update_broadcastdata_size("/tmp/", 35, 0) == 3  , "Test error when getting size bd_id is not numeric");







