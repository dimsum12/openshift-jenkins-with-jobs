#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#
# ARGS :
#   The delivery directory
#   The delivery id
# RETURNS :
#   * 0 if the process is correct
#   * 1 if the delivery contain several directories
#   * 2 if the delivery contain several archives
#   * 3 if the delivery is empty
#   * 4 if the delivery contain several archives and several directories
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/verification/check_delivery.pl $
#   $Date: 23/08/11 $
#   $Author: Charles-Henri Biller (a149912) <charles-henri.biller@atos.net> $
#########################################################################################################################

use strict;
use warnings;
use Cwd;
use Logger;
use Config::Simple;
use DBI;
use File::Basename;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger =
  Logger->new( "check_delivery.pl", $config->param("logger.levels") );

my $dbname   = $config->param("db-ent_referentiel.dbname");
my $host     = $config->param("db-ent_referentiel.host");
my $port     = $config->param("db-ent_referentiel.port");
my $username = $config->param("db-ent_referentiel.username");
my $password = $config->param("db-ent_referentiel.password");

my $file_extension      = ".md5";
my $return_code         = 0;
my $checksum_pattern_ok = ".*OK.*";
my $regex_find = '\(.*.tar\|.*.tgz\|.*.tbz\|.*.zip\|.*.tar.gz\|.*.gz\|.*.not\)';

sub check_delivery {

    # Parameters number validation
    my ( $delivery_dir, $delivery_id ) = @_;
    if ( !defined $delivery_dir || !defined $delivery_id ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (2)"
        );
        return 255;
    }

    # Connection DB
    my $dbh = DBI->connect( "dbi:Pg:dbname=$dbname;host=$host;port=$port",
        $username, $password,
        { AutoCommit => 1, RaiseError => 1, PrintError => 0 } );

    $logger->log( "INFO",
"Lancement de vérification de la structure du répertoire, $delivery_dir"
    );

    my @directories_list = `find $delivery_dir -mindepth 1 -maxdepth 1 -type d`;
    my $directories_number = scalar @directories_list;
    chomp $directories_number;
    my @archives_list =
`find $delivery_dir -mindepth 1 -maxdepth 1 -type f -iregex '$regex_find'`;
    my $archives_number = scalar @archives_list;
    chomp $archives_number;

    $logger->log( "INFO",
        "Nombre de répertoires trouvés : $directories_number" );
    $logger->log( "INFO", "Nombre d'archives trouvées : $archives_number" );

    #No directory or archive in the delivery
    if ( $directories_number == 0 && $archives_number == 0 ) {
        $logger->log( "DEBUG",
"Problème de structure, la livraison est vide et ne contient aucune donnée livrée"
        );
        return 3;
    }

    #Multiple directories in the delivery
    if ( $directories_number > 1 && $archives_number == 0 ) {
        $logger->log( "ERROR",
"Problème de structure, la livraison contient plusieurs répertoires, un seul répertoire doit être présent"
        );
        return 1;
    }

    #Multiple archives in the delivery
    if ( $directories_number == 0 && $archives_number > 1 ) {
        $logger->log( "ERROR",
"Problème de structure, la livraison contient plusieurs archives, une seule archive doit être présente"
        );
        return 2;
    }

    if ( $directories_number == 1 && $archives_number == 0 ) {
        chomp $directories_list[0];
        $logger->log( "INFO",
"La structure de la livraison est correcte et comporte un seul répertoire livré"
        );
        my $delivery_name = basename( $directories_list[0] );
        my $SQL = "UPDATE data SET name='$delivery_name' WHERE id=$delivery_id";
        my $sth = $dbh->prepare($SQL);
        my $rv  = $sth->execute();
        $sth->finish;
        $dbh->disconnect;
        return 0;
    }

    if ( $directories_number == 0 && $archives_number == 1 ) {
        chomp $archives_list[0];
        $logger->log( "INFO",
"La structure de la livraison est correcte et comporte une seule archive livrée"
        );
        my $delivery_name = fileparse( $archives_list[0], qr/[.][^.]*/ );
        $delivery_name = fileparse( $delivery_name, qr/[.][^.]*/ );
        my $SQL = "UPDATE data SET name='$delivery_name' WHERE id=$delivery_id";
        my $sth = $dbh->prepare($SQL);
        my $rv  = $sth->execute();
        $sth->finish;
        $dbh->disconnect;
        return 0;
    }

    if ( $directories_number > 1 && $archives_number > 1 ) {
        $logger->log( "ERROR",
"Problème de structure, la livraison comporte plusieurs répertoires et archives"
        );
        return 4;
    }
}
