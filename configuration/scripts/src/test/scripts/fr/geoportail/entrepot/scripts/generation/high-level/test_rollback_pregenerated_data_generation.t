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
my $tmp_path = $config->param("resources.tmp.path");


require "rollback_pregenerated_data_generation.pl";

#create the destination folder with a test file
system('mkdir -p '.$tmp_path.'test_pregenerated_data/pregenerated_data_target_folder/21');
system('touch '.$tmp_path.'test_pregenerated_data/pregenerated_data_target_folder/21/test');

# Mock permettant de ne pas appeler les services REST.
# Le retour des appels est simulé par un mock spécifique à chaque test (ci dessous)
my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
        'LWP::UserAgent',
        request => sub { return HTTP::Response->new() }
);


ok( rollback_pregenerated_data_generation() == 255, "testWithoutParameters" );

my $mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 0; },
        decoded_content => sub { return '{}'; }
);
ok( rollback_pregenerated_data_generation("-1") == 1, "testWithBadGenerationId" );



$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21, "storage" : {"logicalName" : "'.$tmp_path.'test_pregenerated_data/pregenerated_data_target_folder"}}],"id" : 15}'; }
);
ok( rollback_pregenerated_data_generation("15") == 0, "testWithCorrectGeneration" );

$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 0; },
	decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21, "storage" : {"logicalName" : "'.$tmp_path.'test_pregenerated_data/pregenerated_data_target_folder"}}],"id" : 15}'; }
);
ok( rollback_pregenerated_data_generation("15") == 1, "testWithUnreachableService" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
	decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21, "storage" : {"logicalName" : "'.$tmp_path.'test_pregenerated_data/pregenerated_data_target_folder"}},{"id" : 22}],"id" : 15}'; }
);
ok( rollback_pregenerated_data_generation("15") == 2, "testWithMultipleBroadcastDatasOutput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"storage" : {"logicalName" : "'.$tmp_path.'test_pregenerated_data/pregenerated_data_target_folder"}}],"id" : 15}'; }
);
ok( rollback_pregenerated_data_generation("15") == 253, "testWithNoIdBroadcastDataOutput" );

$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21}],"id" : 15}'; }
);
ok( rollback_pregenerated_data_generation("15") == 253, "testWithNoStorageBroadcastDataOutput" );

$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21, "storage" : {}}],"id" : 15}'; }
);
ok( rollback_pregenerated_data_generation("15") == 253, "testWithNoStorageLogicalNameBroadcastDataOutput" );

$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21, "storage" : {"logicalName" : "'.$tmp_path.'test_pregenerated_data/pregenerated_data_target_folder"}}],"id" : 15}'; }
);
$mock->fake_module(
	'JSON',
	from_json => sub ($@) { return undef; }
);
ok( rollback_pregenerated_data_generation("15") == 254, "testWithJsonConversionError" );

# delete destination directories used for tests
`rm -rf $tmp_path/test_pregenerated_data`;
