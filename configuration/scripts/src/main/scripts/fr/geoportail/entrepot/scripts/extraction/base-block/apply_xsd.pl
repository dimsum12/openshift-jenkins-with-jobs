#!/usr/bin/perl
#########################################################################################################################
#
# USAGE :
#   This script applies an xsd layer to an xml file

# ARGS :
#   The xml file
#   The xsl file
#   The output directory of the html file
#
# RETURNS :
#   * 0 if the conditionning is correct
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/conditionnement/apply_xsd.pl$
#   $Date: 12/09/11 $
#   $Author: Maimouna DEME (a510440) <maimouna.deme@atos.net> $
###########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;

require "set_encoding.pl";

our $VERSION = "1.0";
our $config;
if ( !defined $config ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger = Logger->new( "apply_xsd.pl", $config->param("logger.levels") );
my $resources_path = $config->param("resources.path") . 'conditionnement';
my $java_command   = $config->param("resources.java");

sub apply_xsd {

    my ( $xml_file, $xsl_file, $output_directory ) = @_;

    if ( !defined $xml_file )

    {
        $logger->log( "ERROR", "Le fichier xml n'est pas défini !" );
        return 255;
    }

    if ( !defined $xsl_file )

    {
        $logger->log( "ERROR", "Le fichier xsl n'est pas défini !" );
        return 255;
    }

    if ( !defined $output_directory )

    {
        $logger->log( "ERROR",
            "Le repertoire de destination n'est pas défini ! " );
        return 255;
    }

    if ( !-d $output_directory ) {
        $logger->log( "ERROR",
            "Le dossier de destination du fichier html n'existe pas" );
        return 254;
    }

    if ( !-e $xml_file ) {
        $logger->log( "ERROR", "Le fichier $xml_file n'existe pas !" );
        return 253;
    }

    if ( !-e $xsl_file ) {
        $logger->log( "ERROR", "Le fichier xsl n'existe pas !" );

        return 252;
    }

    set_encoding($xml_file);

    my $dot       = '.';
    my $index     = index $xml_file, $dot;
    my $html_file = substr $xml_file, 0, $index;
    $html_file = $html_file . '.html';
    $logger->log( "INFO", "Le nom du fichier html est" . $html_file );

    my $call =
        "$java_command -cp "
      . $resources_path
      . "/saxon9he.jar net.sf.saxon.Transform -xi:off -warnings:silent -versionmsg:off  -s:$xml_file -xsl:$xsl_file -o:$html_file \!omit-xml-declaration=yes \!encoding=utf-8";

    $logger->log( "INFO", "Exécution de la commande " . $call );

    my $cmd    = `$call`;
    my $retour = `echo \$?`;
    if ( $retour != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de l'exécution de la commande " . $call );
        return 254;

    }

    my $call_mv   = "mv $html_file $output_directory";
    my $cmd_mv    = `$call`;
    my $retour_mv = `echo \$?`;
    if ( $retour_mv != 0 ) {
        $logger->log( "ERROR",
            "Erreur lors de l'execution de la commande " . $call_mv );

    }
    $logger->log( "INFO",
        "Le fichier html a été créé dans le dossier " . $output_directory );

    return 0;
}
