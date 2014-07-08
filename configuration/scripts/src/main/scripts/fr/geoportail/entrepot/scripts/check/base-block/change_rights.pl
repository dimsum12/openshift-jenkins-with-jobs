#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script change the rigths of a file or directory
# ARGS :
#   The directory or file to change
#   The rigths to set
#	if it need to be done recursively (for folders) (0 is true)
#	if sudo is needed (0 is true)
# RETURNS :
#   * 0 if script succedded
#   * 1 if target do not exist
#   * 2 if chmod command failed
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

my $logger = Logger->new( "change_rights.pl", $config->param("logger.levels") );

sub change_rights {

    # Parameters number validation
    my ( $target, $rights, $recursive, $sudo ) = @_;
    if (   !defined $target
        || !defined $rights
        || !defined $recursive
        || !defined $sudo )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (4)"
        );
        return 255;
    }

    if ( !-e $target ) {
        $logger->log( "ERROR", $target . " n'existe pas" );
        return 1;
    }

    # change rigths
    my $cmd = "";
    if ( $sudo == 0 ) {
        $cmd = "sudo ";
    }
    $cmd .= "chmod ";
    if ( $sudo == 0 ) {
        $cmd .= "-R ";
    }
    $cmd .= $rights . " " . $target;

    $logger->log( "INFO", "Commande à executer : " . $cmd );
    my $cmd_return = Execute->run( $cmd, "true" );
    if ( $cmd_return->get_return() != 0 ) {
        $logger->log( "ERROR",
            "Impossible de changer les droits sur  " . $target );
        $cmd_return->log_all( $logger, "DEBUG" );
        return 2;
    }

    return 0;

}

