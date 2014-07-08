# !/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
use Execute;
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

my $resources_path      = $config->param("resources.path");
my $catalog_repository  = $config->param("filer.catalog.repository");
my $root_storage        = $config->param("filer.root.storage");
my $tmp_path            = $config->param("resources.tmp.path");
my $tmp_generation      = $config->param("resources.tmp.generations");


require "demat_data_generation.pl";





my $module =  Test::MockObject->new();
 #my $module = new Test::MockModule('HTTP::Response');

 my $mock_global =  Test::MockObject->new();
$mock_global->fake_module( 'LWP::UserAgent',
    request => sub { return HTTP::Response->new() } );



ok( demat_data_generation() == 255, "testWithoutParameters");







$module->fake_module(
	'HTTP::Response',
	is_success      => sub { return 1; },
	decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21}],"inputDatas" : [{"login" : "complete_delivery_demat_ok","deliveryProduct" : {"name" : "BDTOPO"}}]}'; }
);
#$module->mock('is_success', sub { return 1; });
#$module->mock('decoded_content', sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21}],"inputDatas" : [{"login" :"complete_delivery_demat_ok","deliveryProduct" : {"name" : "BDTOPO"}}]}';});
ok( demat_data_generation("42") == 253, "testNoIdInputData" );


$module->fake_module(
	'HTTP::Response',
	is_success      => sub { return 1; },
	decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21}],"inputDatas" : [{"login" : "complete_delivery_demat_ok","id" : 6}]}'; }
);
#$module->mock('is_success', sub { return 1; });
#$module->mock('decoded_content', sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21}],"inputDatas" : [{"login" : "complete_delivery_demat_ok","id" : 6}]}';});
ok( demat_data_generation("42") == 253, "testNoDeliveryProductInputData" );


$module->fake_module(
	'HTTP::Response',
	is_success      => sub { return 1; },
	decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21}],"inputDatas" : [{"login" : "complete_delivery_demat_nok","deliveryProduct" : {}, "id" : 42}]}'; }
);
#$module->mock('is_success', sub { return 1; });
#$module->mock('decoded_content', sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21}],"inputDatas" : [{"login" : "complete_delivery_demat_nok","deliveryProduct" : {}, "id" : 42}]}';});
ok( demat_data_generation("42") == 253, "testNoDeliveryProductNameInputData" );


$module->fake_module(
	'HTTP::Response',
	is_success      => sub { return 1; },
	decoded_content => sub { return '{"broadcastDatas" : [{"id" : 21}],"inputDatas" : [{"login" : "complete_delivery_demat_ok","deliveryProduct" : {"name" : "BDTOPO"}, "id" : 42}]}'; }
);
#$module->mock('is_success', sub { return 1; });
#$module->mock('decoded_content', sub { return '{"broadcastDatas" : [{"id" : 21}],"inputDatas" : [{"login" : "complete_delivery_demat_ok","deliveryProduct" : {"name" : "BDTOPO"}, "id" : 42}]}';});
ok( demat_data_generation("42") == 253, "testNoBroadcastDatasVersionInputData" );



#$module->mock('is_success', sub { return 1; });
#$module->mock('decoded_content', sub { return '{"broadcastDatas" : [{"version" : 1}],"inputDatas" : [{"login" : "complete_delivery_demat_nok","deliveryProduct" : {"name" : "BDTOPO"}, "id" : 42}]}';});
ok( demat_data_generation("42") == 253, "testNoSIdInputData" );


#$module->mock('is_success', sub { return 1; });
#$module->mock('decoded_content', sub { return '{"broadcastDatas" : [{"version" : 1}],"inputDatas" : [{"login" : "complete_delivery_demat_nok","deliveryProduct" : {"name" : "BDTOPO"}, "id" : 42}]}';});
ok( demat_data_generation("42") == 253, "testNoBroadcastDatasIdInputData" );


$module->fake_module(
	'HTTP::Response',
	is_success      => sub { return 1; },
	decoded_content => sub {return '{"broadcastDatas" : [{"version" : 1,"id" : 21}],"inputDatas" : [{"login" : "complete_delivery_demat_ok","deliveryProduct" : {"name" : "BDTOPO"}, "id" : 42}]}'; }
);
#$module->mock('is_success', sub { return 1; });
#$module->mock('decoded_content', sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21}],"inputDatas" : [{"login" : "complete_delivery_demat_ok","deliveryProduct" : {"name" : "BDTOPO"}, "id" : 42}]}';});
ok( demat_data_generation("42") == 253, "testNoBroadcastDatasStorageInputData" );


