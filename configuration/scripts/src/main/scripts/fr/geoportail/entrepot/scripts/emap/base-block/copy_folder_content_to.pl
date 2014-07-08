#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   copy_folder_content_to.pl("/FILER/SATA3/emap/source","/tmp/destination") will copy contents of folder "/FILER/SATA3/emap/source"
#       into folder "/tmp/destination". If contents already exists, it will be overwritten.
# ARGS :
#   - (string) Path to the source folder you want to copy contents. Must be UNIX formated and must exists.
#   - (string) Path to the destination folder you want to copy content into. Must be UNIX formated and must exists.
# RETURNS :
#   - 0 if copying contents is successfull.
#   - 255 if not enough (or too much) arguments are provided.
#   - 254 if an error occured during copying contents (no access, folder not existing, etc.).
# KEYWORDS
#   $Revision 5 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/emap/copy_folder_content_to.pl $
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
my $logger = Logger->new( "copy_folder_content_to.pl", $logger_levels );
our $VERSION = "5.0";
## End loading

## Main function
sub copy_folder_content_to {

    my @provided_arguments      = @_;
    my $expected_number_of_args = 2;
    my ( $folder_source, $folder_destination ) = @provided_arguments;
    if (   scalar @provided_arguments != $expected_number_of_args
        || !defined $folder_source
        || !defined $folder_destination )
    {
        $logger->log( "ERROR",
                "Le nombre de paramètres renseignés n'est pas celui attendu ("
              . $expected_number_of_args
              . ")" );
        return 255;
    }

    $logger->log( "DEBUG",
        "Paramètre 1 : dossier source = " . $folder_source );
    $logger->log( "DEBUG",
        "Paramètre 2 : dossier de destination = " . $folder_destination );

    my $output_content = `cp -r $folder_source/* $folder_destination/ 2>&1`;
    my $retour         = $?;

    if ( $retour != 0 ) {
        $logger->log( "ERROR", "Erreur lors de la copie : " . $output_content );
        return 254;
    }

    return 0;
}

## End Main Function
