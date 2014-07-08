#!/usr/bin/perl

#########################################################################################################################
# KEYWORDS
#   $Revision 1 $
#   $Source src/test/scripts/fr/geoportail/entrepot/scripts/generation/high_level/test_joincache_generation.t $
#   $Date: 30/05/12 $
#   $Author: Kevin Ferrier (a145972) <kevin.ferrier@atos.net> $
#########################################################################################################################

use strict;
use warnings;

BEGIN {
    push @INC, "lib";
}

use Classpath;
Classpath->load();
use Test::Simple tests => 32;
use Config::Simple;
use Test::MockObject;
use Cwd;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/test/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $tmp_path = $config->param("resources.tmp.path");
chop $tmp_path;
my $tmp_generation = $config->param("resources.tmp.generations");
my $root_storage   = $config->param("filer.root.storage");
chop $root_storage;
my $pyramid_dir      = $config->param("joincache.pyramid_dir");
my $config_file_name = $config->param("joincache.specific_conf_filename");

my $tms_dir = $config->param("joincache.tms_dir");

require "joincache_generation.pl";

# Mock permettant de ne pas appeler les services REST.
# Le retour des appels est simulé par un mock spécifique à chaque test (ci dessous)
my $mock_global = Test::MockObject->new();
$mock_global->fake_module( 'LWP::UserAgent',
    request => sub { return HTTP::Response->new() } );

# Mock global pour le harvesting des métadonnées
local *harvest_generation = sub { return 0; };

ok( joincache_generation() == 255, "testWithoutParameters" );

my $mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 0; },
    decoded_content => sub { return '{}'; }
);
ok(
    joincache_generation( "-1", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 1,
    "testWithBadGenerationId"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub { return '{}'; }
);
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 2,
    "testwithoutInputData"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN100_ROK4_RAW_V1","version":1,"broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"i01a_sat1"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_50cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN100_ROK4_RAW_V1","version":1,"broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"i01a_sat1"},"name":"SCAN100_ROK4_RAW_V1","id":1002}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"i01a_sat1"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 3,
    "testwithNotSameTms"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN100_ROK4_RAW_V1","version":1,"broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"i01a_sat1"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"JPEG","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN100_ROK4_RAW_V1","version":1,"broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"i01a_sat1"},"name":"SCAN100_ROK4_RAW_V1","id":1002}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"i01a_sat1"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 4,
    "testwithNotSameFormat"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN100_ROK4_RAW_V1","version":1,"broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"i01a_sat1"},"name":"SCAN100_ROK4_RAW_V1","id":1002}],"id":3}';
    }
);
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 5,
    "testwithoutOnputData"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN100_ROK4_RAW_V1","version":1,"broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"i01a_sat1"},"name":"SCAN100_ROK4_RAW_V1","id":1002}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN100_ROK4_RAW_V1","storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"i01a_sat1"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"i01a_sat1"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 6,
    "testwithTooManyOutputData"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1"}]}';
    }
);
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 253,
    "testwithBDwithoutId"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"id":1002}]}';
    }
);
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 253,
    "testwithBDwithoutName"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 253,
    "testwithBDwithoutStorage"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 253,
    "testwithBDwithoutLogicalName"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
ok(
    joincache_generation( "16", "Fichier.conf", "jpg", 3, "rgb", 8, "uint",
        "replace" ) == 10,
    "testwithNotExistingCfgFile"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);

ok(
    joincache_generation( "15",
        "Fichier_entree_incorrect_no_bboxes_header.conf",
        "jpg", 3, "rgb", 8, "uint", "replace" ) == 252,
    "testwithInputCfgFileIncorrectNoBboxesHeader"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);

ok(
    joincache_generation( "15",
        "Fichier_entree_incorrect_no_composition_header.conf",
        "jpg", 3, "rgb", 8, "uint", "replace" ) == 252,
    "testwithInputCfgFileIncorrectNoCompositionHeader"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);

ok(
    joincache_generation( "15", "Fichier_entree_incorrect_no_bboxes.conf",
        "jpg", 3, "rgb", 8, "uint", "replace" ) == 252,
    "testwithInputCfgFileIncorrectNoBboxes"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);

ok(
    joincache_generation( "15", "Fichier_entree_incorrect_no_composition.conf",
        "jpg", 3, "rgb", 8, "uint", "replace" ) == 252,
    "testwithInputCfgFileIncorrectNoComposition"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1003},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1004},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1005},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1006}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
