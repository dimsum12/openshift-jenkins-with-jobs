#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 6;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
no warnings 'redefine';
use Cwd;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");

require "duplicate_volume.pl";


# test
{
local *main::launch_synchronization = sub { return 0;};
local *getstatus_synchronization = sub { return 0;};
ok( duplicate_volume("i10a_sat2") == 0, "test ok" );
}



# test
ok( duplicate_volume("i10a_sat9") == 1, "test wrong volume name" );


# test
#$mock_getstatus = Test::MockObject->new();
#    $mock_getstatus->mock( 'getstatus_synchronization',
#        sub { return 1; } );

{
local *launch_synchronization = sub { return 0;};
local *getstatus_synchronization = sub { 
										if ($a == 0){
										$a++;
											return 2;
										}elsif ($a == 1){
											$a++;
											return 0;
										}else{
											return 2;
										}
									};	
ok( duplicate_volume("i10a_sat2") == 3, "test timeout" );
}




# test
#$mock_launch = Test::MockObject->new();
#    $mock_launch ->mock( 'launch_synchronization',
#        sub { return 1; } );
{
local *launch_synchronization = sub { return 1;};
local *getstatus_synchronization = sub { return 1;};
ok( duplicate_volume("i10a_sat2") == 2, "test launch synchronization failed" );
}

# test
{
my $a = 0;
local *main::launch_synchronization = sub { return 0;};
local *getstatus_synchronization = sub { 
										if ($a == 0){
										$a++;
											return 0;
										}else{
											return 0;
										}
									};											
ok( duplicate_volume("i10a_sat2") == 0, "test besoin d'attendre la fin de la copie precedente" );
}






# test
ok( duplicate_volume() == 255, "testWithoutParameters" );

