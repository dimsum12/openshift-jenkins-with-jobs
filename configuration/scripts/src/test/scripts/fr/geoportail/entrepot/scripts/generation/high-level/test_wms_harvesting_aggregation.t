#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 9;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
my $root_storage     = $config->param("filer.root.storage");


require "wms_harvesting_agregation.pl";


# Mock permettant de ne pas appeler les services REST.
# Le retour des appels est simulé par un mock spécifique à chaque test (ci dessous)
my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
	'LWP::UserAgent',
	request => sub { return HTTP::Response->new() }
);


Execute->run( "mkdir -p " . $root_storage . "/fake_storage" );


ok( wms_harvesting_agregation() == 255, "testWithoutParameters" );


my $mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 0; },
		decoded_content => sub {
			return '{}';
		}
);
ok( wms_harvesting_agregation("-1") == 1, "testWithBadGenerationId" );


Execute->run( "cp -r " . $resources_path . "/wms_harvesting_levels_ok " . $root_storage . "/fake_storage/4567" );
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
		decoded_content => sub {
			return '{"broadcastDatas" : [{"name" : "TEST_WMS_AGREGATION", "version" : 1,"id" : 4567,"storage" : {"logicalName" : "fake_storage"} }],"id" : 15}';
		}
);
ok( wms_harvesting_agregation("15") == 0, "testCorrectAgregation" );
Execute->run( "rm -rf " . $root_storage . "/fake_storage/4567" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
		decoded_content => sub {
			return '{"broadcastDatas" : [],"id" : 15}';
		}
);
ok( wms_harvesting_agregation("15") == 2, "testNoBroadcastData" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
		decoded_content => sub {
			return '{"broadcastDatas" : [{"name" : "TEST_WMS_AGREGATION", "version" : 1,"id" : 4568}],"id" : 15}';
		}
);
ok( wms_harvesting_agregation("15") == 253, "testBadBroadcastData" );


Execute->run( "cp -r " . $resources_path . "/wms_harvesting_levels_empty " . $root_storage . "/fake_storage/4569" );
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
		decoded_content => sub {
			return '{"broadcastDatas" : [{"name" : "TEST_WMS_AGREGATION", "version" : 1,"id" : 4569,"storage" : {"logicalName" : "fake_storage"} }],"id" : 15}';
		}
);
ok( wms_harvesting_agregation("15") == 4, "testEmptyBd" );
Execute->run( "rm -rf " . $root_storage . "/fake_storage/4569" );


Execute->run( "cp -r " . $resources_path . "/wms_harvesting_levels_no_pyr " . $root_storage . "/fake_storage/4570" );
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
		decoded_content => sub {
			return '{"broadcastDatas" : [{"name" : "TEST_WMS_AGREGATION", "version" : 1,"id" : 4570,"storage" : {"logicalName" : "fake_storage"} }],"id" : 15}';
		}
);
ok( wms_harvesting_agregation("15") == 4, "testNoPyramid" );
Execute->run( "rm -rf " . $root_storage . "/fake_storage/4570" );


Execute->run( "cp -r " . $resources_path . "/wms_harvesting_levels_bad_level " . $root_storage . "/fake_storage/4571" );
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
		decoded_content => sub {
			return '{"broadcastDatas" : [{"name" : "TEST_WMS_AGREGATION", "version" : 1,"id" : 4571,"storage" : {"logicalName" : "fake_storage"} }],"id" : 15}';
		}
);
ok( wms_harvesting_agregation("15") == 4, "testBadLevel" );
Execute->run( "rm -rf " . $root_storage . "/fake_storage/4571" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{}],"id" : 15}'; }
);
$mock->fake_module(
        'JSON',
        from_json => sub ($@) { return undef; }
);
ok( wms_harvesting_agregation("15") == 254, "testWithJsonConversionError" );
