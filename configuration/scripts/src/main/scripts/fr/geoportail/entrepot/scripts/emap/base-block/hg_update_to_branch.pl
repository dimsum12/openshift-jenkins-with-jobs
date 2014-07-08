#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   hg_update_to_branch.pl("/home/www/my_wkps","develop") will update mercurial workspace "/home/www/my_repo" to
#   the repo's branch "develop". A hg pull will be done in order to get last changes from central repo.
# ARGS :
#   - (string) UNIX path to a valid mercurial workspace.
#   - (string) name of an existing branch of the provided workspace.
# RETURNS :
#   - 0 if the workspace has been updated to the provided branch.
#   - 251 if bad numbers of params is provided.
#   - 252 if the provided workspace do not exist into filesystem.
#   - 253 if the provided workspace exists into filesystem but isn't a valid mercurial workspace/repo.
#   - 254 if the provided branch do not exists into workspace's repository.
#   - 255 if another error occured (no repo access, no filesystem access etc.)
# KEYWORDS
#   $Revision 2 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/emap/hg_update_to_branch.pl $
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
my $logger = Logger->new( "hg_update_to_branch.pl", $logger_levels );
our $VERSION = "2.0";
## End loading

## Main function
sub hg_update_to_branch {

    my @provided_arguments      = @_;
    my $expected_number_of_args = 2;
    my ( $hg_workspace, $hg_new_branch ) = @provided_arguments;
    if (   scalar @provided_arguments != $expected_number_of_args
        || !defined $hg_workspace
        || !defined $hg_new_branch )
    {
        $logger->log( "ERROR",
                "Le nombre de paramètres renseignés n'est pas celui attendu ("
              . $expected_number_of_args
              . ")" );
        return 251;
    }
    $logger->log( "DEBUG",
            "L'espace de travail "
          . $hg_workspace
          . " doit être mis à jour sur la branche "
          . $hg_new_branch
          . " du dépôt." );

    my $hg_valid_branch = 0;
    if ( system( "test -d " . $hg_workspace ) != 0 ) {
        $logger->log( "ERROR",
                "Le dossier "
              . $hg_workspace
              . " n'est pas accessible ou n'existe pas." );
        return 252;
    }

    if ( system( "cd " . $hg_workspace . " && hg status" ) != 0 ) {
        $logger->log( "ERROR",
                "Le dossier "
              . $hg_workspace
              . " n'est pas un espace de travail mercurial valide." );
        return 253;
    }

    my @branch_list   = `cd $hg_workspace && hg branches | awk '{print \$1}'`;
    my $branch_exists = 0;

    foreach my $branch (@branch_list) {
        chomp $branch;
        if ( $branch eq $hg_new_branch ) {
            $branch_exists = 1;
        }
        last if ( $branch_exists == 1 );
    }
    if ( $branch_exists != 1 ) {
        $logger->log( "ERROR",
                "La branche fournie, "
              . $hg_new_branch
              . ", n'existe pas dans le dépôt." );
        return 254;
    }

    my $hg_update_result   = `cd $hg_workspace && hg update -y $hg_new_branch`;
    my $hg_update_exitcode = $?;

    if ( $hg_update_exitcode != 0 ) {
        $logger->log( "ERROR",
                "La mise à jour du worksapce sur la branche "
              . $hg_new_branch
              . " a échoué avec le code erreur "
              . $hg_update_exitcode
              . ". La sortie est :\n"
              . $hg_update_result );
        return 255;
    }

    $logger->log( "DEBUG",
            "Le dépôt a bien été mis à jour sur la branche "
          . $hg_new_branch
          . "." );

    return 0;

}

## End Main Function
