#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 14;
use Config::Simple;
use strict;
use Logger;
use warnings;
use Cwd;
use DBI;
use Test::MockObject;
no warnings 'redefine';


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();

my $deliveries_path = $config->param("filer.delivery-ftp");
my $root_path = $config->param("filer.root.storage");

my $logger =
  Logger->new( "test_upload_check.pl", $config->param("logger.levels") );

require "upload_check.pl";


# Mock permettant de ne pas appeler les services REST.
# Le retour des appels est simulé par un mock spécifique à chaque test (ci dessous)
my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
	'LWP::UserAgent',
	request => sub { return HTTP::Response->new() }
);

Execute->run( "rm -rf $deliveries_path/FTP-1/", "true" );
Execute->run( "rm -rf $deliveries_path/2/", "true" );
Execute->run( "rm -rf $root_path/i01a_sat1", "true" );

my $delivery_path = $deliveries_path . "FTP-1";



my $return = Execute->run( "mkdir " . $delivery_path, "true" );
$logger->log("DEBUG", "Dossier : " . $delivery_path);
$return->log_all( $logger, "DEBUG" );
Execute->run( "touch $deliveries_path/FTP-1/fichier1", "true" );
Execute->run( "touch $deliveries_path/FTP-1/fichier2", "true" );
Execute->run( "touch $deliveries_path/FTP-1/ALL.md5", "true" );
Execute->run( "mkdir $root_path/i01a_sat1", "true" );
Execute->run( "echo  'gtdydhffifjfndhdgdhdh  fichier1' >> $deliveries_path/FTP-1/ALL.md5", "true" );
Execute->run( "echo  'gt1545454ifjfndhdgdhdh fichier2' >> $deliveries_path/FTP-1/ALL.md5", "true" );


my $a = 0;

# test ok
my $mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '{"version" : 1,"id" : 2,"storage" : {"logicalName" : "i01a_sat1"}}'}
);
{
local *check_md5 = sub { return 0 ;};
ok( upload_check("1") == 0, "test ok" );
}


# test 
{
local *check_md5 = sub { return 1 ;};
ok( upload_check("-1") == 1, "test delievry repo does not exist " );
}


# test 
{
local *check_md5 = sub { return 1 ;};
ok( upload_check("1") == 2, "test check md5 failed" );
}

Execute->run( "mkdir $deliveries_path/FTP-1/my_directory/", "true" );

# test 
{
local *check_md5 = sub { return 0 ;};
ok( upload_check("1") == 12, "test directory exists failed" );
}

Execute->run( "rmdir $deliveries_path/FTP-1/my_directory/", "true" );


# test 
{
local *check_md5 = sub { return 0 ;};
local *check_size = sub { return 1 ;};
ok( upload_check("1") == 13, "test file too big  failed" );
}


# test 
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 0; },
);
{
local *check_md5 = sub { return 0 ;};
ok( upload_check("1") == 3, "test WS create BD does not work" );
}





# test 
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '{"version" : 1,"test" : 2}'}
);
{
local *check_md5 = sub { return 0 ;};
ok( upload_check("1") == 5, "test BD id  does not exists" );
}





# test 
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '{"version" : 1,"id" : 2}'}
);
{
local *check_md5 = sub { return 0 ;};
ok( upload_check("1") == 6, "test storage  does not exists" );
}



# test 
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '{"version" : 1,"id" : 2,"storage" : {"id" : "i01a_sat1gfyhfuf"}}'}
);
{
local *check_md5 = sub { return 0 ;};
ok( upload_check("1") == 7, "test storage doesn't have logicalname" );
}


# test 
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '{"version" : 1,"id" : 2,"storage" : {"logicalName" : "i01a_sat1gfyhfuf"}}'}
);
{
local *check_md5 = sub { return 0 ;};
ok( upload_check("1") == 8, "test storage path does not exists" );
}

# test 
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '{"version" : 1,"id" : 2,"storage" : {"logicalName" : "i01a_sat1"}}'}
);
{
local *check_md5 = sub { return 0 ;};
local *create_folder = sub { return 1 ;};
ok( upload_check("1") == 9, "test create directory failed" );
}


# test 
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '{"version" : 1,"id" : 2,"storage" : {"logicalName" : "i01a_sat1"}}'}
);
{
local *check_md5 = sub { return 0 ;};
local *copy_folder_content_to = sub { return 1 ;};
ok( upload_check("1") == 10, "test copy failed" );
}


# test 
$a = 0;
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { if ($a ==0){
										$a++;
											return 1;
											
										}else{
											return 0;
										} },
		decoded_content => sub { return '{"version" : 1,"id" : 2,"storage" : {"logicalName" : "i01a_sat1"}}'}
);
{
local *check_md5 = sub { return 0 ;};
ok( upload_check("1") == 11, "test update BD failed" );
}


# test
ok( upload_check() == 255, "testWithoutParameters" );






Execute->run( "rm -rf $deliveries_path/FTP-1/", "true" );
