#!/usr/bin/perl
##########################################################################################################################################
#
# USAGE :
#   This script will compare a list of dates and returns the latest one
# ARGS :
#   The array of files
# RETURNS :
#   * 0 if the agregation is Ok
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/conditionnement/max_dates.pl $
#   $Date: 11/09/11 $
#   $Author: Maimouna Deme (a510440) <maimouna.deme@atos.net> $
############################################################################################################################################

## Loading GPP3 Perl main env. configurationuse strict;
use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;
use DateTime;
require "retrieve_properties.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger = Logger->new( "max_dates.pl", $config->param("logger.levels") );
my $url_proxy = $config->param("proxy.url");
our $agregated_file;
my $resources_path = $config->param("resources.path");
my $regexp_file    = $resources_path . 'regexp_date';
my (%regexp_hash)  = retrieve_properties($regexp_file);

my $regex_date      = $regexp_hash{'expression_date'};
my $regex_date_year = $regexp_hash{'expression_date'};

sub max_dates {
    my (@dates) = @_;

    if ( scalar @dates == 0 ) {
        $logger->log( "ERROR", "Le tableau de dates est vide" );
        return 255;
    }

    #Test if each date follows the regular expression
    foreach my $d (@dates) {
        if ( $d !~ /$regex_date/ && $d !~ /$regex_date_year/ ) {

            $logger->log( "ERROR",
                    "La date " 
                  . $d
                  . " ne suit pas l'expression régulière d'une date" );
            return 254;

        }
    }

    my @datetime_dates;

    foreach my $d (@dates) {

        #constructs a date for each value
        my $dt = DateTime->new(
            year  => substr( $d, 0, 4 ),
            month => substr( $d, 5, 2 ),
            day   => substr( $d, 8, 2 ),

        );
        push @datetime_dates, $dt;

    }
    my $max_date = $datetime_dates[0];

    for ( my $i = 1 ; $i < scalar @datetime_dates ; $i++ ) {

        if ( DateTime->compare( $max_date, $datetime_dates[$i] ) == -1 ) {

            #$max_date is inferior
            $max_date = $datetime_dates[$i];
        }
    }

    return $max_date->year . '-' . $max_date->month . '-' . $max_date->day;

    #end sub
}
"1";
