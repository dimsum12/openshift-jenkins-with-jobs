#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 20;
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

my $dbname = $config->param("db-ent_donnees.dbname");
my $host = $config->param("db-ent_donnees.host");
my $port =  $config->param("db-ent_donnees.port");
my $username = $config->param("db-ent_donnees.username");
my $password = $config->param("db-ent_donnees.password");

my $catalog_repository = $config->param("filer.catalog.repository");

require "bdd_update_generation.pl";
require "generate_bdd_datas.pl";


# Mock permettant de ne pas appeler les services REST.
# Le retour des appels est simulé par un mock spécifique à chaque test (ci dessous)
my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
	'LWP::UserAgent',
	request => sub { return HTTP::Response->new() }
);
# Insertion d'une base source
if (generate_bdd_datas($resources_path . "complete_delivery_vector_ok/DATAS/", "test_bdd_update_generation") != 0) {
	print "ERREUR LORS DE L'INSERTION DU SCHEMA DE TEST : IMPOSSIBLE DE CONTINUE LES TESTS";
	exit 1;
}

my $database = Database->connect($dbname, $host, $port, $username, $password);

ok( bdd_update_generation() == 255, "testWithoutParameters" );

ok( bdd_update_generation("15","TEST") == 255, "testWithWrongNumberOfParameters" );

my $mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 0; },
		decoded_content => sub { return '{"broadcastDatas" : [{"name" : "BD_PGSQL_TEST_OUTPUT","id" : 21}],"inputDatas" : [{"schemaName" : "test_bdd_update_generation", "name" : "BD_PGSQL_TEST_INPUT","projection" : "maprojection","id" : 20}],"id" : 15}'; }
);
ok( bdd_update_generation("-1", "TEST", "IGNF:LAMB93") == 1, "testWithBadGenerationId" );


$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '{"broadcastDatas" : [{"name" : "BD_PGSQL_TEST_OUTPUT","id" : 21}],"inputDatas" : [{"schemaName" : "test_bdd_update_generation", "name" : "BD_PGSQL_TEST_INPUT","projection" : "maprojection","id" : 20}],"id" : 15}'; }
);
ok( bdd_update_generation("15", "TEST","IGNF:LAMB93") == 0, "testWithCorrectGeneration" );

ok( bdd_update_generation("15","TEST", "wrooong") == 252, "testWithUnknownProjection" );

$database->drop_schema("bd_pgsql_test_output", "true");

$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '{"broadcastDatas" : [{"name" : "BD_PGSQL_TEST_OUTPUT","id" : 21}],"inputDatas" : [{"schemaName" : "test_bdd_update_generation", "name" : "BD_PGSQL_TEST_INPUT","projection" : "maprojection","id" : 20}],"id" : 15}'; }
);


{
	local *update_broadcastdata_size = sub {
		return 1;
	};
	ok( bdd_update_generation("15", "TEST","IGNF:LAMB93") == 10, "testWithKOUpdatingBroadcastdataSize" );
	
}
$database->drop_schema("bd_pgsql_test_output", "true");

$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 0; },
		decoded_content => sub { return '{"broadcastDatas" : [{"name" : "BD_PGSQL_TEST_OUTPUT","id" : 21}],"inputDatas" : [{"schemaName" : "test_bdd_update_generation", "projection" : "maprojection","name" : "BD_PGSQL_TEST_INPUT","id" : 20}],"id" : 15}'; }
);
ok( bdd_update_generation("15", "TEST","IGNF:LAMB93") == 1, "testWithUnreachableService" );


$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '{"broadcastDatas" : [{"name" : "BD_PGSQL_TEST_OUTPUT","id" : 21}],"inputDatas" : [{"schemaName" : "test_bdd_update_generation", "projection" : "maprojection","name" : "BD_PGSQL_TEST_INPUT","id" : 20}, {"schemaName" : "test_bdd_update_generation_2", "name" : "BD_PGSQL_TEST_INPUT_2","id" : 19}],"id" : 15}'; }
);
ok( bdd_update_generation("15", "TEST","IGNF:LAMB93") == 2, "testWithMultipleInputs" );


$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '{"broadcastDatas" : [{"name" : "BD_PGSQL_TEST_OUTPUT","id" : 21}],"inputDatas" : [{"name" : "BD_PGSQL_TEST_INPUT","id" : 20}],"id" : 15}'; }
);
ok( bdd_update_generation("15", "TEST","IGNF:LAMB93") == 2, "testWithNoSchemaNameInput" );



$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '{"broadcastDatas" : [{"name" : "BD_PGSQL_TEST_OUTPUT","id" : 21}],"inputDatas" : [{"name" : "BD_PGSQL_TEST_INPUT","schemaName" : "test_bdd_update_generation","id" : 20}],"id" : 15}'; }
);
ok( bdd_update_generation("15", "TEST","IGNF:LAMB93") == 2, "testWithNoSchemaNameInput" );

