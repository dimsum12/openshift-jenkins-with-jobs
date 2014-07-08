#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 8;
use Config::Simple;
use Test::MockObject;
use Test::MockModule;
use strict;
use warnings;
use Cwd;
use Execute;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();

my $resources_path          = $config->param("resources.path");
my $catalog_repository      = $config->param("filer.catalog.repository");

require "harvest_generation.pl";

Execute->run("mkdir -p $catalog_repository", "true");
Execute->run("mkdir -p $catalog_repository/PVA", "true");
Execute->run("mkdir -p $catalog_repository/ISOAP", "true");
Execute->run("mkdir -p $catalog_repository/INSPIRE", "true");
Execute->run("mkdir -p $catalog_repository/PVA/21", "true");
Execute->run("mkdir -p $catalog_repository/ISOAP/21", "true");
Execute->run("mkdir -p $catalog_repository/INSPIRE/21", "true");


# Mock permettant de ne pas appeler les services REST.
# Le retour des appels est simulé par un mock spécifique à chaque test (ci dessous)
my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
	'LWP::UserAgent',
	request => sub { return HTTP::Response->new() }
);

ok( harvest_generation() == 255, "Test sans paramètres" );
{
	local *harvest_metadatas = sub {
		return 0;
	};
	
	my $mock = Test::MockObject->new();
	$mock->fake_module(
			'HTTP::Response',
			is_success => sub { return 1; }
	);
	Execute->run("cp -r $resources_path/complete_delivery_vector_ok/ $catalog_repository/INSPIRE/21", "true");
	ok( harvest_generation($resources_path."complete_delivery_vector_ok", 21) == 0, "Test avec des métadonnées INSPIRE & ISO AP" );
	Execute->run("rm -rf $catalog_repository/INSPIRE/21/*", "true");
}

{
	my $i = 0;
	local *harvest_metadatas = sub {
		if( 0 == $i){
			$i++;
			return 1;
		} else {
			$i = 0;
			return 0;
		}
	};
	
	ok( harvest_generation($resources_path."complete_delivery_vector_ok", 21) == 1, "Test avec une erreur lors de l'intégration de métadonnées ISO AP" );
}

{
	my $i = 0;
	local *harvest_metadatas = sub {
		if( 0 == $i){
			$i++;
			return 0;
		} else {
			$i = 0;
			return 1;
		}
	};
	
	ok( harvest_generation($resources_path."complete_delivery_vector_ok", 21) == 2, "Test avec une erreur lors de l'intégration de métadonnées INSPIRE" );
}

{
	my $i = 0;
	local *harvest_metadatas = sub {
		if( 2 > $i ){
			$i++;
			return 0;
		} else {
			$i = 0;
			return 1;
		}
	};
	
	ok( harvest_generation($resources_path."complete_delivery_vector_ok", 21) == 3, "Test avec une erreur lors de l'intégration de métadonnées PVA" );
}

{
	local *harvest_metadatas = sub {
		return 0;
	};
	
	local *update_broadcastdata = sub{
		return 4;
	};
	
	ok( harvest_generation($resources_path."complete_delivery_vector_ok", 21) == 4, "Test avec une erreur lors de l'interrogation du webservice" );
}

{
	local *harvest_metadatas = sub {
		return 0;
	};
	
	local *update_broadcastdata = sub{
		return 5;
	};
	
	ok( harvest_generation($resources_path."complete_delivery_vector_ok", 21) == 5, "Test avec une erreur Gateway Timeout sur la mise à jour d'une donnée de diffusion" );
}

{
        local *harvest_metadatas = sub {
                return 0;
        };

	local *retrieve_geometry = sub {
		return undef;
	};
       
        my $mock = Test::MockObject->new();
        $mock->fake_module(
                        'HTTP::Response',
                        is_success => sub { return 1; }
        );

	Execute->run("cp -r $resources_path/complete_delivery_demat_ok/ $catalog_repository/INSPIRE/21", "true");
       
        ok( harvest_generation($resources_path."complete_delivery_demat_ok", 21) == 2, "Test avec une erreur lors de la recuperation de la geometry d'une metadonnee" );
}

Execute->run("rm -rf $catalog_repository", "true");
