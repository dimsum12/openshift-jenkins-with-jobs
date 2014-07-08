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
use Cwd;

use Database;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
my $catalog_repository = $config->param("filer.catalog.repository");

my $pattern_response_delete = $config->param("harvesting.pattern.response.delete");
my $pattern_response_error = $config->param("harvesting.pattern.response.error");
my $i = 0;

require "rollback_harvest_metadatas.pl";

system("mkdir $catalog_repository");
system("mkdir $catalog_repository/id_broacast_data");
my $dir_mtd_src = $resources_path."complete_delivery_vector_ok/MTDS";

my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
	'LWP::UserAgent',
	request => sub { return HTTP::Response->new() }
);

my $mock = Test::MockObject->new();
# Modification du compteur suite à une suppression dans le pattern
$pattern_response_delete =~ s/#count#/4/;
$mock->fake_module(
			'HTTP::Response',
			is_success => sub { return 1 },
			content => sub { return $pattern_response_delete }
);

ok( rollback_harvest_metadatas() == 255, "Test sans paramètre" );

system("cp -r $dir_mtd_src/* $catalog_repository/id_broacast_data");
ok( rollback_harvest_metadatas($catalog_repository."/id_broacast_data", 1) == 0, "Test de rollback avec des métadonnées INSPIRE" );

system("mkdir $catalog_repository/id_broacast_data");
system("cp -r $dir_mtd_src/* $catalog_repository/id_broacast_data");
ok( rollback_harvest_metadatas($catalog_repository."/id_broacast_data", 0) == 0, "Test de rollback avec des métadonnées ISO" );

$mock->fake_module(
                        'HTTP::Response',
                        is_success => sub { return 1 },
			content => sub { return $pattern_response_error }
);
system("mkdir $catalog_repository/id_broacast_data");
system("cp -r $dir_mtd_src/* $catalog_repository/id_broacast_data");
ok( rollback_harvest_metadatas($catalog_repository."/id_broacast_data", 1) == 1, "Test de rollback avec une erreur de suppression des métadonnées INSPIRE" );

system("cp -r $dir_mtd_src/* $catalog_repository/id_broacast_data");
ok( rollback_harvest_metadatas($catalog_repository."/id_broacast_data", 0) == 1, "Test de rollback avec une erreur de suppression des métadonnées ISO" );

system("cp -r $dir_mtd_src/* $catalog_repository/id_broacast_data");
ok( rollback_harvest_metadatas("/dir/not/exist", 1) == 2, "Test avec un répertoire source de métadonnées qui n'existe pas");

$mock->fake_module(
			'HTTP::Response',                        
			is_success => sub { return 0 }
);
system("cp -r $dir_mtd_src/* $catalog_repository/id_broacast_data");
ok( rollback_harvest_metadatas($catalog_repository."/id_broacast_data", 1) == 3, "Test avec une erreur interne survenur sur le catalogue lors d'une suppression de métadonnées, code retour requête HTTP différent de 200");

system ("rm -rf $catalog_repository");
