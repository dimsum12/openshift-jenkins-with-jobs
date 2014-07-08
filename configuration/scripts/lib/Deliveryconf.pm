#!/usr/bin/perl

#########################################################################################################################
#
#  AIM
#   This package is used to parse and load a file configuration associated with a delivery "infos.txt"
#
#  KEYWORDS
#   $Revision 1 $
#   $Source lib/Deliveryconf.pm $
#   $Date: 26/09/11 $
#   $Author: Charles-Henri Biller (a149912) <charles-henri.biller@atos.net> $
#########################################################################################################################

package Deliveryconf;

use strict;
use warnings;
use Logger;

our $VERSION = "1.0";

sub new {
    my ( $class, $delivery_dir, $logger, $config ) = @_;

    my $this = {};
    bless $this, $class;

    my $regex_config_content = "(" . $config->param("auto-detect.keys") . ")";
    my $hash_config;

    my $file_name = $config->param("auto-detect.filename");
    my $config_file =
      `find $delivery_dir -mindepth 2 -maxdepth 2 -type f -name $file_name`;
    chomp $config_file;

    if ( -e $config_file ) {
        $logger->log( "DEBUG",
            "Fichier d'informations complémentaires trouvés -> $config_file"
        );

        my @lines_to_check = `cat $config_file`;
        my $nb_error       = 0;
        my $line_number    = 0;
        if ( scalar @lines_to_check != 0 ) {
            foreach my $line_to_check (@lines_to_check) {
                $line_number = $line_number + 1;
                chomp $line_to_check;
                $line_to_check =~ s/\x0D$//;

                # Check file structure
                if ( $line_to_check =~ /$regex_config_content=.*/ ) {
                    $logger->log( "DEBUG",
                        "Ligne $line_number OK -> $line_to_check" );
                    my @key_value = split /=/, $line_to_check;
                    ${$hash_config}{ $key_value[0] } = $key_value[1];
                }
                elsif ( $line_to_check !~ /^\[.*\]$/ && $line_to_check ne "" ) {
                    $logger->log( "ERROR",
"Ligne $line_number KO -> Mauvaise structuration \"$line_to_check\""
                    );
                    $nb_error = $nb_error + 1;
                }
            }

            if ( $nb_error != 0 ) {
                return;
            }
            else {
                $logger->log( "INFO",
                    "Fichier d'informations complémentaires validé et chargé"
                );
            }
        }
        else {
            $logger->log( "ERROR",
"Le fichier d'informations complémentaires \"$config_file\" est vide"
            );
            return;
        }
    }
    else {
        $logger->log( "ERROR",
            "Le fichier d'informations complémentaires n'existe pas" );
        return;
    }

    $this->{values} = $hash_config;
    return $this;
}

sub get_generations {
    my ($this) = @_;

    my $nb = 1;
    my @hash_config;

    while ( $this->{values}{$nb} ) {
        push @hash_config,
          {
            name       => "$this->{values}{$nb}",
            parameters => "$this->{values}{$nb.'.PARAMS'}"
          };
        $nb = $nb + 1;
    }

    return @hash_config;
}

sub get_parts {
    my ($this) = @_;

    my $nb = 1;
    my @hash_config;

    while ( $this->{values}{ $nb . '.DIR.DATA' } ) {
        push @hash_config,
          {
            name             => $this->{values}{ $nb . '.NAME' },
            dir_data         => $this->{values}{ $nb . '.DIR.DATA' },
            dir_metadata_iso => $this->{values}{ $nb . '.DIR.METADATA.ISO' },
            dir_metadata_inspire =>
              $this->{values}{ $nb . '.DIR.METADATA.INSPIRE' },
            dir_metadata_pva => $this->{values}{ $nb . '.DIR.METADATA.PVA' },
            projection       => $this->{values}{ $nb . '.PROJECTION' },
            format           => $this->{values}{ $nb . '.FORMAT' },
            zone             => $this->{values}{ $nb . '.ZONE' },
            release          => $this->{values}{ $nb . '.RELEASE' },
            resolution       => $this->{values}{ $nb . '.RESOLUTION' }
          };
        $nb = $nb + 1;
    }

    return @hash_config;
}
1;
