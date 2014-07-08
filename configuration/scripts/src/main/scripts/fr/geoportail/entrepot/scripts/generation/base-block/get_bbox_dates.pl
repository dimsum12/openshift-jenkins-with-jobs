#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will generate the BBOX dates from metadata informations of product metadata
# ARGS :
#   The metadata folder
# RETURNS :
#   * an array of two dates
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/base-block/get_bbox_dates.pl $
#   $Date: 05/03/12 $
#   $Author: Nicolas Godelu (a184059) <nicolas.godelu@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Config::Simple;
use Execute;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "get_bbox_dates.pl", $logger_levels );

my $proj4srid_ini = $config->param("resources.proj2srid");
my $gdalinfo      = $config->param("resources.gdalinfo");
my $gdaltransform = $config->param("resources.gdaltransform");

my $type_pattern_image = ".*image.*";
my $gdaltransform_validator_pre =
  "echo '0 0 0' | " . $gdaltransform . " -s_srs '+init=";
my $gdaltransform_validator_post = " +wktext' 1> /dev/null 2>&1";
my $pattern_srid                 = ".*[:].*";
my $pattern_origin               = ".*Origin.*";
my $pattern_lower_left           = ".*Lower Left.*";
my $pattern_extract_lower_left =
  ".*Lower Left[ ]*[(][ ]*\([0-9.-]+\)[ ]*[,][ ]*\([0-9.-]+\)[ ]*[)].*";
my $pattern_upper_right = ".*Upper Right.*";
my $pattern_extract_upper_right =
  ".*Upper Right[ ]*[(][ ]*\([0-9.-]+\)[ ]*[,][ ]*\([0-9.-]+\)[ ]*[)].*";
my $key_srid             = "SRID=";
my $start_polygon        = ";POLYGON((";
my $end_polygon          = "))";
my $coordinate_separator = " ";
my $point_separator      = ",";

require "get_min_max_from_mtd_file.pl";

sub get_bbox_dates {

    # Parameters validation
    my (@mtds_folder) = @_;

    $logger->log( "DEBUG",
        "Paramètre 1 : mtds_folder  size is = " . @mtds_folder );

    my $edition       = "000000";
    my $edition_found = 0;
    my $min           = "999999";
    my $min_found     = 0;
    my $max           = "000000";
    my $max_found     = 0;

    # Does the metadata directory exist ?

    foreach my $metadata_folder (@mtds_folder) {

        $logger->log( "DEBUG", "Working on folder " . $metadata_folder );

        if ( -d $metadata_folder ) {

            # its exist so we try to get dates from metadata

            # Find all metadata
            my @metadata_files = `find $metadata_folder -type f -name "*.xml"`;
            $logger->log( "INFO", "Begin parsing of mtds" );
            $logger->log( "DEBUG",
                scalar @metadata_files . " metadatas found" );

            foreach my $metadata_file (@metadata_files) {
                chomp $metadata_file;

                my ( $min_tmp, $max_tmp, $edition_tmp ) =
                  get_min_max_from_mtd_file($metadata_file);

                if ( ( !( $min_tmp eq "null" ) && ( $min_tmp lt $min ) ) ) {
                    $logger->log( "DEBUG", "New min found :  " . $min_tmp );
                    $min       = $min_tmp;
                    $min_found = 1;
                }

                if ( ( !( $max_tmp eq "null" ) && ( $max_tmp gt $max ) ) ) {
                    $logger->log( "DEBUG", "New max found :  " . $max_tmp );
                    $max       = $max_tmp;
                    $max_found = 1;
                }

                if (
                    (
                          !( $edition_tmp eq "null" )
                        && ( $edition_tmp gt $edition )
                    )
                  )
                {
                    $logger->log( "DEBUG",
                        "New edition date found :  " . $edition_tmp );
                    $edition       = $edition_tmp;
                    $edition_found = 1;
                }

            }

        }
        else {
            $logger->log( "WARN",
                "Le dossier  " . $metadata_folder . " n'existe pas" );
        }
    }

    if ( !$max_found && $edition_found ) {
        $logger->log( "WARN",
"Max date was not found via metadata information so we get it via edition date "
        );
        $max       = $edition;
        $max_found = 1;
    }

    if ( !$max_found ) {
        $logger->log( "WARN",
"Max date was not found via metadata information so it is date of generation"
        );
        my ( $sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst ) =
          localtime(time);
        $year += 1900;
        $mon++;
        if ( $mon < 10 ) {
            $mon = "0" . $mon;
        }
        if ( $mday < 10 ) {
            $mday = "0" . $mday;
        }

        my $today = $year . "-" . $mon . "-" . $mday;
        $logger->log( "INFO", "today date is : " . $today );
        $max       = $today;
        $max_found = 1;

    }

# Peut être à implémenter...
#	if (!$min_found){
#		$logger->log( "WARN","Min date was not found via metadata information so we try to get it via product's metadata");
#
#		my $product_mtd_file;
#
#		 # Does the metadata directory exist ?
#		if ( -e $product_mtd_file ) {
#
#
#			return @dates;
#		}else{
#			$logger->log( "WARN","Le fichier  "  . $product_mtd_file . " n'existe pas" );
#
#		}
#
#	}

    if ( !$min_found ) {
        $logger->log( "WARN",
"Min date was not found via metadata information so we set it to max date"
        );
        $min       = $max;
        $min_found = 1;
    }

    $logger->log( "INFO", "Result is " . $min . "(min) and " . $max . "(max)" );

    return ( $min, $max );

}
