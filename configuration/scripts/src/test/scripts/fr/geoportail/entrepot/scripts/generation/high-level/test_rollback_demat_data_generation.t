# !/usr/bin/perl


BEGIN {
	push @INC, "lib";
}

use Classpath;
use Execute;
Classpath->load();

use Test::Simple tests => 7;
use Config::Simple;
use Test::MockObject;
use Test::MockModule;
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

require "rollback_demat_data_generation.pl";

my $module = new Test::MockModule('HTTP::Response');

my $module_global = new Test::MockModule('LWP::UserAgent');
$module_global->mock('request', sub { return HTTP::Response->new() });


ok( rollback_demat_data_generation() == 255, "testWithoutParameters" );


$module->mock('is_success', sub { return 1; });
$module->mock('decoded_content', sub { return '{"broadcastDatas" : [{"version" : 1}],"inputDatas" : [{"login" : "complete_delivery_demat_nok","deliveryProduct" : {"name" : "BDTOPO"}, "id" : 42}]}';});
ok( rollback_demat_data_generation("42") == 253, "testNoBroadcastDatasId" );
$module->unmock_all();


{	
	local *rollback_harvest_generation = sub {return 5;};

	our $deliveryconf = undef;
	$module->mock('is_success', sub { return 1;});
	$module->mock('decoded_content', sub { return '{"comment":null,"inputDatas":[{"type":"FTP","path":"127.0.0.1:4021","comment":null,"password":"1ps2apmm","login":"complete_delivery_demat_ok","automaticTimeout":false,"deliveryProduct":{"verificationChain":null,"name":"PVA","id":9453,"comment":null},"toDelete":null,"declarationDate":1319795566268,"name":"2008-07-21","id":13941}],"id":42,"parameters":[],"status":"SUCCESS","broadcastDatas":[{"dematerializedEntities":[{"name":"PVA3133-0141_1.0_000_19480000","id":2933,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2934,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2935,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2936,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2937,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2938,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2939,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2940,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2941,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2942,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2943,"metadatas":[]}],"version":3,"storage":{"id":122,"logicalName":"/tmp/i01a_sat1","externStorage":null},"creationDate":1319802986944,"broadcastProduct":{"owners":[],"name":"PVA_DIFF","id":9456,"comment":null},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"metadatas":[],"name":"PVA_DIFFV3","id":42}],"jenkinsBuild":{"id":297,"status":"SUCCESS","buildNumber":10},"creationDate":1319802986897}'});	
	ok( rollback_demat_data_generation("42") == 4, "testWithRollbackMetadatasError" );
	$module->unmock_all();
}


my $cpt=0;
our $deliveryconf = undef;
$module->mock('is_success', sub { if($cpt == 1){$cpt=0;return 0;}else{$cpt++;return 1;} });
$module->mock('decoded_content', sub { return '{"comment":null,"inputDatas":[{"type":"FTP","path":"127.0.0.1:4021","comment":null,"password":"1ps2apmm","login":"complete_delivery_demat_ok","automaticTimeout":false,"deliveryProduct":{"verificationChain":null,"name":"PVA","id":9453,"comment":null},"toDelete":null,"declarationDate":1319795566268,"name":"2008-07-21","id":13941}],"id":42,"parameters":[],"status":"SUCCESS","broadcastDatas":[{"dematerializedEntities":[{"name":"PVA3133-0141_1.0_000_19480000","id":2933,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2934,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2935,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2936,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2937,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2938,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2939,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2940,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2941,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2942,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2943,"metadatas":[]}],"version":3,"storage":{"id":122,"logicalName":"/tmp/i01a_sat1","externStorage":null},"creationDate":1319802986944,"broadcastProduct":{"owners":[],"name":"PVA_DIFF","id":9456,"comment":null},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"metadatas":[],"name":"PVA_DIFFV3","id":42}],"jenkinsBuild":{"id":297,"status":"SUCCESS","buildNumber":10},"creationDate":1319802986897}'});
ok( rollback_demat_data_generation("42") == 3, "testWithUpdateBroadcastDataError" );
$module->unmock_all();


$deliveryconf = undef;
$module->mock('is_success', sub { return 1;});
$module->mock('decoded_content', sub { return '{"comment":null,"inputDatas":[{"type":"FTP","path":"127.0.0.1:4021","comment":null,"password":"1ps2apmm","login":"complete_delivery_demat_ok","automaticTimeout":false,"deliveryProduct":{"verificationChain":null,"name":"PVA","id":9453,"comment":null},"toDelete":null,"declarationDate":1319795566268,"name":"2008-07-21","id":13941}],"id":42,"parameters":[],"status":"SUCCESS","broadcastDatas":[{"dematerializedEntities":[{"name":"PVA3133-0141_1.0_000_19480000","id":2933,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2934,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2935,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2936,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2937,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2938,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2939,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2940,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2941,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2942,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2943,"metadatas":[]}],"version":3,"storage":{"id":122,"logicalName":"/tmp/i01a_sat1","externStorage":null},"creationDate":1319802986944,"broadcastProduct":{"owners":[],"name":"PVA_DIFF","id":9456,"comment":null},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"metadatas":[],"name":"PVA_DIFFV3","id":42},{"version" : 1,"id" : 21}],"jenkinsBuild":{"id":297,"status":"SUCCESS","buildNumber":10},"creationDate":1319802986897}'});
ok( rollback_demat_data_generation("42") == 2, "testWithMultipleBroadcastDatasOutput" );
$module->unmock_all();


$module->mock('is_success', sub { return 0;});
ok( rollback_demat_data_generation("42") == 1, "testWithUnreachableService" );
$module->unmock_all();


$deliveryconf = undef;
$module->mock('is_success', sub { return 1;});
$module->mock('decoded_content', sub { return '{"comment":null,"inputDatas":[{"type":"FTP","path":"127.0.0.1:4021","comment":null,"password":"1ps2apmm","login":"complete_delivery_demat_ok","automaticTimeout":false,"deliveryProduct":{"verificationChain":null,"name":"PVA","id":9453,"comment":null},"toDelete":null,"declarationDate":1319795566268,"name":"2008-07-21","id":13941}],"id":42,"parameters":[],"status":"SUCCESS","broadcastDatas":[{"dematerializedEntities":[{"name":"PVA3133-0141_1.0_000_19480000","id":2933,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2934,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2935,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2936,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2937,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2938,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2939,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2940,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2941,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2942,"metadatas":[]},{"name":"PVA3133-0141_1.0_000_19480000","id":2943,"metadatas":[]}],"version":3,"storage":{"id":122,"logicalName":"/tmp/i01a_sat1","externStorage":null},"creationDate":1319802986944,"broadcastProduct":{"owners":[],"name":"PVA_DIFF","id":9456,"comment":null},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"metadatas":[],"name":"PVA_DIFFV3","id":42}],"jenkinsBuild":{"id":297,"status":"SUCCESS","buildNumber":10},"creationDate":1319802986897}'});
ok( rollback_demat_data_generation("42") == 0, "testRollbackOK" );