$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '{"broadcastDatas" : [{"name" : "BD_PGSQL_TEST_OUTPUT","id" : 21}],"inputDatas" : [{"schemaName" : "test_bdd_update_generation","projection" : "maprojection", "name" : "BD_PGSQL_TEST_INPUT"}],"id" : 15}'; }
);
ok( bdd_update_generation("15", "TEST","IGNF:LAMB93") == 253, "testWithNoIdInput");


$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '{"broadcastDatas" : [{"name" : "BD_PGSQL_TEST_OUTPUT","id" : 21}, {"name" : "BD_PGSQL_TEST_OUTPUT_2","id" : 22}],"inputDatas" : [{"schemaName" : "test_bdd_update_generation", "projection" : "maprojection","name" : "BD_PGSQL_TEST_INPUT","id" : 20}],"id" : 15}'; }
);
ok( bdd_update_generation("15", "TEST","IGNF:LAMB93") == 3, "testWithMultipleOutputs" );


$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21}],"inputDatas" : [{"schemaName" : "test_bdd_update_generation", "projection" : "maprojection","name" : "BD_PGSQL_TEST_INPUT","id" : 20}],"id" : 15}'; }
);
ok( bdd_update_generation("15", "TEST","IGNF:LAMB93") == 253, "testWithNoNameOutput" );


$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '{"broadcastDatas" : [{"name" : "BD_PGSQL_TEST_OUTPUT"}],"inputDatas" : [{"schemaName" : "test_bdd_update_generation", "projection" : "maprojection","name" : "BD_PGSQL_TEST_INPUT","id" : 20}],"id" : 15}'; }
);
ok( bdd_update_generation("15", "TEST","IGNF:LAMB93") == 253, "testWithNoIdOutput" );


$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '{"broadcastDatas" : [{"name" : "BD_PGSQL_TEST_OUTPUT","id" : 21}],"inputDatas" : [{"schemaName" : "test_bdd_update_generation","projection" : "maprojection", "name" : "BD_PGSQL_TEST_INPUT","id" : 20}],"id" : 15}'; }
);
ok( bdd_update_generation("15", "TEST_NO_EXIST","IGNF:LAMB93") == 4, "testWithBadTransformationName" );


$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '{"broadcastDatas" : [{"name" : "BD_PGSQL_TEST_OUTPUT","id" : 21}],"inputDatas" : [{"schemaName" : "test_bdd_update_generation", "projection" : "maprojection","name" : "BD_PGSQL_TEST_INPUT","id" : 20}],"id" : 15}'; }
);
$database->create_schema("bd_pgsql_test_output");
ok( bdd_update_generation("15", "TEST","IGNF:LAMB93") == 5, "testWithIncorrectGeneration" );
$database->drop_schema("bd_pgsql_test_output", "true");

our $mocked_value = 2;
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { $mocked_value = $mocked_value - 1; return $mocked_value; },
		decoded_content => sub { return '{"broadcastDatas" : [{"name" : "BD_PGSQL_TEST_OUTPUT","id" : 21}],"inputDatas" : [{"schemaName" : "test_bdd_update_generation","projection" : "maprojection", "name" : "BD_PGSQL_TEST_INPUT","id" : 20}],"id" : 15}'; }
);
ok( bdd_update_generation("15", "TEST","IGNF:LAMB93") == 6, "testWithUpdateBroadcastDataError" );


$mocked_value = 3;
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { $mocked_value = $mocked_value - 1; return $mocked_value; },
		decoded_content => sub { return '{"broadcastDatas" : [{"name" : "BD_PGSQL_TEST_OUTPUT","id" : 21}],"inputDatas" : [{"schemaName" : "test_bdd_update_generation","projection" : "maprojection", "name" : "BD_PGSQL_TEST_INPUT","id" : 20}],"id" : 15}'; }
);
ok( bdd_update_generation("15", "TEST","IGNF:LAMB93") == 8, "testWithUpdateBBoxesError" );

$database->drop_schema("bd_pgsql_test_output", "true");


$mocked_value = 4;
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { $mocked_value = $mocked_value - 1; return $mocked_value; },
		decoded_content => sub { return '{"broadcastDatas" : [{"name" : "BD_PGSQL_TEST_OUTPUT","id" : 21}],"inputDatas" : [{"schemaName" : "test_bdd_update_generation", "projection" : "maprojection","name" : "BD_PGSQL_TEST_INPUT","id" : 20}],"id" : 15}'; }
);
ok( bdd_update_generation("15", "TEST","IGNF:LAMB93") == 7, "testWithLinkingMetadatasError" );

$database->drop_schema("bd_pgsql_test_output", "true");


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return ''; }
);
$mock->fake_module(
        'JSON',
        from_json => sub ($@) { return undef; }
);
ok( bdd_update_generation("15", "TEST","IGNF:LAMB93") == 254, "testWithJsonConversionError" );



# Nettoyage des données créées en BDD
$database->drop_schema("test_bdd_update_generation", "true");
$database->disconnect();
