#!/usr/bin/perl

#########################################################################################################################
#
#  AIM
#   This package is used to log informations with a generic format for all the scripts and with log levels
#
#  KEYWORDS
#   $Revision 1 $
#   $Source lib/Logger.pm $
#   $Date: 16/08/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

package Logger;

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;

our $VERSION = '1.0';

sub new {
    my ( $class, $class_to_log, $levels ) = @_;

    my $this = {};
    bless $this, $class;
    $this->{CLASS_TO_LOG} = $class_to_log;
    $this->{LEVELS}       = $levels;

    return $this;
}

sub log {
    my ( $this, $level, $log ) = @_;

    foreach my $level_to_test ( split /:/, $this->{LEVELS} ) {
        if ( $level eq $level_to_test ) {
            my $date = `date "+%Y-%m-%d %H:%M:%S"`;
            chomp $date;
            print "[" 
              . $date . "]["
              . $this->{CLASS_TO_LOG} . "] "
              . $level . ": "
              . $log . "\n";
            return 0;
        }
    }

    return 1;
}

1;

