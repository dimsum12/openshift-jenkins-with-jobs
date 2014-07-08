#!/usr/bin/perl

#########################################################################################################################
#
# USAGE :
#
# ARGS :
#   The directory where the md5 files are
#   The directory to check
# RETURNS :
#   * 0 if verification is correct
#   * 1 if some files have not been checked
#   * 2 if some control error occured
#   * 3 if the directory to check does not exist
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/verification/check_xsd.pl $
#   $Date: 23/08/11 $
#   $Author: Charles-Henri Biller (a149912) <charles-henri.biller@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Cwd;
use Logger;
use Config::Simple;
use XML::LibXML;
use XML::Xerces;
use IO::Handle;
use Getopt::Long;

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}

my $logger = Logger->new( "check_xsd.pl", $config->param("logger.levels") );

my $regex_find = '\(.*\.xml\)';

sub check_xsd {

    # Parameters number validation
    my ($delivery_dir) = @_;
    if ( !defined $delivery_dir ) {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (1)"
        );
        return 255;
    }

    my $cpt_errors = 0;

    #Go to the delivery directory
    if ( !chdir $delivery_dir ) {
        $logger->log( "ERROR",
"Le répertoire racine de la livraison \"$delivery_dir\" n'existe pas"
        );
        return 2;
    }

    #Find all xml files
    my @xmlfiles = `find $delivery_dir -iregex '$regex_find' -type f`;

    foreach my $xmlfile (@xmlfiles) {
        chomp $xmlfile;
        my $result = validate("$xmlfile");
        if ( $main::NB_ERRORS > 0 ) {
            $cpt_errors = $cpt_errors + 1;
        }
    }

    if ( $cpt_errors > 0 ) {
        return 1;
    }

    return 0;
}

package main;
use strict;
use warnings;
use XML::Xerces;
use IO::Handle;
use Getopt::Long;

sub validate {
    my ($file) = @_;

    my $namespace   = 1;
    my $schema      = 1;
    my $full_schema = 1;

    # set globals used by the error handler
    $main::FILE    = $file;
    $main::PROGRAM = $0;
    $main::PROGRAM =~ s{.*/(\w+)}{$1};
    $main::NB_ERRORS = 0;

    my $parser = XML::Xerces::XMLReaderFactory::createXMLReader();
    $parser->setErrorHandler( MyErrorHandler->new );

    # print as we parse
    STDERR->autoflush();

    #   my $contentHandler = new XML::Xerces::PerlContentHandler() ;
    #   $parser->setContentHandler($contentHandler) ;

    # handle the optional features
    if (
        eval {
            $parser->setFeature( "$XML::Xerces::XMLUni::fgSAX2CoreNameSpaces",
                $namespace );
            $parser->setFeature( "$XML::Xerces::XMLUni::fgXercesSchema",
                $schema );
            $parser->setFeature(
                "$XML::Xerces::XMLUni::fgXercesSchemaFullChecking",
                $full_schema );
        }
      )
    {
        XML::Xerces::error($@);
    }
    if ($@) { XML::Xerces::error($@); }

    # and the required features
    if (
        eval {
            $parser->setFeature(
                "$XML::Xerces::XMLUni::fgXercesContinueAfterFatalError", 1 );
            $parser->setFeature(
                "$XML::Xerces::XMLUni::fgXercesValidationErrorAsFatal", 0 );
            $parser->setFeature( "$XML::Xerces::XMLUni::fgSAX2CoreValidation",
                1 );
            $parser->setFeature( "$XML::Xerces::XMLUni::fgXercesDynamic", 1 );
        }
      )
    {
        XML::Xerces::error($@);
    }
    if ($@) { XML::Xerces::error($@); }

    if (
        eval {

            # my $is = XML::Xerces::LocalFileInputSource->new($OPTIONS{file});
            my $is = XML::Xerces::LocalFileInputSource->new($file);
            $parser->parse($is);
        }
      )
    {
        XML::Xerces::error($@);
    }
    if ($@) { XML::Xerces::error($@); }

    return 0;
}

package MyErrorHandler;
use strict;
use vars qw(@ISA);
use base qw(XML::Xerces::PerlErrorHandler);

sub warning {
    my ( $parameter1, $parameter2 ) = @_;

    my $line    = $parameter2->getLineNumber;
    my $column  = $parameter2->getColumnNumber;
    my $message = $parameter2->getMessage;
    $main::NB_ERRORS = $main::NB_ERRORS + 1;
    $logger->log( "WARN",
        "WARNING -> [LINE $line, COLUMN $column, $main::FILE] : $message" );

    return;
}

sub error {
    my ( $parameter1, $parameter2 ) = @_;

    my $line    = $parameter2->getLineNumber;
    my $column  = $parameter2->getColumnNumber;
    my $message = $parameter2->getMessage;
    $main::NB_ERRORS = $main::NB_ERRORS + 1;
    $logger->log( "ERROR",
        "ERROR -> [LINE $line, COLUMN $column, $main::FILE] : $message" );

    return;
}

sub fatal_error {
    my ( $parameter1, $parameter2 ) = @_;

    my $line    = $parameter2->getLineNumber;
    my $column  = $parameter2->getColumnNumber;
    my $message = $parameter2->getMessage;
    $main::NB_ERRORS = $main::NB_ERRORS + 1;
    $logger->log( "ERROR",
        "FATAL_ERROR -> [LINE $line, COLUMN $column, $main::FILE] : $message" );

    return;
}
1;
