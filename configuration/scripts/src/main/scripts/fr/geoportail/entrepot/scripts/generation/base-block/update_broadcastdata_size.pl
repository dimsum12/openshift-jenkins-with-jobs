#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will calculate the size of a broadcastdata given in parameter in bytes (schema or folder)  and then call entrepot webservice to update broadcastdata size.
# ARGS :
#   the element to scan (schema or folder)
#	the broadcastdata id
#	boolean saying if it is a bdd braodcastdata (0 if false, 1 if yes)
# RETURNS :
#   * 0 if size was successfully updated
# 	* 1 if folder does not exist
# 	* 2 if broadcastdata id is not numeric
# 	* 3 if errors occured during size calculation
#	* 4 if call to webservice failed
#	* 5 if connection to bdd failed
#	* 6 if getting schema size failed
#	* 7 if disconnecting from bdd failed
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/base-block/update_broadcastdata_size.pl $
#   $Date: 14/03/12 $
#   $Author: Nicolas Godelu (a184059) <nicolas.godelu@atos.net> $
#########################################################################################################################

use strict;
use warnings;
use Cwd;
use Logger;
use Database;
use Config::Simple;
use File::Basename;
use Deliveryconf;
use LWP::UserAgent;
use Execute;
use JSON;
use Tools;
use WebserviceTools;

require "set_encoding.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

our $deliveryconf;

my $logger_levels   = $config->param("logger.levels");
my $url_ws_entrepot = $config->param("resources.ws.url.entrepot");
my $url_proxy       = $config->param("proxy.url");
my $dbname          = $config->param("db-ent_donnees.dbname");
my $host            = $config->param("db-ent_donnees.host");
my $port            = $config->param("db-ent_donnees.port");
my $username        = $config->param("db-ent_donnees.username");
my $password        = $config->param("db-ent_donnees.password");

my $retry_attempts = $config->param("resources.ws.entrepot.retry.attempts");
my $retry_waitingtime =
  $config->param("resources.ws.entrepot.retry.waitingtime");

my $logger = Logger->new( "update_broadcastdata_size.pl", $logger_levels );

sub update_broadcastdata_size {

    # Parameters validation
    my ( $data_to_scan, $bd_id, $is_bdd ) = @_;
    if ( !defined $data_to_scan || !defined $bd_id || !defined $is_bdd ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (2)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : data_to_scan = " . $data_to_scan );
    $logger->log( "DEBUG", "Paramètre 2 : bd_id = " . $bd_id );
    $logger->log( "DEBUG", "Paramètre 3 : is_bdd = " . $is_bdd );

    # verify broadcastdata id
    if ( Tools->is_numeric($bd_id) == 0 ) {
        $logger->log( "ERROR",
                "L'id de la donéne de diffusion est incorrect : " 
              . $bd_id
              . " (ce n'est pas un nombre)" );
        return 2;

    }

    my $size;

    if ($is_bdd) {
        my $database =
          Database->connect( $dbname, $host, $port, $username, $password );

        if ( !defined $database ) {
            $logger->log( "ERROR",
                    "Impossible de se connecter à la base de données " 
                  . $dbname . " sur "
                  . $host . ":"
                  . $port );
            return 5;
        }

        $size = $database->get_schema_size($data_to_scan);
        if ( $database->disconnect() != 0 ) {
            $logger->log( "ERROR",
                    "Impossible de se déconnecter à la base de données "
                  . $dbname . " sur "
                  . $host . ":"
                  . $port );
            return 7;
        }

        if ( $size <= 0 ) {
            $logger->log( "ERROR",
                "Erreur durant la récuparétion de la taille du schéma "
                  . $data_to_scan );
            return 6;
        }

    }
    else {

        # Does the metadata directory exist ?
        if ( !-d $data_to_scan ) {
            $logger->log( "ERROR",
                "Le dossier  " . $data_to_scan . " n'existe pas" );
            return 1;
        }

        # calculate folder size
        my $cmd_get_size_folder = "du -sb " . $data_to_scan;
        $logger->log( "DEBUG", "Execution de : " . $cmd_get_size_folder );
        my $return_cmd_get_size_folder = Execute->run($cmd_get_size_folder);

        my @return_lines = $return_cmd_get_size_folder->get_log();
        my $return       = $return_lines[0];
        chomp($return);

        $logger->log( "DEBUG", "result is  = " . $return );
        my @parts = split /[ \t]/, $return;
        $size = $parts[0];
        $logger->log( "DEBUG", "size is  = '" . $size . "'" );

        if ( Tools->is_numeric($size) == 0 ) {
            $logger->log( "ERROR",
"Erreur en récupérant la taille du dossier. La valeur récupérée est "
                  . $size
                  . " (ce n'est pas un nombre)" );
            return 3;
        }
    }

    # call webservice
    my $ws = WebserviceTools->new(
        'POST',
        $url_ws_entrepot
          . "/generation/updateBroadcastdataSize?broadcastdataId="
          . $bd_id
          . "&size="
          . $size,
        $url_proxy
    );

    $logger->log( "DEBUG",
            "Appel au service REST : "
          . $url_ws_entrepot
          . "/generation/updateBroadcsatdataSize?broadcastdataId="
          . $bd_id
          . "&size="
          . $size );

    my $result = $ws->run( $retry_attempts, $retry_waitingtime );

    if ( !$result ) {
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la mise à jour de la taille de la braodcastdata "
        );
        $logger->log( "ERROR", "l'erreur est : " . $ws->get_content() );
        return 4;
    }
    else {
        $logger->log( "INFO",
            "Mise à jour réussie de la taille de la donéne de diffusion" );
        return 0;
    }

}

