#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 4;
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


my $logger =
  Logger->new( "check_size.pl", $config->param("logger.levels") );

require "check_size.pl";

Execute->run( "rm -rf /tmp/FTP-test-check_size/", "true" );
Execute->run( "mkdir /tmp/FTP-test-check_size/" , "true" );

Execute->run( "touch /tmp/FTP-test-check_size/fichier1", "true" );
Execute->run( "echo  'gtdydhf' >> /tmp/FTP-test-check_size/fichier1", "true" );
Execute->run( "touch /tmp/FTP-test-check_size/fichier2", "true" );
Execute->run( "echo  'gtdydhf' >> /tmp/FTP-test-check_size/fichier2", "true" );

ok( check_size("/tmp/FTP-test-check_size/", "1000") == 0, "test ok" );


Execute->run( "touch /tmp/FTP-test-check_size/fichier3", "true" );
Execute->run( "echo  'gt1545454ifjfndhdgdhdhrgfherhghergierguerukgherghuerghkureghergerguer' >> /tmp/FTP-test-check_size/fichier3", "true" );

ok( check_size("/tmp/FTP-test-check_size/", "15") == 2, "test file too big" );

ok( check_size("/tmp/FTP-does_not_exists/", "1000") == 1, "test directory does not exists" );

ok( check_size() == 255, "test wrond number of parameters" );


Execute->run( "rm -rf /tmp/FTP-test-check_size/", "true" );