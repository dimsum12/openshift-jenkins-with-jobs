#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   hg_clone_chain.pl("https//geoportail.forge.ign.fr/hg/entrepot_scripts","/home/www/my_repo") will clone the repository
#   served at the provided URL and named "entrepot_scripts" into "/home/www/my_repo" folder.
#   Only hgrc env. configuration can be used. All others information needed by hg would be interactivly asked.
# ARGS :
#   - (string) a valid URL refering to a mercurial repository, which this script's executing server can resolve and hit.
#   - (string) existing and empty folder where to checkout.
# RETURNS :
#   - 0 if the repository is well cloned into provided destination.
#   - 252 if bad numbers of arguments is provided.
#   - 253 if provided destination folder do not exists.
#   - 254 if destination exists and has contents.
#   - 255 if another error occured (no url resolving, no access, etc.)
# KEYWORDS
#   $Revision 5 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/emap/hg_clone_chain.pl $
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
my $logger = Logger->new( "hg_clone_chain.pl", $logger_levels );
our $VERSION = "5.0";
## End loading

## Main function
sub hg_clone_chain {

    my @provided_arguments      = @_;
    my $expected_number_of_args = 2;
    my ( $hg_repo_url, $destination_folder ) = @provided_arguments;
    if (   scalar @provided_arguments != $expected_number_of_args
        || !defined $hg_repo_url
        || !defined $destination_folder )
    {
        $logger->log( "ERROR",
                "Le nombre de paramètres renseignés n'est pas celui attendu ("
              . $expected_number_of_args
              . ")" );
        return 252;
    }

    $logger->log( "DEBUG",
        "Le dépôt $hg_repo_url doit être clôné dans $destination_folder."
    );

    if ( system( "test -d " . $destination_folder ) != 0 ) {
        $logger->log( "ERROR",
                "Le dossier "
              . $destination_folder
              . " n'existe pas. Impossible de clôner." );
        return 253;
    }

    if ( `find $destination_folder -not -name ".*" | wc -l` != 1 ) {
        $logger->log( "ERROR",
                "Le dossier "
              . $destination_folder
              . " n'est pas vide. Impossible de clôner." );
        return 254;
    }

    my $clone_cmd_ouput = `hg -y clone $hg_repo_url $destination_folder 2>&1`;
    my $clone_cmd_exitcode = $?;
    if ( $clone_cmd_exitcode != 0 ) {
        $logger->log( "ERROR",
                "Impossible de clôner, la commande a quitté avec le code "
              . $clone_cmd_exitcode
              . ". La sortie est :\n"
              . $clone_cmd_ouput );
        return 255;
    }

    $logger->log( "DEBUG", "Le clonage a été fait." );
    return 0;
}

## End Main Function