$module->fake_module(
	'HTTP::Response',
	is_success      => sub { return 1; },
	decoded_content => sub {return '{"broadcastDatas" : [{"version" : 1,"id" : 21, "storage":{"id":122,"externStorage":null}}],"inputDatas" : [{"login" : "complete_delivery_demat_nok","deliveryProduct" : {"name" : "BDTOPO"}, "id" : 42}]}'; }
);
#$module->mock('is_success', sub { return 1; });
#$module->mock('decoded_content', sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21, "storage":{"id":122,"externStorage":null}}],"inputDatas" : [{"login" : "complete_delivery_demat_nok","deliveryProduct" : {"name" : "BDTOPO"}, "id" : 42}]}';});
ok( demat_data_generation("42") == 253, "testNoBroadcastDatasStorageLogicalNameInputData" );


$module->fake_module(
	'HTTP::Response',
	is_success      => sub { return 0 }
);
#$module->mock('is_success', sub { return 0; });
ok( demat_data_generation("42") == 1, "testWithBadGenerationId" );


$module->fake_module(
	'HTTP::Response',
	is_success      => sub { return 1; },
	decoded_content => sub {return '{"broadcastDatas" : [{"version" : 1,"id" : 21}],"inputDatas" : [{"type":"FTP","path":"127.0.0.1:4021","comment":null,"password":"1ps2apmm","login":"complete_delivery_demat_nok","automaticTimeout":false,"deliveryProduct":{"verificationChain":null,"name":"PVA","id":9453,"comment":null},"toDelete":null,"declarationDate":1319795566268,"name":"2008-07-21","id":13941}, {"login" : "complete_delivery_demat_nok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 6}],"id" : 42}'; }
);
#$module->mock('is_success', sub { return 1; });
#$module->mock('decoded_content', sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21}],"inputDatas" : [{"type":"FTP","path":"127.0.0.1:4021","comment":null,"password":"1ps2apmm","login":"complete_delivery_demat_nok","automaticTimeout":false,"deliveryProduct":{"verificationChain":null,"name":"PVA","id":9453,"comment":null},"toDelete":null,"declarationDate":1319795566268,"name":"2008-07-21","id":13941}, {"login" : "complete_delivery_demat_nok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 6}],"id" : 42}';});
ok( demat_data_generation("42") == 2, "testWithMultipleDeliveriesInput" );



$module->fake_module(
	'HTTP::Response',
	is_success      => sub { return 1; },
	decoded_content => sub {return '{"broadcastDatas" : [{"version" : 1,"id" : 21}],"inputDatas" : [], "id" : 42}';}
);
#$module->mock('is_success', sub { return 1; });
#$module->mock('decoded_content', sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21}],"inputDatas" : [], "id" : 42}';});
ok( demat_data_generation("42") == 2, "testWithNoDeliveriesInput" );


