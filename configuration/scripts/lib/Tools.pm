#!/usr/bin/perl

#########################################################################################################################
#
#  AIM
#   This package contains set of tools
#
#  KEYWORDS
#   $Revision 1 $
#   $Source lib/Tools.pm $
#   $Date: 26/09/11 $
#   $Author: Charles-Henri Biller (a149912) <charles-henri.biller@atos.net> $
#########################################################################################################################

package Tools;

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;

our $VERSION = '1.0';

sub is_numeric {
    my ( $cmd, $expr ) = @_;
    if ( defined $expr ) {
        if (   $expr =~ /^[0-9]+$/
            || $expr =~ /^[0-9]+[.][0-9]+$/
            || $expr =~ /^[0-9]+[,][0-9]+$/ )
        {
            return 1;
        }
        else {
            return 0;
        }
    }
    else {
        return 0;
    }
}
1;
