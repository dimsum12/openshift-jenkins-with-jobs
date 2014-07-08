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

require "change_owner.pl";

Execute->run( "rm -rf /tmp/test-change-owner/", "true" );
Execute->run( "mkdir /tmp/test-change-owner/", "true" );

ok( change_owner() == 255, "Test sans paramètre" );
ok( change_owner("/dossier-qui-n-existe-pas/", "owner", "group", 1) == 1, "Test KO le dossier n'existe pas" );
ok( change_owner("/tmp/test-change-owner/", "owner", "group", 1) == 2, "Test KO sur changement de propriétaire" );
ok( change_owner("/tmp/test-change-owner/", $user, $group, 1) == 0, "Test OK" );

Execute->run( "rm -rf /tmp/test-change-owner/", "true" );
