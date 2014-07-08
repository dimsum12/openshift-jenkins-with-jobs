#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script do a specific raster check on a delivery
# ARGS :
#   The delivery ID
# RETURNS :
#   * 0 if verification is correct
#   * 1 if at least a georaster verification has throw an error
#   * 2 if the delivery does not contains an information file
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/verification/raster_check.pl $
#   $Date: 17/08/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Deliveryconf;
use Cwd;
use Config::Simple;
use DBI;

require "check_georaster.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger = Logger->new( "raster_check.pl", $config->param("logger.levels") );

my $dbname   = $config->param("db-ent_referentiel.dbname");
my $host     = $config->param("db-ent_referentiel.host");
my $port     = $config->param("db-ent_referentiel.port");
my $username = $config->param("db-ent_referentiel.username");
my $password = $config->param("db-ent_referentiel.password");

my $deliveries_path      = $config->param("filer.delivery-ftp");
my $auto_detect_filename = $config->param("auto-detect.filename");
my $nb_raster_check      = $config->param("check.raster.nb");

sub raster_check {

    # Parameters number validation
    my ($delivery_id) = @_;
    if ( !defined $delivery_id ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    $logger->log( "INFO",
        "Vérification Raster de la livraison " . $delivery_id );

    #Préparation DB
    my $dbh = DBI->connect( "dbi:Pg:dbname=$dbname;host=$host;port=$port",
        $username, $password,
        { AutoCommit => 1, RaiseError => 1, PrintError => 1 } );

    my $sth = $dbh->prepare(
        "SELECT login FROM delivery WHERE id = '" . $delivery_id . "'" );
    $sth->execute();

    ( my $delivery_login ) = $sth->fetchrow_array;
    my $delivery_dir = $deliveries_path . $delivery_login;
    $logger->log( "INFO",
        "Récupération du repertoire de la livraison : " . $delivery_dir );

    $sth->finish;
    $dbh->disconnect;

    my $deliveryconf = Deliveryconf->new( $delivery_dir, $logger, $config );
    if ($deliveryconf) {
        my $raster_dir =
          $delivery_dir . '/' . $deliveryconf->{values}{"DIR.DATA"} . '/';

        $logger->log( "INFO", "Vérification des georaster" );
        my $return_check_raster =
          check_georaster( $raster_dir, $nb_raster_check );
        $logger->log( "DEBUG",
            " --> Valeur de retour : " . $return_check_raster );

        if ( $return_check_raster != 0 ) {
            $logger->log( "ERROR",
                "Au moins une vérification georaster est en erreur" );
            return 1;
        }
    }
    else {
        $logger->log( "ERROR",
"Erreur lors de la lecture du fichier d'informations supplémentaires"
        );
        return 2;
    }

    return 0;
}

