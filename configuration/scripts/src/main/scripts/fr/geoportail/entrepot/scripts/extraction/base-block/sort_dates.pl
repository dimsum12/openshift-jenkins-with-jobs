#!/usr/bin/perl
##########################################################################################################################################
#
# USAGE :
#   This script will sort dates and return the min (oldest) or the max (youngest)
# ARGS :
#   - Astring, min if you want the oldest date, max if the most recent
#   - An array of date as string, on format YYYY-MM-DD
# RETURNS :
#   * String : the wanted date
#   * 254 if the provided dates array is empty
#   * 255 : if cannot determine if you want min or max 1st arg)
# KEYWORDS
#   $Revision 2 $
#   $Source src/main/scripts/fr/geoportail/entrepot/conditionnement/sort_dates.pl $
#   $Date: 26/04/2012 $
#   $Author: Damien Duportal $
############################################################################################################################################

## Loading GPP3 Perl main env. configurationuse strict;
use strict;
use warnings;
use Logger;
use Config::Simple;
use POSIX qw(strftime);
use Cwd;
use Time::Local;
use DateTime;
require "retrieve_properties.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger = Logger->new( "sort_dates.pl", $config->param("logger.levels") );

our $agregated_file;
my @datetime_dates;
my $resources_path = $config->param("resources.path");

# my $regexp_file     = $resources_path . 'regexp_date';
# my (%regexp_hash)   = retrieve_properties($regexp_file);
# my $regex_date      = $regexp_hash{'expression_date'};
# my $regex_date_year = $regexp_hash{'expression_date'};

sub sort_dates {

    my ( $extremum, @dates );

    $extremum = $_[0];
    @dates    = @_[ 1 .. $#_ ];

    if ( !defined $extremum || ( $extremum ne "min" && $extremum ne "max" ) ) {
        $logger->log( "ERROR",
"Impossible de déterminer si vous souhaitez le max ou le min. Valeur fournie : "
              . $extremum );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : extremum = " . $extremum );
    $logger->log( "DEBUG", "Paramètre 2 : dates = " . @dates );

    if ( scalar @dates == 0 ) {
        $logger->log( "ERROR", "Le tableau de dates est vide" );
        return 254;
    }

    my @times = ();

    foreach my $date (@dates) {

        # On part du principe que la date est au format YYYY-MM-DD
        my @parsed_date = split( '-', $date );

        my $datetime;
        eval {
            $datetime = DateTime->new(
                "year"  => $parsed_date[0],
                "month" => $parsed_date[1],
                "day"   => $parsed_date[2]
            );
        };
        if ( my $err = $@ ) {
            $logger->log( "ERROR",
                "Impossible de convertir la valeur " . $date . " en date" );
            return 254;
        }

        push( @times, $datetime->epoch );

    }

# On trie par croissance numérique les timestamps cf. http://perlmeme.org/tutorials/sort_function.html
    my @sorted_times = sort { $a <=> $b } @times;

    my $is_max;
    if ( $extremum eq "max" ) {
        $is_max = -1;
    }
    else {
        $is_max = 0;
    }

    my $dt = DateTime->from_epoch( epoch => $sorted_times[$is_max] );
    my $resultat = $dt->ymd;

    return $resultat;
}
