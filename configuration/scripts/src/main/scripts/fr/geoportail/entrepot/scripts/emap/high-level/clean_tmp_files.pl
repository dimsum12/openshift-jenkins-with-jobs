#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will clean the "EMAP"'s tmp folder. First, it'll backup (archive and compress)
#       the tmp folder content into the backup folder. Secondly, it'll remove all tmp's folder content.
# ARGS :
#   none
# RETURNS :
#   * 0 if backup is done and tmp folder is cleaned
#   * 253 if argument are supplied. No action will be done in that case.
#   * 254 if backup is correctly done but tmp folder not cleaned.
#   * 255 if backup cannot be done. tmp folder won't be cleaned in this case.
# KEYWORDS
#   $Revision 2 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/emap/clean_tmp_files.pl $
#   $Date: 23/08/2011 $
#   $Author: Damien DUPORTAL (a503140) <damien.duportal@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Config::Simple;

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "clean_tmp_files.pl", $logger_levels );
our $VERSION = "2.0";
## End loading

## Custom loading
require "compress_folder.pl";
require "clean_folder_content.pl";
require "get_backup_name.pl";

my $emap_tmp_path    = $config->param("emap.tmppath");
my $emap_backup_path = $config->param("emap.backuppath");
## End custom loadingg

sub clean_tmp_files {

    my @provided_arguments      = @_;
    my $expected_number_of_args = 0;
    if ( scalar @provided_arguments != $expected_number_of_args ) {
        $logger->log( "ERROR",
                "Le nombre de paramètres renseignés n'est pas celui attendu ("
              . $expected_number_of_args
              . ")" );
        return 253;
    }

    ## Do backup
    my $backup_full_path =
      $emap_backup_path . "/" . get_backup_name("tmp") . ".tar.gz";
    $logger->log( "DEBUG", "Le backup a faire est " . $backup_full_path );
    my $backup_result = compress_folder( $emap_tmp_path, $backup_full_path );

    if ( $backup_result != 0 ) {
        $logger->log( "ERROR",
            "Le backup a échoué avec le code " . $backup_result );
        return 255;
    }
    else {
        $logger->log( "DEBUG", "Le backup a bien été exécuté" );
    }

    # Do clean tmp file.
    my $clean_result = clean_folder_content($emap_tmp_path);

    if ( $clean_result != 0 ) {
        $logger->log( "ERROR",
            "Le nettoyage a échoué avec le code " . $backup_result );
        return 254;
    }
    else {
        $logger->log( "DEBUG", "Le nettoyage a bien été exécuté" );
    }

    $logger->log( "INFO",
"Le dossier \"tmp\" de l\' EMAP a bien été sauvegardé et réinitalisé."
    );
    return 0;

}
## End Main Function
