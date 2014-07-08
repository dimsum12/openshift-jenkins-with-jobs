#!/usr/bin/perl

BEGIN {
	push @INC, "lib";
}

use Classpath;
Classpath->load();

use Test::Simple tests => 28;
use Database;

use strict;
use warnings;
use Cwd;
use Config::Simple;

my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");

my $dbname = $config->param("db-ent_donnees.dbname");
my $host = $config->param("db-ent_donnees.host");
my $port =  $config->param("db-ent_donnees.port");
my $superusername = $config->param("db-ent_donnees.username");
my $superpassword = $config->param("db-ent_donnees.password");

my $username = $config->param("db-ent_donnees.testusername");
my $password = $config->param("db-ent_donnees.testpassword");

my $database = Database->connect("no_exist", "no_exist.mabase.fr", "5432", "no_user", "no_pass");
ok (! defined($database), "Test de connexion à une base inexistante");

$database = Database->connect($dbname, $host, $port, $superusername, $superpassword);
ok (defined($database), "Test de connexion à la base données");

if (defined($database)) {
	ok( $database->stop_transaction() == 1, "Test de fin de transaction alors qu'aucune transaction n'est en cours");
	ok( $database->rollback_transaction() == 1, "Test de rollback de transaction alors qu'aucune transaction n'est en cours");

	ok( $database->start_transaction() == 0, "Test de début de transaction");
	ok( $database->start_transaction() == 0, "Test de début de transaction alors qu'une trasaction est déjà en cours");
	
	#$database->drop_schema("test_database", "true");

	ok( $database->create_schema('test_database') == 0, "Test de création d'un schéma");
	
	ok( $database->execute_without_return("CREATE TABLE test_database.test (id integer)") == 0, "Test de création d'une table par requête libre");

	ok( $database->execute_without_return("SELECT AddGeometryColumn('test_database', 'test', 'the_geom', 4326, 'POINT', 2)") == 0, "Test de création d'une colonne géométrique par requête libre");

	ok( $database->execute_without_return("INSERT INTO test_database.test VALUES(5, null)") == 0, "Test d'insertion par requête libre");

	ok( $database->stop_transaction() == 0, "Test de fin de transaction");
	

	$database->start_transaction();
	$database->execute_without_return("INSERT INTO test_database.test VALUES(100, null)");
	ok( $database->rollback_transaction() == 0, "Test d'un rollback de transaction");

	$database->execute_without_return("INSERT INTO test_database.test VALUES(6, null)");
	$database->execute_without_return("INSERT INTO test_database.test VALUES(7, null)");
	$database->execute_without_return("INSERT INTO test_database.test VALUES(8, null)");
	my $ref = $database->select_all_row("SELECT * FROM test_database.test WHERE id > 5");
	ok( scalar(@$ref) == 3, "Test d'un select sur plusieurs lignes renvoyant un tableau de rows");
	
	ok( $database->run_sql_dump("test_database", $resources_path."/complete_delivery_vector_ok/DATAS/EBM-EBM_CHR.sql") == 0, "Test d'import d'un fichier SQL");

	ok ( $database->select_many_row("SELEC a FRM test_database.tes") == 1, "Test d'un appel à une requête pas à pas en erreur");

	ok ( $database->select_many_row("SELECT * FROM test_database.test") == 0, "Test d'un appel à une requête renvoyant plusieurs lignes en pas à pas");
	
	$database->select_many_row("SELECT * FROM test_database.test");
	my $total = 0;
	my @row;
	while ( (@row = $database->next_row()) && scalar(@row) != 0) {
		$total = $total + $row[0];
	}
	ok( $total == 26, "Test de parcours des résultats d'une requête");
	
	my $table_list = $database->select_all_tables_from_schema('test_database');
	my $wrong_table = "false";
	foreach my $table (@{$table_list}){
		if($table->[0] ne "test" && $table->[0] ne "ebm_chr"){
			print "true";
			$wrong_table = "true";
		}
	}
	ok($wrong_table eq "false" && scalar(@{$table_list}) == 2, "Test de sélection de toutes les tables dans une schéma");

	ok($database->grant_schema_permissions('test_database', $username, 'USAGE, CREATE') ==0 , "test de grant CREATE sur un schema");
	ok($database->revoke_schema_permissions('test_database', $username, 'CREATE')==0, "Test revoke permission CREATE");
	ok($database->set_permissions_on_tables_from_schema('test_database', $username, 'SELECT, INSERT, UPDATE, DELETE')==0, "Test set permissions on all tables from schema");

	
	$database = Database->connect($dbname, $host, $port, $superusername, $superpassword);
	$database->start_transaction();
	ok( $database->drop_schema("test_database", "true") == 0, "Test de destruction du schéma");	
	
		
	(my $countElements) = $database->select_one_row("SELECT count(*) FROM geometry_columns WHERE f_table_schema = 'test_database'");
	ok (defined($countElements) && $countElements == 0, "Vérification, après drop du schéma, que les colonnes géométriques associées ont bien été supprimés, via la selection d'une seule ligne");

	$database->stop_transaction();
	
	ok (scalar (@{$database->get_user_defined_schemas()}) >= 0, "Test de get_user_defined_schemas");	
	ok (scalar (@{$database->get_tables_from_schema("public")}) >= 0, "Test de get_tables_from_schema");	
	ok (scalar (@{$database->get_sequences_from_schema("public")}) >= 0, "Test de get_sequences_from_schema");	
	
	ok ($database->get_schema_size("public") >0, "Test de get schema size ok");
	ok ($database->get_schema_size("impossibleschemaname") <0, "Test de get schema size nok");
	
	$database->disconnect();
}