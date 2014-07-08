#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 21;
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
my $database = Database->connect($dbname, $host, $port, $username, $password);
require "bdd_generation.pl";


# Mock permettant de ne pas appeler les services REST.
# Le retour des appels est simulé par un mock spécifique à chaque test (ci dessous)
my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
	'LWP::UserAgent',
	request => sub { return HTTP::Response->new() }
);







ok( bdd_generation() == 255, "testWithoutParameters" );


my $mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 0; },
		decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21,"name" : "BD_PGSQL_TEST_OUTPUT"}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
ok( bdd_generation("-1") == 1, "testWithBadGenerationId" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21,"name" : "BD_PGSQL_TEST_OUTPUT"}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; 
		}
);
{
	local *harvest_generation = sub {
		return 0;
	};
	ok( bdd_generation("15") == 0, "testWithCorrectGeneration" );
}


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 22,"name" : "BD_PGSQL_TEST_OUTPUT"}],"inputDatas" : [{"login" : "complete_delivery_vector_ok_with_static","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; 
		}
);
{
	local *harvest_generation = sub {
		return 0;
	};
		
	local *generate_bdd_datas = sub {
		return 0;
	};
	
	local *bbox_from_table = sub {
		return "test";
	};
	
	ok( bdd_generation("15") == 0, "testWithCorrectGenerationWithStatic" );
}

	
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 0; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21,"name" : "BD_PGSQL_TEST_OUTPUT"}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
ok( bdd_generation("15") == 1, "testWithUnreachableService" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21,"name" : "BD_PGSQL_TEST_OUTPUT"}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}, {"login" : "complete_delivery_vector_ok2","deliveryProduct" : {"name" : "BDTOPO"},"id" : 6}],"id" : 15}'; }
);
ok( bdd_generation("15") == 2, "testWithMultipleDeliveriesInput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21,"name" : "BD_PGSQL_TEST_OUTPUT"}],"inputDatas" : [{"deliveryProduct" : {"name" : "BDTOPO"},"id" : 6}],"id" : 15}'; }
);
ok( bdd_generation("15") == 2, "testWithNoLoginDeliveryInput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21,"name" : "BD_PGSQL_TEST_OUTPUT"}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"}}],"id" : 15}'; }
);
ok( bdd_generation("15") == 253, "testWithNoIdDeliveryInput");


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21,"name" : "BD_PGSQL_TEST_OUTPUT"},{"version" : 2,"id" : 22}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
ok( bdd_generation("15") == 3, "testWithMultipleBroadcastDatasOutput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"name" : "BD_PGSQL_TEST_OUTPUT"}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
ok( bdd_generation("15") == 253, "testWithNoIdBroadcastDataOutput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
ok( bdd_generation("15") == 253, "testWithNoNameBroadcastDataOutput" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21,"name" : "BD_PGSQL_TEST_OUTPUT"}],"inputDatas" : [{"login" : "delivery_nok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
ok( bdd_generation("15") == 4, "testWithoutInformationFile" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 2,"id" : 21,"name" : "BD_PGSQL_TEST_OUTPUT"}],"inputDatas" : [{"login" : "complete_delivery_vector_nok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
ok( bdd_generation("15") == 5, "testWithIncorrectGeneration" );


our $mocked_value = 2;
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
	is_success => sub { $mocked_value = $mocked_value - 1 ; return $mocked_value; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 3,"id" : 21,"name" : "BD_PGSQL_TEST_OUTPUT"}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
ok( bdd_generation("15") == 6, "testWithUpdateBroadcastDataError" );


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
		is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 3,"id" : 21,"name" : "BD_PGSQL_TEST_OUTPUT"}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
{
	local *harvest_generation = sub {
		return 30;
	};
	
	local *generate_bdd_datas = sub {
		return 0;
	};
	
	local *bbox_from_table = sub {
		return "test";
	};

	ok( bdd_generation("15") == 7, "testWithHarvestingInpireError" );

	ok( bdd_generation("15") == 7, "testWithHarvestingIsoapError" );
};


{
	local *generate_bdd_datas = sub {
		return 0;
	};
	
	local *bbox_from_table = sub {
		return 2;
	};
	
	ok( bdd_generation("15") == 8, "testWithBBoxesGenerationError" );
};


{
	local *generate_bdd_datas = sub {
		return 0;
	};
	
	local *bbox_from_table = sub {
		return "test";
	};
	
	$mocked_value = 3;
	$mock = Test::MockObject->new();
	$mock->fake_module(
        'HTTP::Response',
	is_success => sub { $mocked_value = $mocked_value - 1 ; return $mocked_value; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 3,"id" : 21,"name" : "BD_PGSQL_TEST_OUTPUT"}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
	);
		
	ok( bdd_generation("15") == 8, "testWithUpdateBBoxesError" );
};


$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21,"name" : "BD_PGSQL_TEST_OUTPUT"}],"inputDatas" : [{"login" : "complete_delivery_vector_ok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; 
		}
);
{
	local *generate_bdd_datas = sub {
		return 0;
	};
	
	local *bbox_from_table = sub {
		return "test";
	};
	
	local *harvest_generation = sub {
		return 0;
	};
	
	local *update_broadcastdata_size = sub {
		return 1;
	};
	
	ok( bdd_generation("15") == 10, "testErrorUpdatingBdSize" );
}

	
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21,"name" : "BD_PGSQL_TEST_OUTPUT"}],"inputDatas" : [{"login" : "complete_delivery_vector_bad_static","deliveryProduct" : {"name" : "BDTOPO"},"id" : 5}],"id" : 15}'; }
);
{
	local *generate_bdd_datas = sub {
		return 0;
	};
	
	local *bbox_from_table = sub {
		return "test";
	};
	
	local *harvest_generation = sub {
		return 0;
	};
	
	local *update_broadcastdata_size = sub {
		return 1;
	};
	
	ok( bdd_generation("15") == 12, "testWithBadStaticDirectory" );
}
	
	
$mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21,"name" : "BD_PGSQL_TEST_OUTPUT", "schemaName" : "test_rollback_bdd_2"}],"id" : 15}'; }
);
$mock->fake_module(
        'JSON',
        from_json => sub ($@) { return undef; }
);
ok( bdd_generation("15") == 254, "testWithJsonConversionError" );




# Nettoyage des données créées en BDD
$database->drop_schema('BD_PGSQL_TEST_OUTPUT', 'true');
$database->disconnect();
