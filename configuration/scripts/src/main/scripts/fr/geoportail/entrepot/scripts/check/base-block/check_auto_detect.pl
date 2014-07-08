#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#   This script detect the product type if the parameter AUTO_DETECTION is spécified
#       it also create the requested generations if they are presents in the information file
# ARGS :
#   The delivery ID
# RETURNS :
#   * 0 if the process is correct
#   * 1 if the product type is unknown
#   * 2 if the delivery ID is unknown
#   * 3 if the information file of the delivery is not correct
#   * 4 if an error occured during creating the generations for the current delivery
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/verification/check_auto_detect.pl $
#   $Date: 17/08/11 $
#   $Author: Charles-Henri Biller (a149912) <charles-henri.biller@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Deliveryconf;
use Cwd;
use DBI;
use HTTP::Request::Common;
use LWP::UserAgent;
use Config::Simple;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger =
  Logger->new( "check_auto_detect.pl", $config->param("logger.levels") );

my $dbname   = $config->param("db-ent_referentiel.dbname");
my $host     = $config->param("db-ent_referentiel.host");
my $port     = $config->param("db-ent_referentiel.port");
my $username = $config->param("db-ent_referentiel.username");
my $password = $config->param("db-ent_referentiel.password");

my $ftp_path             = $config->param("filer.delivery-ftp");
my $ftp_prefix_path      = $config->param("prefix.ftp");
my $regex_config_content = "(" . $config->param("auto-detect.keys") . ")";
my $url_ws_entrepot      = $config->param("resources.ws.url.entrepot");
my $url_proxy            = $config->param("proxy.url");

my $typeautodetect = "AUTO_DETECTION";

sub check_auto_detect {

    # Parameters number validation
    my ($delivery_id) = @_;
    if ( !defined $delivery_id ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    # Connection DB
    my $dbh = DBI->connect( "dbi:Pg:dbname=$dbname;host=$host;port=$port",
        $username, $password,
        { AutoCommit => 1, RaiseError => 1, PrintError => 0 } );

    # Retrieve the product name
    my $SQL =
"SELECT p.name, d.login FROM delivery d, product p WHERE d.deliveryproduct_id=p.id AND d.id=?";
    $logger->log( "DEBUG",
        "Execution de la requête " . $SQL . " avec d.id = " . $delivery_id );
    my $sth = $dbh->prepare($SQL);
    $sth->execute($delivery_id);

    # Verify the delivery id
    if ( my @sth_row = $sth->fetchrow_array() ) {
        my $row_product_name = $sth_row[0];
        my $delivery_login   = $sth_row[1];

        if ( $row_product_name eq $typeautodetect ) {
            $logger->log( "DEBUG", "Lancement de la détection automatique" );
            my $delivery_dir = $ftp_path . $delivery_login . "/";

            my $info_filename = $config->param("auto-detect.filename");

            my $deliveryconf =
              Deliveryconf->new( $delivery_dir, $logger, $config );
            if ( !$deliveryconf ) {
                clean_db( $sth, $dbh );
                return 3;
            }

            $SQL = "SELECT id FROM product WHERE name='"
              . $deliveryconf->{values}{"TYPE"} . "'";
            $sth = $dbh->prepare($SQL);
            my $rv = $sth->execute();
            if ( $rv != 1 ) {
                $logger->log( "ERROR",
"Le type de produit \"$deliveryconf->{values}{'TYPE'}\" est inconnu. Vérifiez le fichier d'informations complémentaires \""
                      . $config->param("auto-detect.filename")
                      . "\"" );
                clean_db( $sth, $dbh );
                return 1;
            }

            # Update product detected
            my $row_product_id = $sth->fetch()->[0];
            $SQL =
"UPDATE delivery SET deliveryproduct_id=$row_product_id WHERE id=$delivery_id";
            $sth = $dbh->prepare($SQL);
            $rv  = $sth->execute();

            # Configure generations to launch
            my $ua = LWP::UserAgent->new;
            if ( $url_proxy ne "none" ) {
                $ua->proxy( [ 'http', 'ftp' ], $url_proxy );
            }
            my @generations = $deliveryconf->get_generations();
            for my $i ( 0 .. $#generations ) {
                my $response = $ua->request(
                    POST $url_ws_entrepot . "/generation/proposeGeneration",
                    [
                        GENERATION => $generations[$i]{name},
                        deliveryId => $delivery_id,
                        parameters => $generations[$i]{parameters},
                    ]
                );

                if ( $response->is_success ) {
                    $logger->log( "INFO",
"Configuration de la génération \"$generations[$i]{name}\" ayant pour paramètres \"$generations[$i]{parameters}\""
                    );
                }
                else {
                    $logger->log( "ERROR",
"Une erreur s'est produite lors de la configuration de la génération \"$generations[$i]{name}\" ayant pour paramètres \"$generations[$i]{parameters}\""
                    );
                    clean_db( $sth, $dbh );
                    return 4;
                }
            }

            #clean_db( $sth, $dbh );
            return 0;

        }
        else {
            $logger->log( "INFO",
                "Pas de détection automatique du type de produit" );
            clean_db( $sth, $dbh );
            return 0;
        }
    }
    else {
        $logger->log( "ERROR",
            "L'identifiant de la livraison \"$delivery_id\" est inconnue" );
        clean_db( $sth, $dbh );
        return 2;
    }
}

# Release DB connection
sub clean_db {

    # Parameters number validation
    my ( $sth, $dbh ) = @_;
    if ( !defined $sth || !defined $dbh ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (2)"
        );
        return 255;
    }

    $sth->finish;
    $dbh->disconnect;

    return;
}
