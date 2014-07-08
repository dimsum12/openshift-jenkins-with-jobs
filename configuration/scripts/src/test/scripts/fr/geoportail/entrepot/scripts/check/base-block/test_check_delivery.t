#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 8;
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

my $dbh;
my $sth;

sub initDB(){
	$dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=$host;port=$port",$username,$password,{AutoCommit => 1, RaiseError => 0, PrintError => 1});
	$sth = $dbh->prepare("SELECT id FROM product WHERE name = 'AUTO_DETECTION'");
	$sth->execute();
	(my $id_auto_detect) = $sth->fetchrow_array;
	$sth = $dbh->prepare("INSERT INTO product (id, name) VALUES(8888,'produit_de_test')");
	$sth->execute();
	$sth = $dbh->prepare("INSERT INTO deliveryproduct (id) VALUES(8888)");
	$sth->execute();
	$sth = $dbh->prepare("INSERT INTO data(id)
                VALUES(9999),
                        (9998)");
        $sth->execute();
	$sth = $dbh->prepare("INSERT INTO delivery(id, automatictimeout, deliveryproduct_id, login)
		VALUES(9999, FALSE, 8888, 'FTP-9999'),
			(9998, FALSE, ".$id_auto_detect.", 'FTP-9998')");
	$sth->execute();

    $sth->finish;
    $dbh->disconnect;
}

sub cleanDB(){
    $dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=$host;port=$port",$username,$password,{AutoCommit => 1, RaiseError => 1, PrintError => 0});

    $sth = $dbh->prepare("DELETE FROM generation_data
                WHERE data_id=9995 OR data_id=9994");
    $sth->execute();

    $sth = $dbh->prepare("DELETE FROM delivery
	WHERE id=9998
        OR id=9999");
    $sth->execute();

    $sth = $dbh->prepare("DELETE FROM data
        WHERE id=9998
        OR id=9999");
    $sth->execute();

    $sth = $dbh->prepare("DELETE FROM deliveryproduct
		WHERE id=8888");
	$sth->execute();

    $sth = $dbh->prepare("DELETE FROM product
		WHERE id=8888");
	$sth->execute();

    $sth->finish;
    $dbh->disconnect;
}

#Préparation DB
cleanDB();
initDB();

require "check_delivery.pl";

ok( check_delivery() == 255, "Test sans paramètre" );
ok( check_delivery($resources_path."check_delivery_one_directory_ok", 9998) == 0, "Test avec une livraison comportant un seul répertoire livré");
ok( check_delivery($resources_path."check_delivery_one_archive_ok", 9999) == 0, "Test avec une livraison comportant une seule archive livrée");
ok( check_delivery($resources_path."check_delivery_multiple_directories_nok", 9999) == 1, "Test avec une livraison comportant plusieurs répertoires livrés");
ok( check_delivery($resources_path."check_delivery_multiple_archives_nok", 9999) == 2, "Test avec une livraison comportant plusieurs archives livrées"); 
ok( check_delivery($resources_path."check_delivery_no_directory_nok", 9999) == 3, "Test avec une livraison comportant aucun répertoire livré");
ok( check_delivery($resources_path."check_delivery_no_archive_nok", 9999) == 3, "Test avec une livraison comportant aucune archive livrée");
ok( check_delivery($resources_path."check_delivery_nok", 9999) == 4, "Test avec une livraison comportant plusieurs répertoires et plusieurs archives livrées");

cleanDB();
