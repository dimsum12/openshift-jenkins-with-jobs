#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script do a generic check on a delivery
# ARGS :
#   The delivery ID
# RETURNS :
#   * 0 if verification is correct
#   * 1 if at least an error occured during the verifications
#   * 254 if the delivery id does not exist in DB
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/verification/standard_check.pl $
#   $Date: 17/08/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;
use DBI;

require "check_delivery.pl";
require "check_md5.pl";
require "check_uncompress.pl";
require "check_xsd.pl";
require "check_auto_detect.pl";
require "change_owner.pl";
require "change_rights.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger =
  Logger->new( "standard_check.pl", $config->param("logger.levels") );

my $dbname   = $config->param("db-ent_referentiel.dbname");
my $host     = $config->param("db-ent_referentiel.host");
my $port     = $config->param("db-ent_referentiel.port");
my $username = $config->param("db-ent_referentiel.username");
my $password = $config->param("db-ent_referentiel.password");

my $deliveries_path = $config->param("filer.delivery-ftp");
my $warning_chain   = $config->param("check.warning.chain");

my $user   = $config->param("check.user");
my $group  = $config->param("check.group");
my $rights = $config->param("check.rights");
my $sudo = $config->param("check.sudo");

sub standard_check {

    # Parameters number validation
    my ($delivery_id) = @_;
    if ( !defined $delivery_id ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    $logger->log( "INFO",
        "Vérification Standard de la livraison " . $delivery_id );

    #Préparation DB
    my $dbh = DBI->connect( "dbi:Pg:dbname=$dbname;host=$host;port=$port",
        $username, $password,
        { AutoCommit => 1, RaiseError => 1, PrintError => 1 } );

    my $sth = $dbh->prepare(
        "SELECT login FROM delivery WHERE id = '" . $delivery_id . "'" );
    $sth->execute();

    ( my $delivery_login ) = $sth->fetchrow_array;
    if ( !defined $delivery_login ) {
        $logger->log( "ERROR",
            "La livraison a vérifier est introuvable en BDD" );
        return 254;
    }

    my $delivery_dir = $deliveries_path . $delivery_login . "/";
    $logger->log( "INFO",
        "Récupération du repertoire de la livraison : " . $delivery_dir );

    $sth->finish;
    $dbh->disconnect;

    my $warning = 0;

    $logger->log( "INFO",
        "Vérification de la structure des données livrées" );
    my $return_check_delivery = check_delivery( $delivery_dir, $delivery_id );
    $logger->log( "DEBUG",
        " --> Valeur de retour : " . $return_check_delivery );
    if ( $return_check_delivery != 0 ) {
        $logger->log( "ERROR",
            "Erreur dans la structuration des données livrées" );
        return 1;
    }

    $logger->log( "INFO", "Vérification des clés md5" );
    my $return_check_md5 = check_md5( $delivery_dir, $delivery_dir );
    $logger->log( "DEBUG", " --> Valeur de retour : " . $return_check_md5 );

    if ( $return_check_md5 == 1 ) {
        $logger->log( "WARN",
            "Au moins un fichier de la livraison n'a pas de clé md5 associée"
        );
        $warning = $warning + 1;
    }
    elsif ( $return_check_md5 != 0 ) {
        $logger->log( "ERROR", "Au moins une vérification md5 est en erreur" );
        return 1;
    }

    $logger->log( "INFO", "Décompression des archives" );
    my $return_check_uncompress = check_uncompress($delivery_dir);
    $logger->log( "DEBUG",
        " --> Valeur de retour : " . $return_check_uncompress );
    if ( $return_check_uncompress != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de la décompression des archives" );
        return 1;
    }

    # changement du propriétaire des différents fichiers extraits
    $logger->log( "INFO", "changements de propriétaires des données" );
    my $return_change_owner = change_owner( $delivery_dir, $user, $group, $sudo );
    $logger->log( "DEBUG", " --> Valeur de retour : " . $return_change_owner );
    if ( $return_change_owner != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors du changement de propriétaire des fichiers extraits"
        );
        return 1;
    }

    # changement des droits des différents fichiers extraits
    $logger->log( "INFO", "changements de droits des données" );
    my $return_change_rights = change_rights( $delivery_dir, $rights, 0, 1 );
    $logger->log( "DEBUG", " --> Valeur de retour : " . $return_change_rights );
    if ( $return_change_rights != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors du changement de propriétaire des fichiers extraits"
        );
        return 1;
    }

    $logger->log( "INFO", "Vérification des XML de métadonnées" );
    my $return_check_xsd = check_xsd($delivery_dir);
    $logger->log( "DEBUG", " --> Valeur de retour : " . $return_check_xsd );
    if ( $return_check_xsd != 0 ) {
        $logger->log( "ERROR", "Au moins une vérification XML est en erreur" );
        return 1;
    }

    $logger->log( "INFO", "Détection du type de produit" );
    my $return_check_auto_detect = check_auto_detect($delivery_id);
    $logger->log( "DEBUG",
        " --> Valeur de retour : " . $return_check_auto_detect );
    if ( $return_check_auto_detect != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de la détection du type de produit" );
        return 1;
    }

    if ( $warning > 0 ) {
        $logger->log( "WARN",
                "Avertissement sur la livraison"
              . $delivery_id
              . " : Aucun traitement automatique ne sera lancée sur celle-ci"
        );
        $logger->log( "INFO",
            "Envoi du message warning_chain à l'orchestrateur" );
        $logger->log( "INFO", $warning_chain );
    }

    return 0;
}
1;
