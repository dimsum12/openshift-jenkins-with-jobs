#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script copy metadata from intern filer to extern filer. It takes the BroadcastData ID to synchronize
# ARGS :
#   The list of broadcastdata IDs separated by a coma
# RETURNS :
#   * 0 if success
#	* 1 if copy failed
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/publication/synchronize_metadatas_on_extern_zone.pl $
#   $Date: 30/08/11 $
#   $Author: Nicolas Godelu (A184059) <nicolas.godelu@atos.net> $
#########################################################################################################################

use strict;
use warnings;
use Cwd;
use Logger;
use Database;
use Config::Simple;
use DBI;
use File::Basename;

require "duplicate_volume.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger_levels = $config->param("logger.levels");
my $logger =
  Logger->new( "synchronize_metadatas_on_extern_zone.pl", $logger_levels );

my $extern_filer = $config->param("filer.catalog.extern.volume");

sub synchronize_metadatas_on_extern_zone {

    $logger->log( "INFO", "volume à synchroniser : " . $extern_filer );

    # synchronize volume
    my $return_sync = duplicate_volume($extern_filer);

    if ( $return_sync != 0 ) {
        $logger->log( "ERROR", "Erreur lors de l'appel du duplicate volume" );
        $logger->log( "DEBUG", "Code retour = " . $return_sync );
        return 1;

    }
    $logger->log( "INFO",
        "copie des métadonnées terminée : " . $extern_filer );

    return 0;

}

