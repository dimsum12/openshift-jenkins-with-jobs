#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();
use Execute;
use Test::Simple tests => 11;
use Config::Simple;
use strict;
use warnings;
use Cwd;
use Test::MockObject;
use Test::MockModule;

my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
my $tmp_path = $config->param("resources.tmp.path");
my $tmp_generation = $config->param("resources.tmp.generations");
my $config_file_name = $config->param("be4.specific_conf_filename");
my $root_storage     = $config->param("filer.root.storage");
my $pyramid_dir 	 = $config->param("be4.pyramid_dir");


require("wms_harvesting.pl");


my $module_global = new Test::MockModule('LWP::UserAgent');
$module_global->mock('request', sub { return HTTP::Response->new() });
my $moduleHTTP = new Test::MockModule('HTTP::Response');
my $mockJSON = new Test::MockModule('JSON');




ok( wms_harvesting("ppp") == 255, "testWithOneParameters");


$moduleHTTP->mock('is_success' , sub {return 1});
$moduleHTTP->mock('decoded_content', sub {return '{}';});
$mockJSON->mock('from_json', sub ($@) { return undef; });
ok( wms_harvesting(1234,"png","normal","false","FFFFFF",2000,2000,"SRID=4326;POLYGON((0 0,0 1,1 1,1 0,0 0))", "4326", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "false", 4, 8) == 254, "testWithJsonConversionError");
$moduleHTTP->unmock('decoded_content');
$moduleHTTP->unmock('is_success');
$mockJSON->unmock('from_json');


$moduleHTTP->mock('is_success' , sub {return 0});
ok( wms_harvesting(1234,"png","normal","false","FFFFFF",2000,2000,"SRID=4326;POLYGON((0 0,0 1,1 1,1 0,0 0))", "4326", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "false", 4, 8) == 1, "testWithBadGenerationId");
$moduleHTTP->unmock('is_success');
Execute->run("rm -rf " . $tmp_path . $tmp_generation . "/1234/");


