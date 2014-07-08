#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script synchronize a volume by launching a snapmirror action on the volume on the dedicated machine
# ARGS :
#   The volume to synchronize
# RETURNS :
#   * 0 if synchronization is finished
#	* 1 if connection to machine failed
#   * 2 if snapmirror still in progress
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/synchronization/getstatus_synchronization.pl $
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
use Execute;
our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $script_synchro = $config->param("synchronization.script");
my $logger_levels  = $config->param("logger.levels");
my $logger = Logger->new( "getstatus_synchronization.pl", $logger_levels );

my $regexp_idle = "^.*Idle.*\$";

sub getstatus_synchronization {

    # Parameters number validation
    my ( $machine, $volume ) = @_;
    if ( !defined $volume || !defined $machine ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (2)"
        );
        return 255;
    }

    $logger->log( "INFO", "Paramètre 1 : machine = " . $machine );
    $logger->log( "INFO", "Paramètre 2 : volume = " . $volume );

    $logger->log( "INFO", "Script de synchro à utiliser " . $script_synchro );

    # connect to machine
    my ( $sortie, $exitcode ) = getstatus( $machine, $volume );

    if ( $exitcode != 0 ) {
        $logger->log( "ERROR", "Erreur lors de l'appel du snapmirror" );
        $logger->log( "INFO",  "Code retour = " . $sortie );
        return 1;
    }
    $logger->log( "INFO", "retour du get status  " . $sortie );

    # get the status
    my $status = $sortie;
    $logger->log( "INFO", "status : " . $status );
    chomp $status;

    # test return code
    if ( $status !~ /$regexp_idle/ ) {
        $logger->log( "INFO",
            "Snapmirror toujours en cours. Etat actuel =  " . $status );
        return 2;
    }

    $logger->log( "INFO", "volume synchronisé " );
    return 0;

}

sub getstatus {
    my ( $machine, $volume ) = @_;
    my $sortie = `sudo $script_synchro $machine $volume status | grep "Status"`;
    my $exitcode = $?;
    $logger->log( "DEBUG", "bash-execution sortie =  " . $sortie );
    $logger->log( "DEBUG", "bash-execution code retour =   " . $exitcode );
    return $sortie, $exitcode;
}

