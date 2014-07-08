#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will generate a Rok4 base pyramid and all the scripts to populate it
#   This script realize a call to Be4 with the good parameters
# ARGS :
#   The generation ID
#   The splitted level id (optionnal)
# RETURNS :
#   * 0 if generation is correct
#   * 1 if the configuration file does not exist
#   * 2 if launching Be4 return an error
#   * 254 if the be4 generic configuration file is unreachable
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 2 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/rok4_generation.pl $
#   $Date: 26/03/12 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Execute;
use Cwd;
use LWP::UserAgent;
use HTTP::Request::Common;
use Config::Simple;
use JSON;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger =
  Logger->new( "rok4_generation.pl", $config->param("logger.levels") );

my $tmp_path         = $config->param("resources.tmp.path");
my $tmp_generation   = $config->param("resources.tmp.generations");
my $config_file_name = $config->param("be4.specific_conf_filename");
my $generic_cfg_file = $config->param("be4.generic_conf_file");
my $be4_cmd          = $config->param("be4.cmd");

my $be4_properties_token  = "--properties";
my $be4_environment_token = "--environment";

sub rok4_generation {

    # Extraction des paramètres
    my ( $generation_id, $splitted_level ) = @_;
    if ( !defined $generation_id ) {
        $logger->log( "ERROR",
"Le nombre de paramètres renseignés n'est pas celui attendu (1 ou 2)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : generation_id = " . $generation_id );
    if ( defined $splitted_level ) {
        $logger->log( "DEBUG",
            "Paramètre 2 : splitted_level = " . $splitted_level );
    }

    # Définition des chemins d'accès
    my $tmp_generation_dir;
    if ( defined $splitted_level ) {
        $tmp_generation_dir =
            $tmp_path
          . $tmp_generation . '/'
          . $generation_id . '/'
          . $splitted_level . '/';
    }
    else {
        $tmp_generation_dir =
          $tmp_path . $tmp_generation . '/' . $generation_id . '/';
    }

    my $cfg_file = $tmp_generation_dir . $config_file_name;

    # Recherche du fichier de configuration spécifique be4
    $logger->log( "DEBUG",
        "Fichier de configuration spécifique : " . $cfg_file );
    if ( !-e $cfg_file ) {
        $logger->log( "ERROR",
            "Le fichier de configuration de la génération est introuvable : "
              . $cfg_file );

        return 1;
    }

    # Recherche du fichier de configuration générique be4
    $logger->log( "DEBUG",
        "Fichier de configuration générique : " . $generic_cfg_file );
    if ( !-e $generic_cfg_file ) {
        $logger->log( "ERROR",
            "Le fichier de configuration de be4 est introuvable : "
              . $generic_cfg_file );

        return 254;
    }

    # Execution de la commande perl de be4
    my $cmd =
        $be4_cmd . " "
      . $be4_properties_token . "="
      . $cfg_file . " "
      . $be4_environment_token . "="
      . $generic_cfg_file;
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd );
    my $result = Execute->run( $cmd, "true" );
    if ( $result->get_return() != 0 ) {
        $logger->log( "ERROR",
"Erreur lors de l'execution de la commande d'initialisation d'une génération Be4 : "
              . $cmd );
        $result->log_all( $logger, "ERROR" );

        return 2;
    }

    $logger->log( "INFO",
"Initialisation de la pyramide et création des scripts unitaires Be4 effectuée"
    );
    return 0;
}

