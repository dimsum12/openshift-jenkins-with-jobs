#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 9;
use Config::Simple;
use Test::MockObject;
use Test::MockModule;
use strict;
use warnings;
use Cwd;

use Database;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new("test_harvest_metadatas.pl", $logger_levels);

my $resources_path = $config->param("resources.path");
my $catalog_repository = $config->param("filer.catalog.repository");

require "harvest_metadatas.pl";

system("mkdir -p $catalog_repository");

my $module_global = new Test::MockModule('LWP::UserAgent');
$module_global->mock('request', sub { return HTTP::Response->new() });

my $module = new Test::MockModule('HTTP::Response');


ok( harvest_metadatas() == 255, "Test sans paramètre" );


my $cpt = 0;
$module->mock('is_success', sub { return 1; });
$module->mock('content', sub { 
	my $return = "<?xml version='1.0' encoding='utf-8' ?>";
	$return = $return."<csw:CrawlResponse xmlns:csw=\"http://www.opengis.net/cat/csw/2.0.2\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:dcterms=\"http://purl.org/dc/terms/\" xmlns:ows=\"http://www.opengis.net/ows\" xmlns:erdas=\"http://www.erdas.com/cat/isoap\">";
	$return = $return."<erdas:crawlStatus>finished</erdas:crawlStatus>";
	$return = $return."<erdas:id>43834727-63b8-42b6-af57-9c46fb8b8049</erdas:id>";
	$return = $return."<erdas:folder>/FILERS/i03a_sat3/catalog-integration/INSPIRE/67</erdas:folder>";
	$return = $return."<erdas:failure count=\"0\"></erdas:failure>";
	$return = $return."<erdas:success count=\"4\">";
	$return = $return."<erdas:id>IGNF_PVA_1-0__1980__X0145-0051_V21.xml</erdas:id>";
	$return = $return."<erdas:id>IGNF_PVA_1-0__1980__X0145-0052_V5.xml</erdas:id>";
	$return = $return."<erdas:id>IGNF_PVA_1-0__1980__X0145-0053_V106.xml</erdas:id>";
	$return = $return."<erdas:id>IGNF_PVA_1-0__1980__X0145-0054_V1.xml</erdas:id>";
	$return = $return."</erdas:success>";
	$return = $return."</csw:CrawlResponse>";
	return $return;
});
ok( harvest_metadatas($resources_path."complete_delivery_vector_ok/MTDS", $catalog_repository."/id_broacast_data", "INSPIRE") == 0, "Test avec des métadonnées INSPIRE");


ok( harvest_metadatas($resources_path."complete_delivery_vector_ok/MTDS", $catalog_repository."/id_broacast_data", "ISO") == 0, "Test avec des métadonnées ISO");


ok( harvest_metadatas($resources_path."complete_delivery_vector_ok/MTDS", $catalog_repository."/id_broacast_data", "PVA") == 0, "Test avec des métadonnées ISO PVA");
$module->unmock_all();

$cpt = 0;
$module->mock('is_success', sub { if($cpt == 2){$cpt=0;return 0;}else{$cpt++;return 1;} });
my $return = "<?xml version='1.0' encoding='utf-8' ?>";
$return = $return."<csw:CrawlResponse xmlns:csw=\"http://www.opengis.net/cat/csw/2.0.2\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:dcterms=\"http://purl.org/dc/terms/\" xmlns:ows=\"http://www.opengis.net/ows\" xmlns:erdas=\"http://www.erdas.com/cat/isoap\">";
$return = $return."<erdas:crawlStatus>finished</erdas:crawlStatus>";
$return = $return."<erdas:id>41f005ae-df6d-48a0-a4c2-aaca2646a460</erdas:id>";
$return = $return."<erdas:folder>".$catalog_repository."/id_broacast_data</erdas:folder>";
$return = $return."<erdas:failure count=\"2\">";
$return = $return."<erdas:id>IGNF_PVA_1-0__1980__X0145-0051_V1.xml</erdas:id>";
$return = $return."<erdas:id>IGNF_PVA_1-0__1980__X0145-0052_V1.xml</erdas:id>";
$return = $return."</erdas:failure>";
$return = $return."<erdas:success count=\"4\">";
$return = $return."<erdas:id>IGNF_PVA_1-0__1980__X0145-0053_V1.xml</erdas:id>";
$return = $return."<erdas:id>IGNF_PVA_1-0__1980__X0145-0054_V1.xml</erdas:id>";
$return = $return."</erdas:success>";
$return = $return."</csw:CrawlResponse>";
$module->mock('content', sub { return $return;});
ok( harvest_metadatas($resources_path."complete_delivery_vector_ok/MTDS", $catalog_repository."/id_broacast_data", 1) == 1, "Test avec une erreur d'intégration des métadonnées INSPIRE");
$module->unmock_all();


