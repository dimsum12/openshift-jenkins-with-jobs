#!/usr/bin/perl

BEGIN {
    push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 14;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
use Cwd;

use Database;

my $config_path = cwd() . "/src/test/config/local";
our $config = new Config::Simple( $config_path . "/config_perl.ini" )
  or die Config::Simple->error();
my $resources_path = $config->param("resources.path");

my $dbname   = $config->param("db-ent_donnees.dbname");
my $host     = $config->param("db-ent_donnees.host");
my $port     = $config->param("db-ent_donnees.port");
my $username = $config->param("db-ent_donnees.username");
my $password = $config->param("db-ent_donnees.password");

require "reprocess_existing_bdd_generation.pl";
require "generate_bdd_datas.pl";

my $database = Database->connect( $dbname, $host, $port, $username, $password );

# Mock permettant de ne pas appeler les services REST.
# Le retour des appels est simulé par un mock spécifique à chaque test (ci dessous)
my $mock_global = Test::MockObject->new();
$mock_global->fake_module( 'LWP::UserAgent',
    request => sub { return HTTP::Response->new() } );

ok( reprocess_existing_bdd_generation() == 255, "testWithoutParameters" );

ok( reprocess_existing_bdd_generation("15") == 255, "testWithoutScriptDirectory" );

my $mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 0; },
    decoded_content => sub { return '{}'; }
);
ok(
    reprocess_existing_bdd_generation( "-1",
        $resources_path . "test_reprocess_existing_bdd/reprocess_scripts_ok" ) ==
      1,
    "testWithBadGenerationId"
);

# generate test source schema
generate_bdd_datas($resources_path."complete_delivery_vector_ok/DATAS/", "test_source_schema_ok");

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas" : [{"id" : 20, "schemaName" : "test_source_schema_ok", "version" : 1}], "broadcastDatas" : [{"id" : 21, "schemaName" : "test_reprocess_existing_bdd_target", "version" : 2}], "id" : 15}';
    }
);
ok(
    reprocess_existing_bdd_generation( "15",
        $resources_path . "test_reprocess_existing_bdd/reprocess_scripts_ok" ) ==
      0,
    "testWithCorrectData"
);
$database->drop_schema("test_source_schema_ok", "true");
$database->drop_schema("test_source_schema_ok_reprocessed_2", "true");
$database->revoke_schema_permissions("test_source_schema_ok");

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 0; },
    decoded_content => sub {
        return
'{"inputDatas" : [{"id" : 20, "schemaName" : "test_reprocess_existing_bdd_source"}], "broadcastDatas" : [{"id" : 21, "schemaName" : "test_reprocess_existing_bdd_target"}], "id" : 15}';
    }
);
ok(
    reprocess_existing_bdd_generation( "15",
        $resources_path . "test_reprocess_existing_bdd/reprocess_scripts_ok" ) ==
      1,
    "testWithUnreachableService"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas" : [{"id" : 20, "schemaName" : "test_reprocess_existing_bdd_source"}], "broadcastDatas" : [{"id" : 21, "schemaName" : "test_reprocess_existing_bdd_target_1"}, {"id" : 22, "schemaName" : "test_reprocess_existing_bdd_target_2"}], "id" : 15}';
    }
);
ok(
    reprocess_existing_bdd_generation( "15",
        $resources_path . "test_reprocess_existing_bdd/reprocess_scripts" ) ==
      3,
    "testWithMultipleBroadcastDatasOutput"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas" : [{"id" : 20, "schemaName" : "test_reprocess_existing_bdd_source_1"}, {"id" : 19, "schemaName" : "test_reprocess_existing_bdd_source_2"}], "broadcastDatas" : [{"id" : 21, "schemaName" : "test_reprocess_existing_bdd_target_1"}], "id" : 15}';
    }
);
ok(
    reprocess_existing_bdd_generation( "15",
        $resources_path . "test_reprocess_existing_bdd/reprocess_scripts" ) ==
      2,
    "testWithMultipleInputDatas"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas" : [{"id" : 20, "version" : 1}], "broadcastDatas" : [{"id" : 21, "schemaName" : "test_reprocess_existing_bdd_target_1", "version" : 1}], "id" : 15}';
    }
);
ok(
    reprocess_existing_bdd_generation( "15",
        $resources_path . "test_reprocess_existing_bdd/reprocess_scripts" ) ==
      253,
    "testWithNoSchemaNameInputData"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas" : [{"id" : 20, "schemaName" : "test_reprocess_existing_bdd_source", "version" : 1}], "broadcastDatas" : [{"schemaName" : "test_rollback_bdd", "version" : 1}],"id" : 15}';
    }
);
ok(
    reprocess_existing_bdd_generation( "15",
        $resources_path . "test_reprocess_existing_bdd/reprocess_scripts" ) ==
      253,
    "testWithNoIdBroadcastDataOutput"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas" : [{"schemaName" : "test_reprocess_existing_bdd_source", "version" : 1}], "broadcastDatas" : [{"id" : 21, "schemaName" : "test_rollback_bdd", "version" : 1}],"id" : 15}';
    }
);
ok(
    reprocess_existing_bdd_generation( "15",
        $resources_path . "test_reprocess_existing_bdd/reprocess_scripts" ) ==
      253,
    "testWithNoIdInputData"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas" : [{"id" : 20, "schemaName" : "test_source_schema_ok", "version" : 1}], "broadcastDatas" : [{"id" : 21, "schemaName" : "test_reprocess_existing_bdd_target"}], "id" : 15}';
    }
);
ok(
    reprocess_existing_bdd_generation( "15",
        $resources_path . "test_reprocess_existing_bdd/reprocess_scripts" ) ==
      253,
    "testWithNoVersionBroadcastDataOutput"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas" : [{"id" : 20, "schemaName" : "test_schema_not_exists", "version" : 1}], "broadcastDatas" : [{"id" : 21, "schemaName" : "test_reprocess_existing_bdd_target", "version" : 2}], "id" : 15}';
    }
);
ok(
    reprocess_existing_bdd_generation( "15",
        $resources_path . "test_reprocess_existing_bdd/reprocess_scripts" ) ==
      4,
    "testWithDataGenerationError"
);

our $mocked_value = 2;
$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success =>
      sub { $mocked_value = $mocked_value - 1; return $mocked_value; },
    decoded_content => sub {
        return
'{"inputDatas" : [{"id" : 20, "schemaName" : "test_source_schema_ok", "version" : 1}], "broadcastDatas" : [{"id" : 21, "schemaName" : "test_reprocess_existing_bdd_target", "version" : 2}], "id" : 15}';
    }
);
ok(
    reprocess_existing_bdd_generation( "15",
        $resources_path . "test_reprocess_existing_bdd/reprocess_scripts" ) ==
      5,
    "testWithUpdateBroadcastDataError"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas" : [{"id" : 20, "schemaName" : "test_reprocess_existing_bdd_source"}], "broadcastDatas" : [{"id" : 21, "schemaName" : "test_reprocess_existing_bdd_target"}], "id" : 15}';
    }
);
$mock->fake_module( 'JSON', from_json => sub ($@) { return undef; } );
ok(
    reprocess_existing_bdd_generation( "15",
        $resources_path . "test_reprocess_existing_bdd/reprocess_scripts" ) ==
      254,
    "testWithJsonConversionError"
);