$moduleHTTP->mock('is_success' , sub {return 1});
$moduleHTTP->mock('decoded_content', sub {return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"id" : 15}';});
ok( wms_harvesting(1234,"png","normal","false","FFFFFF",2000,2000,"SRID=4326;POLYGON((0 0,0 1,1 1,1 0,0 0))", "4326", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "false", 4, 8) == 2, "testNoInputData");
$moduleHTTP->unmock('decoded_content');
$moduleHTTP->unmock('is_success');
Execute->run("rm -rf " . $tmp_path . $tmp_generation . "/1234/");


$moduleHTTP->mock('is_success' , sub {return 1});
$moduleHTTP->mock('decoded_content', sub {return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5},{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';});
ok( wms_harvesting(1234,"png","normal","false","FFFFFF",2000,2000,"SRID=4326;POLYGON((0 0,0 1,1 1,1 0,0 0))", "4326", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "false", 4, 8) == 2, "testWithMultipleInputData");
$moduleHTTP->unmock('decoded_content');
$moduleHTTP->unmock('is_success');
Execute->run("rm -rf " . $tmp_path . $tmp_generation . "/1234/");


$moduleHTTP->mock('is_success' , sub {return 1});
$moduleHTTP->mock('decoded_content', sub {return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';});
ok( wms_harvesting(1234,"png","normal","false","FFFFFF",2000,2000,"SRID=4326;POLYGON((0 0,0 1,1 1,1 0,0 0))", "4326", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "false", 4, 8) == 2, "testWithNoResourceInputData");
$moduleHTTP->unmock('decoded_content');
$moduleHTTP->unmock('is_success');
Execute->run("rm -rf " . $tmp_path . $tmp_generation . "/1234/");


$moduleHTTP->mock('is_success' , sub {return 1});
$moduleHTTP->mock('decoded_content', sub {return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"layerName" : "ma_couche", "login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';});
ok( wms_harvesting(1234,"png","normal","false","FFFFFF",2000,2000,"SRID=4326;POLYGON((0 0,0 1,1 1,1 0,0 0))", "4326", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "false", 4, 8) == 4, "testWithResourceInputDataNotPublishedInternalZone");
$moduleHTTP->unmock('decoded_content');
$moduleHTTP->unmock('is_success');
Execute->run("rm -rf " . $tmp_path . $tmp_generation . "/1234/");


$moduleHTTP->mock('is_success' , sub {return 1});
$moduleHTTP->mock('decoded_content', sub {return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"layerName" : "ma_couche", "releasedOnInternZone" : "true", "login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';});
ok( wms_harvesting(1234,"png","normal","false","FFFFFF",2000,2000,"SRID=4326;POLYGON((0 0, 0,0 0))", "4326", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "false", 4, 8) == 6, "testWithGridGeneratorError");
$moduleHTTP->unmock('decoded_content');
$moduleHTTP->unmock('is_success');
Execute->run("rm -rf " . $tmp_path . $tmp_generation . "/1234/");


our $mocked_first_call = "true";
$moduleHTTP->mock('is_success' , sub {return 1});
$moduleHTTP->mock('decoded_content', sub {
		if ("true" eq $mocked_first_call) {
			$mocked_first_call = "false";
			return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"layerName" : "ma_couche", "releasedOnInternZone" : "true", "login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';
		} else {
			return '{"name" : "BROADCAST_DATA_BE4_OLD_TEST_NAME", "version" : 1,"id" : 20,"storage" : {"logicalName" : "fake_storage"} }';
		}
	}
);
{
	local *create_be4_conf = sub {
			return 3;
	};	

	Execute->run("mkdir -p " . $root_storage . "/fake_storage/20/" . $pyramid_dir);
	Execute->run("touch " . $root_storage . "/fake_storage/20/" . $pyramid_dir . "/BROADCAST_DATA_BE4_OLD_TEST_NAME.pyr");
	ok( wms_harvesting(1234,"png","normal","false","FFFFFF",2000,2000,"SRID=4326;POLYGON((0 0,0 1,1 1,1 0,0 0))", "4326", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "false", 4, 8) == 8, "testWithRok4ConfigurationError");
	Execute->run("rm -rf " . $root_storage . "/fake_storage/20/");
	Execute->run("rm -rf " . $tmp_path . $tmp_generation . "/1234/");
}
$moduleHTTP->unmock('decoded_content');
$moduleHTTP->unmock('is_success');


our $mocked_count = 1;
$moduleHTTP->mock('is_success' , sub {return 1});
$moduleHTTP->mock('decoded_content', sub {
		if ( 1 == $mocked_count) {
			$mocked_count += 1;
			return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"layerName" : "ma_couche", "releasedOnInternZone" : "true", "login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';
		} elsif (2 == $mocked_count) {
			$mocked_count += 1;
			return '{"name" : "BROADCAST_DATA_BE4_OLD_TEST_NAME", "version" : 1,"id" : 20,"storage" : {"logicalName" : "fake_storage"} }';
		} else {
			return '{"originators":"owner2;owner1","startDate":"1970-01-01 01:03:42.222","endDate":"1970-01-01 01:05:33.334"}';
		}
	}
);
{
	local *create_be4_conf = sub {
			return 0;
	};
	
	Execute->run("mkdir -p " . $root_storage . "/fake_storage/20/" . $pyramid_dir);
	Execute->run("touch " . $root_storage . "/fake_storage/20/" . $pyramid_dir . "/BROADCAST_DATA_BE4_OLD_TEST_NAME.pyr");
	ok( wms_harvesting(1234,"png","normal","false","FFFFFF",2000,2000,"SRID=4326;POLYGON((0 0,0 1,1 1,1 0,0 0))", "4326", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "false", 10, 12) == 0, "testWithCorrectGenerationSimpleWithAncestor");
	Execute->run("rm -rf " . $root_storage . "/fake_storage/20/");
	Execute->run("rm -rf " . $tmp_path . $tmp_generation . "/1234/");
}
$moduleHTTP->unmock('decoded_content');
$moduleHTTP->unmock('is_success');


$mocked_first_call = "true";
$moduleHTTP->mock('is_success' , sub {return 1});
$moduleHTTP->mock('decoded_content', sub {
		if ("true" eq $mocked_first_call) {
			$mocked_first_call = "false";
			return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_BE4_SIMPLE_TEST_NAME", "version" : 1,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }],"inputDatas" : [{"layerName" : "ma_couche", "releasedOnInternZone" : "true", "login" : "complete_delivery_raster_ok","deliveryProduct" : {"name" : "BDORTHO"},"id" : 5}],"id" : 15}';
		} else {
			return '{"name" : "BROADCAST_DATA_BE4_OLD_TEST_NAME", "version" : 1,"id" : 20,"storage" : {"logicalName" : "fake_storage"} }';
		}
	}
);
{
	Execute->run("mkdir -p " . $root_storage . "/fake_storage/20/" . $pyramid_dir);
	Execute->run("touch " . $root_storage . "/fake_storage/20/" . $pyramid_dir . "/BROADCAST_DATA_BE4_OLD_TEST_NAME.pyr");
	ok( wms_harvesting(1234,"png","normal","false","FFFFFF",2000,2000,"POLYGON", "4326", "raw", "", "4096", "4096", "8", "uint", "rgb", "3", "bicubique", "1", "FF", "false", 4, 8) == 0, "testWithRok4ConfigurationError");
	Execute->run("rm -rf " . $root_storage . "/fake_storage/20/");
	Execute->run("rm -rf " . $tmp_path . $tmp_generation . "/1234/");
}
$moduleHTTP->unmock('decoded_content');
$moduleHTTP->unmock('is_success');