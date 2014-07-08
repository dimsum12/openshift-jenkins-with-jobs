#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   compress_folder.pl("/FILER/SATA3/emap/source","/tmp/source_archive.tgz") will archive and compress (tar + gzip)
#       folder "/FILER/SATA3/emap/source" into folder "/tmp/destination". If contents already exists, it will be overwritten.
# ARGS :
#   - (string) Path to the folder you want to archive & compress contents. Must be UNIX formated and must exists.
#   - (string) Path of the archive file you want as resulting archiving & comrpessing. Must be UNIX formated.
# RETURNS :
#   - 0 if compressing contents is successfull.
#   - 255 if not enough (or too much) arguments are provided.
#   - 254 if an error occured during compressing contents (no access, folder not existing, etc.).
# KEYWORDS
#   $Revision 3 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/emap/compress_folder.pl $
#   $Date: 23/08/2011 $
#   $Author: Damien DUPORTAL (a503140) <damien.duportal@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Config::Simple;

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "compress_folder.pl", $logger_levels );
our $VERSION = "2.0";
## End loading

## Main function
sub compress_folder {

    my @provided_arguments      = @_;
    my $expected_number_of_args = 2;
    my ( $folder_to_compress, $archive_to_create_from_folder ) =
      @provided_arguments;
    if (   scalar @provided_arguments != $expected_number_of_args
        || !defined $folder_to_compress
        || !defined $archive_to_create_from_folder )
    {
        $logger->log( "ERROR",
                "Le nombre de paramètres renseignés n'est pas celui attendu ("
              . $expected_number_of_args
              . ")" );
        return 255;
    }

    $logger->log( "DEBUG",
        "Paramètre 1 : dossier à compresser = " . $folder_to_compress );
    $logger->log( "DEBUG",
        "Paramètre 2 : archive de destination pour la compression = "
          . $archive_to_create_from_folder );

    my $output_content =
`cd $folder_to_compress 2>&1 && tar czvf $archive_to_create_from_folder . 2>&1`;
    my $retour_commande = $?;

    $logger->log( "DEBUG",
        "Retour commande de compression : " . $retour_commande );
    $logger->log( "DEBUG",
        "Sortie commande de compression : " . $output_content );

    if ( $retour_commande != 0 ) {
        $logger->log( "ERROR",
                "Erreur lors de la compression. Le code retour est "
              . $retour_commande
              . ". La sortie d'exécution est : "
              . $output_content );
        my $nettoyage_commande =
          system "rm -f " . $archive_to_create_from_folder;
        if ( $nettoyage_commande != 0 ) {
            $logger->log( "ERROR",
"Nettoyage impossible. Il ets nécessaire de supprimer manuellement le fichier corrompu suivant : "
                  . $nettoyage_commande );
        }
        return 254;
    }

    return 0;
}

## End Main Function
