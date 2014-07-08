#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script delete a directory folder after checking that it is a valid one
#       First it verifies if the folder exists
#       Then it deletes all files from the folder
# ARGS :
#   The folder to delete
# RETURNS :
#   * 0 if the deletion worked
#   * 1 if the folder doesn't exist
#   * 2 if the "rm -rf" command returned an error code
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 2 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/outils/delete_data.pl $
#   $Date: 22/09/11 $
#   $Author: Stefan Tudose (a508763) <stefan.tudose@atos.net> $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

use strict;
use warnings;
use Cwd;
use Logger;
use Database;
use Config::Simple;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "delete_data.pl", $logger_levels );

sub delete_data {

    # Parameters number validation
    my ($dir_to_delete) = @_;
    if ( !defined $dir_to_delete ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : dir_to_delete = " . $dir_to_delete );

    # Does the directory exist ?
    if ( !-d $dir_to_delete ) {
        $logger->log( "ERROR",
            "Le répertoire à supprimer " . $dir_to_delete . " n'existe pas" );
        return 1;
    }

    # delete all files from folder
    my $cmd = "rm -rf " . $dir_to_delete;
    $logger->log( "DEBUG", "Exécution de la commande : " . $cmd );

    my $return_value = system $cmd;
    if ( $return_value != 0 ) {
        $logger->log( "ERROR",
            "Erreur d'execution de la commande de suppression" );
        $logger->log( "DEBUG", "Code retour = " . $return_value );

        return 2;
    }

    return 0;
}

