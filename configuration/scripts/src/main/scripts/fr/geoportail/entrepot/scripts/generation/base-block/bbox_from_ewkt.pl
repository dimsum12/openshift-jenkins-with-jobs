#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will generate a BBOX from an EWKT geometry
# ARGS :
#   The EWKT representation for the geometry
#	The output SRID of the BBOX
# RETURNS :
#   * The EWKT BBOX if everything is ok
#   * 1 if an error occured connecting database (including table does not exist)
#   * 2 if the SRID spécified for the output is unknown
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/bbox_from_ewkt.pl $
#   $Date: 21/03/12 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Config::Simple;
use Database;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "bbox_from_ewkt.pl", $logger_levels );

my $dbname   = $config->param("db-ent_donnees.dbname");
my $host     = $config->param("db-ent_donnees.host");
my $port     = $config->param("db-ent_donnees.port");
my $username = $config->param("db-ent_donnees.username");
my $password = $config->param("db-ent_donnees.password");

my $pattern_epsg_srid = "^epsg[:][0-9]+\$";

sub bbox_from_ewkt {

    # Validation des parametres
    my ( $polygon, $output_srid ) = @_;
    if ( !defined $polygon || !defined $output_srid ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (2)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : polygon = " . $polygon );
    $logger->log( "DEBUG", "Paramètre 2 : output_srid = " . $output_srid );

    # Prepare BDD
    $logger->log( "DEBUG",
            "Connection à la BDD : " 
          . $dbname . " sur " 
          . $host . ":" 
          . $port
          . " avec l'utilisateur "
          . $username );
    my $database =
      Database->connect( $dbname, $host, $port, $username, $password );

    if ( !defined $database ) {
        $logger->log( "ERROR",
                "Impossible de seconnecter à la base de données " 
              . $dbname . " sur "
              . $host . ":"
              . $port );
        return 1;
    }

    # Getting the srid
    my $srid;
    if ( $output_srid =~ /$pattern_epsg_srid/i ) {
        $logger->log( "DEBUG", "La projection est de type EPSG" );

        my @output_srid_splitted = split /:/, $output_srid;
        $srid = $output_srid_splitted[1];
    }
    else {
        $logger->log( "DEBUG", "La projection est de type IGNF" );

        my $sql = "SELECT srid FROM spatial_ref_sys WHERE proj4text like '%"
          . $output_srid . "%'";
        ($srid) = $database->select_one_row($sql);

        if ( !defined $srid ) {
            $logger->log( "ERROR",
                "Impossible de trouver le SRID de la projection demandée : "
                  . $output_srid );
            return 2;
        }
    }
    $logger->log( "INFO", "SRID de la projection : " . $srid );

    # Getting the BBOX
    my $sql =
        "SELECT asewkt(setsrid(st_extent(transform(geomfromewkt('" 
      . $polygon . "'), "
      . $srid . ")), "
      . $srid . "))";
    ( my $bbox ) = $database->select_one_row($sql);

    if ( !defined $bbox ) {
        $logger->log( "ERROR",
            "Impossible de calculer la BBOX de la donnée via la requête : "
              . $sql );
        return 3;
    }

    return $bbox;
}

