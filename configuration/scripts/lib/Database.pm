#!/usr/bin/perl

#########################################################################################################################
#
#  AIM
#   This package is used to access PostgreSQL/PostGIS databases with pratic functionnalities
#
#  KEYWORDS
#   $Revision 1 $
#   $Source lib/pm $
#   $Date: 16/08/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

package Database;

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use DBI;
use Logger;
use Execute;
use Config::Simple;

our $VERSION = '1.0';

my $psql_command;
my $pg_dump_command;
our $config;

sub connect {
    my ( $class, $dbname, $host, $port, $username, $password ) = @_;

    my $this = {};
    bless $this, $class;

    if ( not( defined $config ) ) {
        my $config_path = cwd() . "/src/main/config/local";
        $config = Config::Simple->new( $config_path . "/config_perl.ini" )
          or croak Config::Simple->error();
    }
    $psql_command    = $config->param("resources.psql");
    $pg_dump_command = $config->param("resources.pgdump");

    $this->{LOGGER} =
      Logger->new( "Database.pm", $config->param("logger.levels") );

    $this->{LOGGER}->log( "DEBUG", "Création de l'objet Database" );
    $this->{LOGGER}->log( "DEBUG",
            " Connection à la base " 
          . $dbname . " sur " 
          . $host . ":" 
          . $port
          . " avec l'utilisateur "
          . $username
          . " demandée" );

    $this->{DBH} = DBI->connect( "dbi:Pg:dbname=$dbname;host=$host;port=$port",
        $username, $password,
        { AutoCommit => 1, RaiseError => 0, PrintError => 0 } )
      or return;

    $this->{PGDATABASE} = $dbname;
    $this->{PGHOST}     = $host;
    $this->{PGPORT}     = $port;
    $this->{PGUSER}     = $username;
    $this->{PGPASSWORD} = $password;

    $this->{LOGGER}->log( "DEBUG", " Connection effectuée" );
    return $this;
}

sub disconnect {
    my ($this) = @_;

    $this->{LOGGER}->log( "DEBUG", "Deconnection demandée" );
    $this->{DBH}->disconnect() or return 1;
    $this->{LOGGER}->log( "DEBUG", " Deconnection effectuée" );

    return 0;
}

sub start_transaction {
    my ($this) = @_;

    if ( $this->{DBH}->{AutoCommit} == 0 ) {
        $this->{LOGGER}->log( "DEBUG",
            "Une transaction est déjà en cours. Commit de cette dernière" );
        $this->stop_transaction();
    }

    $this->{LOGGER}->log( "DEBUG", "Début de transaction demandée" );
    $this->{DBH}->begin_work() or return 1;
    $this->{LOGGER}->log( "DEBUG", " Début de transaction OK" );

    return 0;
}

sub stop_transaction {
    my ($this) = @_;

    if ( $this->{DBH}->{AutoCommit} == 1 ) {
        $this->{LOGGER}
          ->log( "DEBUG", "Aucune transaction en cours. Commit annulé" );

        return 1;
    }

    $this->{LOGGER}->log( "DEBUG", "Fin de transaction demandée" );
    $this->{DBH}->commit() or return 1;
    $this->{LOGGER}->log( "DEBUG", " Fin de transaction OK" );

    return 0;
}

sub rollback_transaction {
    my ($this) = @_;

    if ( $this->{DBH}->{AutoCommit} == 1 ) {
        $this->{LOGGER}
          ->log( "DEBUG", "Aucune transaction en cours. Rollback annulé" );

        return 1;
    }

    $this->{LOGGER}->log( "DEBUG", "Rollback de transaction demandée" );
    $this->{DBH}->rollback() or return 1;
    $this->{LOGGER}->log( "DEBUG", " Rollback de transaction OK" );

    return 0;
}

