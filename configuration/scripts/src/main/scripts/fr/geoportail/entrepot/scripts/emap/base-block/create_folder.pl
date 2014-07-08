#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   create_folder.pl("/FILER/SATA3/emap/new") will create the folder "new" into parent folder "/FILER/SATA3/emap".
# ARGS :
#   - (string) Path to the folder you want to create. Must be UNIX formated. Parent folde rmust exists and accessible by
#       the user who is executing script.
# RETURNS :
#   - 0 if creating folder is success.
#   - 255 if not enough (or too much...) argument provided.
#   - 254 if cannot create folder (no access, new folder already existing, provided parent path.
# KEYWORDS
#   $Revision 9 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/emap/create_folder.pl $
#   $Date: 23/08/2011 $
#   $Author: Damien DUPORTAL (a503140) <damien.duportal@atos.net> $
#########################################################################################################################

# Loading GPP3 Perl main env. configuration
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
my $logger = Logger->new( "create_folder.pl", $logger_levels );
our $VERSION = "9.0";
## End loading

## Main function
sub create_folder {

    my @provided_arguments      = @_;
    my $expected_number_of_args = 1;
    my ($folder_to_create)      = @provided_arguments;
    if ( scalar @provided_arguments != $expected_number_of_args
        || !defined $folder_to_create )
    {
        $logger->log( "ERROR",
                "Le nombre de paramètres renseignés n'est pas celui attendu ("
              . $expected_number_of_args
              . ")" );
        return 255;
    }

    $logger->log( "DEBUG",
        "Paramètre 1 : dossier à créer = " . $folder_to_create );

    my $output_content = `mkdir -p $folder_to_create 2>&1`;
    my $retour         = $?;

    if ( $retour != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de création du dossier : " . $output_content );
        return 254;
    }
    $logger->log( "DEBUG",
        "Le dossier " . $folder_to_create . " a été créé" );

    return 0;
}

## End Main Function
