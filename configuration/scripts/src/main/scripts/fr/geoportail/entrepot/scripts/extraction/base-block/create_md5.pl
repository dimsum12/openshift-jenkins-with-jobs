#!/usr/bin/perl
##########################################################################################################################################
#
# USAGE :
#   This script will create an md5 on a folder or a file
# ARGS :
#   The folder or filewhich the md5 file must be created
# RETURNS :
#   * 0 if the creation of the md5 file is OK
#   * 1 if the file does not exist
#   * 3 if an error occured during md5 calutation
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 3 $
#   $Source src/main/scripts/fr/geoportail/entrepot/extraction/base-block/create_md5.pl $
#   $Date: 11/01/12 $
#   $Author: Maimouna Deme (a510440) <maimouna.deme@atos.net> $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
############################################################################################################################################

## Loading GPP3 Perl main env. configuration

use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;
use Execute;
use File::Basename;

our $VERSION = "1.0";
our $config;

if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger = Logger->new( "create_md5.pl", $config->param("logger.levels") );

sub create_md5 {

    # Extraction des paramètres
    my ($file) = @_;

    if ( !defined $file ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : file = " . $file );

    my $md5_file = $file . ".md5";
    $logger->log( "DEBUG", "Nom du fichier MD5 à créer : " . $md5_file );

    # Controle du fichier à traiter
    my $cmd_md5;
    if ( -d $file ) {
        $logger->log( "DEBUG", "Le fichier à traiter est un répertoire" );

        $cmd_md5 =
            "cd " 
          . $file . ";" 
          . "cd ..;" 
          . "touch "
          . $md5_file . ";" . "find "
          . ( basename $file)
          . " -type f -a -not -name '*.md5' | while read line; do md5sum -b \$line >> "
          . $md5_file
          . "; done";
    }
    elsif ( -f $file ) {
        $logger->log( "DEBUG",
            "Le fichier à traiter est un fichier régulier" );

        my $folder = dirname $file;
        $cmd_md5 =
            "cd " 
          . $folder
          . "; md5sum -b "
          . ( basename $file) . " >> "
          . $md5_file;
    }
    else {
        $logger->log( "ERROR",
            "Le fichier à traiter " . $file . " n'existe pas" );
        return 1;
    }

    $logger->log( "DEBUG", "Commande à executer : " . $cmd_md5 );
    my $result = Execute->run( $cmd_md5, "true" );

    if ( 0 != $result->get_return() && 256 != $result->get_return() ) {
        $logger->log( "ERROR",
            "Erreur d'execution de la commande " . $cmd_md5 );
        $logger->log( "ERROR", "Code retour : " . $result->get_return() );
        $result->log_all( $logger, "DEBUG" );
        return 2;
    }

    return 0;
}

