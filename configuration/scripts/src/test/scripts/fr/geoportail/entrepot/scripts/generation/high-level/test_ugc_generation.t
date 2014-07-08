#!/usr/bin/perl

BEGIN {
    push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 24;
use Config::Simple;
use Test::MockObject;
use Execute;
use strict;
use warnings;
use Cwd;

my $config_path = cwd() . "/src/test/config/local";
our $config = new Config::Simple( $config_path . "/config_perl.ini" )
  or die Config::Simple->error();

my $root_storage = $config->param("filer.root.storage");


require "ugc_generation.pl";

# Mock permettant de ne pas appeler les services REST.
# Le retour des appels est simulé par un mock spécifique à chaque test (ci dessous)
my $mock_global = Test::MockObject->new();
$mock_global->fake_module( 'LWP::UserAgent',
    request => sub { return HTTP::Response->new() } );
$mock_global->fake_module( 'Execute', get_return => sub { return 0; } );

ok( ugc_generation() == 255, "testWithoutParameters" );

my $mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 0; },
    decoded_content => sub { return '{}'; }
);
ok( ugc_generation( "-1", "BDNYME", "french" ) == 1,
    "testWithBadGenerationId" );

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"broadcastDatas" : [{"name" : "BROADCAST_DATA_UGC_ONE_LEVEL_TEST", "version" : 1,"id" : 42,"storage" : 	{"logicalName" : "fake_storage"} }],"inputDatas" : [{"id" : 10, "schemaName" : "ign_test_pgsql_bdtopov1"}]}';
    }
);


{
	local *update_broadcastdata_size = sub { return 1;};
	ok( ugc_generation( "15", "BDNYME", "french" ) == 11,
    "testKOWhenUpdatingBdSize" );
	
}


{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "15", "BDNYME", "french" ) == 0,
    "testWithCorrectOneLevelGeneration" );
}


$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"broadcastDatas" : [{"name" : "BROADCAST_DATA_UGC_TWO_LEVEL_TEST", "version" : 1,"id" : 43,"storage" : 	{"logicalName" : "fake_storage"} }],"inputDatas" : [{"id" : 10, "schemaName" : "ign_test_pgsql_bdadressev4"}]}';
    }
);

{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "16", "BDADRESSE", "french" ) == 0,
    "testWithCorrectTwoLevelGeneration" );
}


$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"broadcastDatas" : [{"name" : "BROADCAST_DATA_UGC_TWO_LEVEL_TEST", "version" : 1,"id" : 43,"storage" : 	{"logicalName" : "fake_storage"} }],"inputDatas" : [{"id" : 10, "schemaName" : "ign_test_pgsql_bdadressev4"},{"id" : 11, "schemaName" : "ign_test_pgsql_bdadressev5"}]}';
    }
);

{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "17", "BDADRESSE", "french" ) == 0,
    "testWithCorrectTwoInputDatas" );
}


$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"broadcastDatas" : [{"name" : "BROADCAST_DATA_UGC_TWO_LEVEL_TEST", "version" : 1,"id" : 43,"storage" : 	{"logicalName" : "fake_storage"} }]}';
    }
);

{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "18", "BDADRESSE", "french" ) == 3, "testWithNoInputData" );
}


$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"broadcastDatas" : [{"name" : "BROADCAST_DATA_UGC_TWO_LEVEL_TEST", "version" : 1,"id" : 43,"storage" : 	{"logicalName" : "fake_storage"} }],"inputDatas" : [{"id" : 10, "schemaName" : "ign_test_pgsql_bdadressev4"},{"id" : 11}]}';
    }
);

{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "18", "BDADRESSE", "french" ) == 253,
    "testWithBadInputData" );
}


$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"broadcastDatas" : [{"name" : "BROADCAST_DATA_UGC_TWO_LEVEL_TEST", "version" : 1,"id" : 43,"storage" : 	{"logicalName" : "fake_storage"} },{"name" : "BROADCAST_DATA_UGC_TWO_LEVEL_TEST2", "version" : 1,"id" : 44,"storage" : 	{"logicalName" : "fake_storage"} }],"inputDatas" : [{"id" : 11, "schemaName" : "ign_test_pgsql_bdadressev5"}]}';
    }
);

