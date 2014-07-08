#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 3;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
no warnings 'redefine';
use Cwd;



my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");

require "launch_synchronization.pl";


#   * 0 if synchronization is launched
#	* 1 if connection to machine failed
#   * 255 if the function is called an incorrect number of arguments



# test
{
local *executebashonmachine = sub { return "",0;};
ok( launch_synchronization("localhost","a184059") == 0, "test synchro lancée" );
}



# test
# test
{
local *executebashonmachine = sub { return "",1;};
ok( launch_synchronization("localhost","a184059") == 1, "test erreur de connection à la machine" );
}


# test
ok( launch_synchronization() == 255, "testWithoutParameters" );
