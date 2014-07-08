#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 3;
use Config::Simple;

use strict;
use warnings;
use Cwd;
use DBI;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");


my $dbname = $config->param("db-ent_referentiel.dbname");
my $host = $config->param("db-ent_referentiel.host");
my $port =  $config->param("db-ent_referentiel.port");
my $username = $config->param("db-ent_referentiel.username");
my $password = $config->param("db-ent_referentiel.password");

#Préparation DB
my $dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=$host;port=$port",$username,$password,{AutoCommit => 1, RaiseError => 0, PrintError => 0});

my $sth = $dbh->prepare("INSERT INTO product (id, name)
        VALUES(8887,'AUTO_DETECTION')");
$sth->execute();

$sth = $dbh->prepare("INSERT INTO deliveryproduct (id) VALUES(8887)");
$sth->execute();

$sth = $dbh->prepare("INSERT INTO data(id)
        VALUES(9999),
                (9998)");
$sth->execute();

$sth = $dbh->prepare("INSERT INTO delivery(id, automatictimeout, deliveryproduct_id, login)
        VALUES(9999, FALSE, 8887, 'complete_delivery_raster_ok'),
                (9998, FALSE, 8887, 'complete_delivery_raster_nok')");
$sth->execute();

$sth->finish;
$dbh->disconnect;

require "raster_check.pl";

ok( raster_check() == 255, "testWithoutParameters" );
ok( raster_check(9999) == 0, "testWithCorrectDelivery" );
ok( raster_check(9998) == 1, "testWithIncorrectDelivery" );


$dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=$host;port=$port",$username,$password,{AutoCommit => 1, RaiseError => 0, PrintError => 0});

$sth = $dbh->prepare("DELETE FROM delivery
        WHERE id=9999
        OR id=9998");
$sth->execute();

$sth = $dbh->prepare("DELETE FROM data
        WHERE id=9999
        OR id=9998");
$sth->execute();

$sth = $dbh->prepare("DELETE FROM deliveryproduct
        WHERE id=8887");
$sth->execute();

$sth = $dbh->prepare("DELETE FROM product
        WHERE id=8887");
$sth->execute();

$sth->finish;
$dbh->disconnect;
