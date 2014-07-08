#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 27;
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


require "rok4_configuration.pl";


# Mock permettant de ne pas appeler les services REST.
# Le retour des appels est simulé par un mock spécifique à chaque test (ci dessous)
my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
	'LWP::UserAgent',
	request => sub { return HTTP::Response->new() }
);

# Mock global pour le harvesting des métadonnées
local *harvest_generation = sub { return 0; };


ok( rok4_configuration() == 255, "testWithoutParameters" );

my $mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 0; },
        decoded_content => sub { return '{}'; }
);
ok( rok4_configuration("-1", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "true", "true") == 1, "testWithBadGenerationId" );


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
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "true", "true") == 0
		&& `more $tmp_path/$tmp_generation/15/$config_file_name | wc -l` eq `more $resources_path/be4/be4_specific_simple.conf | wc -l`
		, "testWithCorrectGenerationSimple" );

		
`mkdir -p $root_storage/fake_storage/20/pyramid/`;
`touch $root_storage/fake_storage/20/pyramid/BROADCAST_DATA_BE4_OLD_TEST_NAME.pyr`;
our $mocked_first_call = "true";
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {	if ("true" eq $mocked_first_call) {
										$mocked_first_call = "false";
										return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 2,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';
									} else {
										return '{"name" : "BROADCAST_DATA_BE4_OLD_TEST_NAME", "version" : 1,"id" : 20,"storage" : {"logicalName" : "fake_storage"} }';
									}
								}
);
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "true", "true") == 0
		&& `more $tmp_path/$tmp_generation/15/$config_file_name | wc -l` eq `more $resources_path/be4/be4_specific_update.conf | wc -l`
		, "testWithCorrectGenerationSimpleWithAncestor" );
`rm -rf $root_storage/fake_storage/20/`;


`mkdir -p $root_storage/fake_storage/20/pyramid/`;
`touch $root_storage/fake_storage/20/pyramid/BROADCAST_DATA_BE4_OLD_TEST_NAME.pyr`;
our $mocked_first_call = "true";
$mock = Test::MockObject->new();
$mocked_call = "0";
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { 	
									if ("0" eq $mocked_call) {
											$mocked_call = "1";
											return 1;
									} elsif ("1" eq $mocked_call) {
											$mocked_call = "2";
											return 1;
									}elsif ("2" eq $mocked_call) {
											$mocked_call = "3";
											return 1;
									} elsif ("3" eq $mocked_call) {
											$mocked_call = "4";
											return 1;
									}else {
											return 0;
									}
							},
        decoded_content => sub {	if ("true" eq $mocked_first_call) {
										$mocked_first_call = "false";
										return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 2,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';
									} else {
										return '{"name" : "BROADCAST_DATA_BE4_OLD_TEST_NAME", "version" : 1,"id" : 20,"storage" : {"logicalName" : "fake_storage"} }';
									}
								}
);
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "true", "true") == 15
		&& `more $tmp_path/$tmp_generation/15/$config_file_name | wc -l` eq `more $resources_path/be4/be4_specific_update.conf | wc -l`
		, "testNokWithErrorcopyingmtds" );
`rm -rf $root_storage/fake_storage/20/`;





$mocked_first_call = "true";
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {	if ("true" eq $mocked_first_call) {
										$mocked_first_call = "false";
										return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_UPDATE_TEST_NAME", "version" : 2,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';
									} else {
										return '{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 20,"storage" : {"logicalName" : "fake_storage"} }';
									}
								}
);
`mkdir -p $root_storage/fake_storage/20/$pyramid_dir/`;
`touch $root_storage/fake_storage/20/$pyramid_dir/BROADCAST_DATA_BE4_SIMPLE_TEST_NAME.pyr`;
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "true", "true") == 0
		&& `more $tmp_path/$tmp_generation/15/$config_file_name | wc -l` eq `more $resources_path/be4/be4_specific_update.conf | wc -l`
		, "testWithCorrectGenerationUpdate" );
`rm -rf $root_storage/fake_storage/20/`;


$mocked_first_call = "true";
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {
									return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 2,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5},{"layerName" : "WMS_LAYER_NAME","releasedOnInternZone" : true,"id" : 12}],"id" : 15}';
								}
);
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "false", "true", "4", "8") == 0
		&& `more $tmp_path/$tmp_generation/15/$config_file_name | wc -l` eq `more $resources_path/be4/be4_specific_harvested.conf | wc -l`
		, "testWithCorrectGenerationHarvested" );
		
$mocked_first_call = "true";
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {	if ("true" eq $mocked_first_call) {
										$mocked_first_call = "false";
										return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 2,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';
									} else {
										return '{"name" : "BROADCAST_DATA_BE4_OLD_TEST_NAME", "version" : 1,"id" : 20,"storage" : {"logicalName" : "fake_storage"} }';
									}
								}
);
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "false", "false", "4", "8") == 0
		&& `more $tmp_path/$tmp_generation/15/$config_file_name | wc -l` eq `more $resources_path/be4/be4_specific_with_levels.conf | wc -l`
		, "testWithCorrectGenerationWithLevels" );

		
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 0; },
        decoded_content => sub { return '{}'; }
);
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "true", "true") == 1, "testWithUnreachableService" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub 	{
									return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_UPDATE_TEST_NAME", "version" : 2,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_first","id" : 5}, {"login" : "complete_delivery_raster_second","id" : 6}],"id" : 15}';
								}
);
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "true", "false") == 2, "testWithMultipleDeliveriesInput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub 	{
									return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 2,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"id" : 5}],"id" : 15}';
								}
);
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "true", "true") == 2, "testWithBadDeliveryInput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub 	{
									return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }, {"name" : "BROADCAST_DATA_BE4_OTHER_TEST_NAME", "version" : 1,"id" : 22,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';
								}
);
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "true", "true") == 3, "testWithMultipleBroadcastDatasOutput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub 	{
									return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 21 }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';
								}
);
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "true", "false") == 253, "testWithNoStorageBroadcastDataOutput" );


