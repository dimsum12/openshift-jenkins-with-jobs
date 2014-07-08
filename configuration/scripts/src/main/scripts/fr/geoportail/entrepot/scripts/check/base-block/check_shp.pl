#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script check a sql directory
# ARGS :
#   The directory where the sql files are
# RETURNS :
#   * 0 if verification is correct
#   * 1 if no sql file where found in the directory
#   * 2 if some control error occured
#   * 3 if the directory to check does not exist
#   * 254 if the SQL regular expressions file is unreachable
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/verification/check_sql.pl $
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
use Execute;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

our $logger = Logger->new( "check_sql.pl", $config->param("logger.levels") );

my $ogrinfo = $config->param("resources.ogrinfo");

sub check_shp {

    # Parameters number validation
    my ($shp_dir) = @_;
    if ( !defined $shp_dir ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    if ( !-d $shp_dir ) {
        $logger->log( "ERROR",
            "Le répertoire de sql " . $shp_dir . " n'existe pas" );
        return 3;
    }

    my @list_files_shp = `find $shp_dir -name "*.shp"`;
    if ( scalar @list_files_shp == 0 ) {
        $logger->log( "WARN",
            "Le répertoire " . $shp_dir . " ne contient aucun fichier SHP" );
        return 1;
    }

    foreach my $file_shp (@list_files_shp) {
        chomp $file_shp;
        my ( $filename, $directory, $suffix ) =
          fileparse( $file_shp, qr/[.][^.]*/ );

        # check dbf
        my $dbf_filename = $directory . $filename . ".dbf";
        if ( !-f $dbf_filename ) {
            $logger->log( "ERROR", "Le fichier $dbf_filename n'existe pas" );
            return 2;
        }

        # check shx
        my $shx_filename = $directory . $filename . ".shx";
        if ( !-f $shx_filename ) {
            $logger->log( "ERROR", "Le fichier $shx_filename n'existe pas" );
            return 2;
        }

        # check integrity
        my $result = Execute->run( "$ogrinfo $file_shp", "true" );
        if ( 0 != $result->get_return() ) {
            $result->log_all( $logger, "ERROR" );
            return 2;
        }

        $logger->log( "DEBUG", "Vérification du shape $file_shp ok" );
    }

    return 0;
}
