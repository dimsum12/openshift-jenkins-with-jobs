#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 12;
use Config::Simple;
use Test::MockObject;
use Execute;
use strict;
use warnings;
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();

my $tmp_path         		= $config->param("resources.tmp.path");
my $tmp_generation   		= $config->param("resources.tmp.generations");


require "prepackaged_generation.pl";


# Mock permettant de ne pas appeler les services REST.
# Le retour des appels est simulé par un mock spécifique à chaque test (ci dessous)
my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
	'LWP::UserAgent',
	request => sub { return HTTP::Response->new() }
);



ok( prepackaged_generation() == 255, "testWithoutParameters" );

my $mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 0; },
        decoded_content => sub { return '{}'; }
);
ok( prepackaged_generation("-1", "BDORTHO", "TEST", "REGION", "LAMB93|LAMBE", "TIFF|JPG", "0,0|0,0", "1000,1000", "2000,2000", "TEST-%PROJ%-%X3%-%Y3%") == 1, "testWithBadGenerationId" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {
								return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_PP_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : 	{"logicalName" : "fake_storage"} }],"inputDatas" : [],"id" : 15}';
		}
);
ok( prepackaged_generation("15", "BDORTHO", "TEST", "REGION", "LAMB93|LAMBE", "TIFF|JPG", "0,0|0,0", "1000,1000", "2000,2000", "TEST-%PROJ%-%X3%-%Y3%") == 2, "testWithNoResource" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {
								return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_PP_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : 	{"logicalName" : "fake_storage"}},{"name" : "BROADCAST_DATA_PP_SIMPLE_TEST_NAME_2", "version" : 1,"id" : 22,"storage" : {"logicalName" : "fake_storage"}}],"inputDatas" : [{"releasedOnInternal" : "true","resourceFamily" : {"service" : "WMSRASTER"},"id" : 5,"layerName" : "LAYER.NAME.1"}],"id" : 15}';
		}
);
ok( prepackaged_generation("15", "BDORTHO", "TEST", "REGION", "LAMB93|LAMBE", "TIFF|JPG", "0,0|0,0", "1000,1000", "2000,2000", "TEST-%PROJ%-%X3%-%Y3%") == 3, "testWithTwoBroadcastData" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {
								return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_PP_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : 	{"logicalName" : "fake_storage"} }],"inputDatas" : [{"releasedOnInternal" : "false","resourceFamily" : {"service" : "WMSRASTER"},"id" : 5,"layerName" : "LAYER.NAME.1"}],"id" : 15}';
		}
);
ok( prepackaged_generation("15", "BDORTHO", "TEST", "REGION", "LAMB93|LAMBE", "TIFF|JPG", "0,0|0,0", "1000,1000", "2000,2000", "TEST-%PROJ%-%X3%-%Y3%") == 4, "testWithNoReleasedOnInternal" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {
								return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_PP_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : 	{"logicalName" : "fake_storage"} }],"inputDatas" : [{"releasedOnInternal" : "true","resourceFamily" : {"service" : "WMSRASTER"},"id" : 5,"layerName" : "LAYER.NAME.1"}],"id" : 15}';
		}
);
ok( prepackaged_generation("15", "BDORTHO", "TEST", "DONTEXIST", "LAMB93|LAMBE", "TIFF|JPG", "0,0|0,0", "1000,1000", "2000,2000", "TEST-%PROJ%-%X3%-%Y3%") == 5, "testWithEmpriseDontExist" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {
								return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_PP_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : 	{"logicalName" : "fake_storage"} }],"inputDatas" : [{"releasedOnInternal" : "true","resourceFamily" : {"service" : "WMSRASTER"},"id" : 5,"layerName" : "LAYER.NAME.1"}],"id" : 15}';
		}
);
ok( prepackaged_generation("15", "BDORTHO", "TEST", "REGION_NO_ID", "LAMB93|LAMBE", "TIFF|JPG", "0,0|0,0", "1000,1000", "2000,2000", "TEST-%PROJ%-%X3%-%Y3%") == 5, "testWithEmpriseNoId" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {
								return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_PP_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : 	{"logicalName" : "fake_storage"} }],"inputDatas" : [{"releasedOnInternal" : "true","resourceFamily" : {"service" : "WMSRASTER"},"id" : 5,"layerName" : "LAYER.NAME.1"}],"id" : 15}';
		}
);
ok( prepackaged_generation("15", "BDORTHO", "TEST", "REGION", "LAMB93|LAMBE|RGF93G", "TIFF|JPG", "0,0|0,0", "1000,1000", "2000,2000", "TEST-%PROJ%-%X3%-%Y3%") == 5, "testWithBadProjectionsAndOrigins" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {
								return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_PP_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : 	{"logicalName" : "fake_storage"} }],"inputDatas" : [{"id" : 5,"name" : "NAME1"}],"id" : 15}';
		}
);
ok( prepackaged_generation("15", "BDORTHO", "TEST", "REGION", "LAMB93|LAMBE", "TIFF|JPG", "0,0|0,0", "1000,1000", "2000,2000", "TEST-%PROJ%-%X3%-%Y3%") == 253, "testWithInputDataNotResource" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {
								return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_PP_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : 	{"logicalName" : "fake_storage"} }],"inputDatas" : [{"releasedOnInternal" : "true","resourceFamily" : {},"id" : 5,"layerName" : "LAYER.NAME.1"}],"id" : 15}';
		}
);
ok( prepackaged_generation("15", "BDORTHO", "TEST", "REGION", "LAMB93|LAMBE", "TIFF|JPG", "0,0|0,0", "1000,1000", "2000,2000", "TEST-%PROJ%-%X3%-%Y3%") == 253, "testWithResourceWithoutService" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {
								return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_PP_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : 	{"logicalName" : "fake_storage"} }],"inputDatas" : [{"releasedOnInternal" : "true","resourceFamily" : {"service" : "SERVICE"},"id" : 5,"layerName" : "LAYER.NAME.1"}],"id" : 15}';
		}
);
ok( prepackaged_generation("15", "BDORTHO", "TEST", "REGION", "LAMB93|LAMBE", "TIFF|JPG", "0,0|0,0", "1000,1000", "2000,2000", "TEST-%PROJ%-%X3%-%Y3%") == 253, "testWithResourceWithUnknownService" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {
								return '{"broadcastDatas" : [{"version" : 1,"id" : 21,"storage" : 	{"logicalName" : "fake_storage"} }],"inputDatas" : [{"releasedOnInternal" : "true","resourceFamily" : {"service" : "WMSRASTER"},"id" : 5,"layerName" : "LAYER.NAME.1"}],"id" : 15}';
		}
);
ok( prepackaged_generation("15", "BDORTHO", "TEST", "REGION", "LAMB93|LAMBE", "TIFF|JPG", "0,0|0,0", "1000,1000", "2000,2000", "TEST-%PROJ%-%X3%-%Y3%") == 253, "testWithBadBroadcastData" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {
								return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_PP_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : 	{"logicalName" : "fake_storage"} }],"inputDatas" : [{"releasedOnInternal" : "true","resourceFamily" : {"service" : "WMSRASTER"},"id" : 5,"layerName" : "LAYER.NAME.1"}],"id" : 15}';
		}
);
#ok( prepackaged_generation("15", "BDORTHO", "TEST", "REGION", "LAMB93|LAMBE", "TIFF|JPG", "0,0|0,0", "1000,1000", "2000,2000", "TEST-%PROJ%-%X3%-%Y3%") == 0, "testWithCorrectGeneration" );
#Execute->run( "rm -rf " . $tmp_path . $tmp_generation . "/15/", "true" );
