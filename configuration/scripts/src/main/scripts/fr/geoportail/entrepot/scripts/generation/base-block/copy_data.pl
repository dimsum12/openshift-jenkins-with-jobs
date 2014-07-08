#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will copy all the files from a source folder to a destination folder
#       First it verifies if the folders exists, the destination folder is empty and there is enough free space
#       Then it copies all files from the delivery folder to the destination folder
# ARGS :
#   The source folder
#   The destination folder
#   "true" if the entire source folder must be copied (optionnal)
# RETURNS :
#   * 0 if the copy worked
#   * 1 if the source folder doesn't exist
#   * 2 if the destination folder doesn't exist
#   * 3 if there was an error during file copy
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 3 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/base-block/copy_data.pl $
#   $Date: 26/01/12 $
#   $Author: Stefan Tudose (a508763) <stefan.tudose@atos.net> $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Database;
use Execute;
use Config::Simple;
use DBI;

our $VERSION = "1.0";

my $cmd_cp           = "cp -f -p -r ";
my $bash_count_lines = "| wc -l";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "copy_data.pl", $logger_levels );

sub copy_data {

    # Parameters validation
    my ( $source_dir, $destination_dir, $copy_with_dir ) = @_;
    if ( !defined $source_dir || !defined $destination_dir ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (2)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : source_dir = " . $source_dir );
    $logger->log( "DEBUG",
        "Paramètre 2 : destination_dir = " . $destination_dir );

    # Does the source directory exist ?
    if ( !-d $source_dir ) {
        $logger->log( "ERROR",
                "Le répertoire source des données "
              . $source_dir
              . " n'existe pas" );
        return 1;
    }

    # Does the destination directory exist ?
    if ( !-d $destination_dir ) {
        my $create_folder_cmd = "mkdir -p " . $destination_dir;
        my $create_folder_return = Execute->run( $create_folder_cmd, "true" );
        if ( $create_folder_return->get_return() != 0 ) {
            $logger->log( "ERROR",
                "Impossible de créer le répertoire : " . $destination_dir );
            $create_folder_return->log_all( $logger, "DEBUG" );
            return 2;
        }
    }

    # Copy all files to destination directory
    my $cmd;
    if ( defined $copy_with_dir && "true" eq $copy_with_dir ) {
        $cmd = $cmd_cp . $source_dir . " " . $destination_dir;
    }
    else {
        $cmd = $cmd_cp . $source_dir . "/* " . $destination_dir;
    }

    $logger->log( "DEBUG", "Appel à la commande : " . $cmd );
    my $result = Execute->run($cmd);
    if ( $result->get_return() != 0 ) {
        $logger->log( "ERROR",
                "Erreur lors de la copie de "
              . $source_dir
              . " vers "
              . $destination_dir );
        return 3;
    }

    return 0;
}
