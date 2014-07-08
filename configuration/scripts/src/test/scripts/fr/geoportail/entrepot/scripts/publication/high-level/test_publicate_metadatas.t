#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 9;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
no warnings 'redefine';
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");

require "publicate_metadatas.pl";




# Mock permettant de ne pas appeler les services REST.
# Le retour des appels est simulé par un mock spécifique à chaque test (ci dessous)
my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
	'LWP::UserAgent',
	request => sub { return HTTP::Response->new() }
);




#   * 0 if success
#	* 1 zone is incorrect
#	* 2 if crawl failed
#	* 3 if change status failed for isoap mtds
#	* 4 if change status failed for inspiremtds
#	* 5 if impossible to copy metadatas to extern storage
#   * 255 if the function is called an incorrect number of arguments




# test
my $mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '["ghfu-fr,gfur-frf","456-8552,4782-fd458","2,3","2,3","INTERNAL"]'; }
);
{
local *crawl_broadcastdata = sub { return 0 ;};
local *change_status_metadatas = sub { return 0;};
local *synchronize_metadatas_on_extern_zone = sub { return 0;};
ok( publicate_metadatas("3838") == 0, "test ok" );
}

# test
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '["ghfu-fr,gfur-frf","456-8552,4782-fd458","2,3","2,3","INTEAL"]'; }
);
{
local *crawl_broadcastdata = sub { return 0 ;};
local *change_status_metadatas = sub { return 0;};
local *synchronize_metadatas_on_extern_zone = sub { return 0;};

ok( publicate_metadatas("22") == 1, "test wrong zone" );

}







# test
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '["ghfu-fr,gfur-frf","456-8552,4782-fd458","2,3","2,3","INTERNAL"]'; }
);
{
local *crawl_broadcastdata = sub { return 1 ;};
local *change_status_metadatas = sub { return 0;};
local *synchronize_metadatas_on_extern_zone = sub { return 0;};

ok( publicate_metadatas("33") == 2, "test crawl failed" );

}





# test
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '["ghfu-fr,gfur-frf","456-8552,4782-fd458","2,3","2,3","EXTERNAL"]'; }
);
{
local *crawl_broadcastdata = sub { return 0 ;};
local *change_status_metadatas = sub { return 1;};
local *synchronize_metadatas_on_extern_zone = sub { return 0;};
ok( publicate_metadatas("55") == 3, "test change isoap status failed" );
}


# test
{
local *crawl_broadcastdata = sub { return 0 ;};
local *change_status_metadatas = sub { return 0;};
local *synchronize_metadatas_on_extern_zone = sub { return 1;};
ok( publicate_metadatas("22") == 6, "test copy failed" );
}



# test
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '["ghfu-fr,gfur-frf","456-8552,4782-fd458","2,3","2,3","INTERNAL"]'; }
);
{
my $a = 0;
local *crawl_broadcastdata = sub { return 0 ;};
local *change_status_metadatas = sub { 
										if ($a ==0){
										$a++;
											return 0;
											
										}else{
											return 1;
										}
									};

local *synchronize_metadatas_on_extern_zone = sub { return 0;};
ok( publicate_metadatas("3") == 4, "test change inspire status failed" );
}


{
my $a = 0;
local *crawl_broadcastdata = sub { return 0 ;};
local *change_status_metadatas = sub { 
										if ($a <2){
										$a++;
											return 0;
											
										}else{
											return 1;
										}
									};

local *synchronize_metadatas_on_extern_zone = sub { return 0;};
ok( publicate_metadatas("3") == 7, "test change pva status failed" );
}

# test
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 0; },
		decoded_content => sub { return '["ghfu-fr,gfur-frf","456-8552,4782-fd458","2,3","2,3","INTERNAL"]'; }
);
{
local *crawl_broadcastdata = sub { return 1 ;};
local *change_status_metadatas = sub { return 0;};
ok( publicate_metadatas("33") == 5, "connection failed" );
}





# test
ok( publicate_metadatas() == 255, "testWithoutParameters" );