sub select_one_row {
    my ( $this, $sql ) = @_;

    $this->{LOGGER}
      ->log( "DEBUG", "Requête SELECT à une seule réponse : " . $sql );
    $this->{LOGGER}->log( "DEBUG", " Préparation de la requête" );
    my $sth = $this->{DBH}->prepare($sql) or return;
    $this->{LOGGER}->log( "DEBUG", " Execution de la requête" );
    $sth->execute() or return;
    $this->{LOGGER}
      ->log( "DEBUG", " Lecture de la première ligne retournée" );
    my @row = $sth->fetchrow_array() or return;
    $this->{LOGGER}->log( "DEBUG", " Cloture de la requête" );
    $sth->finish() or return;
    $this->{LOGGER}->log( "DEBUG", " SELECT OK" );

    return @row;
}

sub select_all_row {
    my ( $this, $sql ) = @_;

    $this->{LOGGER}
      ->log( "DEBUG", "Requête SELECT à une plusieurs réponses : " . $sql );
    $this->{LOGGER}->log( "DEBUG", " Préparation de la requête" );
    my $sth = $this->{DBH}->prepare($sql) or return;
    $this->{LOGGER}->log( "DEBUG", " Execution de la requête" );
    $sth->execute() or return;
    $this->{LOGGER}
      ->log( "DEBUG", " Lecture de l'ensemble des lignes retournées" );
    my $rows = $sth->fetchall_arrayref() or return;
    $this->{LOGGER}->log( "DEBUG", " Cloture de la requête" );
    $sth->finish() or return;
    $this->{LOGGER}->log( "DEBUG", " SELECT OK" );

    return $rows;
}

sub select_many_row {
    my ( $this, $sql ) = @_;

    $this->{LOGGER}->log( "DEBUG",
        "Requête SELECT à une plusieurs réponses bufferisée : " . $sql );
    if ( defined $this->{CURRENT_STH} ) {
        $this->{LOGGER}
          ->log( "DEBUG", " Nettoyage de la précédente requête" );
        $this->{CURRENT_STH}->finish() or return 1;
    }

    $this->{LOGGER}->log( "DEBUG", " Préparation de la requête" );

    $this->{CURRENT_STH} = $this->{DBH}->prepare($sql) or return 1;
    $this->{CURRENT_STH}->execute() or return 1;
    $this->{LOGGER}->log( "DEBUG", " Requête prête" );

    return 0;
}

sub next_row {
    my ($this) = @_;

    $this->{LOGGER}
      ->log( "DEBUG", "Demande de la ligne suivante de la requête courante" );
    if ( defined $this->{CURRENT_STH} ) {
        $this->{LOGGER}->log( "DEBUG", " Récupération de la ligne suivante" );
        my @raw = $this->{CURRENT_STH}->fetchrow_array();

        if ( scalar(@raw) == 0 && $this->{CURRENT_STH}->err ) {
            $this->{LOGGER}->log( "DEBUG",
                " Problème de lecture dans les résultats de la requête : "
                  . $this->{CURRENT_STH}->errstr );
            return;
        }

        $this->{LOGGER}->log( "DEBUG", " Récupération OK" );
        return @raw;
    }
    else {
        $this->{LOGGER}->log( "DEBUG", " Aucune requête n'est en cours" );
        return;
    }
}

sub create_schema {
    my ( $this, $schema_name ) = @_;
    $schema_name = lc $schema_name;

    $this->{LOGGER}
      ->log( "DEBUG", "Création du schéma " . $schema_name . " demandée" );
    $this->{LOGGER}->log( "DEBUG", " Préparation de la requête" );
    my $sth = $this->{DBH}->prepare( "CREATE SCHEMA " . $schema_name );
    $this->{LOGGER}->log( "DEBUG", " Execution de la requête" );
    $sth->execute() or return 1;
    $this->{LOGGER}->log( "DEBUG", " Cloture de la requête" );
    $sth->finish() or return 1;
    $this->{LOGGER}->log( "DEBUG", " Création OK" );

    return 0;
}

sub get_user_defined_schemas {
    my ($this) = @_;

    $this->{LOGGER}->log( "DEBUG",
        "Récupération de la liste des schémas non systèmes demandée." );
    my $req_user_schemas =
"SELECT nspname FROM pg_namespace WHERE nspname NOT LIKE 'pg_%' AND nspname NOT IN ('public','information_schema') ORDER BY nspname;";

    return $this->select_all_row($req_user_schemas);

}