{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "18", "BDADRESSE", "french" ) == 4,
    "testWithTooMuchOutputDatas" );
}


$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"broadcastDatas" : [{"name" : "BROADCAST_DATA_UGC_TWO_LEVEL_TEST", "version" : 1,"id" : 43,"storage" : 	{"id" : 1}}],"inputDatas" : [{"id" : 10, "schemaName" : "ign_test_pgsql_bdadressev4"},{"id" : 11, "schemaName" : "ign_test_pgsql_bdadressev5"}]}';
    }
);

{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "18", "BDADRESSE", "french" ) == 253,
    "testWithBadStorageLogicalName" );
}


$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"broadcastDatas" : [{"name" : "BROADCAST_DATA_UGC_ONE_LEVEL_TEST", "version" : 1,"id" : 42,"storage" : 	{"logicalName" : "fake_storage"} }],"inputDatas" : [{"id" : 10, "schemaName" : "ign_test_pgsql_bdtopov1"}]}';
    }
);
our $mocked_call;
$mock->fake_module(
    'Execute',
    get_return => sub {
        if   ( $mocked_call == 0 ) { return 1; }
        else                       { $mocked_call--; return 0; }
    }
);

$mocked_call = 0;

{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "15", "BDNYME", "french" ) == 5,
    "testWithErrorCreatingTmpDir" );
}


$mocked_call = 2;
{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "15", "NOT_EXIST", "french" ) == 6,
    "testWithErrorOpeningLevel1SQL" );
}


$mocked_call = 2;
{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "15", "BDADRESSE", "french" ) == 6,
   "testWithErrorReadingLinks" );
}


$mocked_call = 3;
{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "15", "BDADRESSE", "french" ) == 6,
    "testWithErrorReadingLevel2Point" );
}


$mocked_call = 4;
{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "15", "BDADRESSE", "french" ) == 6,
    "testWithErrorReadingLevel2Linestring" );
}


$mocked_call = 8;
{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "15", "BDADRESSE", "french" ) == 5,
    "testWithErrorCopyingBinaries" );
}


$mocked_call = 9;
{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "15", "BDADRESSE", "french" ) == 5,
    "testWithErrorCreatingArboTref" );
}

	
$mocked_call = 10;

{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "15", "BDADRESSE", "french" ) == 5,
    "testWithErrorCreatingArboAutoComp" );
}


$mocked_call = 11;
{
	local *update_broadcastdata_size = sub { return 1;};
	ok( ugc_generation( "15", "BDADRESSE", "french" ) == 7,
    "testWithErrorGeneratingTref" );
}


$mocked_call = 12;
{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "15", "BDADRESSE", "french" ) == 7,
    "testWithErrorGeneratingAutoComp" );
}


$mocked_call = 13;
{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "15", "BDADRESSE", "french" ) == 8,
    "testWithErrorCleaningTmp" );
}

	
$mocked_call = 14;

{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "15", "BDADRESSE", "french" ) == 9,
    "testWithErrorCleaningAutoCompNoFiles" );
}

my $i=0;
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { if ($i == 0) {$i= $i + 1; return 1;}else{return 0;} }
	);
$mocked_call = 15;
{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "15", "BDADRESSE", "french" ) == 10,
    "testWithErrorUpdatingBroadcastDataUGC" );
}


my $cmd = "touch $root_storage/fake_storage/42/autocomp/toto.txt; touch $root_storage/fake_storage/42/autocomp/toto.abc";
Execute->run( $cmd, "true" );
$i=0;
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { if ($i == 0) {$i= $i + 1; return 1;}else{return 0;} }
	);
$mocked_call = 15;
{
	local *update_broadcastdata_size = sub { return 0;};
	ok( ugc_generation( "15", "BDADRESSE", "french" ) == 9,
    "testWithErrorCleaningAutoComp" );
}
