#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 7;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
no warnings qw/redefine/;
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");

require "harvest_directory.pl";




my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
	'LWP::UserAgent',
	request => sub { return HTTP::Response->new() }
);




# test ok 
my $a = 0;
my $mock = Test::MockObject->new();
$mock->fake_module(
			'HTTP::Response',
			is_success => sub { return 1;},
			content => sub { 
				my $return;
				if ($a == 0){
					$a++;
					$return = "<?xml version='1.0' encoding='utf-8' ?>
<csw:CrawlResponse xmlns:csw=\"http://www.opengis.net/cat/csw/2.0.2\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:dcterms=\"http://purl.org/dc/terms/\" xmlns:ows=\"http://www.opengis.net/ows\" xmlns:erdas=\"http://www.erdas.com/cat/isoap\">
  <erdas:crawlStatus>started</erdas:crawlStatus>
  <erdas:id>32723283-ebcd-447b-9489-b6740a74e886</erdas:id>
  <erdas:folder>/FILERS/i03a_sat3/catalog-integration/ISOAP/555</erdas:folder>
  <erdas:success count=\"0\">
  </erdas:success>
</csw:CrawlResponse>";
					
					return $return;
				} elsif ($a == 1){
					$a++;
					$return = $return."<csw:CrawlResponse xmlns:csw=\"http://www.opengis.net/cat/csw/2.0.2\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:dcterms=\"http://purl.org/dc/terms/\" xmlns:ows=\"http://www.opengis.net/ows\" xmlns:erdas=\"http://www.erdas.com/cat/isoap\">
  <erdas:crawlStatus>started</erdas:crawlStatus>
  <erdas:id>fceb2a02-a165-4009-99c0-112144ee2a23</erdas:id>
  <erdas:folder>/FILERS/i03a_sat3/catalog-integration/ISOAP/555</erdas:folder>
  <erdas:failure count=\"0\">
  </erdas:failure>
  <erdas:success count=\"71\">
  </erdas:success>
</csw:CrawlResponse>
";
				} else { 
					$a = 0 ;
					$return = "<csw:CrawlResponse xmlns:csw=\"http://www.opengis.net/cat/csw/2.0.2\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:dcterms=\"http://purl.org/dc/terms/\" xmlns:ows=\"http://www.opengis.net/ows\" xmlns:erdas=\"http://www.erdas.com/cat/isoap\">
  <erdas:crawlStatus>finished</erdas:crawlStatus>
  <erdas:id>fceb2a02-a165-4009-99c0-112144ee2a23</erdas:id>
  <erdas:folder>/FILERS/i03a_sat3/catalog-integration/ISOAP/555</erdas:folder>
  <erdas:failure count=\"0\">
  </erdas:failure>
  <erdas:success count=\"71\">
  </erdas:success>
</csw:CrawlResponse>
";
					return $return;
				}
			}
);

ok( harvest_directory("url", "/my/folder", 1) == 0, "Test ok avec des métadonnées INSPIRE");
ok( harvest_directory("url", "/my/folder", 0) == 0, "Test ok avec des métadonnées ISO");



# test launch crawl failed

$mock = Test::MockObject->new();
$mock->fake_module(
			'HTTP::Response',
			is_success => sub { return 0;}
				
);

ok( harvest_directory("url", "/my/folder", 0) == 1, "crawl failed" );




# test get status failed
my $d = 1;
$mock = Test::MockObject->new();
$mock->fake_module(
			'HTTP::Response',
			is_success => sub {
				if ($d == 1) {
					$d++;
					return 1;
				} else {
					return 0;
				}
			}
);
ok( harvest_directory("url", "/my/folder", 0) == 2, "test crawl failed" );




