#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();
use Test::Simple tests =>2;
use Config::Simple;
use strict;
use warnings;
use Cwd;
use Logger;
use XML::DOM::XPath;


my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
my $logger = Logger->new( "set_node.pl", $config->param("logger.levels") );

require "set_node.pl";


ok(set_node() == 255, "testWithoutParameters"); 

system ("cp -r ".$resources_path."conditionnement/testSetNode /tmp");
my $xml_folder='/tmp/testSetNode';
my @files = `ls $xml_folder/*.xml`;	 	
my $parser= XML::DOM::Parser->new();
my $doc = $parser->parsefile ($files[0]); 
my $gmd_tag ='/gmd:MD_Metadata/gmd:identificationInfo/gmd:MD_DataIdentification/gmd:resourceFormat/gmd:MD_Format/gmd:name/gco:CharacterString';

ok(set_node($doc,$gmd_tag,'tag') ==0, "testOkCase");

system ("rm -rf /tmp/testSetNode");