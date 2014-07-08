#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script check a data directory with one or more MD5 files
# ARGS :
#   The directory where the md5 files are
#   The directory to check
# RETURNS :
#   * 0 if verification is correct
#   * 1 if some files have not been checked
#   * 2 if some control error occured
#   * 3 if the directory to check does not exist
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/verification/check_md5.pl $
#   $Date: 17/08/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Config::Simple;
use File::Basename;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger = Logger->new( "check_md5.pl", $config->param("logger.levels") );

my $file_extension      = "*.md5";
my $return_code         = 0;
my $checksum_pattern_ok = ".*OK.*";

sub check_md5 {

    # Parameters number validation
    my ( $md5_dir, $base_dir ) = @_;
    if ( !defined $md5_dir || !defined $base_dir ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (2)"
        );
        return 255;
    }

    if ( !-d $base_dir ) {
        $logger->log( "ERROR",
            "Le répertoire de base " . $base_dir . " n'existe pas" );
        return 3;
    }

    my $nb_ok      = 0;
    my $nb_error   = 0;
    my $nb_checked = 0;
    my $nb_total =
      `find $base_dir -not -name *"$file_extension" -type f | wc -l`;
    chomp $nb_total;
    $logger->log( "DEBUG", "Recherche des fichiers md5 dans " . $md5_dir );
    my @result_find_md5 = `find $md5_dir -name "$file_extension"`;

    chdir $base_dir;
    foreach my $row_find (@result_find_md5) {
        my $md5_local_dir = dirname($row_find);
        chdir $md5_local_dir;

        $logger->log( "DEBUG", "Verification de " . $row_find );
        my @checksum_result = `md5sum -c $row_find`;

        foreach my $row_checksum (@checksum_result) {
            chomp $row_checksum;
            $logger->log( "INFO", "Contrôle MD5 de " . $row_checksum );

            if ( $row_checksum =~ /$checksum_pattern_ok/ ) {
                $nb_ok = $nb_ok + 1;
            }
            else {
                $nb_error = $nb_error + 1;
            }

            $nb_checked = $nb_checked + 1;
        }
    }

    if ( $nb_error != 0 ) {
        $logger->log( "INFO",
                $nb_error
              . " vérification(s) MD5 en erreur sur "
              . $nb_checked
              . " effectuée(s)" );
        return 2;
    }
    elsif ( $nb_checked != $nb_total ) {
        $logger->log( "INFO",
                $nb_checked
              . " vérification(s) MD5 effectuée(s) sur "
              . $nb_total
              . " fichier(s) dans l'arborescence" );
        return 1;
    }
    else {
        $logger->log( "INFO",
                "Toutes les vérifications (" 
              . $nb_ok
              . ") sont OK, et tous les fichiers de l'arborescence ont été vérifiés"
        );
        return 0;
    }
}