# test harvest failed
my $b = 0;
$mock = Test::MockObject->new();
$mock->fake_module(
			'HTTP::Response',
			is_success => sub {
					return 1;
			},
			content => sub { 
				my $return;
				if ($a == 0){
					$a++;
					$return = "<?xml version='1.0' encoding='utf-8' ?>
<csw:CrawlResponse xmlns:csw=\"http://www.opengis.net/cat/csw/2.0.2\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:dcterms=\"http://purl.org/dc/terms/\" xmlns:ows=\"http://www.opengis.net/ows\" xmlns:erdas=\"http://www.erdas.com/cat/isoap\">
  <erdas:crawlStatus>started</erdas:crawlStatus>
  <erdas:id>32723283-ebcd-447b-9489-b6740a74e886</erdas:id>
  <erdas:folder>/FILERS/i03a_sat3/catalog-integration/ISOAP/555</erdas:folder>
  <erdas:success count=\"0\">
  </erdas:success>
</csw:CrawlResponse>";
					
					return $return;
				} elsif ($a == 1){
					$a++;
					$return = $return."<csw:CrawlResponse xmlns:csw=\"http://www.opengis.net/cat/csw/2.0.2\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:dcterms=\"http://purl.org/dc/terms/\" xmlns:ows=\"http://www.opengis.net/ows\" xmlns:erdas=\"http://www.erdas.com/cat/isoap\">
  <erdas:crawlStatus>started</erdas:crawlStatus>
  <erdas:id>fceb2a02-a165-4009-99c0-112144ee2a23</erdas:id>
  <erdas:folder>/FILERS/i03a_sat3/catalog-integration/ISOAP/555</erdas:folder>
  <erdas:failure count=\"0\">
  </erdas:failure>
  <erdas:success count=\"71\">
  </erdas:success>
</csw:CrawlResponse>
";
				} else { 
					$a = 0 ;
					$return = "<csw:CrawlResponse xmlns:csw=\"http://www.opengis.net/cat/csw/2.0.2\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:dcterms=\"http://purl.org/dc/terms/\" xmlns:ows=\"http://www.opengis.net/ows\" xmlns:erdas=\"http://www.erdas.com/cat/isoap\">
  <erdas:crawlStatus>finished</erdas:crawlStatus>
  <erdas:id>fceb2a02-a165-4009-99c0-112144ee2a23</erdas:id>
  <erdas:folder>/FILERS/i03a_sat3/catalog-integration/ISOAP/555</erdas:folder>
  <erdas:failure count=\"5\">
  </erdas:failure>
  <erdas:success count=\"71\">
  </erdas:success>
</csw:CrawlResponse>
";
					return $return;
				}
			}
);
ok( harvest_directory("url", "/my/folder", 1) == 3, "Test avec une erreur d'intégration des métadonnées");



# test timeout 

$mock = Test::MockObject->new();
$mock->fake_module(
			'HTTP::Response',
			is_success => sub { return 1 },
			content => sub { 
				my $return;
				if ($a == 0){
					$a++;
					$return = "<?xml version='1.0' encoding='utf-8' ?>";
					$return = $return."<csw:CrawlResponse xmlns:csw=\"http://www.opengis.net/cat/csw/2.0.2\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:dcterms=\"http://purl.org/dc/terms/\" xmlns:ows=\"http://www.opengis.net/ows\" xmlns:erdas=\"http://www.erdas.com/cat/isoap\">";
					$return = $return."<erdas:CrawlStatus>started</erdas:CrawlStatus>";
					$return = $return."<erdas:folder>/id_broacast_data</erdas:folder>";
					$return = $return."<erdas:asynchronous>true</erdas:asynchronous>";
					$return = $return."<erdas:id>41f005ae-df6d-48a0-a4c2-aaca2646a460</erdas:id>";
					$return = $return."<erdas:threadNb>4</erdas:threadNb>";
					$return = $return."<erdas:delay>0</erdas:delay>";
					$return = $return."</csw:CrawlResponse>";
					return $return;
				} else {
					
					$return = "<?xml version='1.0' encoding='utf-8' ?>";
					$return = $return."<csw:CrawlResponse xmlns:csw=\"http://www.opengis.net/cat/csw/2.0.2\" xmlns:dc=\"http://purl.org/dc/elements/1.1/\" xmlns:dcterms=\"http://purl.org/dc/terms/\" xmlns:ows=\"http://www.opengis.net/ows\" xmlns:erdas=\"http://www.erdas.com/cat/isoap\">";
					$return = $return."<erdas:CrawlStatus>inprogress</erdas:CrawlStatus>";
					$return = $return."<erdas:id>41f005ae-df6d-48a0-a4c2-aaca2646a460</erdas:id>";
					$return = $return."<erdas:folder>folder</erdas:folder>";
					$return = $return."</csw:CrawlResponse>";
					return $return;
				} 
			}
);
ok( harvest_directory("url", "/my/folder", 1) == 4, "Test timeout");



# test
ok( harvest_directory() == 255, "testWithoutParameters" );