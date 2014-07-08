#!/usr/bin/perl

#########################################################################################################################
#
#  AIM
#   This package contains set of web servoce tools
#
#  KEYWORDS
#   $Revision 1 $
#   $Source lib/Tools.pm $
#   $Date: 12/03/12 $
#   $Author: Nicolas Godelu (a184059) <nicolas.godelu@atos.net> $
#########################################################################################################################

package WebserviceTools;

use strict;
use warnings;
use Logger;
use LWP::UserAgent;
use HTTP::Request::Common;
use Cwd;
use Execute;
use JSON;
use Config::Simple;

our $VERSION = "1.0";

our $config;

sub new {
    my ( $class, $method, $url, $url_proxy ) = @_;
    my $this = {};
    bless $this, $class;

    if ( not( defined $config ) ) {
        my $config_path = cwd() . "/src/main/config/local";
        $config = Config::Simple->new( $config_path . "/config_perl.ini" )
          or croak Config::Simple->error();
    }

    $this->{LOGGER} =
      Logger->new( "WebserviceTools.pm", $config->param("logger.levels") );

    if ( !defined $method || !defined $url || !defined $url_proxy ) {
        $this->{LOGGER}->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (4)" );
        return;
    }

    $this->{method}    = $method;
    $this->{url}       = $url;
    $this->{url_proxy} = $url_proxy;

    # check method
    if ( $method ne "POST" && $method ne "PUT" && $method ne "GET" ) {
        $this->{LOGGER}->log( "ERROR",
                "La méthode demandée " 
              . $method
              . " n'est pas reconnue (doit être GET, POST ou PUT)." );
        return;

    }

    $this->{ua} = LWP::UserAgent->new;
    if ( $url_proxy ne "none" ) {
        $this->{LOGGER}->log( "DEBUG", "Utilisation du proxy : " . $url_proxy );
        $this->{ua}->proxy( [ 'http', 'ftp' ], $url_proxy );
    }

    return $this;
}

sub run {
    my ( $this, $retry_attempts, $wait_time, %parameters ) = @_;

    foreach ( keys %parameters ) {
        print $_ . " : " . $parameters{$_} . "\n";
    }

    $this->{response} = $this->make_request(%parameters);

    if ( !$this->{response}->is_success ) {

        $this->{LOGGER}->log( "ERROR", "Une erreur s'est produite " );

        my $attempts = 0;
        while ( $attempts < $retry_attempts ) {

            # still trying
            $attempts += 1;
            $this->{LOGGER}->log( "INFO",
                    "attente de "
                  . $wait_time
                  . " secondes avant nouvel essai...." );
            $this->{LOGGER}->log( "INFO",
                "Nouvelle tentative " . $attempts . " sur " . $retry_attempts );
            sleep $wait_time;

            $this->{response} = $this->make_request(%parameters);
            if ( $this->{response}->is_success ) {
                $this->{LOGGER}->log( "DEBUG", "request succeeded" );
                return 1;
            }

        }

        return 0;
    }
    else {
        return 1;
    }

}

sub get_decoded_content {
    my ($this) = @_;
    return $this->{response}->decoded_content;
}

sub get_content {
    my ($this) = @_;
    return $this->{response}->content;
}

sub make_request {
    my ( $this, %parameters ) = @_;

    if ( $this->{method} eq "POST" ) {
        return $this->{ua}->request( POST $this->{url}, %parameters );
    }
    elsif ( $this->{method} eq "PUT" ) {
        return $this->{ua}->request( PUT $this->{url}, %parameters );
    }
    else {
        return $this->{ua}->request( GET $this->{url}, %parameters );
    }

}

sub get_json {
    my ($this) = @_;
    my $json_response = $this->get_decoded_content();
    return JSON::from_json($json_response);
}

1;
