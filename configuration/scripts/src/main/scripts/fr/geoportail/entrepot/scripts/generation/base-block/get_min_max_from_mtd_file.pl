#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script will get the min max date from a mtd file. It wil aggregate the mtd file and tkae the maximum date and minimum date of temporal extent.
#	If temporal extent not defined, min  and max will be null.
# 	If edition date is not available, editiondate will be null will be "null"
# ARGS :
#   The metadata file
# RETURNS :
#   * an array of three dates as string (min, max , edition)
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/generation/base-block/get_min_max_from_mtd_file.pl $
#   $Date: 06/03/12 $
#   $Author: Nicolas Godelu (a184059) <nicolas.godelu@atos.net> $
#########################################################################################################################

use strict;
use warnings;
use Cwd;
use Logger;
use Database;
use Config::Simple;
use DBI;
use HTTP::Request::Common;
use LWP::UserAgent;
use File::Basename;
use Deliveryconf;
use Execute;
use JSON;
use XML::DOM::XPath;
use XML::XPath;
use XML::XPath::XMLParser;
use HTTP::Status qw(:constants :is status_message);

require "set_encoding.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

our $deliveryconf;

my $logger_levels = $config->param("logger.levels");

my $gmd_temporal_extent_end_position =
  $config->param("generation-gml.gmd_temporal_extent_end_position");
my $gmd_temporal_extent_begin_position =
  $config->param("generation-gml.gmd_temporal_extent_begin_position");
my $gmd_edition_date = $config->param("generation-gml.gmd_edition_date");

my $logger = Logger->new( "get_min_max_from_mtd_file.pl", $logger_levels );

sub get_min_max_from_mtd_file {

    # Parameters validation
    my ($metadata_file) = @_;
    if ( !defined $metadata_file ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : metadata_file = " . $metadata_file );

    # Does the metadata directory exist ?
    if ( !-e $metadata_file ) {
        $logger->log( "ERROR",
            "Le fichier  " . $metadata_file . " n'existe pas" );
        my @dates = ( "null", "null", "null" );
        return @dates;
    }

    #set_encoding($metadata_file);

    # min and max dates
    my $min       = "999999";
    my $max       = "000000";
    my $max_found = 0;
    my $edition   = "null";

    # parsing du fichier de mtd
    my $parser             = XML::DOM::Parser->new();
    my $doc_file_of_folder = $parser->parsefile($metadata_file);

    # Recherche des noeuds date pour chaque fichier
    my @nodes_temporal_extent_begin_position =
      $doc_file_of_folder->findnodes($gmd_temporal_extent_begin_position);
    my @nodes_temporal_extent_end_position =
      $doc_file_of_folder->findnodes($gmd_temporal_extent_end_position);

    $logger->log( "DEBUG",
        "Begin temporal extent count is : "
          . scalar @nodes_temporal_extent_begin_position );
    $logger->log( "DEBUG",
        "End temporal extent count is : "
          . scalar @nodes_temporal_extent_end_position );

    for ( 0 .. scalar @nodes_temporal_extent_begin_position - 1 ) {

        my $min_tmp = $nodes_temporal_extent_begin_position[$_]->string_value;
        chomp($min_tmp);

        # cast date to format yyyy-mm-dd
        $min_tmp = cast_date($min_tmp);

        $logger->log( "DEBUG", "Tag Begin position " . $_ . " = " . $min_tmp );

        if (   ( $min_tmp lt $min )
            && !( $min_tmp eq "" )
            && !( $min_tmp eq " " ) )
        {
            $logger->log( "DEBUG", "New min found :  " . $min_tmp );
            $min = $min_tmp;

        }
    }

    for ( 0 .. scalar @nodes_temporal_extent_end_position - 1 ) {
        my $max_tmp = $nodes_temporal_extent_end_position[$_]->string_value;
        chomp($max_tmp);

        # cast date to format yyyy-mm-dd
        $max_tmp = cast_date($max_tmp);

        $logger->log( "DEBUG", "Tag End position " . $_ . " = " . $max_tmp );

        if ( $max_tmp gt $max && !( $max_tmp eq "" ) && !( $max_tmp eq " " ) ) {
            $logger->log( "DEBUG", "New max found :  " . $max_tmp );
            $max       = $max_tmp;
            $max_found = 1;
        }
    }

    if ( !$max_found ) {
        $logger->log( "DEBUG",
"Max date was not found in temporal extent so we try to get Edition Date "
        );

        my $xp = XML::XPath->new( filename => $metadata_file );
        my $result = $xp->findvalue($gmd_edition_date);

        # cast date to format yyyy-mm-dd
        $result = cast_date($result);

        $logger->log( "DEBUG", "edition date found is :" . $result );

        if ( !( $result eq "" ) ) {
            $logger->log( "DEBUG",
                "We found an edition date which is " . $result );
            $edition = $result;

        }
        else {
            $logger->log( "WARN", "impossible to get edition date. " );
        }
    }

    if ( $min eq "999999" ) {
        $logger->log( "WARN",
            "impossible to get min date so we set it to null. " );
        $min = "null";
    }

    if ( $max eq "000000" ) {
        $logger->log( "WARN",
            "impossible to get max date so we set it to null. " );
        $max = "null";
    }

    $logger->log( "INFO",
            "Result is " 
          . $min
          . "(min) and "
          . $max
          . "(max) and "
          . $edition
          . " (edition date)" );

    # Libération de la mémoire
    $doc_file_of_folder->dispose;

    my @dates = ( $min, $max, $edition );
    return @dates;
}

sub cast_date {

    # Parameters validation
    my ($date) = @_;
    if ( !defined $date ) {
        return "";
    }

    my $length = length($date);
    if ( $length < 10 ) {
	
		if ( $length == 4 && $date =~ /[0-9]{4}/ ) {
			$logger->log( "DEBUG", "the date is only a year : " . $date );
			my $transformed_date = $date . "-01-01";
			$logger->log( "DEBUG", "date transformed is  : " . $transformed_date );
			return $transformed_date;
		}
	
        $logger->log( "DEBUG", "the date is not well formatted : " . $date );
        return "";
    }

    my $result = substr $date, 0, 10;
    $logger->log( "DEBUG", "Date cutted is " . $result );

    $result =~ s/:/-/;
    $logger->log( "DEBUG", "Date transformed is " . $result );
    return $result;
}

