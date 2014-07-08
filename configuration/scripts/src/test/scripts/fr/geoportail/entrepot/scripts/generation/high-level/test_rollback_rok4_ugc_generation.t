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
no warnings 'redefine';
use Cwd;

use Database;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
my $catalog_repository = $config->param("filer.catalog.repository");
my $root_storage     = $config->param("filer.root.storage");
my $tmp_path        = $config->param("resources.tmp.path");
my $tmp_generation  = $config->param("resources.tmp.generations");


require "rollback_rok4_ugc_generation.pl";



# Mock permettant de ne pas appeler les services REST.
# Le retour des appels est simulé par un mock spécifique à chaque test (ci dessous)
my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
        'LWP::UserAgent',
        request => sub { return HTTP::Response->new() }
);

# Mock global pour le rollback du harvesting des métadonnées
local *rollback_harvest_generation = sub { return 0; };


ok( rollback_rok4_ugc_generation() == 255, "testWithoutParameters" );


my $mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 0; },
        decoded_content => sub { return '{}'; }
);
ok( rollback_rok4_ugc_generation("-1") == 1, "testWithBadGenerationId" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 0; },
	decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21, "schemaName" : "test_rollback_bdd"}],"id" : 15}'; }
);
ok( rollback_rok4_ugc_generation("15") == 1, "testWithUnreachableService" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
	decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21, "schemaName" : "test_rollback_bdd"},{"id" : 22, "schemaName" : "test_rollback_bdd_2"}],"id" : 15}'; }
);
ok( rollback_rok4_ugc_generation("15") == 2, "testWithMultipleBroadcastDatasOutput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
	decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21}],"id" : 15}'; }
);
ok( rollback_rok4_ugc_generation("15") == 253, "testWithNoStorageBroadcastDatas" );


my $data_dir = $root_storage . '/fake_storage/21';
my $tmp_dir = $tmp_path . $tmp_generation . '/15/';
`mkdir -p $data_dir`;
`mkdir -p $tmp_dir`;
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
		decoded_content => sub {
			return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_ROLLBACK_TEST_NAME", "version" : 2,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }]}';
		}
);
ok( rollback_rok4_ugc_generation("15") == 0 && `ls -1 $data_dir | wc -l` == 0 && `ls -1 $tmp_dir | wc -l` == 0, "testWithCorrectBroadcastDatas" );


$data_dir = $root_storage . '/fake_storage/21';
$tmp_dir = $tmp_path . $tmp_generation . '/15/';
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
		decoded_content => sub {
			return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_ROLLBACK_TEST_NAME", "version" : 2,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }]}';
		}
);
ok( rollback_rok4_ugc_generation("15") == 0 && `ls -1 $data_dir | wc -l` == 0 && `ls -1 $tmp_dir | wc -l` == 0, "testWithNotYetGeneratedBroadcastDatas" );


$data_dir = $root_storage . '/fake_storage/21';
$tmp_dir = $tmp_path . $tmp_generation . '/15/';
`mkdir -p $data_dir`;
`mkdir -p $tmp_dir`;
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
		decoded_content => sub {
			return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_ROLLBACK_TEST_NAME", "version" : 2,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }]}';
		}
);
{
	local *delete_data = sub { return 2; };
	ok( rollback_rok4_ugc_generation("15") == 3 && `ls -1 $data_dir | wc -l` == 0 && `ls -1 $tmp_dir | wc -l` == 0, "testWithDeletingError" );
}
`rmdir $data_dir`;
`rmdir $tmp_dir`;


{
	local *rollback_harvest_generation = sub { return 1; };
	
	$mock = Test::MockObject->new();
	$mock->fake_module(
			'HTTP::Response',
			is_success => sub { return 1; },
			decoded_content => sub {
				return '{"broadcastDatas" : [{"name" : "BROADCAST_DATA_ROLLBACK_TEST_NAME", "version" : 2,"id" : 21,"storage" : {"logicalName" : "fake_storage"} }]}';
			}
	);
	ok( rollback_rok4_ugc_generation("15") == 4, "testWithErrorRollbackingMetadatas" );
}

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
ok( rollback_rok4_ugc_generation("15") == 254, "testWithJsonConversionError" );

