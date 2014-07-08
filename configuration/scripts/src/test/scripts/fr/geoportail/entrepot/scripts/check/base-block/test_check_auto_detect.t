#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 11;
use Config::Simple;
use Test::MockObject;

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
	$sth->finish;

	$sth = $dbh->prepare("INSERT INTO product (id, name)
			VALUES(8888,'produit_de_test')");
	$sth->execute();
	$sth->finish;

	$sth = $dbh->prepare("INSERT INTO deliveryproduct (id) VALUES(8888)");
	$sth->execute();
	$sth->finish;

	$sth = $dbh->prepare("INSERT INTO data(id)
                VALUES(9999),
                        (9998),
                        (9997),
                        (9996),
                        (9995),
                        (9994),
                        (9993),
                        (9992),
                        (10001)");
        $sth->execute();
	$sth->finish;

	$sth = $dbh->prepare("INSERT INTO delivery(id, automatictimeout, deliveryproduct_id, login) 
		VALUES(9999, FALSE, 8888, 'FTP-9999'),
			(9998, FALSE, ".$id_auto_detect.", 'FTP-9998'),
			(9997, FALSE, ".$id_auto_detect.", 'FTP-9997'),
			(9996, FALSE, ".$id_auto_detect.", 'FTP-9996'),
			(9995, FALSE, ".$id_auto_detect.", 'FTP-9995'),
			(9994, FALSE, ".$id_auto_detect.", 'FTP-9994'),
			(9993, FALSE, ".$id_auto_detect.", 'FTP-9993'),
			(9992, FALSE, ".$id_auto_detect.", 'FTP-9992'),
            (10001, FALSE, ".$id_auto_detect.", 'FTP-10001')");
	$sth->execute();
	$sth->finish;
	
	$dbh->disconnect;
}

sub cleanDB(){
	$dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=$host;port=$port",$username,$password,{AutoCommit => 1, RaiseError => 1, PrintError => 0});
	$sth = $dbh->prepare("DELETE FROM delivery
			WHERE id=9992 
			OR id=9993 
			OR id=9994
			OR id=9995
			OR id=9996
			OR id=9997
			OR id=9998
			OR id=9999
            OR id=10001");
	$sth->execute();
	$sth->finish;

	$sth = $dbh->prepare("DELETE FROM data
                        WHERE id=9992
                        OR id=9993
                        OR id=9994
                        OR id=9995
                        OR id=9996
                        OR id=9997
                        OR id=9998
                        OR id=9999
                        OR id=10001");
    $sth->execute();
	$sth->finish;

	$sth = $dbh->prepare("DELETE FROM deliveryproduct
			WHERE id=8888");
	$sth->execute();
	$sth->finish;

	$sth = $dbh->prepare("DELETE FROM product 
		WHERE id=8888");
	$sth->execute();
	$sth->finish;
	
	$dbh->disconnect;
}

#Préparation DB
cleanDB();
initDB();

require "check_auto_detect.pl";


my $mock = Test::MockObject->new();
$mock->fake_module(
	'LWP::UserAgent',
	request => sub { return HTTP::Response->new() }
);
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 1; },
);


ok( check_auto_detect() == 255, "Test sans paramètre" );
ok( check_auto_detect(9995) == 0, "Test avec un type trouvé et valide associé à un fichier d'informations complémentaires");
ok( check_auto_detect(9992) == 0, "Test avec un type trouvé et valide associé à un fichier d'informations complémentaires complexe");
ok( check_auto_detect(9999) == 0, "Test avec un identifiant ne nécessitant pas de détection automatique" );
ok( check_auto_detect(10001) == 0, "Test avec type trouvé et valide associé à un fichier d'information de type POI");
ok( check_auto_detect(9996) == 1, "Test avec un type inconnu");
ok( check_auto_detect(10000) == 2, "Test avec un identifiant de livraison inconnu" );
ok( check_auto_detect(9998) == 3, "Test avec un fichier d'informations complémentaires absent");
ok( check_auto_detect(9993) == 3, "Test avec un fichier d'informations vide");
ok( check_auto_detect(9997) == 3, "Test avec un fichier d'informations complémentaires mal formaté" );
$mock->fake_module(
        'HTTP::Response',
        is_success => sub { return 0; },
);
ok( check_auto_detect(9994) == 4, "Test avec un type trouvé et valide avec une erreur dans le nom de la génération");

cleanDB();
