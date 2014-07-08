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
no warnings 'redefine';
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");

require "depublicate_metadatas.pl";


#   * 0 if success
#	* 1 zone is incorrect
#	* 3 if change status failed for isoap mtds
#	* 4 if change status failed for inspiremtds
#   * 255 if the function is called an incorrect number of arguments

# Mock permettant de ne pas appeler les services REST.
# Le retour des appels est simulé par un mock spécifique à chaque test (ci dessous)
my $mock_global = Test::MockObject->new();
$mock_global->fake_module(
	'LWP::UserAgent',
	request => sub { return HTTP::Response->new() }
);


# test
my $mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '["ghfu-fr,gfur-frf","456-8552,4782-fd458","456-8552,4782-fd458","INTERNAL"]'; }
);
{
local *change_status_metadatas = sub { return 0;};
ok( depublicate_metadatas("INTERNAL", "ghfu-fr,gfur-frf", "456-8552,4782-fd458") == 0, "test ok" );
}



# test
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '["ghfu-fr,gfur-frf","456-8552,4782-fd458","456-8552,4782-fd458","INTE"]'; }
);
{
local *change_status_metadatas = sub { return 0;};
ok( depublicate_metadatas("22") == 1, "test wrong zone" );
}




# test
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '["ghfu-fr,gfur-frf","456-8552,4782-fd458","456-8552,4782-fd458","INTERNAL"]'; }
);
{
local *change_status_metadatas = sub { return 1;};
ok( depublicate_metadatas("33") == 3, "test change isoap status failed" );
}

# test
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '["ghfu-fr,gfur-frf","456-8552,4782-fd458","456-8552,4782-fd458","INTERNAL"]'; }
);
{
my $a = 0;
local *change_status_metadatas = sub { 
										if ($a ==0){
										$a++;
											return 0;
											
										}else{
											return 1;
										}
									};
ok( depublicate_metadatas("33") == 4, "test change inspire status failed" );
}


{
my $a = 0;
local *change_status_metadatas = sub { 
										if ($a <2){
										$a++;
											return 0;
											
										}else{
											return 1;
										}
									};
ok( depublicate_metadatas("33") == 6, "test change pva status failed" );
}




# test
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 0; },
		decoded_content => sub { return '["ghfu-fr,gfur-frf","456-8552,4782-fd458","456-8552,4782-fd458","INTE"]'; }
);
{
local *change_status_metadatas = sub { return 0;};
ok( depublicate_metadatas("22") == 5, "test connection to webservice failed" );
}






# test
$mock = Test::MockObject->new();
$mock->fake_module(
		'HTTP::Response',
		is_success => sub { return 1; },
		decoded_content => sub { return '["ghfu-fr,gfur-frf","456-8552,4782-fd458","456-8552,4782-fd458","INTERNAL"]'; }
);
ok( depublicate_metadatas() == 255, "testWithoutParameters" );