sub get_tables_from_schema {
    my ( $this, $schema_name ) = @_;
    $schema_name = lc $schema_name;

    $this->{LOGGER}->log( "DEBUG",
        "Récupération de la liste des tables du schéma " . $schema_name );
    my $req_get_tables = "SELECT tablename FROM pg_tables WHERE schemaname = '"
      . $schema_name . "';";

    return $this->select_all_row($req_get_tables);
}

sub get_sequences_from_schema {
    my ( $this, $schema_name ) = @_;
    $schema_name = lc $schema_name;

    $this->{LOGGER}->log( "DEBUG",
        "Récupération de la liste des sequences du schéma " . $schema_name );
    my $req_get_seqs =
"select c.relname from pg_class c, pg_namespace n where n.oid = c.relnamespace and c.relkind in ('S') and n.nspname in ('"
      . $schema_name . "');";

    return $this->select_all_row($req_get_seqs);
}

sub drop_schema {
    my ( $this, $schema_name, $cascade ) = @_;
    $schema_name = lc $schema_name;

    if ( !defined $cascade ) {
        $cascade = "false";
    }

    $this->{LOGGER}->log( "DEBUG",
            "Destruction du schéma "
          . $schema_name
          . " demandée (cascade = "
          . $cascade
          . ")" );

    $this->{LOGGER}->log( "DEBUG",
        " Récupération des colonnes géométriques liées au schéma "
          . $schema_name );
    my $geometries = $this->select_all_row(
"SELECT f_table_name, f_geometry_column FROM geometry_columns WHERE f_table_schema = '"
          . $schema_name
          . "'" );
    if ( defined $geometries ) {
        foreach my $row ( @{$geometries} ) {
            my $geom_table_name;
            my $geom_geometry_column;
            ( $geom_table_name, $geom_geometry_column ) = @{$row};
            $this->{LOGGER}->log( "DEBUG",
                    " Suppression de la colonne "
                  . $geom_geometry_column
                  . " de la table "
                  . $geom_table_name );
            $this->execute_without_return( "SELECT DropGeometryColumn('"
                  . $schema_name . "', '"
                  . $geom_table_name . "', '"
                  . $geom_geometry_column
                  . "')" );
        }
    }

    $this->{LOGGER}->log( "DEBUG", " Préparation de la requête" );
    my $sql = "DROP SCHEMA " . $schema_name;

    if ( $cascade && $cascade eq "true" ) {
        $sql = $sql . " CASCADE";
    }

    my $sth = $this->{DBH}->prepare($sql);
    $this->{LOGGER}->log( "DEBUG", " Execution de la requête : " . $sql );
    $sth->execute() or return 1;
    $this->{LOGGER}->log( "DEBUG", " Cloture de la requête" );
    $sth->finish() or return 1;
    $this->{LOGGER}->log( "DEBUG", " Destruction OK" );

    return 0;
}

sub revoke_schema_permissions {
    my ( $this, $schema_name, $username, $permissions ) = @_;
    $schema_name = lc $schema_name;

    $this->{LOGGER}->log(
        "DEBUG",

        " Demande de suppression de la(des) permission(s) "
          . $permissions
          . " pour l'utilisateur "
          . $username
          . " pour le schema "
          . $schema_name
          . " demandée"
    );

    my $return =
      $this->execute_without_return( "REVOKE "
          . $permissions
          . " ON SCHEMA "
          . $schema_name
          . " FROM "
          . $username );
    if ( $return != 0 ) {
        $this->{LOGGER}
          ->log( "DEBUG", " Erreur lors de l'éxecution de la commande" );
        return 1;
    }
    return 0;
}

