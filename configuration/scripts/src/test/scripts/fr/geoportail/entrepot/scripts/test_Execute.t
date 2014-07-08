#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 4;
use Execute;
use Logger;

use strict;
use warnings;
use Cwd;
use Config::Simple;

my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");


my $cmd1 = 'echo "TEST OUT"';
my $cmd2 = 'man';
my $cmd3 = $cmd1.';'.$cmd2;
my $logger = Logger->new( "test", $config->param("logger.levels") );

my $result1 = Execute->run($cmd1);
my @log1 = $result1->get_log();
my $log1_1 = $log1[0];
chomp $log1_1;
my $return_value1 = $result1->get_return();
ok ($log1_1 eq 'TEST OUT' && $return_value1 == 0, "Test avec une simple sortie et un retour à 0");


my $result2 = Execute->run($cmd2, "true");
my @log2 = $result2->get_log();
my $log2_1 = $log2[0];
chomp $log2_1;
my $return_value2 = $result2->get_return();
ok ($log2_1 ne '' && $return_value2 != 0, "Test avec une sortie erreur et un retour à 1");


my $result3 = Execute->run($cmd3, "false");
my @log3 = $result3->get_log();
my $log3_1 = $log3[0];
chomp $log3_1;
my $return_value3 = $result3->get_return();
ok ($log3_1 eq 'TEST OUT' && scalar @log3 == 1 && $return_value3 != 0, "Test avec une double sortie, un retour à 1 et pas de sortie erreur");


my $result4 = Execute->run($cmd3, "true");
my @log4 = $result4->get_log();
my $log4_1 = $log4[0];
my $log4_2 = $log4[1];
chomp $log4_1;
chomp $log4_2;
my $return_value4 = $result4->get_return();
$result4->log_all($logger, "INFO");
ok ($log4_1 eq 'TEST OUT' && $log4_2 ne '' && $return_value4 != 0, "Test avec une double sortie, un retour à 1 et de la sortie erreur");
