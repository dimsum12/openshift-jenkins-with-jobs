#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script launch a snapmirror resynchronization on a volume by connecting via SSH to a machine
# ARGS :
#   The machine to connect on via SSH
#   The volume to synchronize
# RETURNS :
#   * 0 if synchronization is launched
#	* 1 if connection to machine failed
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

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $script_synchro = $config->param("synchronization.script");
my $logger_levels  = $config->param("logger.levels");
my $logger         = Logger->new( "launch_synchronization.pl", $logger_levels );

sub launch_synchronization {

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
    my ( $sortie, $exitcode ) = executebashonmachine( $machine, $volume );

    if ( $exitcode != 0 ) {
        $logger->log( "ERROR", "Erreur lors de l'appel du snapmirror" );
        $logger->log( "INFO",  "Code retour = " . $sortie );
        return 1;
    }
    else {
        $logger->log( "INFO",
            "snapmirror lancé avec succès  avec la sortie : " . $sortie );
        return 0;
    }

}

sub executebashonmachine {
    my ( $machine, $volume ) = @_;

    my $sortie = `sudo $script_synchro $machine $volume start | grep "started"`;
    my $exitcode = $?;
    $logger->log( "DEBUG", "bash-execution sortie =  " . $sortie );
    $logger->log( "DEBUG", "bash-execution code retour =   " . $exitcode );
    return $sortie, $exitcode;
}