$cpt = 0;
$module->mock('is_success', sub { if($cpt == 2){$cpt=0;return 0;}else{$cpt++;return 1;} });
$return = "<?xml version='1.0' encoding='utf-8' ?>";
$return = $return."<csw:CrawlResponse xmlns:csw=\"http://www.opengis.net/cat/csw/2.0.2\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:dcterms=\"http://purl.org/dc/terms/\" xmlns:ows=\"http://www.opengis.net/ows\" xmlns:erdas=\"http://www.erdas.com/cat/isoap\">";
$return = $return."<erdas:crawlStatus>finished</erdas:crawlStatus>";
$return = $return."<erdas:id>41f005ae-df6d-48a0-a4c2-aaca2646a460</erdas:id>";
$return = $return."<erdas:folder>".$catalog_repository."/id_broacast_data</erdas:folder>";
$return = $return."<erdas:failure count=\"2\">";
$return = $return."<erdas:id>IGNF_PVA_1-0__1980__X0145-0051_V1.xml</erdas:id>";
$return = $return."<erdas:id>IGNF_PVA_1-0__1980__X0145-0052_V1.xml</erdas:id>";
$return = $return."</erdas:failure>";
$return = $return."<erdas:success count=\"4\">";
$return = $return."<erdas:id>IGNF_PVA_1-0__1980__X0145-0053_V1.xml</erdas:id>";
$return = $return."<erdas:id>IGNF_PVA_1-0__1980__X0145-0054_V1.xml</erdas:id>";
$return = $return."</erdas:success>";
$return = $return."</csw:CrawlResponse>";
$module->mock('content', sub { return $return;});
ok( harvest_metadatas($resources_path."complete_delivery_vector_ok/MTDS", $catalog_repository."/id_broacast_data", 0) == 1, "Test avec une erreur d'intégration des métadonnées ISO");
$module->unmock_all();


ok( harvest_metadatas("/dir/not/exist", "/tmp/dir" , 0) == 2, "Test avec un répertoire source de métadonnées qui n'existe pas");


$module->mock('is_success', sub { return 0;});
ok( harvest_metadatas($resources_path."complete_delivery_vector_ok/MTDS", $catalog_repository."/id_broacast_data", 1) == 3, "Test avec une erreur lors d'une demande de moissonnage, le catalogue ne répond plus");
$module->unmock_all();


$cpt = 0;
$module->mock('is_success', sub { if($cpt == 1){$cpt=0;return 0;}else{$cpt++;return 1;} });
$return = "<?xml version='1.0' encoding='utf-8' ?>";
$return = $return."<csw:CrawlResponse xmlns:csw=\"http://www.opengis.net/cat/csw/2.0.2\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:dcterms=\"http://purl.org/dc/terms/\" xmlns:ows=\"http://www.opengis.net/ows\" xmlns:erdas=\"http://www.erdas.com/cat/isoap\">";
$return = $return."<erdas:crawlStatus>started</erdas:crawlStatus>";
$return = $return."<erdas:folder>$catalog_repository/id_broacast_data</erdas:folder>";
$return = $return."<erdas:asynchronous>true</erdas:asynchronous>";
$return = $return."<erdas:id>41f005ae-df6d-48a0-a4c2-aaca2646a460</erdas:id>";
$return = $return."<erdas:threadNb>4</erdas:threadNb>";
$return = $return."<erdas:delay>0</erdas:delay>";
$return = $return."</csw:CrawlResponse>";
$module->mock('content', sub { return $return;});
ok( harvest_metadatas($resources_path."complete_delivery_vector_ok/MTDS", $catalog_repository."/id_broacast_data", 1) == 4, "Test avec une erreur lors de la récupération du statut du moissonnage, le catalogue ne répond pas");
$module->unmock_all();


# ok( harvest_metadatas($resources_path."complete_delivery_vector_ok/MTDS", $catalog_repository."/id_broacast_data", 1) == 5, "Test avec une erreur lors de la récupération des versions de métadonnées existantes dans le catalogue, le catalogue ne répond pas");

system ("rm -rf $catalog_repository");