`mkdir -p $root_storage/fake_storage/1002/$pyramid_dir`;
`mkdir -p $root_storage/fake_storage/1003/$pyramid_dir`;
`mkdir -p $root_storage/fake_storage/1004/$pyramid_dir`;
`mkdir -p $root_storage/fake_storage/1005/$pyramid_dir`;
`mkdir -p $root_storage/fake_storage/1006/$pyramid_dir`;
`mkdir -p $root_storage/fake_storage/1002/$tms_dir`;
`mkdir -p $root_storage/fake_storage/1003/$tms_dir`;
`mkdir -p $root_storage/fake_storage/1004/$tms_dir`;
`mkdir -p $root_storage/fake_storage/1005/$tms_dir`;
`mkdir -p $root_storage/fake_storage/1006/$tms_dir`;
`cp /dev/null $root_storage/fake_storage/1002/$tms_dir/RGR92UTM40S_10cm.tms`;
`cp /dev/null $root_storage/fake_storage/1003/$tms_dir/RGR92UTM40S_10cm.tms`;
`cp /dev/null $root_storage/fake_storage/1004/$tms_dir/RGR92UTM40S_10cm.tms`;
`cp /dev/null $root_storage/fake_storage/1005/$tms_dir/RGR92UTM40S_10cm.tms`;
`cp /dev/null $root_storage/fake_storage/1006/$tms_dir/RGR92UTM40S_10cm.tms`;
`cp /dev/null $root_storage/fake_storage/1002/$pyramid_dir/MONDE12F_V1.pyr`;
`cp /dev/null $root_storage/fake_storage/1003/$pyramid_dir/SCAN25_V1.pyr`;
`cp /dev/null $root_storage/fake_storage/1004/$pyramid_dir/SCANREG_V1.pyr`;
`cp /dev/null $root_storage/fake_storage/1005/$pyramid_dir/ROUTE_V1.pyr`;
`cp /dev/null $root_storage/fake_storage/1006/$pyramid_dir/BATIMENT_V1.pyr`;
`chmod -R 000 $root_storage/fake_storage/`;
ok(
    joincache_generation( "16", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 8,
    "testwithErrorCreatingPyrDir"
);
`chmod -R 777 $root_storage/fake_storage/`;

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1003},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1004},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1005},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1006}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
`chmod 000 $tmp_path/$tmp_generation/`;
ok(
    joincache_generation( "16", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 9,
    "testwithErrorCreatingTmpDir"
);
`chmod 777 $tmp_path/$tmp_generation/`;

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1004},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1005},'		  
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1006}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 11,
    "testBroadcastProductNotPresentInInputDatas"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1003},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1004},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1005},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1006}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 253,
    "testwithBDwithoutPyr"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1003},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1004},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1005},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1006}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
