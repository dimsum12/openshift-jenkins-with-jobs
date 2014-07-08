#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 6;
use WebserviceTools;

use strict;
use Test::MockObject;
use warnings;
use Cwd;
use Config::Simple;

my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();


my $username = $config->param("db-ent_donnees.testusername");
my $password = $config->param("db-ent_donnees.testpassword");

my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
	'LWP::UserAgent',
	request => sub { return HTTP::Response->new() }
);
my $mock = Test::MockObject->new();
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
        decoded_content => sub { return '{content_ok}'; }
);



my $ws_ok =  WebserviceTools->new(  'GET', "http://127.0.0.1:8080/api/generation/updateRok4BD" , "none");
ok ($ws_ok, "Test de création");


ok ($ws_ok->run(0, 0), "Test de run ok sans paramètres");



my(%hash) = ( broadcastDataId => 45, 'pyrFile' => 'tagada', ancestorId => 42, tmsName => "tmsname", format => "format", projection => "proj" );

ok ($ws_ok->run(0, 0, %hash ), "Test de run ok avec  paramètres");

ok ($ws_ok->get_decoded_content() eq '{content_ok}', "Test de get_content ok ");



my $a = 0;
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { 
							if ($a == 0){
								$a++;
								return 0;											
							}else{										
								return 1;
							}},
        decoded_content => sub { return '{content_ok}'; }
);

ok ($ws_ok->run(1, 1, %hash ), "Test de run ko puis ok ");


ok (!WebserviceTools->new(  'NONE', "http://127.0.0.1:8080/api/generation/updateRok4BD" , "none"), "Test de création ko ");
			
			



