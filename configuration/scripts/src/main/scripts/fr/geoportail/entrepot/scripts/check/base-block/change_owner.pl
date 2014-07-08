#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script change the owner of a directory recursively
# ARGS :
#   The directory to change owner
#   The new owner
#	The new group
#	if sudo is needed (0 is true)
# RETURNS :
#   * 0 if script succedded
#   * 1 if directory do not exist
#   * 2 if chown command failed
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/check/base-block/change_owner.pl $
#   $Date: 13/02/12 $
#   $Author: Nicolas Godelu (a184059) <nicolas.godelu@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Config::Simple;
use File::Basename;
use Execute;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger = Logger->new( "change_owner.pl", $config->param("logger.levels") );

sub change_owner {

    # Parameters number validation
    my ( $dir, $owner, $group, $sudo ) = @_;
    if ( !defined $dir || !defined $owner || !defined $group || !defined $sudo )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (4)"
        );
        return 255;
    }

    if ( !-d $dir ) {
        $logger->log( "ERROR", "Le répertoire " . $dir . " n'existe pas" );
        return 1;
    }

    # change owner
    my $cmd = "";
    if ( $sudo == 0 ) {
        $cmd = "sudo ";
    }
    $cmd .= "chown -R " . $owner . ":" . $group . " " . $dir;
    $logger->log( "INFO", "Commande à executer : " . $cmd );
    my $cmd_return = Execute->run( $cmd, "true" );
    if ( $cmd_return->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Impossible de changer les droits sur le dossier  " . $dir );
        $cmd_return->log_all( $logger, "DEBUG" );
        return 2;
    }

    return 0;

}

