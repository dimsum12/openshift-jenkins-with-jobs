#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script launch a snapmirror resynchronization on a volume by connecting via SSH to a machine
# ARGS :
#   The machine to connect on via SSH
#   The volume to synchronize
# RETURNS :
#   * 0 if synchronization succeeded
#   * 1 if name of volume is wrong
#	* 2 if connection to machine failed
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/synchronization/launch_synchronization.pl $
#   $Date: 30/08/11 $
#   $Author: Nicolas Godelu (A184059) <nicolas.godelu@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Config::Simple;
use DBI;
use Net::OpenSSH;

require "launch_synchronization.pl";
require "getstatus_synchronization.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $gap     = $config->param("synchronization.gap");
my $timeout = $config->param("synchronization.timeout");

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "duplicate_volume.pl", $logger_levels );

my $tete1 = "spgpp001s";
my $tete2 = "spgpp002s";
my $tete3 = "spgpp003s";
my $tete4 = "spgpp004s";
return 1;

sub duplicate_volume {

    # Parameters number validation
    my ($volume) = @_;
    if ( !defined $volume ) {
        $logger->log( "ERROR",
            "Le nombre de parametres renseignes n'est pas celui attendu (1)" );
        return 255;
    }

    my $elapsed_time = "0";

    $logger->log( "INFO", "Parametre 1 : volume = " . $volume );
    $logger->log( "INFO",
"Parametre 2 : gap (delai entre 2 appels a la baie pour connaître l'etat du snapmirror) = "
          . $gap );
    $logger->log( "INFO",
"Parametre 3 : timeout (delai apres lequel le snapmirror est considere en erreur) = "
          . $timeout );

    #Calculate the netapp machine to connect on
    my $tete = substr $volume, 8, 9;

    my $machine = 0;
    if ( $tete eq "1" ) {
        $machine = $tete1;
    }
    if ( $tete eq "2" ) {
        $machine = $tete2;
    }
    if ( $tete eq "3" ) {
        $machine = $tete3;
    }
    if ( $tete eq "4" ) {
        $machine = $tete4;
    }
    if ( $machine eq "0" ) {
        $logger->log( "ERROR",
            "la tete lue a partir du volume est incorrecte. Sa valeur est "
              . $tete );
        return 1;
    }

    $logger->log( "INFO", "Machine oÃ¹ se connecter = " . $machine );

    # waiting for machine be ready
    $logger->log( "INFO",
        "On vérifie que le volume est disponible pour une nouvelle recopie" );
    my $return_status = getstatus_synchronization( $machine, $volume );

    if ( $return_status == 1 ) {
        $logger->log( "ERROR", "Erreur lors de l'appel du snapmirror status" );
        $logger->log( "DEBUG", "Code retour = " . $return_status );
        return 2;

    }

    while ( $return_status != 0 ) {

        # synchronization still not finished

        if ( $elapsed_time < $timeout ) {

            # no timeout

            $logger->log( "INFO",
                    "Synchronization toujours en cours. on attend " 
                  . $gap
                  . " secondes... Temps deja ecoule (en secondes) = "
                  . $elapsed_time );
            my $result = sleep $gap;
            $elapsed_time += $gap;

        }
        else {

            # timeout
            $logger->log( "ERROR",
"Timeout - la synchronization a depassee le timeout (en secondes) fixe a  "
                  . $timeout );
            return 3;
        }
        $return_status = getstatus_synchronization( $machine, $volume );
    }

    # launch synchronization
    $logger->log( "INFO",
        "Volume disponible, on peut maintenant lancer notre copie" );

    my $return_launch = launch_synchronization( $machine, $volume );
    if ( $return_launch != 0 ) {
        $logger->log( "ERROR", "Erreur lors de l'appel du snapmirror laucnh" );
        $logger->log( "DEBUG", "Code retour = " . $return_launch );
        return 2;
    }

    # monitor status
    $logger->log( "DEBUG", "Maintenant on attend que le statut soit ok" );
    $return_status = getstatus_synchronization( $machine, $volume );

    if ( $return_status == 1 ) {
        $logger->log( "ERROR", "Erreur lors de l'appel du snapmirror status" );
        $logger->log( "DEBUG", "Code retour = " . $return_status );
        return 2;

    }

    $elapsed_time = "0";
    while ( $return_status != 0 ) {

        # synchronization still not finished

        if ( $elapsed_time < $timeout ) {

            # no timeout

            $logger->log( "INFO",
                    "Synchronization toujours en cours. on attend " 
                  . $gap
                  . " secondes... Temps deja ecoule (en secondes) = "
                  . $elapsed_time );
            my $result = sleep $gap;
            $elapsed_time += $gap;

        }
        else {

            # timeout
            $logger->log( "ERROR",
"Timeout - la synchronization a depassee le timeout (en secondes) fixe a  "
                  . $timeout );
            return 3;
        }
        $return_status = getstatus_synchronization( $machine, $volume );
    }

    $logger->log( "INFO",
        "Synchonization terminee en " . $elapsed_time . " secondes" );

    return 0;

}

