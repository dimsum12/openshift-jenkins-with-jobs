#!/usr/bin/perl
##########################################################################################################################################
#
# USAGE :
#   This script will set a node with a given value
# ARGS :
#   The doc node that represents the root of an xml file
#   The path of the tag
#   The value of the tag
# RETURNS :
#   * 0 if the agregation is Ok
#   * 254 if the researched tag doesn't exists
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/conditionnement/set_node.pl $
#   $Date: 05/10/11 $
#   $Author: Maimouna Deme (a510440) <maimouna.deme@atos.net> $
############################################################################################################################################

## Loading GPP3 Perl main env. configurationuse strict;
use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;
use XML::DOM::XPath;

our $VERSION = "1.0";
our $config;
our $tags;

if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger = Logger->new( "set_node.pl", $config->param("logger.levels") );

sub set_node {

    my ( $doc, $gmd_tag, $tag_value ) = @_;

    if ( !defined $doc || !defined $gmd_tag || !defined $tag_value ) {

        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (3)"
        );
        return 255;
    }
    $logger->log( "DEBUG", "Le tag à modifier est  : " . $gmd_tag );
    $logger->log( "DEBUG", "La valeur à insérer  est  : " . $tag_value );

    my @nodes = $doc->findnodes($gmd_tag);
    $logger->log( "DEBUG",
        "Le nombre de noeuds $gmd_tag est  : " . scalar @nodes );
    if ( scalar @nodes == 0 ) {
        $logger->log( "ERROR", "Le tag recherché n'existe pas !" );
        return 254;
    }
	
	
	foreach my $node (@nodes) {
		$logger->log( "DEBUG",
        "La valeur contenue dans le tag correspondant à $gmd_tag est : "
          . $node->string_value );
		my $child = $node->getFirstChild;

		if ($child){
			$child->setNodeValue($tag_value);
		}else{
			$logger->log( "WARN", "Impossble de trouver de noeud fils"  );
		}
		
		$logger->log( "DEBUG",
	"La valeur contenue dans le tag  correspondant à $gmd_tag après changement est : "
			  . $node->string_value );
	}
	

    return 0;
}
"1";
