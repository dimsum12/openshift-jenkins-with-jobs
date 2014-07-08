#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#
# ARGS :
#   The delivery directory
# RETURNS :
#   * 0 if the process is correct
#   * 1 if a package couldn't be uncompressed
#   * 2 if a package has an unknown archive type
#   * 3 if the delivery directory doesn't exist
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/verification/check_uncompress.pl $
#   $Date: 17/08/11 $
#   $Author: Charles-Henri Biller (a149912) <charles-henri.biller@atos.net> $
#########################################################################################################################

use strict;
use warnings;
use Cwd;
use Archive::Extract;
use File::Basename;
use Logger;
use Config::Simple;

$Archive::Extract::PREFER_BIN = 1;
our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger =
  Logger->new( "check_uncompress.pl", $config->param("logger.levels") );

my $regex_find = '\(.*.tar\|.*.tgz\|.*.tbz\|.*.zip\|.*.tar.gz\|.*.gz\|.*.not\)';
my $extract_dir_name  = "extract";
my $unable_to_extract = "Unable to extract.*";

sub check_uncompress {

    # Parameters number validation
    my ($delivery_dir) = @_;

    if ( !defined $delivery_dir ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    #Go to the delivery directory
    if ( !chdir $delivery_dir ) {
        $logger->log( "ERROR",
"Le répertoire racine de la livraison \"$delivery_dir\" n'existe pas"
        );
        return 3;
    }

    #Uncompress recursively packages found
    my $return_code = uncompress_packages_found($delivery_dir);

    if ( $return_code == 0 ) {
        $logger->log( "INFO",
"Tous les fichiers à décompresser ont été décompressés et sont OK"
        );
        return 0;
    }
    elsif ( $return_code == 100 ) {
        $logger->log( "INFO", "Aucun fichier à décompresser." );
        return 0;
    }
    else {
        return $return_code;
    }
}

sub uncompress_packages_found {

    #Retrieve first argument
    my ($path_to_scan) = @_;

    #Find all packages
    my @packages =
      `find $path_to_scan -maxdepth 1 -iregex '$regex_find' -type f`;

    #Uncompress all packages found
    if ( @packages != 0 ) {
        foreach my $package (@packages) {

            #Delete end line break
            chomp $package;

            #Instanciate package
            my $ae = Archive::Extract->new( archive => $package );
            if ( !defined $ae ) {
                $logger->log( "ERROR",
"La décompression du fichier \"$package\" a échoué, type d'archive inconnu"
                );

                #Delete delivery dir
                system "rm -rf $path_to_scan/*";
                return 2;
            }

            #Set decompression result
            my $string_result;

            #Extract package
            my $ok = $ae->extract( to => dirname($package) );

            #Uncompress recurisvely packages found
            $string_result = $ae->error( [1] );
            if ( $string_result ne "" ) {
                $logger->log( "ERROR",
                    "La décompression du fichier \"$package\" a échoué" );

                #Delete delivery dir
                system "rm -rf $path_to_scan/*";
                return 1;
            }
            else {

                #Delete package
                unlink $package
                  or croak("Le package n'a pas pu être supprimé");
                $logger->log( "DEBUG", "Suppression de $package." );

                $logger->log( "INFO", "Décompression de $package OK" );
            }
        }
    }
    else {
        return 100;
    }

    return 0;
}
