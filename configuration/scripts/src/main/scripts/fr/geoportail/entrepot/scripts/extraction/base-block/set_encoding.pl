#!/usr/bin/perl
##########################################################################################################################################
#
# USAGE :
#   This script will agregate a list of xml files
# ARGS :
#   The folder that contains the xml files
#   The type of the product
# RETURNS :
#   * 0 if the agregation is Ok
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/conditionnement/set_encoding.pl $
#   $Date: 06/10/11 $
#   $Author: Maimouna Deme (a510440) <maimouna.deme@atos.net> $
############################################################################################################################################

## Loading GPP3 Perl main env. configurationuse strict;
use XML::LibXML;
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

my $logger = Logger->new( "set_encoding.pl", $config->param("logger.levels") );
my $in;
my $out;

sub set_encoding {

    my ($infile) = @_;

    if ( !defined $infile ) {
        $logger->log( "ERROR",
"Le fichier de propriêµ©s attendu en entrê¥ n'est pas renseignée"
        );
        return 255;
    }

    my $output_file = $infile . '.tmp';

    if ( !open $in, "<", $infile ) {
        $logger->log( "ERROR", "Impossible d'ouvrir le fichier  : " . $infile );

        return 5;
    }
    if ( !open $out, ">:encoding(UTF-8)", $output_file ) {
        $logger->log( "ERROR",
            "Impossible d'ouvrir en écriture le fichier  : " . $output_file );

        return 5;
    }

    while (<$in>) { print {$out} $_; }

    if ( !close $in ) {
        $logger->log( "ERROR",
            "Impossible de fermer le fichier ouvert en lecture : " . $infile );

        return 5;
    }
    if ( !close $out ) {
        $logger->log( "ERROR",
            "Impossible de fermer le fichier ouvert en ecriture : "
              . $output_file );

        return 5;
    }

    #on renommme le fichier avec le même nom que le fichier input

    `mv $output_file $infile`;

    return 0;
}
"1";