$mocked_first_call = "true";
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {	if ("true" eq $mocked_first_call) {
										$mocked_first_call = "false";
										return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_UPDATE_TEST_NAME", "version" : 2,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';
									} else {
										return '{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 20 }';
									}
								}
);
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "true", "true") == 252, "testWithBadAncestorBroadcastData" );


$mocked_first_call = "true";
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub 	{ 	if ("true" eq $mocked_first_call) {
									$mocked_first_call = "false";
									return 1;
								} else {
									return 0;
								}
							},
        decoded_content => sub {	
									return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 2,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5},{"login" : "not_a_resource","id" : 6}],"id" : 15}';
								}
);
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "false", "false", "4", "8") == 2, "testWithNoHarvestingLayer" );
		
		
$mocked_first_call = "true";
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub 	{ 	if ("true" eq $mocked_first_call) {
									$mocked_first_call = "false";
									return 1;
								} else {
									return 0;
								}
							},
        decoded_content => sub {	
									return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 2,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5},{"layerName" : "WMS_LAYER_NAME","releasedOnInternZone" : false,"id" : 12}],"id" : 15}';
								}
);
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "false", "true", "4", "8") == 8, "testWithHarvestingLayerNotPublished" );

		
$mocked_first_call = "true";
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {	if ("true" eq $mocked_first_call) {
										$mocked_first_call = "false";
										return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_UPDATE_TEST_NAME", "version" : 2,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';
									} else {
										return '{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 20,"storage" : {"logicalName" : "fake_storage"} }';
									}
								}
);
`mkdir -p $root_storage/fake_storage/20/$pyramid_dir/`;
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "true", "true") == 7
		, "testWithNoAncestorPyrFile" );
`rm -rf $root_storage/fake_storage/20/`;


$mocked_first_call = "true";
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {	if ("true" eq $mocked_first_call) {
										$mocked_first_call = "false";
										return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_UPDATE_TEST_NAME", "version" : 2,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';
									} else {
										return '{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 20,"storage" : {"logicalName" : "fake_storage_2"} }';
									}
								}
);
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "true", "true") == 13
		, "testWithDifferentAncestorStorage" );


$mocked_first_call = "true";
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub 	{	if ("true" eq $mocked_first_call) {
										$mocked_first_call = "false";
										return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_not_exist","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';
									} else {
										return '{}';
									}
								}
);
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "false", "true") == 4, "testWithoutInformationFile" );


$mocked_first_call = "true";
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {	if ("true" eq $mocked_first_call) {
										$mocked_first_call = "false";
										return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 16}';
									} else {
										return '{}';
									}
								}
);
`mkdir $tmp_path/$tmp_generation/16/`;
`chmod 000 $tmp_path/$tmp_generation/16/`;
ok( rok4_configuration("16", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "false", "true") == 5, "testWithErrorCreatingBe4Conf" );
`chmod 777 $tmp_path/$tmp_generation/16/`;
`rm -r $tmp_path/$tmp_generation/16/`;


$mocked_first_call = "true";
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub {	if ("true" eq $mocked_first_call) {
										$mocked_first_call = "false";
										return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 16}';
									} else {
										return '{}';
									}
								}
);
`mkdir -p $root_storage/fake_storage/21`;
`chmod 000 $root_storage/fake_storage/21`;
ok( rok4_configuration("16", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "false", "true") == 6, "testWithErrorCreatingPyramidDir" );
`chmod 777 $root_storage/fake_storage/21`;
`rm -r $root_storage/fake_storage/21`;


$mocked_call = "0";
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { 	
								if ("0" eq $mocked_call) {
										$mocked_call = "1";
										return 1;
								} elsif ("1" eq $mocked_call) {
										return 0;
								}
						},
        decoded_content => sub {
								return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';
						}
);
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "true", "true") == 9, "testWithErrorUpdatingBroadcastData" );
		
		
$mocked_call = "0";
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
								} elsif ("2" eq $mocked_call) {
										$mocked_call = "3";
										return 1;
								} else {
										return 0;
								}
						},
        decoded_content => sub {
								return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';
						}
);
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "true", "true") == 9, "testWithErrorUpdatingBBoxes" );
		
		
$mocked_call = "0";
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
	local *bbox_from_images = sub { return 1; };
    ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "true", "true") == 10, "testWithErrorCalculatingBBox" );
}









{
	local *harvest_generation = sub { return 1; };
	
	$mocked_call = "0";
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
	ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "true", "true") == 11
			, "testWithErrorHarvestingMetadatas" );
}




		
$mocked_call = "0";
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
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "no_exist", "true", "true") == 12, "testWithIncorrectPreprocessing" );

		
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
ok( rok4_configuration("15", "LAMB93_10cm", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "none", "false", "true") == 254, "testWithJsonConversionError" );



# Nettoyage de la génération restante
`rm -r $tmp_path/$tmp_generation/15/`;
`rm -r $tmp_path/$tmp_generation/16/`;
