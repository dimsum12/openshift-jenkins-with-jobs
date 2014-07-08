#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 11;
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

my $dbname = $config->param("db-ent_donnees.dbname");
my $host = $config->param("db-ent_donnees.host");
my $port =  $config->param("db-ent_donnees.port");
my $username = $config->param("db-ent_donnees.username");
my $password = $config->param("db-ent_donnees.password");

my $dir_mtd_src = $resources_path."complete_delivery_vector_ok/MTDS";


require "rollback_bdd_generation.pl";



my $database = Database->connect($dbname, $host, $port, $username, $password);
$database->create_schema('test_rollback_bdd');
$database->create_schema('test_rollback_bdd_2');

system("mkdir $catalog_repository");



# Mock permettant de ne pas appeler les services REST.
# Le retour des appels est simulé par un mock spécifique à chaque test (ci dessous)
my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
        'LWP::UserAgent',
        request => sub { return HTTP::Response->new() }
);



ok( rollback_bdd_generation() == 255, "testWithoutParameters" );


my $mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 0; },
        decoded_content => sub { return '{}'; }
);
ok( rollback_bdd_generation("-1") == 1, "testWithBadGenerationId" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21, "schemaName" : "test_rollback_bdd"}],"id" : 15}'; }
);


system("mkdir $catalog_repository/INSPIRE");
system("mkdir $catalog_repository/INSPIRE/21");
system("cp -r $dir_mtd_src/* $catalog_repository/INSPIRE/21");
{
	local *rollback_harvest_metadatas = sub {return 0;};
	ok( rollback_bdd_generation("16") == 0, "testWithCorrectSchema" );
}
system ("rm -rf $catalog_repository");


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 0; },
	decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21, "schemaName" : "test_rollback_bdd"}],"id" : 15}'; }
);
ok( rollback_bdd_generation("15") == 1, "testWithUnreachableService" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
	decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21, "schemaName" : "test_rollback_bdd"},{"id" : 22, "schemaName" : "test_rollback_bdd_2"}],"id" : 15}'; }
);
ok( rollback_bdd_generation("15") == 2, "testWithMultipleBroadcastDatasOutput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
	decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21}],"id" : 15}'; }
);
ok( rollback_bdd_generation("15") == 253, "testWithNoSchemaNameBroadcastDataOutput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
	decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21, "schemaName" : ""}],"id" : 15}'; }
);
ok( rollback_bdd_generation("15") == 0, "testWithEmptySchemaNameBroadcastDataOutput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"schemaName" : "test_rollback_bdd"}],"id" : 15}'; }
);
ok( rollback_bdd_generation("15") == 253, "testWithNoIdBroadcastDataOutput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
	decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21, "schemaName" : "test_rollback_bdd_no_exist"}],"id" : 15}'; }
);
ok( rollback_bdd_generation("15") == 3, "testWithIncorrectGeneration" );




system("mkdir $catalog_repository");
system("mkdir $catalog_repository/INSPIRE");
system("mkdir $catalog_repository/INSPIRE/21");
system("cp -r $dir_mtd_src/* $catalog_repository/INSPIRE/21");
{
	local *rollback_harvest_generation = sub {return 1;};
	$database->create_schema('test_rollback_bdd');
	$mock = Test::MockObject->new();
	$mock->fake_module(
	'HTTP::Response',
	is_success => sub { return 1; },
	decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21, "schemaName" : "test_rollback_bdd"}],"id" : 15}'; }
	);
	ok( rollback_bdd_generation("16") == 5, "testWithRollbackMetadatasError" );
}
system ("rm -rf $catalog_repository");


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
ok( rollback_bdd_generation("15") == 254, "testWithJsonConversionError" );
