#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 5;
use Config::Simple;
use Execute;
use Test::MockObject;
use strict;
use warnings;
use Cwd;

$ENV{PATH} = '/usr/rok4/bin/:' . $ENV{PATH};

my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
my $tmp_path = $config->param("resources.tmp.path");
my $tmp_generation = $config->param("resources.tmp.generations");
my $config_file_name = $config->param("be4.specific_conf_filename");
my $root_storage     = $config->param("filer.root.storage");
my $pyramid_dir 	 = $config->param("be4.pyramid_dir");


require "rok4_generation.pl";




ok( rok4_generation() == 255, "testWithoutParameters" );


Execute->run("mkdir -p $tmp_path$tmp_generation/15", "true");
ok( rok4_generation("15") == 1, "testWithNotExistFileConf");
Execute->run("rm -rf $tmp_path$tmp_generation/15", "true");


Execute->run("mkdir -p $tmp_path$tmp_generation/16", "true");
Execute->run("cp $resources_path/be4/be4_specific_bad.conf $tmp_path$tmp_generation/16/be4_specific.conf", "true");
ok( rok4_generation("16") == 2, "testWithBadFileConf");
Execute->run("rm -rf $tmp_path$tmp_generation/16", "true");


our $mock = Test::MockObject->new();
$mock->fake_module( 'Execute', get_return => sub { return 0; } );
Execute->run("mkdir -p $root_storage/fake_storage/21/$pyramid_dir", "true");
Execute->run("mkdir -p $tmp_path$tmp_generation/17/scripts", "true");
Execute->run("cp $resources_path/be4/be4_specific_simple.conf $tmp_path$tmp_generation/17/be4_specific.conf", "true");
ok( rok4_generation("17") == 0, "testWithCorrectFileConf");
Execute->run("rm -rf $tmp_path$tmp_generation/17", "true");
Execute->run("rm -rf $root_storage/fake_storage/21", "true");


Execute->run("mkdir -p $root_storage/fake_storage/21/$pyramid_dir", "true");
Execute->run("mkdir -p $tmp_path$tmp_generation/18/1/scripts", "true");
Execute->run("cp $resources_path/be4/be4_specific_simple.conf $tmp_path$tmp_generation/18/1/be4_specific.conf", "true");
ok( rok4_generation("18", "1") == 0, "testWithCorrectFileConfAndLevel");
Execute->run("rm -rf $tmp_path$tmp_generation/18", "true");
Execute->run("rm -rf $root_storage/fake_storage/21", "true");

