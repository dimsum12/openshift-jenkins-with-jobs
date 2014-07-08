#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   clean_folder_content.pl("/FILER/SATA3/emap/new") will delete all content of folder "/FILER/SATA3/emap/new" but not itself.
# ARGS :
#   - (string) Path to the folder you want to clean contents. Must be UNIX formated.
# RETURNS :
#   - 0 if cleaning folder is success.
#   - 255 if not enough (or too much...) argument provided.
#   - 254 if cannot clean folder (no access, new folder already existing, provided parent path...)
# KEYWORDS
#   $Revision 5 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/emap/clean_folder_content.pl $
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
my $logger = Logger->new( "clean_folder_content.pl", $logger_levels );
our $VERSION = "5.0";
## End loading

## Main function
sub clean_folder_content {

    my @provided_arguments      = @_;
    my $expected_number_of_args = 1;
    my ($folder_to_clean)       = @provided_arguments;
    if ( scalar @provided_arguments != $expected_number_of_args
        || !defined $folder_to_clean )
    {
        $logger->log( "ERROR",
                "Le nombre de paramètres renseignés n'est pas celui attendu ("
              . $expected_number_of_args
              . ")" );
        return 255;
    }

    $logger->log( "DEBUG",
        "Paramètre 1 : dossier à nettoyer = " . $folder_to_clean );

    my $output_content =
      `rm -rf $folder_to_clean 2>&1 && mkdir -p $folder_to_clean 2>&1`;
    my $code_retour = $?;

    $logger->log( "DEBUG", "Code retour du nettoyage : " . $code_retour );
    $logger->log( "DEBUG", "Sortie du nettoyage : " . $output_content );

    if ( $code_retour != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors du nettoyage du dossier : " . $output_content );
        return 254;
    }
    $logger->log( "DEBUG",
        "Le dossier " . $folder_to_clean . " a été nettoyé" );

    return 0;
}

## End Main Function