sub grant_schema_permissions {
    my ( $this, $schema_name, $username, $permissions ) = @_;
    $schema_name = lc $schema_name;

    $this->{LOGGER}->log( "DEBUG",
            " Demande d'ajout de la(des) permission(s) "
          . $permissions
          . " pour l'utilisateur "
          . $username
          . " pour le schema "
          . $schema_name
          . " demandée" );

    my $return =
      $this->execute_without_return( "GRANT "
          . $permissions
          . " ON SCHEMA "
          . $schema_name . " TO "
          . $username );
    if ( $return != 0 ) {
        $this->{LOGGER}
          ->log( "DEBUG", " Erreur lors de l'éxecution de la commande" );
        return 1;
    }

    return 0;
}

sub set_permissions_on_tables_from_schema {

# Grant ONLY given permimssions on a table. If the permissions parameter is empty, revoke all permissions
    my ( $this, $schema_name, $username, $permissions ) = @_;
    $schema_name = lc $schema_name;

    $this->{LOGGER}->log( "DEBUG",
            "Modification des droits pour toutes les tables du schema "
          . $schema_name
          . " demandée" );

    my $table_list = $this->select_all_tables_from_schema($schema_name);

    foreach my $table ( @{$table_list} ) {
        $this->revoke_all_permissions_on_table( $schema_name, $table->[0],
            $username );
        if ( defined $permissions ) {
            my $return =
              $this->grant_table_permissions( $schema_name, $table->[0],
                $permissions, $username );
            if ( $return != 0 ) {
                $this->{LOGGER}->log( "DEBUG",
                    " Erreur lors de l'éxecution de la commande" );
                return 1;
            }
        }
    }

    return 0;
}

sub select_all_tables_from_schema {
    my ( $this, $schema_name ) = @_;
    $schema_name = lc $schema_name;

    $this->{LOGGER}->log( "DEBUG",
        " Selection de toutes les tables du schéma " . $schema_name );
    return $this->select_all_row(
            "SELECT tablename FROM pg_tables WHERE schemaname='"
          . $schema_name
          . "'" );
}

sub revoke_all_permissions_on_table {
    my ( $this, $schema_name, $table_name, $user ) = @_;
    $schema_name = lc $schema_name;

    $this->{LOGGER}->log( "DEBUG",
" Execution de la commande d'annulation de tous les permissions pour l'utilisateur "
          . $user
          . " sur la table "
          . $schema_name . "."
          . $table_name );
    my $return =
      $this->execute_without_return( "REVOKE ALL PRIVILEGES ON "
          . $schema_name . "."
          . $table_name
          . " FROM "
          . $user );
    if ( $return != 0 ) {
        $this->{LOGGER}
          ->log( "DEBUG", " Erreur lors de l'éxecution de la commande" );
        return 1;
    }

    return 0;
}

sub grant_table_permissions {
    my ( $this, $schema_name, $table_name, $permissions, $user ) = @_;
    $schema_name = lc $schema_name;

    $this->{LOGGER}->log( "DEBUG",
            " Execution de la commande d'ajout de la permission "
          . $permissions
          . " pour l'utilisateur "
          . $user
          . " sur la table "
          . $schema_name . "."
          . $table_name );
    my $return =
      $this->execute_without_return( "GRANT "
          . $permissions . " ON "
          . $schema_name . "."
          . $table_name . " TO "
          . $user );

    if ( $return != 0 ) {
        $this->{LOGGER}
          ->log( "DEBUG", " Erreur lors de l'éxecution de la commande" );
        return 1;
    }
    return 0;
}

sub execute_without_return {
    my ( $this, $sql_line ) = @_;

    $this->{LOGGER}->log( "DEBUG",
        "Execution sans attente de réponse de la ligne : " . $sql_line );
    $this->{LOGGER}->log( "DEBUG", " Préparation de la requête" );
    my $sth = $this->{DBH}->prepare($sql_line);
    $this->{LOGGER}->log( "DEBUG", " Execution de la requête" );
    $sth->execute() or return 1;
    $this->{LOGGER}->log( "DEBUG", " Cloture de la requête" );
    $sth->finish() or return 1;
    $this->{LOGGER}->log( "DEBUG", " Execution OK" );

    return 0;
}

