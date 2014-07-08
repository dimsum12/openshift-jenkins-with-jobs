#!/usr/bin/perl

#########################################################################################################################
#
#  AIM
#   This package is used to execute bash command using unified calls
#
#  KEYWORDS
#   $Revision 1 $
#   $Source lib/Execute.pm $
#   $Date: 26/09/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

package Execute;

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;

our $VERSION = '1.0';
my $skip_error = "2> /dev/null";
my $keep_error = "2>&1";

sub run {
    my ( $class, $cmd, $get_err ) = @_;

    if ( !defined $get_err ) {
        $get_err = "false";
    }

    my $this = {};
    bless $this, $class;

    if ( "true" eq $get_err ) {
        $cmd = $cmd . " " . $keep_error;
    }
    else {
        $cmd = $cmd . " " . $skip_error;
    }

    my @return_log   = `$cmd`;
    my $return_value = `echo $?`;
    chomp $return_value;

    $this->{RETURN_LOG}   = \@return_log;
    $this->{RETURN_VALUE} = $return_value;

    return $this;
}

sub get_log {
    my ($this) = @_;
    my $return_log = $this->{"RETURN_LOG"};
    return @{$return_log};
}

sub log_all {
    my ( $this, $logger, $level ) = @_;
    my $return_log = $this->{"RETURN_LOG"};

    foreach my $line ( @{$return_log} ) {
        chomp($line);
        $logger->log( $level, $line );
    }

    return;
}

sub get_return {
    my ($this) = @_;
    return $this->{"RETURN_VALUE"};
}

1;

