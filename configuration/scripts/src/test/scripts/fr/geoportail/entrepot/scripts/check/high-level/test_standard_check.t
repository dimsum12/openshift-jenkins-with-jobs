#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 10;
use Config::Simple;

use strict;
use warnings;
no warnings 'redefine';
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


#Preparation DB
my $dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=$host;port=$port",$username,$password,{AutoCommit => 1, RaiseError => 0, PrintError => 0});

my $sth = $dbh->prepare("SELECT id FROM product WHERE name = 'AUTO_DETECTION'");
        $sth->execute();
        (my $id_auto_detect) = $sth->fetchrow_array;

$sth = $dbh->prepare("INSERT INTO data(id)
        VALUES(9999)");
$sth->execute();

$sth = $dbh->prepare("INSERT INTO delivery(id, automatictimeout, deliveryproduct_id, login)
        VALUES(9999, FALSE, $id_auto_detect, 'complete_delivery_standard_ok')");
$sth->execute();

$sth->finish;
$dbh->disconnect;


require "standard_check.pl";


# Mock global pour l'ensemble des briques de verification
{
        local *check_delivery = sub {return 0;};
        local *check_md5 = sub {return 0;};
        local *check_uncompress = sub {return 0;};
        local *check_xsd = sub {return 0;};
        local *check_auto_detect = sub {return 0;};
		local *change_owner = sub {return 0;};
		local *change_rights = sub {return 0;};


	ok( standard_check() == 255, "testWithoutParameters" );

	ok( standard_check(9999) == 0, "testWithCorrectDelivery" );
	
	{
		local *check_md5 = sub {return 1;};
		ok( standard_check(9999) == 0, "testWithWarningDelivery" );
	}

	{
		local *check_delivery = sub {return 1;};
		ok( standard_check(9999) == 1, "testWithErrorCheckDelivery" );
	}

	{
		local *check_md5 = sub {return 2;};
		ok( standard_check(9999) == 1, "testWithErrorCheckMd5" );
	}

	{
		local *check_uncompress = sub {return 1;};
		ok( standard_check(9999) == 1, "testWithErrorCheckUncompressed" );
	}
	
	{
		local *check_xsd = sub {return 1;};
		ok( standard_check(9999) == 1, "testWithErrorCheckXsd" );
	}
	
	{
		local *check_auto_detect = sub {return 1;};
		ok( standard_check(9999) == 1, "testWithErrorAutoDetect" );
	}
	
	{
		local *change_owner = sub {return 1;};
		ok( standard_check(9999) == 1, "testWithErrorChangeOwner" );
	}
	
	{
		local *change_rights = sub {return 1;};
		ok( standard_check(9999) == 1, "testWithErrorChangeRights" );
	}
}


$dbh = DBI->connect("dbi:Pg:dbname=$dbname;host=$host;port=$port",$username,$password,{AutoCommit => 1, RaiseError => 0, PrintError => 0});

$sth = $dbh->prepare("DELETE FROM generation
	WHERE delivery_id=9999");
$sth->execute();

$sth = $dbh->prepare("DELETE FROM delivery
        WHERE id=9999");
$sth->execute();

$sth = $dbh->prepare("DELETE FROM data
        WHERE id=9999");
$sth->execute();

$sth->finish;
$dbh->disconnect;
