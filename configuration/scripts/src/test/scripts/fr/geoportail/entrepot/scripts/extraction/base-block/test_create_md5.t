#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();
use Test::Simple tests =>5;
use Config::Simple;
use strict;
use warnings;
use Cwd;
use Logger;


require "create_md5.pl" ;




ok(create_md5() == 255, "testWithoutParameters");


ok(create_md5("/tmp/not_exist") == 1, "testWithUnexistingFolder");


Execute->run( "mkdir -p /tmp/empty", "true" ); 
ok(create_md5("/tmp/empty") == 0, "testWithEmptyFolder");
Execute->run( "rm -rf /tmp/empty", "true");
Execute->run( "rm  /tmp/empty.md5", "true");


Execute->run( "mkdir -p /tmp/conditionnement_md5/test" );
Execute->run( "touch /tmp/conditionnement_md5/test1" );
Execute->run( "touch /tmp/conditionnement_md5/test2" );
ok(create_md5( "/tmp/conditionnement_md5" ) == 0, "testOKFolder" );
ok(create_md5( "/tmp/conditionnement_md5/test1" ) == 0, "testOKFile");
Execute->run( "rm -rf /tmp/conditionnement_md5", "true" );
Execute->run( "rm /tmp/conditionnement_md5.md5", "true" );





