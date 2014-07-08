#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 8;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
my $tmp_path = $config->param("resources.tmp.path");
my $tmp_generation = $config->param("resources.tmp.generations");
my $config_file_name = $config->param("be4.specific_conf_filename");
my $root_storage     = $config->param("filer.root.storage");
my $pyramid_dir 	 = $config->param("be4.pyramid_dir");


require "rok4_final_update.pl";


# Mock permettant de ne pas appeler les services REST.
# Le retour des appels est simulé par un mock spécifique à chaque test (ci dessous)
my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
	'LWP::UserAgent',
	request => sub { return HTTP::Response->new() }
);

# Mock global pour le harvesting des métadonnées



ok( rok4_final_update() == 255, "testWithoutParameters" );

my $mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 0; },
        decoded_content => sub { return '{}'; }
);
ok( rok4_final_update("-1") == 1, "testWithBadGenerationId" );


our $mocked_call = "0";
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { 	
								if ("0" eq $mocked_call) {
										$mocked_call = "1";
										return 1;
								} elsif ("1" eq $mocked_call) {
										$mocked_call = "2";
										return 0;
								} else {
										return 1;
								}
						},
        decoded_content => sub {
								return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';
						}
);
{
	local *update_broadcastdata_size = sub { return 0;};
	ok( rok4_final_update("15") == 0 );
}
$mocked_call = "0";
{
	local *update_broadcastdata_size = sub { return 1;};
	ok( rok4_final_update("15") == 3 );
}


		
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 0; },
        decoded_content => sub { return '{}'; }
);
ok( rok4_final_update("15") == 1, "testWithUnreachableService" );



$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub 	{
									return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }, {"name" : "BROADCAST_DATA_BE4_OTHER_TEST_NAME", "version" : 1,"id" : 22,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';
								}
);
ok( rok4_final_update("15") == 2, "testWithMultipleBroadcastDatasOutput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub 	{
									return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 21 }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';
								}
);
ok( rok4_final_update("15") == 253, "testWithNoStorageBroadcastDataOutput" );



		
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
ok( rok4_final_update("15") == 254, "testWithJsonConversionError" );


