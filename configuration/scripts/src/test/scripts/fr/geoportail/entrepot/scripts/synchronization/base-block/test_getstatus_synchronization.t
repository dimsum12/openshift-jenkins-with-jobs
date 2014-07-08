#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 4;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
no warnings 'redefine';
use Cwd;



my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");

require "getstatus_synchronization.pl";


#   * 0 if synchronization is correct
#	* 1 if connection to machine failed
#   * 2 if snapmirror still in progress
#   * 255 if the function is called an incorrect number of arguments



# test
{
local *getstatus = sub { return "Status Idle",0;};
ok( getstatus_synchronization("localhost","a184059") == 0, "test ok" );
}





# test
{
local *getstatus = sub { return "", 1;};
ok( getstatus_synchronization("localhost","a184059") == 1, "test connection failed" );
}




# test
{
local *getstatus = sub { return "nicolas", 0;};
ok( getstatus_synchronization("localhost","a184059") == 2, "test snapmirror still in progress" );
}


# test
ok( getstatus_synchronization() == 255, "testWithoutParameters" );






