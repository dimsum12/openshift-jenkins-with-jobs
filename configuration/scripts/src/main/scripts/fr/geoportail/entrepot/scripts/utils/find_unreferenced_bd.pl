#!/usr/bin/perl
#########################################################################################################################
#
# USAGE :
#   This script return the broadcast datas identifiers for broadcast datas still in the specified filer, which are not in
#   database anymore, or schema name for broadcast datas still in the BDD
# ARGS :
#	The volume name, or "BDD" for seeking in database ent_donnees
# RETURNS :
#   * An identifiers list (ids or schema names)
#   * 1 if an error occured during connecting to database
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/extraction/base-block/find_unreferenced_bd.pl $
#   $Date: 04/07/12 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;
use LWP::UserAgent;
use HTTP::Request::Common;
use File::Basename;
use Database;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger =
  Logger->new( "find_unreferenced_bd.pl", $config->param("logger.levels") );
 
my $dbname        = $config->param("db-ent_donnees.dbname");
my $host          = $config->param("db-ent_donnees.host");
my $port          = $config->param("db-ent_donnees.port");
my $username      = $config->param("db-ent_donnees.username");
my $password      = $config->param("db-ent_donnees.password");
my $dbname_ref    = $config->param("db-ent_referentiel.dbname");
my $host_ref      = $config->param("db-ent_referentiel.host");
my $port_ref      = $config->param("db-ent_referentiel.port");
my $username_ref  = $config->param("db-ent_referentiel.username");
my $password_ref  = $config->param("db-ent_referentiel.password");
my $root_storage  = $config->param("filer.root.storage");


sub find_unreferenced_bd {

    # Extraction des paramètres
    my (
        $filer_name 
    ) = @_;
    if ( !defined $filer_name ) {
        $logger->log( "ERROR","Le nombre de paramètres renseignés n'est pas celui attendu (1)" );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : filer_name = " . $filer_name );
	
	
	# Connection à la BDD
    $logger->log( "DEBUG",
            "Connection à la BDD : " 
          . $dbname_ref . " sur " 
          . $host_ref . ":" 
          . $port_ref
          . " avec l'utilisateur "
          . $username_ref );
    my $database_ref =
      Database->connect( $dbname_ref, $host_ref, $port_ref, $username_ref, $password_ref );
	if ( !defined $database_ref ) {
		return 1;
	}
	 	
	my @list_id = ();
	if ( "BDD" eq $filer_name ) {
		# Connection à la BDD datas
		$logger->log( "DEBUG",
				"Connection à la BDD : " 
			  . $dbname . " sur " 
			  . $host . ":" 
			  . $port
			  . " avec l'utilisateur "
			  . $username );
		my $database_datas =
		  Database->connect( $dbname, $host, $port, $username, $password );
		if ( !defined $database_datas ) {
			return 1;
		}
		# Listage des schemas B
		my $sql = "SELECT nspname FROM pg_namespace WHERE nspname <> 'public' AND nspowner <> 10";
		$logger->log( "DEBUG", "Execution de la requête : " . $sql );
		
		$database_datas->select_many_row($sql);
		
		my @row = $database_datas->next_row();
		while ( @row ) {
			my $schema_name = $row[0];
			$logger->log( "DEBUG", "Traitement de : " . $schema_name );
			
			my $sql =  "SELECT id FROM broadcastdatapgsql WHERE schemaname = '" . $schema_name . "'";
			$logger->log( "DEBUG", "Execution de la requête : " . $sql );
			
			my ($id) = $database_ref->select_one_row($sql);
			if ( !defined $id ) {
				$logger->log( "DEBUG", "Ajout de : " . $schema_name . " à la liste" );
				push @list_id, $schema_name;
			}
			
			@row = $database_datas->next_row();
		}
	} else {
		# Listage des fichiers à la racine du volume souhaité
		my $cmd_list_files = "find " . $root_storage . "/" . $filer_name . " -mindepth 1 -maxdepth 1";
		$logger->log( "DEBUG", "Execution de : " . $cmd_list_files );
		my $return_list_files = Execute->run($cmd_list_files);
		my @list_files = $return_list_files->get_log();
		$logger->log( "INFO", scalar @list_files . " fichiers trouvés" );
	
		foreach my $current_file (@list_files) {
			chomp($current_file);
			$logger->log( "DEBUG", "Traitement de : " . $current_file );
			
			my $current_id = basename $current_file;
			if ( -d $current_file && $current_id =~ /^[0-9]*$/ ) {
				my $sql =  "SELECT id FROM broadcastdata WHERE id = '" . $current_id . "'";
				$logger->log( "DEBUG", "Execution de la requête : " . $sql );
				
				my ($id) = $database_ref->select_one_row($sql);
				if ( !defined $id ) {
					$logger->log( "DEBUG", "Ajout de : " . $current_id . " à la liste" );
					push @list_id, $current_id;
				}
			}
		}
	}
	
	$logger->log( "INFO", scalar @list_id . " identifiants trouvés : " . join " ", @list_id );
}