$module->fake_module(
	'HTTP::Response',
	is_success      => sub { return 1; },
	decoded_content => sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21}, {"version" : 1,"id" : 21}],"inputDatas" : [{"login" : "complete_delivery_demat_nok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 6}],"id" : 42}'; }
);
#$module->mock('is_success', sub { return 1; });
#$module->mock('decoded_content', sub { return '{"broadcastDatas" : [{"version" : 1,"id" : 21}, {"version" : 1,"id" : 21}],"inputDatas" : [{"login" : "complete_delivery_demat_nok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 6}],"id" : 42}';});
ok( demat_data_generation("42") == 3, "testWithMultipleBroadcastDatasOutput" );


$module->fake_module(
	'HTTP::Response',
	is_success      => sub { return 1; },
	decoded_content => sub {return '{"broadcastDatas" : [],"inputDatas" : [{"login" : "complete_delivery_demat_nok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 6}],"id" : 42}'; }
);
#$module->mock('is_success', sub { return 1; });
#$module->mock('decoded_content', sub { return '{"broadcastDatas" : [],"inputDatas" : [{"login" : "complete_delivery_demat_nok","deliveryProduct" : {"name" : "BDTOPO"},"id" : 6}],"id" : 42}';});
ok( demat_data_generation("42") == 3, "testWithNoBroadcastDatasOutput" );



our $deliveryconf = undef;
$module->fake_module(
	'HTTP::Response',
	is_success      => sub { return 1; },
	decoded_content => sub {return '{"comment":null,"inputDatas":[{"type":"FTP","path":"127.0.0.1:4021","comment":null,"password":"1ps2apmm","login":"complete_delivery_demat_nok","automaticTimeout":false,"deliveryProduct":{"verificationChain":null,"name":"PVA","id":9453,"comment":null},"toDelete":null,"declarationDate":1319795566268,"name":"2008-07-21","id":13941}],"id":42,"parameters":[],"status":"SUCCESS","broadcastDatas":[{"dematerializedEntities":[{"name":"PVA3133-0141_1.0_000_19480000","id":2933,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2934,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2935,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2936,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2937,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2938,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2939,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2940,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2941,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2942,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2943,"metadatas":[]}],"version":3,"storage":{"id":122,"logicalName":"/tmp/i01a_sat1","externStorage":null},"creationDate":1319802986944,"broadcastProduct":{"owners":[],"name":"PVA_DIFF","id":9456,"comment":null},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"metadatas":[],"name":"PVA_DIFFV3","id":13960}],"jenkinsBuild":{"id":297,"status":"SUCCESS","buildNumber":10},"creationDate":1319802986897}' }
);
#$module->mock('is_success', sub { return 1; });
#$module->mock('decoded_content', sub { return '{"comment":null,"inputDatas":[{"type":"FTP","path":"127.0.0.1:4021","comment":null,"password":"1ps2apmm","login":"complete_delivery_demat_nok","automaticTimeout":false,"deliveryProduct":{"verificationChain":null,"name":"PVA","id":9453,"comment":null},"toDelete":null,"declarationDate":1319795566268,"name":"2008-07-21","id":13941}],"id":42,"parameters":[],"status":"SUCCESS","broadcastDatas":[{"dematerializedEntities":[{"name":"PVA3133-0141_1.0_000_19480000","id":2933,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2934,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2935,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2936,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2937,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2938,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2939,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2940,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2941,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2942,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2943,"metadatas":[]}],"version":3,"storage":{"id":122,"logicalName":"/tmp/i01a_sat1","externStorage":null},"creationDate":1319802986944,"broadcastProduct":{"owners":[],"name":"PVA_DIFF","id":9456,"comment":null},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"metadatas":[],"name":"PVA_DIFFV3","id":13960}],"jenkinsBuild":{"id":297,"status":"SUCCESS","buildNumber":10},"creationDate":1319802986897}'});
ok( demat_data_generation("42") == 4, "testWithoutInformationFile" );



$deliveryconf = undef;
$module->fake_module(
	'HTTP::Response',
	is_success      => sub { return 1; },
	decoded_content => sub {return '{"comment":null,"inputDatas":[{"type":"FTP","path":"127.0.0.1:4021","comment":null,"password":"1ps2apmm","login":"complete_delivery_demat_ok","automaticTimeout":false,"deliveryProduct":{"verificationChain":null,"name":"PVA","id":9453,"comment":null},"toDelete":null,"declarationDate":1319795566268,"name":"2008-07-21","id":13941}],"id":42,"parameters":[],"status":"SUCCESS","broadcastDatas":[{"dematerializedEntities":[{"name":"PVA3133-0141_1.0_000_19480000","id":2933,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2934,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2935,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2936,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2937,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2938,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2939,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2940,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2941,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2942,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2943,"metadatas":[]}],"version":3,"storage":{"id":122,"logicalName":"atmp/i01a_sat1","externStorage":null},"creationDate":1319802986944,"broadcastProduct":{"owners":[],"name":"PVA_DIFF","id":9456,"comment":null},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"metadatas":[],"name":"PVA_DIFFV3","id":42}],"jenkinsBuild":{"id":297,"status":"SUCCESS","buildNumber":10},"creationDate":1319802986897}' }
);
#$module->mock('is_success', sub { return 1; });
#$module->mock('decoded_content', sub { return '{"comment":null,"inputDatas":[{"type":"FTP","path":"127.0.0.1:4021","comment":null,"password":"1ps2apmm","login":"complete_delivery_demat_ok","automaticTimeout":false,"deliveryProduct":{"verificationChain":null,"name":"PVA","id":9453,"comment":null},"toDelete":null,"declarationDate":1319795566268,"name":"2008-07-21","id":13941}],"id":42,"parameters":[],"status":"SUCCESS","broadcastDatas":[{"dematerializedEntities":[{"name":"PVA3133-0141_1.0_000_19480000","id":2933,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2934,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2935,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2936,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2937,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2938,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2939,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2940,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2941,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2942,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2943,"metadatas":[]}],"version":3,"storage":{"id":122,"logicalName":"atmp/i01a_sat1","externStorage":null},"creationDate":1319802986944,"broadcastProduct":{"owners":[],"name":"PVA_DIFF","id":9456,"comment":null},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"metadatas":[],"name":"PVA_DIFFV3","id":42}],"jenkinsBuild":{"id":297,"status":"SUCCESS","buildNumber":10},"creationDate":1319802986897}'});
###ok( demat_data_generation("42") == 5, "testWithCopyError" );



my $cpt = 0;
$deliveryconf = undef;
$module->fake_module(
	'HTTP::Response',
	is_success      => sub {if($cpt == 1){$cpt=0;return 0;}else{$cpt++;return 1;} },
	decoded_content => sub {return '{"comment":null,"inputDatas":[{"type":"FTP","path":"127.0.0.1:4021","comment":null,"password":"1ps2apmm","login":"complete_delivery_demat_ok","automaticTimeout":false,"deliveryProduct":{"verificationChain":null,"name":"PVA","id":9453,"comment":null},"toDelete":null,"declarationDate":1319795566268,"name":"2008-07-21","id":13941}],"id":42,"parameters":[],"status":"SUCCESS","broadcastDatas":[{"dematerializedEntities":[{"name":"PVA3133-0141_1.0_000_19480000","id":2933,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2934,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2935,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2936,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2937,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2938,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2939,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2940,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2941,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2942,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2943,"metadatas":[]}],"version":3,"storage":{"id":122,"logicalName":"tmp/i01a_sat1","externStorage":null},"creationDate":1319802986944,"broadcastProduct":{"owners":[],"name":"PVA_DIFF","id":9456,"comment":null},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"metadatas":[],"name":"PVA_DIFFV3","id":42}],"jenkinsBuild":{"id":297,"status":"SUCCESS","buildNumber":10},"creationDate":1319802986897}' }
);
#$module->mock('is_success', sub { if($cpt == 1){$cpt=0;return 0;}else{$cpt++;return 1;} });
#$module->mock('decoded_content', sub { return '{"comment":null,"inputDatas":[{"type":"FTP","path":"127.0.0.1:4021","comment":null,"password":"1ps2apmm","login":"complete_delivery_demat_ok","automaticTimeout":false,"deliveryProduct":{"verificationChain":null,"name":"PVA","id":9453,"comment":null},"toDelete":null,"declarationDate":1319795566268,"name":"2008-07-21","id":13941}],"id":42,"parameters":[],"status":"SUCCESS","broadcastDatas":[{"dematerializedEntities":[{"name":"PVA3133-0141_1.0_000_19480000","id":2933,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2934,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2935,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2936,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2937,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2938,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2939,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2940,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2941,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2942,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2943,"metadatas":[]}],"version":3,"storage":{"id":122,"logicalName":"tmp/i01a_sat1","externStorage":null},"creationDate":1319802986944,"broadcastProduct":{"owners":[],"name":"PVA_DIFF","id":9456,"comment":null},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"metadatas":[],"name":"PVA_DIFFV3","id":42}],"jenkinsBuild":{"id":297,"status":"SUCCESS","buildNumber":10},"creationDate":1319802986897}'});
Execute->run( "chmod -R 777 $root_storage/tmp/i01a_sat1", "true" );
Execute->run( "rm -rf $root_storage/tmp/i01a_sat1", "true" );
ok( demat_data_generation("42") == 7, "testWithUpdateBroadcastDataError" );
Execute->run( "chmod -R 777 $root_storage/tmp/i01a_sat1", "true" );
Execute->run( "rm -rf $root_storage/tmp/i01a_sat1", "true" );



$deliveryconf = undef;
$module->fake_module(
	'HTTP::Response',
	is_success      => sub { return 1; },
	decoded_content => sub {return '{"comment":null,"inputDatas":[{"type":"FTP","path":"127.0.0.1:4021","comment":null,"password":"1ps2apmm","login":"complete_delivery_demat_ok","automaticTimeout":false,"deliveryProduct":{"verificationChain":null,"name":"PVA","id":9453,"comment":null},"toDelete":null,"declarationDate":1319795566268,"name":"2008-07-21","id":13941}],"id":42,"parameters":[],"status":"SUCCESS","broadcastDatas":[{"dematerializedEntities":[{"name":"PVA3133-0141_1.0_000_19480000","id":2933,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2934,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2935,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2936,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2937,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2938,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2939,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2940,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2941,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2942,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2943,"metadatas":[]}],"version":3,"storage":{"id":122,"logicalName":"tmp/i01a_sat1","externStorage":null},"creationDate":1319802986944,"broadcastProduct":{"owners":[],"name":"PVA_DIFF","id":9456,"comment":null},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"metadatas":[],"name":"PVA_DIFFV3","id":42}],"jenkinsBuild":{"id":297,"status":"SUCCESS","buildNumber":10},"creationDate":1319802986897}' }
);
#$module->mock('is_success', sub { return 1;});
#$module->mock('decoded_content', sub { return '{"comment":null,"inputDatas":[{"type":"FTP","path":"127.0.0.1:4021","comment":null,"password":"1ps2apmm","login":"complete_delivery_demat_ok","automaticTimeout":false,"deliveryProduct":{"verificationChain":null,"name":"PVA","id":9453,"comment":null},"toDelete":null,"declarationDate":1319795566268,"name":"2008-07-21","id":13941}],"id":42,"parameters":[],"status":"SUCCESS","broadcastDatas":[{"dematerializedEntities":[{"name":"PVA3133-0141_1.0_000_19480000","id":2933,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2934,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2935,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2936,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2937,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2938,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2939,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2940,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2941,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2942,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2943,"metadatas":[]}],"version":3,"storage":{"id":122,"logicalName":"tmp/i01a_sat1","externStorage":null},"creationDate":1319802986944,"broadcastProduct":{"owners":[],"name":"PVA_DIFF","id":9456,"comment":null},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"metadatas":[],"name":"PVA_DIFFV3","id":42}],"jenkinsBuild":{"id":297,"status":"SUCCESS","buildNumber":10},"creationDate":1319802986897}'});
{
	local *harvest_generation = sub {
		return 30;
	};

	
	
	
	ok( demat_data_generation("42") == 8, "testWithHarvestingInpireError" );
	Execute->run( "chmod -R 777 $root_storage/tmp/i01a_sat1", "true" );
	Execute->run( "rm -rf $root_storage/tmp/i01a_sat1", "true" );


	ok( demat_data_generation("42") == 8, "testWithHarvestingIsoapError" );
	Execute->run( "chmod -R 777 $root_storage/tmp/i01a_sat1", "true" );
	Execute->run( "rm -rf $root_storage/tmp/i01a_sat1", "true" );
};


$module->fake_module(
	'HTTP::Response',
	is_success      => sub { return 1; },
	decoded_content => sub {return '{"comment":null,"inputDatas":[{"type":"FTP","path":"127.0.0.1:4021","comment":null,"password":"1ps2apmm","login":"complete_delivery_demat_ok","automaticTimeout":false,"deliveryProduct":{"verificationChain":null,"name":"PVA","id":9453,"comment":null},"toDelete":null,"declarationDate":1319795566268,"name":"2008-07-21","id":13941}],"id":42,"parameters":[],"status":"SUCCESS","broadcastDatas":[{"dematerializedEntities":[{"name":"PVA3133-0141_1.0_000_19480000","id":2933,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2934,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2935,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2936,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2937,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2938,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2939,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2940,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2941,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2942,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2943,"metadatas":[]}],"version":3,"storage":{"id":122,"logicalName":"tmp/i01a_sat1","externStorage":null},"creationDate":1319802986944,"broadcastProduct":{"owners":[],"name":"PVA_DIFF","id":9456,"comment":null},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"metadatas":[],"name":"PVA_DIFFV3","id":42}],"jenkinsBuild":{"id":297,"status":"SUCCESS","buildNumber":10},"creationDate":1319802986897}' }
);
#$module->mock('is_success', sub { return 0;});
#$module->mock('decoded_content', sub { return '{"comment":null,"inputDatas":[{"type":"FTP","path":"127.0.0.1:4021","comment":null,"password":"1ps2apmm","login":"complete_delivery_demat_ok","automaticTimeout":false,"deliveryProduct":{"verificationChain":null,"name":"PVA","id":9453,"comment":null},"toDelete":null,"declarationDate":1319795566268,"name":"2008-07-21","id":13941}],"id":42,"parameters":[],"status":"SUCCESS","broadcastDatas":[{"dematerializedEntities":[{"name":"PVA3133-0141_1.0_000_19480000","id":2933,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2934,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2935,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2936,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2937,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2938,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2939,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2940,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2941,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2942,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2943,"metadatas":[]}],"version":3,"storage":{"id":122,"logicalName":"tmp/i01a_sat1","externStorage":null},"creationDate":1319802986944,"broadcastProduct":{"owners":[],"name":"PVA_DIFF","id":9456,"comment":null},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"metadatas":[],"name":"PVA_DIFFV3","id":42}],"jenkinsBuild":{"id":297,"status":"SUCCESS","buildNumber":10},"creationDate":1319802986897}'});
{
	local *harvest_generation = sub {
		return 0;
	};
	local *update_broadcastdata_size = sub { return 1;};
	ok( demat_data_generation("2946") == 10, "testWithDemaErrorUpdatingBdSize");
	Execute->run( "chmod -R 777 $root_storage/tmp/i01a_sat1", "true" );
	Execute->run( "rm -rf $root_storage/tmp/i01a_sat1", "true" );
};



$module->fake_module(
	'HTTP::Response',
	is_success      => sub { return 1; },
	decoded_content => sub {return '{"comment":null,"inputDatas":[{"type":"FTP","path":"127.0.0.1:4021","comment":null,"password":"1ps2apmm","login":"complete_delivery_demat_ok","automaticTimeout":false,"deliveryProduct":{"verificationChain":null,"name":"PVA","id":9453,"comment":null},"toDelete":null,"declarationDate":1319795566268,"name":"2008-07-21","id":13941}],"id":42,"parameters":[],"status":"SUCCESS","broadcastDatas":[{"dematerializedEntities":[{"name":"PVA3133-0141_1.0_000_19480000","id":2933,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2934,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2935,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2936,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2937,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2938,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2939,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2940,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2941,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2942,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2943,"metadatas":[]}],"version":3,"storage":{"id":122,"logicalName":"tmp/i01a_sat1","externStorage":null},"creationDate":1319802986944,"broadcastProduct":{"owners":[],"name":"PVA_DIFF","id":9456,"comment":null},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"metadatas":[],"name":"PVA_DIFFV3","id":42}],"jenkinsBuild":{"id":297,"status":"SUCCESS","buildNumber":10},"creationDate":1319802986897}' }
);
#$module->mock('is_success', sub { return 1;});
#$module->mock('decoded_content', sub { return '{"comment":null,"inputDatas":[{"type":"FTP","path":"127.0.0.1:4021","comment":null,"password":"1ps2apmm","login":"complete_delivery_demat_ok","automaticTimeout":false,"deliveryProduct":{"verificationChain":null,"name":"PVA","id":9453,"comment":null},"toDelete":null,"declarationDate":1319795566268,"name":"2008-07-21","id":13941}],"id":42,"parameters":[],"status":"SUCCESS","broadcastDatas":[{"dematerializedEntities":[{"name":"PVA3133-0141_1.0_000_19480000","id":2933,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2934,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2935,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2936,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2937,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2938,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2939,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2940,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2941,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2942,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2943,"metadatas":[]}],"version":3,"storage":{"id":122,"logicalName":"tmp/i01a_sat1","externStorage":null},"creationDate":1319802986944,"broadcastProduct":{"owners":[],"name":"PVA_DIFF","id":9456,"comment":null},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"metadatas":[],"name":"PVA_DIFFV3","id":42}],"jenkinsBuild":{"id":297,"status":"SUCCESS","buildNumber":10},"creationDate":1319802986897}'});
{
	local *harvest_generation = sub {
		return 0;
	};
	local *update_broadcastdata_size = sub { return 0;};
	ok( demat_data_generation("2946") == 0, "testWithDematOk");
	Execute->run( "chmod -R 777 $root_storage/tmp/i01a_sat1", "true" );
	Execute->run( "rm -rf $root_storage/tmp/i01a_sat1", "true" );
};







Execute->run( "chmod -R 777 $root_storage/tmp/i01a_sat1", "true" );
Execute->run( "rm -rf $root_storage/tmp/i01a_sat1", "true" );
