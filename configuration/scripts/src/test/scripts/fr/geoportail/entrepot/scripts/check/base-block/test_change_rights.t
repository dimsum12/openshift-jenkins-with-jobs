#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 4;
use Config::Simple;
use Execute;
use strict;
use warnings;
use Cwd;

my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $user = $config->param("check.user");
my $group = $config->param("check.group");

require "change_rights.pl";

Execute->run( "rm -rf /tmp/test-change-rights/", "true" );
Execute->run( "mkdir /tmp/test-change-rights/", "true" );
Execute->run( "touch /tmp/test-change-rights/file1", "true" );
Execute->run( "touch /tmp/test-change-rights/file2", "true" );

ok( change_rights() == 255, "Test sans paramètre" );
ok( change_rights("/dossier-qui-n-existe-pas/", 751, 1, 1) == 1, "Test KO le dossier n'existe pas" );
ok( change_rights("/tmp/test-change-rights/file1", 999, 0, 1) == 2, "Test KO sur changement de droits" );
ok( change_rights("/tmp/test-change-rights/", 751, 1 , 1) == 0, "Test OK" );

Execute->run( "rm -rf /tmp/test-change-owner/", "true" );