sub run_sql_dump {
    my ( $this, $schema_name, $sql_file, %call_parameters ) = @_;
    $schema_name = lc $schema_name;

    $this->{LOGGER}->log( "DEBUG",
            "Intégration du dump SQL "
          . $sql_file
          . " dans le schéma "
          . $schema_name
          . " demandée" );

    local $ENV{"PGDATABASE"} = $this->{PGDATABASE};
    local $ENV{"PGHOST"}     = $this->{PGHOST};
    local $ENV{"PGPORT"}     = $this->{PGPORT};
    local $ENV{"PGUSER"}     = $this->{PGUSER};
    local $ENV{"PGPASSWORD"} = $this->{PGPASSWORD};

    my $cmd_psql =
        "PGOPTIONS='-c search_path="
      . $schema_name
      . ",public' "
      . $psql_command
      . " -v ON_ERROR_STOP=1 -q -f "
      . $sql_file
      . " 1> /dev/null 2>&1";
    $this->{LOGGER}->log( "DEBUG", " Appel à la commande : " . $cmd_psql );

    my $result = Execute->run( $cmd_psql, "true" );
    if ( $result->get_return() != 0 ) {
        $this->{LOGGER}->log( "ERROR",
            "Erreur lors de l'éxecution de la commande : " . $cmd_psql );
        $result->log_all( $this->{LOGGER}, "ERROR" );

        return 1;
    }

    $this->{LOGGER}->log( "DEBUG", " Intégration OK" );

    return 0;
}

sub exec_pg_dump {
    my ( $this, $dump_file ) = @_;

    $this->{LOGGER}->log( "DEBUG",
            "Génération du dump de la base PGSQL "
          . $this->{PGDATABASE}
          . " dans le fichier "
          . $dump_file
          . " demandée" );

    local $ENV{"PGDATABASE"} = $this->{PGDATABASE};
    local $ENV{"PGHOST"}     = $this->{PGHOST};
    local $ENV{"PGPORT"}     = $this->{PGPORT};
    local $ENV{"PGUSER"}     = $this->{PGUSER};
    local $ENV{"PGPASSWORD"} = $this->{PGPASSWORD};

    my $cmd_pg_dump =
      $pg_dump_command . " -Fc -f" . $dump_file . " 1> /dev/null 2>&1";
    $this->{LOGGER}->log( "DEBUG", " Appel à la commande : " . $cmd_pg_dump );

    my $result = Execute->run( $cmd_pg_dump, "true" );
    if ( $result->get_return() != 0 ) {
        $this->{LOGGER}->log( "ERROR",
            "Erreur lors de l'éxecution de la commande : " . $cmd_pg_dump );
        $result->log_all( $this->{LOGGER}, "ERROR" );

        return 1;
    }

    $this->{LOGGER}->log( "DEBUG", " PG dump OK" );

    return 0;
}

sub get_schema_size {
    my ( $this, $schema_name ) = @_;

    $this->{LOGGER}->log( "DEBUG",
        "Requête pour avoir la taille du schema : " . $schema_name );
    $this->{LOGGER}->log( "DEBUG", " Préparation de la requête" );

    my $sql = "SELECT sum(t.table_size) FROM (
					SELECT pg_total_relation_size(pg_catalog.pg_class.oid) as table_size FROM   pg_catalog.pg_class
					JOIN pg_catalog.pg_namespace ON relnamespace = pg_catalog.pg_namespace.oid
					WHERE pg_catalog.pg_namespace.nspname = '" . $schema_name . "'
					) t";
    $this->{LOGGER}->log( "DEBUG", "La requête est : " . $sql );
    my @row  = $this->select_one_row($sql);
    my $size = $row[0];
    if ( $size eq "" ) {
        $this->{LOGGER}->log( "ERROR",
            "Erreur durant la récupération de la taille du schema "
              . $schema_name );
        return -2;
    }
    chomp($size);
    $this->{LOGGER}
      ->log( "DEBUG", "La taille du schéma est de " . $size . " octets" );
    return $size;
}

1;

