#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 18;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
my $tmp_path = $config->param("resources.tmp.path");
my $root_storage = $config->param("filer.root.storage");

require "pregenerated_data_generation.pl";

# create destination directories used for tests
`mkdir -p $tmp_path/test_pregenerated_data/pregenerated_data_target_folder`;

# Mock permettant de ne pas appeler les services REST.
# Le retour des appels est simulé par un mock spécifique à chaque test (ci dessous)
my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
	'LWP::UserAgent',
	request => sub { return HTTP::Response->new() }
);

ok( pregenerated_data_generation() == 255, "testWithoutParameters" );

my $mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 0; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21, "storage" : {"logicalName" : "pregenerated_data_target_folder"}}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
ok( pregenerated_data_generation("-1") == 1, "testWithBadGenerationId" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21, "storage" : {"logicalName" : "pregenerated_data_target_folder"}}],"inputDatas" : [{"login" : "complete_delivery_prepackaged","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);

ok( pregenerated_data_generation("15") == 0, "testWithCorrectGeneration" );

# give write permission in order to delete generated data
system('chmod -R a+w '.$root_storage.'pregenerated_data_target_folder/21');
# delete generation data
system('rm -rf '.$root_storage.'pregenerated_data_target_folder/21');

$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21, "storage" : {"logicalName" : "pregenerated_data_target_folder"}}],"inputDatas" : [{"login" : "complete_delivery_prepackaged","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
{
	local *update_broadcastdata_size = sub {
		return 1;
	};
	ok( pregenerated_data_generation("15") == 9, "testKoUpdatingBroadcastdataSize" );
	
}


# give write permission in order to delete generated data
system('chmod -R a+w '.$root_storage.'pregenerated_data_target_folder/21');
# delete generation data
system('rm -rf '.$root_storage.'pregenerated_data_target_folder/21');








$mock = Test::MockObject->new();
$mock->fake_module(
       'HTTP::Response',
        is_success => sub { return 0; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21, "storage" : {"logicalName" : "pregenerated_data_target_folder"}}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
ok( pregenerated_data_generation("15") == 1, "testWithUnreachableService" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21, "storage" : {"logicalName" : "pregenerated_data_target_folder"}}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}, {"login" : "complete_delivery_vector_ok2","deliveryProduct" : {"name" : "BDTOPO"},"id" : 6}],"id" : 15}'; }
);
ok( pregenerated_data_generation("15") == 2, "testWithMultipleDeliveriesInput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21, "storage" : {"logicalName" : "pregenerated_data_target_folder"}}],"inputDatas" : [{"deliveryProduct" : {"name" : "BDTOPO"},"id" : 6}],"id" : 15}'; }
);
ok( pregenerated_data_generation("15") == 2, "testWithNoLoginDeliveryInput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21, "storage" : {"logicalName" : "pregenerated_data_target_folder"}}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"}}],"id" : 15}'; }
);
ok( pregenerated_data_generation("15") == 253, "testWithNoIdDeliveryInput");


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21, "storage" : {"logicalName" : "pregenerated_data_target_folder"}}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","id" : 5}],"id" : 15}'; }
);
ok( pregenerated_data_generation("15") == 253, "testWithNoDeliveryProductInput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21, "storage" : {"logicalName" : "pregenerated_data_target_folder"}}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"useless" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
ok( pregenerated_data_generation("15") == 253, "testWithNoNameDeliveryProductInput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21, "storage" : {"logicalName" : "pregenerated_data_target_folder"}},{"version" : 2,"id" : 22, "storage" : {"logicalName" : "'.$resources_path.'test_pregenerated_data/pregenerated_data_target_folder"}}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
ok( pregenerated_data_generation("15") == 3, "testWithMultipleBroadcastDatasOutput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21, "storage" : {"logicalName" : "pregenerated_data_target_folder"}}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
ok( pregenerated_data_generation("15") == 253, "testWithNoVersionBroadcastDataOutput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1, "storage" : {"logicalName" : "pregenerated_data_target_folder"}}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
ok( pregenerated_data_generation("15") == 253, "testWithNoIdBroadcastDataOutput" );

$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1, "id" : 21}], "inputDatas" : [{"login" : "complete_delivery_vector_ok", "deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
ok( pregenerated_data_generation("15") == 253, "testWithNoStorageBroadcastDataOutput" );

$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1, "id" : 21, "storage" : {}}],"inputDatas" : [{"login" : "complete_delivery_vector_ok", "deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
ok( pregenerated_data_generation("15") == 253, "testWithNoStorageLogicalNameBroadcastDataOutput" );

$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21, "storage" : {"logicalName" : "pregenerated_data_target_folder"}}],"inputDatas" : [{"login" : "delivery_nok" ,"deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
ok( pregenerated_data_generation("15") == 4, "testWithoutInformationFile" );

our $mocked_value = 2;
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { $mocked_value = $mocked_value - 1; return $mocked_value; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21, "storage" : {"logicalName" : "pregenerated_data_target_folder"}}],"inputDatas" : [{"login" : "complete_delivery_prepackaged","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
ok( pregenerated_data_generation("15") == 7, "testWithUpdateBroadcastDataError" );

$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21, "schemaName" : "test_rollback_bdd_2"}],"id" : 15}'; }
);
$mock->fake_module(
        'JSON',
        from_json => sub ($@) { return undef; }
);
ok( pregenerated_data_generation("15") == 254, "testWithJsonConversionError" );

# delete destination directories used for tests
system('rm -rf '.$root_storage.'pregenerated_data_target_folder/21');
