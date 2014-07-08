#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 5;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
no warnings qw/redefine/;
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");

require "change_status_metadatas.pl";



my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
	'LWP::UserAgent',
	request => sub { return HTTP::Response->new() }
);


# ok
my $a = 0;
my $mock = Test::MockObject->new();
$mock->fake_module(
			'HTTP::Response',
			is_success => sub { return 1;},
			content => sub { 
				my $return;
				if ($a == 0){
					$a++;
					$return = "<?xml version='1.0' encoding='utf-8' ?> ";
					$return = $return."<csw:SetStatusResponse xmlns:csw='http://www.opengis.net/cat/csw/2.0.2' xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:dcterms='http://purl.org/dc/terms/' xmlns:ows='http://www.opengis.net/ows'>";
					$return = $return."<csw:totalUpdated>2</csw:totalUpdated>";
					$return = $return."</csw:SetStatusResponse> ";
					return $return;
				}
				elsif ($a == 1) {
					$a++;
					$return = "<?xml version='1.0' encoding='utf-8' ?> ";
					$return = $return."<csw:SetStatusResponse xmlns:csw='http://www.opengis.net/cat/csw/2.0.2' xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:dcterms='http://purl.org/dc/terms/' xmlns:ows='http://www.opengis.net/ows'>";
					$return = $return."<csw:totalUpdated>2</csw:totalUpdated>";
					$return = $return."</csw:SetStatusResponse> ";
					return $return;
				}
				else { 
					$a = 0;
					$return = "<?xml version='1.0' encoding='utf-8' ?> ";
					$return = $return."<csw:SetStatusResponse xmlns:csw='http://www.opengis.net/cat/csw/2.0.2' xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:dcterms='http://purl.org/dc/terms/' xmlns:ows='http://www.opengis.net/ows'>";
					$return = $return."<csw:totalUpdated>1</csw:totalUpdated>";
					$return = $return."</csw:SetStatusResponse> ";
					return $return;
				}
				
			}		
);

ok( change_status_metadatas("", "id1,id2,i-d-3,id-4,i-d5", "PUBLISHED", 1) == 0, "test ok  inspire" );
ok( change_status_metadatas("", "id1,id2,i-d-3,id-4,i-d5", "PUBLISHED", 0) == 0, "test iso ap" );



# erreur failed

$mock = Test::MockObject->new();
$mock->fake_module(
			'HTTP::Response',
			is_success => sub { return 0;}
);
ok( change_status_metadatas("", "id1,id2,i-d-3,id-4,i-d5", "PUBLISHED", 1) == 1, "test send request failed" );

# erreur getstatus
$mock = Test::MockObject->new();
$mock->fake_module(
			'HTTP::Response',
			is_success => sub { return 1;},
			content => sub { 
					my $return = "<?xml version='1.0' encoding='utf-8' ?> ";
					$return = $return."<csw:SetStatusResponse xmlns:csw='http://www.opengis.net/cat/csw/2.0.2' xmlns:dc='http://purl.org/dc/elements/1.1/' xmlns:dcterms='http://purl.org/dc/terms/' xmlns:ows='http://www.opengis.net/ows'>";
					$return = $return."<csw:totalUpdated>1</csw:totalUpdated>";
					$return = $return."</csw:SetStatusResponse> ";
					return $return;
			}		
);
ok( change_status_metadatas("", "id1,id2,i-d-3,id-4,i-d5", "PUBLISHED", 0) == 2, "test ok  inspire" );


# test
ok( change_status_metadatas() == 255, "testWithoutParameters" );