#!/usr/bin/perl

BEGIN {
        push @INC, "lib";
}

use Classpath;
Classpath->load();
use Test::Simple tests =>5;
use Config::Simple;
use strict;
use warnings;
use Cwd;
use Logger;
my $config_path = cwd()."/src/test/config/local";
our $config = new Config::Simple($config_path."/config_perl.ini") or die Config::Simple->error();
my $resources_path = $config->param("resources.path");
my $logger_levels = $config->param("logger.levels");
my $logger = Logger->new( "test_apply_xsd.pl", $logger_levels );

require "apply_xsd.pl";






system ("cp -r ".$resources_path."conditionnement/xmlRasterAggregate /tmp");

ok( apply_xsd("/tmp/inexistingFileForApply_xsd.xml",$resources_path."conditionnement/mtd2xhtml.xslt","/tmp/xmlRasterAggregate/") == 253, "testInexistingXmlFile");

ok( apply_xsd("/tmp/xmlRasterAggregate/IGNF_BDPARCELLAIREr_1-2_SHP_LAMB93_13_agregated.xml",$resources_path."conditionnement/abcd.xslt","/tmp/xmlRasterAggregate/") == 252, "testWithInexistingXsltFile");


ok( apply_xsd("/tmp/xmlRasterAggregate/IGNF_BDPARCELLAIREr_1-2_SHP_LAMB93_13_agregated.xml",$resources_path."conditionnement/abcd.xslt","/tmp/inexistingOutputDirectory") == 254, "testWithInexistingOutputDirectory");



ok( apply_xsd("/tmp/xmlRasterAggregate/IGNF_BDPARCELLAIREr_1-2_SHP_LAMB93_13_agregated.xml",$resources_path."conditionnement/mtd2xhtml.xslt","/tmp/xmlRasterAggregate/") == 0, "testOkCase");
system ("rm -rf /tmp/xmlRasterAggregate");

system ("cp -r ".$resources_path."conditionnement/xmlVectorAggregate /tmp");
ok( apply_xsd("/tmp/xmlVectorAggregate/IGNF_BDPARCELLAIREr_1-2_SHP_LAMB93_13_agregated.xml",$resources_path."conditionnement/mtd2xhtml.xslt","/tmp/xmlVectorAggregate") == 0, "testOkCaseAgregated");
system ("rm -rf /tmp/xmlVectorAggregate");