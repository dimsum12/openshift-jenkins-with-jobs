#!/usr/bin/perl

BEGIN {
    push @INC, "lib";
}


use Classpath;
Classpath->load();
use Test::Simple tests =>2;
use Config::Simple;
use Test::MockObject;
use Test::MockModule;
use strict;
use warnings;
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path 			= $config->param("resources.path");
my $tmp_path         			= $config->param("resources.tmp.path");
my $tmp_extraction   			= $config->param("resources.tmp.extractions");
my $root_storage    			= $config->param("filer.root.storage");

require "rollback_extraction_boutique.pl";


# Le retour d'appel simulé par un mock spécifique à chaque test
 my $mock_global = Test::MockObject->new();
 $mock_global->fake_module(
	 'LWP::UserAgent',
	 request => sub { return HTTP::Response->new() }
);




ok(rollback_extraction_boutique() == 255, "testWithoutParameters");


# Calcul du repertoire de travail temporaire de l'extraction
my $tmp_output_storage = $tmp_path . $tmp_extraction . "/";

# Calcul de la destination de l'extraction
my $extraction_output_storage = $root_storage;
	
# copie de ressources de tests dans l'espace d'extraction
my $cmd = "cp -r ".$resources_path.'/extraction/data_extraction ' . $tmp_output_storage . '1488';
Execute->run( $cmd, "true" );

# copie de ressources de tests dans l'espace d'extraction
$cmd="cp -r ".$resources_path.'/extraction/file_download_space ' . $extraction_output_storage . 'fake/5742';
Execute->run( $cmd, "true" );

my $mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success => sub { return 1; },
    decoded_content => sub {
		return '{"managerId":"cleok","priority":1,"extractionsWMS":[{"type":"WMSVecteur","bboxes":[{"name":"1245012_12401401","id":1488,"points":"2.3,48.5,2.4,48.9"},{"name":"1245013_12401402","id":1489,"points":"2.4,48.6,2.5,49"}],"imageWidth":500,"imageHeight":500,"style":"","id":265,"layerName":"sde:commune","dataFolder":"myDataFolder","themeFolder":"mythemeFolder","outputCrs":"EPSG:4326","outputFormat":"image/jpeg","service":"WMS"}],"purchaseId":"2012-07-00001e","zipName":"extraction_boutique_0001e","rootFolder":"rootFolder","downLoadFolder":"downLoadFolder","zipMaxSize":300,"productId":"BDORTHO","packagingId":"id1","extentDescription":"Zone","geographicIdentifier":"77","isPrepackaged":null,"idsMetadatasInspireToRequest":[],"idsMetadatasIsoApToRequest":["IGNF_PVA_1-0__1980__X0145-0051.xml","IGNF_PVA_2-0__1980__X0145-0051.xml"],"id":1488,"parameters":[],"status":null,"jenkinsBuild":null,"creationDate":1320075966706,"broadcastDatas":[{"creationDate":null,"version":null,"broadcastProduct":null,"metadatas":[{"name":"metadata_bd1","id":812,"version":null,"validated":false},{"name":"metadata_bd2","id":813,"version":null,"validated":false},{"name":"metadata_bd3","id":814,"version":null,"validated":false},{"name":"metadata_bd4","id":815,"version":4,"validated":false}],"storage":{"logicalName":"fake"},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"name":"broadcastData1","id":5742}]}';
	}		
);
 
ok(rollback_extraction_boutique("1488") == 0,"testOkRollback");	
 
 


 
 
 

