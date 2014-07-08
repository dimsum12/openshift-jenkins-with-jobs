#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will return a backup filename without extension, based onto current datetime and provided backup type. E.g :
#       get_backup_name("tmp") will return, for example, "tmp_20110308_11h58".
# ARGS :
#   - (string) The type of the backup. Could be : "tmp", "bdd", "chain" or "catalog".
# RETURNS :
#   * 0 if filename is correctly generated
#   * 255 if not enough or too much arguments are provided
#   * 254 if provided backup type isn't known.
#   * (string) the backup name
# KEYWORDS
#   $Revision 2$
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/emap/get_backup_name.pl $
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
my $logger = Logger->new( "get_backup_name.pl", $logger_levels );
our $VERSION = "2.0";
## End loading

## Main function
sub get_backup_name {

    my @provided_arguments      = @_;
    my $expected_number_of_args = 1;
    my ($backup_type)           = @provided_arguments;
    if ( scalar @provided_arguments != $expected_number_of_args
        || !defined $backup_type )
    {
        $logger->log( "ERROR",
                "Le nombre de paramètres renseignés n'est pas celui attendu ("
              . $expected_number_of_args
              . ")" );
        return 255;
    }

    my $backup_name_to_return = "";

    $logger->log( "DEBUG",
        "Paramètre 1 : type de sauvegarde = " . $backup_type );

    ## The insctruction "switch/case" is badly interpreted by testcoverage.
    ## So we have to use a if statement.
    if ( $backup_type eq "tmp" ) {
        $backup_name_to_return = "tmp_";
    }
    elsif ( $backup_type eq "bdd" ) {
        $backup_name_to_return = "bdd_";
    }
    elsif ( $backup_type eq "chain" ) {
        $backup_name_to_return = "chain_";
    }
    elsif ( $backup_type eq "catalog" ) {
        $backup_name_to_return = "catalog_";
    }
    else {
        $logger->log( "ERROR",
            "Le type de sauvegarde " . $backup_type . " est inconnu" );
        return 254;
    }

    ### Getting and formatting Date, with perl specifi stuffes
    my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) =
      localtime time;
    $mon  += 1;
    $year += 1900;

    # Need to have two-digit, even for < 10 integers.
    foreach ( $sec, $min, $hour, $mday, $mon, $year ) {
        s{^(\d)$}{0$1};
    }
    my $custom_date_string = $year . $mon . $mday . "_" . $hour . "h" . $min;
    $logger->log( "DEBUG", "La date générée est : " . $custom_date_string );

    $backup_name_to_return .= $custom_date_string;
    $logger->log( "DEBUG",
        "La chaîne générée est : " . $backup_name_to_return );

    return $backup_name_to_return;
}

## End Main Function
