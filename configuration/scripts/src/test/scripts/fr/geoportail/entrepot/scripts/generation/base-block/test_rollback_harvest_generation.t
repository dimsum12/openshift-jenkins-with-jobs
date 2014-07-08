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
use Cwd;

require "rollback_harvest_generation.pl";

my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();

my $resources_path     = $config->param("resources.path");
my $catalog_repository = $config->param("filer.catalog.repository");

my $dir_mtd_src = $resources_path."complete_delivery_vector_ok/MTDS";

system("mkdir $catalog_repository");
system("mkdir $catalog_repository/ISOAP");
system("mkdir $catalog_repository/INSPIRE");
system("mkdir $catalog_repository/ISOAP/id_broacast_data");
system("mkdir $catalog_repository/INSPIRE/id_broacast_data");
system("cp -r $dir_mtd_src/* $catalog_repository/ISOAP/id_broacast_data");
system("cp -r $dir_mtd_src/* $catalog_repository/INSPIRE/id_broacast_data");

my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
	'LWP::UserAgent',
	request => sub { return HTTP::Response->new() }
);

ok( rollback_harvest_generation() == 255, "Test sans paramètres" );

{
	local *rollback_harvest_metadatas = sub { return 0;};
	
	my $mock = Test::MockObject->new();
	$mock->fake_module(
			'HTTP::Response',
			is_success => sub { return 1; }
	);
	
	ok( rollback_harvest_generation("id_broacast_data") == 0, "Test rollback de métadonnées réussi" );
}

{
	local *rollback_harvest_metadatas = sub { return 1;};
	ok( rollback_harvest_generation("id_broacast_data") == 1, "Test avec une erreur lors du rollback des métadonnées ISOAP" );
}

{
	my $i = 0;
	local *rollback_harvest_metadatas = sub { 
		if (0 == $i) {
			$i++;
			return 0;
		} else {
			$i = 0;
			return 1;
		}
	};
	ok( rollback_harvest_generation("id_broacast_data") == 2, "Test avec une erreur lors du rollback des métadonnées INSPIRE" );
}

{
	local *rollback_harvest_metadatas = sub { return 0;};
	
	my $mock = Test::MockObject->new();
	$mock->fake_module(
			'HTTP::Response',
			is_success => sub { return 0; }
	);
	ok( rollback_harvest_generation("id_broacast_data") == 3, "Test avec une erreur lors du rollback de la données de diffusion" );
}

system "rm -rf $catalog_repository";