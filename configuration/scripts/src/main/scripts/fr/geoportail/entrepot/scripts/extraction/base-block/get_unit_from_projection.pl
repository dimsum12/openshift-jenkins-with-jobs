#!/usr/bin/perl
##########################################################################################################################################
#
# USAGE :
#   This script will detect if a projection is in degres or meters
# ARGS :
#   - projection
# RETURNS :
#   * m if the projection is in meters
#   * d if the projection is in degres 
#   * 1 if projections is unknown
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/extraction/base-block/get_unit_from_projection.pl $
#   $Date: 26/04/12 $
#   $Author: Nicolas Godelu (a154059) <nicolas.godelu@atos.net> $
############################################################################################################################################

## Loading GPP3 Perl main env. configurationuse strict;
use strict;
use warnings;
use Logger;
use Config::Simple;
use Execute;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger =
  Logger->new( "get_unit_from_projection.pl", $config->param("logger.levels") );

my $gdalsrsinfo = $config->param("resources.gdalsrsinfo");



sub get_unit_from_projection {

    # Extraction des paramètres
    my ( $projection  ) = @_;
    if ( !defined $projection )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : projection = " . $projection );


	my $cmd =  $gdalsrsinfo . " -o mapinfo " . $projection;
	$logger->log( "DEBUG", "Comamnde executée : " . $cmd );
	
	
	my $cmd_result =  Execute->run( $cmd, "true" );
	
	my @cmd_return =  $cmd_result->get_log();
	my $cmd_return_line = $cmd_return[0];
    chomp $cmd_return_line;
	
	if ($cmd_return_line =~ m/ERROR/){
		$logger->log( "ERROR",
			"La commande \"" . $cmd_result->get_return() . "\" a renvoyé une erreur");
		$logger->log( "DEBUG", "Sortie complète du processus :" );
		$cmd_result->log_all( $logger, "DEBUG" );
		return 1;
	}

	
	if ($cmd_return_line =~ m/"m"/){
		$logger->log( "INFO", "La projection est en mètres" );
		return "m";
	} else{
		$logger->log( "INFO", "La projection est en degrés" );
		return "d";
	}
	
}