`rm $root_storage/fake_storage/1004/$pyramid_dir/SCANREG_V1.pyr`;
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 12,
    "testwithNotExistingPyramidFile"
);
`cp /dev/null $root_storage/fake_storage/1004/$pyramid_dir/SCANREG_V1.pyr`;

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"bboxList":[{"id":1,"owners":[{"name":"IGN"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1003},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"bboxList":[{"id":1,"owners":[{"name":"IGN"},{"name":"PO"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1004},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"bboxList":[{"id":1,"owners":[{"name":"IGN"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1005},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"bboxList":[{"id":1,"owners":[{"name":"IGN"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1006}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
`mkdir $tmp_path/$tmp_generation/`;
`mkdir $tmp_path/$tmp_generation/16/`;
`chmod -R 000 $tmp_path/$tmp_generation/16/`;
ok(
    joincache_generation( "16", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 7,
    "testwithErrorCreatingJoinCacheCfgFile"
);
`chmod -R 777 $tmp_path/$tmp_generation/16/`;
`rm -r $tmp_path/$tmp_generation/16/`;

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"bboxList":[{"id":1,"owners":[{"name":"IGN"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1003},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1004},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"bboxList":[{"id":1,"owners":[{"name":"IGN"},{"name":"PO"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1005},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1006}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
$mock->fake_module( 'Execute', get_return => sub { return -1; } );
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 14,
    "testWithErrorExecutionJoincache"
);

our $mocked_value = 2;
$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success =>
      sub { $mocked_value = $mocked_value - 1; return $mocked_value; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"bboxList":[{"id":1,"owners":[{"name":"IGN"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1003},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1004},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"bboxList":[{"id":1,"owners":[{"name":"IGN"},{"name":"PO"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1005},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1006}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
$mock->fake_module( 'Execute', get_return => sub { return 0; } );
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 13,
    "testUpdateRok4BDFailed"
);

$mocked_value = 3;
$mock         = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success =>
      sub { $mocked_value = $mocked_value - 1; return $mocked_value; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"bboxList":[{"id":1,"owners":[{"name":"IGN"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1003},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1004},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"bboxList":[{"id":1,"owners":[{"name":"IGN"},{"name":"PO"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1005},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1006}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
$mock->fake_module( 'Execute', get_return => sub { return 0; } );
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 13,
    "testUpdateBboxesFailed"
);

$mocked_value = 4;
$mock         = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success =>
      sub { $mocked_value = $mocked_value - 1; return $mocked_value; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"bboxList":[{"id":1,"owners":[{"name":"IGN"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1003},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1004},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"bboxList":[{"id":1,"owners":[{"name":"IGN"},{"name":"PO"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1005},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1006}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
$mock->fake_module( 'Execute', get_return => sub { return 0; } );
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 13,
    "testCopyMetadatasFromBDFailed"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1003},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1004},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1005},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1006}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 253,
    "testwithoutOriginators"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1003},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1004},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1005},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1006}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
$mock->fake_module( 'Execute', get_return => sub { return 0; } );
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 253,
    "testwithoutOriginators"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"bboxList":[{"id":1,"owners":[{"name":"IGN"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1003},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1004},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"bboxList":[{"id":1,"owners":[{"name":"IGN"},{"name":"PO"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1"},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1006}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
$mock->fake_module( 'Execute', get_return => sub { return 0; } );
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 253,
    "testwithInputBDwithoutId"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"bboxList":[{"id":1,"owners":[{"name":"IGN"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1003},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1004},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"bboxList":[{"id":1,"owners":[{"name":"IGN"},{"name":"PO"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1005},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1006}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
$mock->fake_module( 'Execute', get_return => sub { return 0; } );
local *update_broadcastdata_size = sub { return 1; };
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 13,
    "testUpdateBDSizeFailed"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub {
        return
'{"inputDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"MONDE12F_V1","version":1,"broadcastProduct":{"name":"MONDE12F","id":19},"bboxList":[{"id":1,"owners":[{"name":"IGN"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCAN25_V1","version":1,"broadcastProduct":{"name":"SCAN25","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1003},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"SCANREG_V1","version":1,"broadcastProduct":{"name":"SCANREG","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1004},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"ROUTE_V1","version":1,"broadcastProduct":{"name":"ROUTE","id":19},"bboxList":[{"id":1,"owners":[{"name":"IGN"},{"name":"PO"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1005},'
          . '{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","noDataValue":"FFFFFF","projection":"IGNF:LAMB93","pyrFile":"BATIMENT_V1","version":1,"broadcastProduct":{"name":"BATIMENT","id":19},"bboxList":[{"id":1,"owners":[{"name":"BROM"}]}],"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1006}],"id":3,'
          . '"broadcastDatas":[{"format":"TIFF","tmsName":"RGR92UTM40S_10cm","pyrFile":"SCAN100_ROK4_RAW_V1","broadcastProduct":{"name":"SCAN100_ROK4_RAW","id":19},"storage":{"id":6,"name":"Pyramide Pleine Qualite","logicalName":"fake_storage"},"name":"SCAN100_ROK4_RAW_V1","id":1002}]}';
    }
);
$mock->fake_module( 'Execute', get_return => sub { return 0; } );
*update_broadcastdata_size = sub { return 0; };
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 0,
    "testNominal"
);

$mock = Test::MockObject->new();
$mock->fake_module(
    'HTTP::Response',
    is_success      => sub { return 1; },
    decoded_content => sub { return '{"broadcastDatas" : [{}],"id" : 15}'; }
);
$mock->fake_module( 'JSON', from_json => sub ($@) { return; } );
ok(
    joincache_generation( "15", "Fichier_entree.conf", "jpg", 3, "rgb", 8,
        "uint", "replace" ) == 254,
    "testWithJsonConversionError"
);

# Nettoyage de la génération restante
`rm -r $tmp_path/$tmp_generation/`;
`rm -r $root_storage/fake_storage/`;

