#!/usr/bin/perl
##########################################################################################################################################
#
# USAGE :
#   This script will load a file of properties into an hash
# ARGS :
#   The file of properties
# RETURNS :
#   * The reference of the hash if everything is ok
#   * 255 if the function is called with an incorrect number of arguments
#   * 254 if the file of properties doesn't exists
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/conditionnement/retrieve_properties.pl $
#   $Date: 05/10/11 $
#   $Author: Maimouna Deme (a510440) <maimouna.deme@atos.net> $
############################################################################################################################################

## Loading GPP3 Perl main env. configurationuse strict;
use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;

our $VERSION = "1.0";
our $config;

if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger =
  Logger->new( "retrieve_properties.pl", $config->param("logger.levels") );

sub retrieve_properties {

    my ($properties_file) = @_;

    if ( !defined $properties_file ) {
        $logger->log( "ERROR",
            "Le fichier de propriétés attendu en entrée n'est pas renseigné"
        );
        return 255;
    }

    if ( !-e $properties_file ) {
        $logger->log( "ERROR",
                "Le fichier de propriétés "
              . $properties_file
              . " n'existe pas" );
        return 254;

    }

    my %hash;

    my $properties_handler;

    #opens the directory and retrieves the list of files
    if ( !open $properties_handler, "<", $properties_file ) {
        $logger->log( "ERROR",
            "Impossible d'ouvrir le fichier  : " . $properties_file );

        return 5;
    }
    else {
        $logger->log( "INFO", "Ouverture du fichier  : " . $properties_file );

        while (<$properties_handler>) {
            chomp;
            my ( $key, $val ) = split /=/;
            $hash{$key} .= exists $hash{$key} ? "$val" : $val;
            $logger->log( "DEBUG",
                "Elément du hash :" . $key . " :" . $hash{$key} );

        }
    }

    if ( !close $properties_handler ) {
        $logger->log( "ERROR",
            "Impossible de fermer le fichier ouvert en lecture : "
              . $properties_file );

        return 5;
    }

    return %hash;
}
"1";
