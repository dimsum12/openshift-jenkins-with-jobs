#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script check the size of files of a directory
# ARGS :
#   The directory to check
#   The maximum size
# RETURNS :
#   * 0 if verification is correct
#   * 1 if directory does not exists
#   * 2 if one file is too big
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/verification/base-block/check_size.pl $
#   $Date: 09/02/12 $
#   $Author: Nicolas Godelu (a184059) <nicolas.godelu@atos.net> $
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

my $logger = Logger->new( "check_size.pl", $config->param("logger.levels") );

sub check_size {

    # Parameters number validation
    my ( $directory, $size_max ) = @_;
    if ( !defined $directory || !defined $size_max ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (2)"
        );
        return 255;
    }

    if ( !-d $directory ) {
        $logger->log( "ERROR",
            "Le répertoire à vérifier " . $directory . " n'existe pas" );
        return 1;
    }

    my $cmd_list_files = "find " . $directory . " -not -name *md5 -type f";
    $logger->log( "DEBUG",
        "Appel à la commande comptant listant les fichiers : "
          . $cmd_list_files );
    my $result_find_files = Execute->run( $cmd_list_files, "false" );
    my @files = $result_find_files->get_log();

    foreach my $file (@files) {
        chomp $file;
        $logger->log( "DEBUG",
            "Récupération de la taille du fichier : " . $file );
        my $file_size = -s ($file);
        if ( $file_size > $size_max ) {
            $logger->log( "ERROR",
                    "Le fichier " 
                  . $file
                  . " est trop volumineux ("
                  . $file_size
                  . " octets). La taille maximale est "
                  . $size_max
                  . " octets" );
            return 2;
        }
    }

    return 0;

}

