#!/usr/bin/perl

#########################################################################################################################
#
#  AIM
#   This package is needed to get a complete classpath of the project automaticly
#
#  KEYWORDS
#   $Revision 1 $
#   $Source lib/Classpath.pm $
#   $Date: 16/08/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

package Classpath;

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;

our $VERSION = "1.0";
our $classpath_loaded;
our $config;

sub load {

    if ( not( defined $config ) ) {

        my $config_path = cwd() . "/src/main/config/local";
        our $config = Config::Simple->new( $config_path . "/config_perl.ini" )
          or croak Config::Simple->error();
    }

    if ( not( defined $classpath_loaded ) ) {
        my $scripts_dir = cwd() . "/src/main/scripts";
        foreach my $rep (`find $scripts_dir -type "d"`) {
            chomp $rep;
            push @INC, $rep;
        }

        foreach my $other_directory ( split /,/,
            $config->param("classpath.directoriestoscan") )
        {
			if ( -d $other_directory) {
				foreach my $rep_to_scan (`find $other_directory -type "d"`) {
					chomp $rep_to_scan;
					push @INC, $rep_to_scan;
				}
			}

        }

        $classpath_loaded = "true";
    }

    #print join("\n",@INC);
    return;
}

1;

