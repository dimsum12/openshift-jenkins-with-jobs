#!/usr/bin/perl
#########################################################################################################################
#
# USAGE :
#   This script package an extraction.
#   It generate MD5 checksum files and compress the directory into multiparted 7Z archive
# ARGS :
#   The directory to package
#	The target archive (absolute path, with only .7z extension)
#	The splitting size for 7Z
# RETURNS :
#   * 0 if the packaging is correct
#   * 1 if an error occured during calculating md5 inside the package
#   * 2 if an error ocurred during compression of the package (7Z)
#   * 3 if an error occured during calculating md5 for the archive's parts
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 2 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/packaging/high_level/packaging.pl$
#   $Date: 26/12/11 $
#   $Author: Maimouna DEME (a510440) <maimouna.deme@atos.net> $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
###########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;

require "zip_folder.pl";
require "create_md5.pl";

our $VERSION = "1.0";

our $config;
if ( !defined $config ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger = Logger->new( "packaging.pl", $config->param("logger.levels") );

sub packaging {

    # Extraction des paramètres
    my ( $directory, $target_package, $zip_name, $zip_size ) = @_;
    if (   !defined $directory
        || !defined $target_package
        || !defined $zip_name
        || !defined $zip_size )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (4)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : directory = " . $directory );
    $logger->log( "DEBUG",
        "Paramètre 2 : target_package = " . $target_package );
    $logger->log( "DEBUG", "Paramètre 3 : zip_name = " . $zip_name );
    $logger->log( "DEBUG", "Paramètre 4 : zip_size = " . $zip_size );

    # Application du md5 pour chaque sous dossier
    my $cmd_find_folders = "find " . $directory . " -depth -mindepth 1 -type d";
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd_find_folders );
    my $result_folders = Execute->run( $cmd_find_folders, "false" );
    my @folders = $result_folders->get_log();

    $logger->log( "INFO",
"Création de MD5 sur les différents répertoires de l'arborescence extraite"
    );
    foreach my $folder (@folders) {
        chomp $folder;

        $logger->log( "DEBUG", "Appel à create_md5 sur " . $folder );
        my $return_create_md5 = create_md5($folder);
        if ( $return_create_md5 != 0 ) {
            $logger->log( "ERROR",
                "erreur durant l'appel à create_md5 sur " . $folder );
            $logger->log( "ERROR",
                "Code retour de la fonction create_md5 : "
                  . $return_create_md5 );
            return 1;
        }
    }

    # Application du md5 pour le dossier racine
    $logger->log( "DEBUG",
        "Appel à create_md5 sur le répertoire racine : " . $directory );
    my $return_create_md5 = create_md5($directory);
    if ( $return_create_md5 != 0 ) {
        $logger->log( "ERROR",
            "erreur durant l'appel à create_md5 sur  " . $directory );
        $logger->log( "ERROR",
            "Code retour de la fonction create_md5 : " . $return_create_md5 );
        return 1;
    }

    # Création de l'archive 7Z
    $logger->log( "INFO", "Compression du package" );
    my $return_zip_folder =
      zip_folder( $directory, $zip_size, 1, $target_package, $zip_name );
    if ( $return_zip_folder != 0 ) {
        $logger->log( "ERROR",
            "erreur durant l'appel à zip_folder sur " . $directory );
        $logger->log( "ERROR",
            "Code retour de la fonction zip_folder : " . $return_zip_folder );
        return 2;
    }

    $logger->log( "INFO", "Création de MD5 sur les fichiers archive" );

    # Liste des archives
    my $cmd_find_archives = "ls -1 " . $target_package . "/*.7z.*";
    $logger->log( "DEBUG", "Appel à la commande : " . $cmd_find_archives );
    my $result_archives = Execute->run( $cmd_find_archives, "false" );
    my @archives = $result_archives->get_log();

    $logger->log( "DEBUG",
        "Nombre de partie d'archive générées : " . scalar @archives );

    # Suppression de l'extension .001 si une seule archive est présente
    if ( 1 == scalar @archives ) {
        $logger->log( "INFO",
"Une seule archive a été générée : On supprime donc l'extension .001"
        );
        my $cmd_rename = "mv "
          . $target_package . "/"
          . $zip_name
          . ".7z.001 "
          . $target_package . "/"
          . $zip_name . ".7z";
        $logger->log( "DEBUG", "Appel à la commande : " . $cmd_rename );
        my $result_rename = Execute->run( $cmd_rename, "true" );
        if ( 0 != $result_rename->get_return() ) {
            $logger->log( "ERROR",
                "erreur durant l'appel à la commande " . $cmd_rename );
            $result_rename->log_all( $logger, "ERROR" );
            return 2;
        }

        $archives[0] = $target_package . "/" . $zip_name . ".7z";
    }

    # Création d'un md5 pour chaque archive
    foreach my $archive (@archives) {
        chomp $archive;

        my $return_create_md5 = create_md5($archive);
        if ( $return_create_md5 != 0 ) {
            $logger->log( "ERROR",
                "erreur durant l'appel à create_md5 sur " . $archive );
            $logger->log( "ERROR",
                "Code retour de la fonction create_md5 : "
                  . $return_create_md5 );
            return 3;
        }
    }

    return 0;
}
