#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   clean_chains() will clean the "EMAP"'s processing_chain folder and request last chains.
#   It'll make a backup of current folder first, clean this chain-folder and then checkout last content.
# ARGS :
#   none
# RETURNS :
#   * 0 if all processes are well done.
#   * 251 if backup cannot be done. Script won't clean and checkout repo.
#   * 252 if cleaning chain's folder cannot be done, while backup is OK. Script won't checkout repo.
#   * 253 if checkouting chain's repository cannot be done, but backup and cleaning are OK.
#   * 254 if an argument has been provided. No action will be done.
#   * 255 if updating to branch chain's repository cannot be done, but backup and cleaning are OK.
#   $Revision 2 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/emap/clean_chains.pl $
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
my $logger = Logger->new( "clean_chains.pl", $logger_levels );
our $VERSION = "2.0";
## End loading

## Custom loading
require "compress_folder.pl";
require "clean_folder_content.pl";
require "get_backup_name.pl";
require "hg_clone_chain.pl";
require "hg_update_to_branch.pl";

my $emap_chain_path  = $config->param("emap.chainpath");
my $emap_backup_path = $config->param("emap.backuppath");
my $emap_hg_repo     = $config->param("emap.hg_repo_url");
my $emap_hg_branch   = $config->param("emap.hg_branch");
## End custom loadingg

## Main function
sub clean_chains {

    my @provided_arguments      = @_;
    my $expected_number_of_args = 0;
    if ( scalar @provided_arguments != $expected_number_of_args ) {
        $logger->log( "ERROR",
                "Le nombre de paramètres renseignés n'est pas celui attendu ("
              . $expected_number_of_args
              . ")" );
        return 254;
    }

    ### Do backup of chains folder
    my $backup_full_path =
      $emap_backup_path . "/" . get_backup_name("chain") . ".tar.gz";
    $logger->log( "DEBUG", "Le backup a faire est " . $backup_full_path );
    my $backup_result = compress_folder( $emap_chain_path, $backup_full_path );
    if ( $backup_result != 0 ) {
        $logger->log( "ERROR",
            "Le backup a échoué avec le code " . $backup_result );
        return 251;
    }
    else {
        $logger->log( "DEBUG", "Le backup a bien été exécuté" );
    }

    ##### Do clean tmp file.
    my $clean_result = clean_folder_content($emap_chain_path);
    if ( $clean_result != 0 ) {
        $logger->log( "ERROR",
            "Le nettoyage a échoué avec le code " . $clean_result );
        return 252;
    }
    else {
        $logger->log( "DEBUG", "Le nettoyage a bien été exécuté" );
    }

    ####### Clone and update chains
    my $clone_result = hg_clone_chain( $emap_hg_repo, $emap_chain_path );
    if ( $clone_result != 0 ) {
        $logger->log( "ERROR", "Le clonage a échoué " . $clone_result );
        return 253;
    }
    else {
        $logger->log( "DEBUG", "Le clonage a bien été exécuté" );
    }

    my $update_result =
      hg_update_to_branch( $emap_chain_path, $emap_hg_branch );
    if ( $update_result != 0 ) {
        $logger->log( "ERROR",
                "La mise a jour sur la branche "
              . $emap_hg_branch
              . "a échouée." );
        return 255;
    }
    else {
        $logger->log( "DEBUG",
                "La mise à jour sur la branche "
              . $emap_hg_branch
              . " s'est correctement déroulée." );
    }

    $logger->log( "INFO",
"Le dossier \"processing_chains\" de l\' EMAP a bien été sauvegardé et réinitalisé avec la dernière version du dépôt."
    );
    return 0;
}

## End Main Function
