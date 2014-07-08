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

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

our $regexs_file = $config->param("check.sql.regexsfile");
our $logger = Logger->new( "check_sql.pl", $config->param("logger.levels") );

my $nb_head_lines_to_check = 20;
my $nb_tail_lines_to_check = 5;

sub check_sql {

    # Parameters number validation
    my ($sql_dir) = @_;
    if ( !defined $sql_dir ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    if ( !-d $sql_dir ) {
        $logger->log( "ERROR",
            "Le répertoire de sql " . $sql_dir . " n'existe pas" );
        return 3;
    }

    my @list_files_sql = `find $sql_dir -name "*.sql"`;
    if ( scalar @list_files_sql == 0 ) {
        $logger->log( "WARN",
            "Le répertoire " . $sql_dir . " ne contient aucun fichier SQL" );
        return 1;
    }

    if ( !-e $regexs_file ) {
        $logger->log( "ERROR",
"Impossible d'accéder au fichier de ressource des expressions régulières SQL"
        );
        return 254;
    }
    my @regexs = `more $regexs_file`;

    my $nb_file_errors = 0;
    my $nb_file_checks = 0;

    foreach my $file_sql (@list_files_sql) {
        chomp $file_sql;
        $logger->log( "INFO", "Vérification du fichier " . $file_sql );

        my @lines_to_check = `head -$nb_head_lines_to_check $file_sql`;

        my $nb_errors    = 0;
        my $nb_checks    = 0;
        my $line_to_join = "";

        foreach my $line_to_check (@lines_to_check) {
            chomp $line_to_check;
            $line_to_check = $line_to_join . $line_to_check;

            if ( $line_to_check =~ /^[]*[-]{2}.*$/ ) {
                $logger->log( "DEBUG",
                    "\"" . $line_to_check . "\" est une ligne de commentaire" );
            }
            elsif ( $line_to_check =~ /^.*;[ ]*$/ ) {
                my $line_ok = "false";
                $logger->log( "DEBUG",
                    "Verification de la ligne : " . $line_to_check );
              FOREACH_REGEX: foreach my $regex (@regexs) {
                    chomp $regex;
                    $logger->log( "DEBUG",
                            "Test de \""
                          . $line_to_check
                          . "\" par la regex \""
                          . $regex
                          . "\"" );
                    if ( $line_to_check =~ /$regex/i ) {
                        $logger->log( "DEBUG",
                                "La ligne \""
                              . $line_to_check
                              . "\" est vérifié par la regex \""
                              . $regex
                              . "\"" );
                        $line_ok = "true";
                        last FOREACH_REGEX;
                    }
                }

                if ( $line_ok eq "false" ) {
                    $logger->log( "ERROR",
                            "La ligne \""
                          . $line_to_check
                          . "\" du fichier \"$file_sql\" n'a été vérifiée par aucune expression régulière"
                    );
                    $nb_errors = $nb_errors + 1;
                }

                $nb_checks    = $nb_checks + 1;
                $line_to_join = "";
            }
            else {
                $logger->log( "DEBUG",
                        "\""
                      . $line_to_check
                      . "\" n'est pas une ligne SQL complète" );
                $line_to_join = $line_to_check;
            }
        }

        if ( $line_to_join ne "" ) {
            $logger->log( "INFO",
"La dernière ligne à vérifier n'est pas une ligne SQL complète et est donc ignorée"
            );
        }

        if ( $nb_errors != 0 ) {
            $logger->log( "ERROR",
                    "Le fichier "
                  . $file_sql
                  . " contient "
                  . $nb_errors
                  . " ligne(s) non valide(s) sur "
                  . $nb_checks
                  . " ligne(s) vérifiée(s)" );
            $nb_file_errors = $nb_file_errors + 1;
        }
        else {
            $logger->log( "INFO",
                "Le fichier " . $file_sql . " a été correctement vérifié" );
        }

        $nb_file_checks = $nb_file_checks + 1;
    }

    if ( $nb_file_errors != 0 ) {
        $logger->log( "ERROR",
                $nb_file_errors
              . " fichier(s) sur "
              . $nb_file_checks
              . " vérifié(s) contient des erreurs" );
        return 2;
    }
    else {
        return 0;
    }
}

