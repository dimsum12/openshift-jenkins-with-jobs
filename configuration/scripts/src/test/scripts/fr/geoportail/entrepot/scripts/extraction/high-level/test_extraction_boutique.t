#!/usr/bin/perl

BEGIN {
    push @INC, "lib";
}

use Classpath;
Classpath->load();
use Test::Simple tests => 14;
use Config::Simple;
use Test::MockObject;
use strict;
use warnings;
use Cwd;

my $config_path = cwd() . "/src/test/config/local";
our $config = new Config::Simple( $config_path . "/config_perl.ini" )
  or die Config::Simple->error();
my $resources_path   = $config->param("resources.path");
my $tmp_path         = $config->param("resources.tmp.path");
my $tmp_extraction   = $config->param("resources.tmp.extractions");
my $root_storage   	 = $config->param("filer.root.storage");

require "extraction_boutique.pl";


my $sample_mtd ='<?xml version=\'1.0\' encoding=\'utf-8\' ?><csw:GetRecordByIdResponse xmlns:csw="http://www.opengis.net/cat/csw/2.0.2" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:ows="http://www.opengis.net/ows"><gmd:MD_Metadata xmlns:gco="http://www.isotc211.org/2005/gco" xmlns:gts="http://www.isotc211.org/2005/gts" xmlns:gml="http://www.opengis.net/gml" xmlns:gsr="http://www.isotc211.org/2005/gsr" xmlns:gmx="http://www.isotc211.org/2005/gmx" xmlns:gss="http://www.isotc211.org/2005/gss" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:gmd="http://www.isotc211.org/2005/gmd" xmlns:srv="http://www.isotc211.org/2005/srv" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" uuid="IGNF_PVA_1-0__1980__X0145-0051"><gmd:fileIdentifier><gco:CharacterString>IGNF_PVA_1-0__1980__X0145-0051.xml</gco:CharacterString></gmd:fileIdentifier><gmd:language><gmd:LanguageCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#LanguageCode" codeListValue="fre">fre</gmd:LanguageCode></gmd:language><gmd:characterSet><gmd:MD_CharacterSetCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#MD_CharacterSetCode" codeListValue="utf8">utf8</gmd:MD_CharacterSetCode></gmd:characterSet><gmd:hierarchyLevel><gmd:MD_ScopeCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#MD_ScopeCode" codeListValue="dataset">dataset</gmd:MD_ScopeCode></gmd:hierarchyLevel><gmd:hierarchyLevelName><gco:CharacterString>Mission</gco:CharacterString></gmd:hierarchyLevelName><gmd:contact><gmd:CI_ResponsibleParty><gmd:organisationName><gco:CharacterString>IGN-F</gco:CharacterString></gmd:organisationName><gmd:positionName><gco:CharacterString>responsable de marché</gco:CharacterString></gmd:positionName><gmd:contactInfo><gmd:CI_Contact><gmd:address><gmd:CI_Address><gmd:deliveryPoint><gco:CharacterString>Institut Géographique National - Service Clients</gco:CharacterString></gmd:deliveryPoint><gmd:deliveryPoint><gco:CharacterString>73 avenue de Paris</gco:CharacterString></gmd:deliveryPoint><gmd:city><gco:CharacterString>Saint Mandé</gco:CharacterString></gmd:city><gmd:postalCode><gco:CharacterString>94165 Cedex</gco:CharacterString></gmd:postalCode><gmd:country><gco:CharacterString>FRA</gco:CharacterString></gmd:country><gmd:electronicMailAddress><gco:CharacterString>sav-bd@ign.fr</gco:CharacterString></gmd:electronicMailAddress></gmd:CI_Address></gmd:address></gmd:CI_Contact></gmd:contactInfo><gmd:role><gmd:CI_RoleCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#CI_RoleCode" codeListValue="distributor">distributor</gmd:CI_RoleCode></gmd:role></gmd:CI_ResponsibleParty></gmd:contact><gmd:dateStamp><gco:Date>2008-06-20</gco:Date></gmd:dateStamp><gmd:metadataStandardName><gco:CharacterString>ISO 19115</gco:CharacterString></gmd:metadataStandardName><gmd:metadataStandardVersion><gco:CharacterString>2005/PDAM 1</gco:CharacterString></gmd:metadataStandardVersion><gmd:locale><gmd:PT_Locale id="locale-eng"><gmd:languageCode><gmd:LanguageCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#LanguageCode" codeListValue="eng">eng</gmd:LanguageCode></gmd:languageCode><gmd:country><gmd:Country codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#Country" codeListValue="GB">GB</gmd:Country></gmd:country><gmd:characterEncoding><gmd:MD_CharacterSetCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#MD_CharacterSetCode" codeListValue="8859part15">8859part15</gmd:MD_CharacterSetCode></gmd:characterEncoding></gmd:PT_Locale></gmd:locale><gmd:spatialRepresentationInfo><gmd:MD_VectorSpatialRepresentation><gmd:topologyLevel><gmd:MD_TopologyLevelCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#MD_TopologyLevelCode" codeListValue="geometryOnly">geometryOnly</gmd:MD_TopologyLevelCode></gmd:topologyLevel><gmd:geometricObjects><gmd:MD_GeometricObjects><gmd:geometricObjectType><gmd:MD_GeometricObjectTypeCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#MD_GeometricObjectTypeCode" codeListValue="surface">surface</gmd:MD_GeometricObjectTypeCode></gmd:geometricObjectType><gmd:geometricObjectCount><gco:Integer>201</gco:Integer></gmd:geometricObjectCount></gmd:MD_GeometricObjects></gmd:geometricObjects></gmd:MD_VectorSpatialRepresentation></gmd:spatialRepresentationInfo><gmd:referenceSystemInfo><gmd:MD_ReferenceSystem id="IGNF_PVA_1-0.xml.referenceSystemInfo.LAMBE"><gmd:referenceSystemIdentifier><gmd:RS_Identifier><gmd:code><gmx:Anchor xlink:href="http://librairies.ign.fr/geoportail/resources/RIG.xml#LAMBE">NTF Lambert II étendu</gmx:Anchor></gmd:code><gmd:codeSpace><gco:CharacterString>urn:ogc:def:crs:IGNF:1.1</gco:CharacterString></gmd:codeSpace></gmd:RS_Identifier></gmd:referenceSystemIdentifier></gmd:MD_ReferenceSystem></gmd:referenceSystemInfo><gmd:identificationInfo><gmd:MD_DataIdentification><gmd:citation><gmd:CI_Citation><gmd:title><gco:CharacterString>0145-0051</gco:CharacterString></gmd:title><gmd:date><gmd:CI_Date><gmd:date><gco:Date>1980</gco:Date></gmd:date><gmd:dateType><gmd:CI_DateTypeCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#CI_DateTypeCode" codeListValue="creation">creation</gmd:CI_DateTypeCode></gmd:dateType></gmd:CI_Date></gmd:date><gmd:edition><gco:CharacterString>1.0</gco:CharacterString></gmd:edition><gmd:identifier><gmd:MD_Identifier id="IGNF_PVA_1-0__1980__X0145-0051.identifier"><gmd:code><gco:CharacterString>IGNF_PVA_1-0__1980__X0145-0051</gco:CharacterString></gmd:code></gmd:MD_Identifier></gmd:identifier><gmd:series><gmd:CI_Series><gmd:name><gco:CharacterString>IGNF_PVA_1-0.xml</gco:CharacterString></gmd:name><gmd:issueIdentification><gco:CharacterString>Produit</gco:CharacterString></gmd:issueIdentification></gmd:CI_Series></gmd:series></gmd:CI_Citation></gmd:citation><gmd:abstract><gco:CharacterString>Prise de vues aériennes</gco:CharacterString></gmd:abstract><gmd:pointOfContact><gmd:CI_ResponsibleParty><gmd:organisationName><gco:CharacterString>Institut Géographique National - France (IGN-F)</gco:CharacterString></gmd:organisationName><gmd:positionName><gco:CharacterString>dépot légal</gco:CharacterString></gmd:positionName><gmd:contactInfo><gmd:CI_Contact><gmd:address><gmd:CI_Address><gmd:electronicMailAddress><gco:CharacterString>sav-bd@ign.fr</gco:CharacterString></gmd:electronicMailAddress></gmd:CI_Address></gmd:address></gmd:CI_Contact></gmd:contactInfo><gmd:role><gmd:CI_RoleCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#CI_RoleCode" codeListValue="custodian">custodian</gmd:CI_RoleCode></gmd:role></gmd:CI_ResponsibleParty></gmd:pointOfContact><gmd:resourceMaintenance><gmd:MD_MaintenanceInformation id="IGNF_PVA_1-0.xml.resourceMaintenance_1"><gmd:maintenanceAndUpdateFrequency><gmd:MD_MaintenanceFrequencyCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#MD_MaintenanceFrequencyCode" codeListValue="irregular">irregular</gmd:MD_MaintenanceFrequencyCode></gmd:maintenanceAndUpdateFrequency><gmd:maintenanceNote><gco:CharacterString>La couverture du territoire s\'étend sur plusieurs années. Les dernières prises de vues ont couverte le territoire en 5 ans.</gco:CharacterString></gmd:maintenanceNote></gmd:MD_MaintenanceInformation></gmd:resourceMaintenance><gmd:resourceFormat><gmd:MD_Format id="IGNF_PVA_1-0.xml.resourceFormat.JP2"><gmd:name><gco:CharacterString>JPEG 2000</gco:CharacterString></gmd:name><gmd:version><gco:CharacterString>ISO/CEI 15444-1</gco:CharacterString></gmd:version></gmd:MD_Format></gmd:resourceFormat><gmd:descriptiveKeywords><gmd:MD_Keywords><gmd:keyword><gco:CharacterString>ISO 19139 ; IGN-F</gco:CharacterString></gmd:keyword><gmd:keyword><gco:CharacterString>PVA</gco:CharacterString></gmd:keyword><gmd:keyword><gco:CharacterString>PHOTOGRAPHIE AERIENNE</gco:CharacterString></gmd:keyword><gmd:keyword><gco:CharacterString>PRISE DE VUE AERIENNE</gco:CharacterString></gmd:keyword><gmd:type><gmd:MD_KeywordTypeCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#MD_KeywordTypeCode" codeListValue="theme">theme</gmd:MD_KeywordTypeCode></gmd:type></gmd:MD_Keywords></gmd:descriptiveKeywords><gmd:descriptiveKeywords><gmd:MD_Keywords id="IGNF_PVA_1-0__1980__X0145-0051.descriptiveKeywords.INSPIRE"><gmd:keyword><gco:CharacterString>photographie aérienne</gco:CharacterString></gmd:keyword><gmd:keyword><gco:CharacterString>couverture spatiale (SIG) (approx.)</gco:CharacterString></gmd:keyword><gmd:type><gmd:MD_KeywordTypeCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#MD_KeywordTypeCode" codeListValue="theme">theme</gmd:MD_KeywordTypeCode></gmd:type><gmd:thesaurusName><gmd:CI_Citation><gmd:title xsi:type="gmd:PT_FreeText_PropertyType"><gco:CharacterString>Thésaurus GEMET</gco:CharacterString><gmd:PT_FreeText><gmd:textGroup><gmd:LocalisedCharacterString locale="#locale-eng">GEMET Thesaurus</gmd:LocalisedCharacterString></gmd:textGroup></gmd:PT_FreeText></gmd:title><gmd:date><gmd:CI_Date><gmd:date><gco:Date>2007-10-17</gco:Date></gmd:date><gmd:dateType><gmd:CI_DateTypeCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#CI_DateTypeCode" codeListValue="creation">creation</gmd:CI_DateTypeCode></gmd:dateType></gmd:CI_Date></gmd:date><gmd:edition><gco:CharacterString>1.0</gco:CharacterString></gmd:edition></gmd:CI_Citation></gmd:thesaurusName></gmd:MD_Keywords></gmd:descriptiveKeywords><gmd:resourceSpecificUsage><gmd:MD_Usage id="IGNF_PVA_1-0.xml.resourceSpecificUsage_1"><gmd:specificUsage><gco:CharacterString>Echelles d\'affichage</gco:CharacterString></gmd:specificUsage><gmd:userDeterminedLimitations><gco:CharacterString>Dépend de l\'échelle ou de la résolution de la prise de vue.</gco:CharacterString></gmd:userDeterminedLimitations><gmd:userContactInfo><gmd:CI_ResponsibleParty><gmd:organisationName><gco:CharacterString>IGN-F</gco:CharacterString></gmd:organisationName><gmd:positionName><gco:CharacterString>dépot légal</gco:CharacterString></gmd:positionName><gmd:contactInfo><gmd:CI_Contact><gmd:address><gmd:CI_Address><gmd:electronicMailAddress><gco:CharacterString>sav-bd@ign.fr</gco:CharacterString></gmd:electronicMailAddress></gmd:CI_Address></gmd:address></gmd:CI_Contact></gmd:contactInfo><gmd:role><gmd:CI_RoleCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#CI_RoleCode" codeListValue="custodian">custodian</gmd:CI_RoleCode></gmd:role></gmd:CI_ResponsibleParty></gmd:userContactInfo></gmd:MD_Usage></gmd:resourceSpecificUsage><gmd:resourceConstraints><gmd:MD_SecurityConstraints><gmd:useLimitation><gco:CharacterString>Présence de zones sensibles</gco:CharacterString></gmd:useLimitation><gmd:classification><gmd:MD_ClassificationCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#MD_ClassificationCode" codeListValue="restricted">restricted</gmd:MD_ClassificationCode></gmd:classification></gmd:MD_SecurityConstraints></gmd:resourceConstraints><gmd:spatialRepresentationType><gmd:MD_SpatialRepresentationTypeCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#MD_SpatialRepresentationTypeCode" codeListValue="vector">vector</gmd:MD_SpatialRepresentationTypeCode></gmd:spatialRepresentationType><gmd:spatialResolution><gmd:MD_Resolution><gmd:equivalentScale><gmd:MD_RepresentativeFraction id="IGNF_PVA_1-0__1980__X0145-0051.spatialResolution_1"><gmd:denominator><gco:Integer>14500</gco:Integer></gmd:denominator></gmd:MD_RepresentativeFraction></gmd:equivalentScale></gmd:MD_Resolution></gmd:spatialResolution><gmd:language><gmd:LanguageCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#LanguageCode" codeListValue="fre">fre</gmd:LanguageCode></gmd:language><gmd:characterSet><gmd:MD_CharacterSetCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#MD_CharacterSetCode" codeListValue="utf8">utf8</gmd:MD_CharacterSetCode></gmd:characterSet><gmd:topicCategory><gmd:MD_TopicCategoryCode>imageryBaseMapsEarthCover</gmd:MD_TopicCategoryCode></gmd:topicCategory><gmd:extent><gmd:EX_Extent><gmd:description><gco:CharacterString>F 1-8-3 IFN 53</gco:CharacterString></gmd:description><gmd:geographicElement><gmd:EX_GeographicBoundingBox><gmd:westBoundLongitude><gco:Decimal>-1.15904477976042</gco:Decimal></gmd:westBoundLongitude><gmd:eastBoundLongitude><gco:Decimal>-0.637435511516389</gco:Decimal></gmd:eastBoundLongitude><gmd:southBoundLatitude><gco:Decimal>48.179533801239</gco:Decimal></gmd:southBoundLatitude><gmd:northBoundLatitude><gco:Decimal>48.385938667755</gco:Decimal></gmd:northBoundLatitude></gmd:EX_GeographicBoundingBox></gmd:geographicElement><gmd:geographicElement><gmd:EX_BoundingPolygon><gmd:polygon><gml:MultiSurface gml:id="polygon.IGNF_PVA_1-0__1980__X0145-0051" srsName="http://librairies.ign.fr/geoportail/resources/RIG.xml#xpointer(//*[@gml:id=\'LAMBE\'])"><gml:surfaceMember><gml:Surface gml:id="s.IGNF_PVA_1-0__1980__X0145-0051.1"><gml:patches><gml:PolygonPatch><gml:exterior><gml:Ring><gml:curveMember><gml:Curve gml:id="c.IGNF_PVA_1-0__1980__X0145-0051.0"><gml:segments><gml:LineStringSegment><gml:posList>346567.07 2380486.53 348283.11 2380471.02 348281.50 2380327.10 348964.34 2380319.06 348964.35 2380345.73 350680.05 2380344.29 352406.30 2380346.15 352406.03 2380319.85 353614.30 2380318.16 353614.33 2380272.95 354529.30 2380268.93 354529.51 2380346.59 356248.06 2380344.98 357978.45 2380348.28 357978.28 2380320.86 359256.09 2380320.93 359255.83 2380291.46 360181.11 2380283.80 360181.09 2380301.03 361537.62 2380283.09 361537.63 2380285.33 363073.10 2380302.27 363072.62 2380438.46 364373.22 2380444.84 364373.20 2380460.95 366101.12 2380469.58 366518.91 2380470.05 367571.15 2380475.26 369312.11 2380457.88 369311.43 2380380.99 370794.84 2380394.53 370795.11 2380328.31 371877.05 2380302.43 373606.55 2380308.38 373606.93 2380270.23 375030.93 2380276.71 375031.12 2380264.54 376545.17 2380264.90 376545.37 2380211.07 377495.15 2380215.04 379248.83 2380211.52 379279.27 2378457.74 379240.79 2376701.89 378448.17 2376692.11 378423.60 2375726.04 378419.62 2375363.32 379385.06 2375356.45 379355.79 2373584.28 379346.15 2372963.81 379478.74 2372965.78 379457.44 2371234.56 379463.66 2370214.79 379651.74 2370214.63 379659.32 2368490.73 379625.86 2366760.92 378734.96 2366764.55 378718.42 2365919.03 378702.86 2364203.19 378448.51 2364204.76 378437.94 2363500.93 378412.58 2362580.73 379115.96 2362572.75 379094.48 2360879.42 379079.28 2359183.45 377575.38 2359192.78 377575.44 2359166.01 375867.29 2359191.96 374152.21 2359198.92 374152.67 2359264.20 373589.23 2359263.14 373588.00 2359197.89 372180.06 2359214.19 372179.96 2359155.86 370444.99 2359182.58 368726.32 2359212.12 368728.79 2359399.77 368028.86 2359412.33 368028.82 2359409.45 366313.19 2359433.65 364589.19 2359441.11 364590.47 2359527.49 363629.13 2359544.74 362631.94 2359551.86 362631.05 2359498.06 360908.26 2359536.12 359960.60 2359563.40 359959.92 2359502.10 358276.65 2359533.51 356619.28 2359566.66 356619.43 2359634.94 355695.75 2359645.66 354150.94 2359667.07 353220.08 2359665.75 353219.52 2359598.75 351864.29 2359613.66 351862.47 2359511.61 350186.94 2359512.21 349340.64 2359514.35 349339.93 2359472.71 347640.01 2359465.53 345912.36 2359484.36 345914.00 2359537.53 344380.75 2359557.19 344381.51 2359581.80 343098.38 2359602.18 343151.50 2361320.51 343168.65 2362364.35 341782.51 2362370.80 341790.27 2364053.84 341802.87 2364730.44 341719.22 2364729.77 341686.31 2364730.43 341246.61 2364726.11 341246.82 2364739.19 340042.00 2364763.23 340025.21 2366440.92 340048.60 2368143.10 340705.61 2368140.04 340726.38 2368995.94 340728.00 2370722.15 342266.77 2370710.99 342261.70 2371365.49 342243.47 2373123.59 342645.74 2373121.52 342657.55 2373875.93 342656.24 2375682.24 344462.10 2375647.98 345261.28 2375624.70 345261.36 2375636.68 345850.91 2375618.37 345855.33 2376048.12 345873.94 2376997.22 344763.62 2376972.16 344803.44 2378765.17 344833.16 2380499.03 346567.07 2380486.53 346567.07 2380486.53</gml:posList></gml:LineStringSegment></gml:segments></gml:Curve></gml:curveMember></gml:Ring></gml:exterior></gml:PolygonPatch></gml:patches></gml:Surface></gml:surfaceMember></gml:MultiSurface></gmd:polygon></gmd:EX_BoundingPolygon></gmd:geographicElement><gmd:temporalElement><gmd:EX_TemporalExtent><gmd:extent><gml:TimePeriod gml:id="extent.1980"><gml:beginPosition>1980-08-20T00:00:00Z</gml:beginPosition><gml:endPosition>1980-09-02T00:00:00Z</gml:endPosition></gml:TimePeriod></gmd:extent></gmd:EX_TemporalExtent></gmd:temporalElement></gmd:EX_Extent></gmd:extent><gmd:supplementalInformation><gco:CharacterString>Format des clichés : 230x230 (mm x mm)</gco:CharacterString></gmd:supplementalInformation></gmd:MD_DataIdentification></gmd:identificationInfo><gmd:contentInfo><gmd:MD_ImageDescription><gmd:attributeDescription gco:nilReason="inapplicable"><gco:RecordType/></gmd:attributeDescription><gmd:contentType><gmd:MD_CoverageContentTypeCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#MD_CoverageContentTypeCode" codeListValue="image">image</gmd:MD_CoverageContentTypeCode></gmd:contentType><gmd:dimension><gmd:MD_Band><gmd:sequenceIdentifier><gco:MemberName><gco:aName><gco:CharacterString>Gris</gco:CharacterString></gco:aName><gco:attributeType><gco:TypeName><gco:aName><gco:CharacterString>Number_PropertyType</gco:CharacterString></gco:aName></gco:TypeName></gco:attributeType></gco:MemberName></gmd:sequenceIdentifier><gmd:bitsPerValue><gco:Integer>8</gco:Integer></gmd:bitsPerValue></gmd:MD_Band></gmd:dimension><gmd:triangulationIndicator><gco:Boolean>false</gco:Boolean></gmd:triangulationIndicator><gmd:radiometricCalibrationDataAvailability><gco:Boolean>false</gco:Boolean></gmd:radiometricCalibrationDataAvailability><gmd:cameraCalibrationInformationAvailability><gco:Boolean>false</gco:Boolean></gmd:cameraCalibrationInformationAvailability><gmd:filmDistortionInformationAvailability><gco:Boolean>false</gco:Boolean></gmd:filmDistortionInformationAvailability><gmd:lensDistortionInformationAvailability><gco:Boolean>false</gco:Boolean></gmd:lensDistortionInformationAvailability></gmd:MD_ImageDescription></gmd:contentInfo><gmd:distributionInfo><gmd:MD_Distribution><gmd:distributionFormat><gmd:MD_Format id="IGNF_PVA_1-0.xml.distributionFormat.SHAPEFILE"><gmd:name><gco:CharacterString>SHAPEFILE</gco:CharacterString></gmd:name><gmd:version><gco:CharacterString>1.0</gco:CharacterString></gmd:version><gmd:formatDistributor><gmd:MD_Distributor><gmd:distributorContact><gmd:CI_ResponsibleParty><gmd:organisationName><gco:CharacterString>ESRI</gco:CharacterString></gmd:organisationName><gmd:contactInfo><gmd:CI_Contact><gmd:onlineResource><gmd:CI_OnlineResource><gmd:linkage><gmd:URL>http://www.esri.com/</gmd:URL></gmd:linkage><gmd:protocol><gco:CharacterString>HTTP</gco:CharacterString></gmd:protocol></gmd:CI_OnlineResource></gmd:onlineResource></gmd:CI_Contact></gmd:contactInfo><gmd:role><gmd:CI_RoleCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#CI_RoleCode" codeListValue="originator">originator</gmd:CI_RoleCode></gmd:role></gmd:CI_ResponsibleParty></gmd:distributorContact></gmd:MD_Distributor></gmd:formatDistributor></gmd:MD_Format></gmd:distributionFormat><gmd:distributionFormat><gmd:MD_Format id="IGNF_PVA_1-0.xml.distributionFormat.JP2"><gmd:name><gco:CharacterString>JPEG 2000</gco:CharacterString></gmd:name><gmd:version><gco:CharacterString>ISO/CEI 15444-1</gco:CharacterString></gmd:version><gmd:formatDistributor><gmd:MD_Distributor><gmd:distributorContact><gmd:CI_ResponsibleParty><gmd:organisationName><gco:CharacterString>Joint Photographic Experts Group</gco:CharacterString></gmd:organisationName><gmd:contactInfo><gmd:CI_Contact><gmd:onlineResource><gmd:CI_OnlineResource><gmd:linkage><gmd:URL>http://www.jpeg.org/jpeg2000/</gmd:URL></gmd:linkage><gmd:protocol><gco:CharacterString>HTTP</gco:CharacterString></gmd:protocol></gmd:CI_OnlineResource></gmd:onlineResource></gmd:CI_Contact></gmd:contactInfo><gmd:role><gmd:CI_RoleCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#CI_RoleCode" codeListValue="originator">originator</gmd:CI_RoleCode></gmd:role></gmd:CI_ResponsibleParty></gmd:distributorContact></gmd:MD_Distributor></gmd:formatDistributor></gmd:MD_Format></gmd:distributionFormat><gmd:distributor><gmd:MD_Distributor><gmd:distributorContact><gmd:CI_ResponsibleParty><gmd:organisationName><gco:CharacterString>IGN-F</gco:CharacterString></gmd:organisationName><gmd:contactInfo><gmd:CI_Contact><gmd:address><gmd:CI_Address><gmd:electronicMailAddress><gco:CharacterString>sav-bd@ign.fr</gco:CharacterString></gmd:electronicMailAddress></gmd:CI_Address></gmd:address></gmd:CI_Contact></gmd:contactInfo><gmd:role><gmd:CI_RoleCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#CI_RoleCode" codeListValue="distributor">distributor</gmd:CI_RoleCode></gmd:role></gmd:CI_ResponsibleParty></gmd:distributorContact></gmd:MD_Distributor></gmd:distributor><gmd:transferOptions><gmd:MD_DigitalTransferOptions><gmd:unitsOfDistribution><gco:CharacterString>cliché</gco:CharacterString></gmd:unitsOfDistribution><gmd:transferSize><gco:Real>5</gco:Real></gmd:transferSize><gmd:onLine><gmd:CI_OnlineResource><gmd:linkage><gmd:URL>http://www.geoportail.fr/</gmd:URL></gmd:linkage><gmd:function><gmd:CI_OnLineFunctionCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#CI_OnLineFunctionCode" codeListValue="information">information</gmd:CI_OnLineFunctionCode></gmd:function></gmd:CI_OnlineResource></gmd:onLine><gmd:onLine><gmd:CI_OnlineResource><gmd:linkage><gmd:URL>http://www.ign.fr/</gmd:URL></gmd:linkage><gmd:function><gmd:CI_OnLineFunctionCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#CI_OnLineFunctionCode" codeListValue="information">information</gmd:CI_OnLineFunctionCode></gmd:function></gmd:CI_OnlineResource></gmd:onLine><gmd:offLine><gmd:MD_Medium><gmd:name><gmd:MD_MediumNameCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#MD_MediumNameCode" codeListValue="cdRom">cdRom</gmd:MD_MediumNameCode></gmd:name><gmd:mediumFormat><gmd:MD_MediumFormatCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#MD_MediumFormatCode" codeListValue="iso9660">iso9660</gmd:MD_MediumFormatCode></gmd:mediumFormat><gmd:mediumNote><gco:CharacterString>Image compressée, gravée sur support au guichet uniquement.</gco:CharacterString></gmd:mediumNote></gmd:MD_Medium></gmd:offLine></gmd:MD_DigitalTransferOptions></gmd:transferOptions></gmd:MD_Distribution></gmd:distributionInfo><gmd:dataQualityInfo><gmd:DQ_DataQuality><gmd:scope><gmd:DQ_Scope><gmd:level><gmd:MD_ScopeCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#MD_ScopeCode" codeListValue="dataset">dataset</gmd:MD_ScopeCode></gmd:level></gmd:DQ_Scope></gmd:scope><gmd:lineage><gmd:LI_Lineage><gmd:statement xsi:type="gmd:PT_FreeText_PropertyType"><gco:CharacterString>Produit par l\'Institut Géographique National</gco:CharacterString><gmd:PT_FreeText><gmd:textGroup><gmd:LocalisedCharacterString locale="#locale-eng">Produced by National Mapping Agency - France</gmd:LocalisedCharacterString></gmd:textGroup></gmd:PT_FreeText></gmd:statement></gmd:LI_Lineage></gmd:lineage></gmd:DQ_DataQuality></gmd:dataQualityInfo><gmd:metadataConstraints><gmd:MD_SecurityConstraints><gmd:useLimitation xsi:type="gmd:PT_FreeText_PropertyType"><gco:CharacterString>Aucune contrainte</gco:CharacterString><gmd:PT_FreeText><gmd:textGroup><gmd:LocalisedCharacterString locale="#locale-eng">no conditions apply</gmd:LocalisedCharacterString></gmd:textGroup></gmd:PT_FreeText></gmd:useLimitation><gmd:classification><gmd:MD_ClassificationCode codeList="http://librairies.ign.fr/geoportail/resources/Codelists.xml#MD_ClassificationCode" codeListValue="unclassified">unclassified</gmd:MD_ClassificationCode></gmd:classification></gmd:MD_SecurityConstraints></gmd:metadataConstraints></gmd:MD_Metadata></csw:GetRecordByIdResponse>';

my $sample_wfs =
'<?xml version="1.0" encoding="UTF-8"?><wfs:FeatureCollection xmlns="http://www.opengis.net/wfs" xmlns:wfs="http://www.opengis.net/wfs" xmlns:sde="http://openplans.org/topp" xmlns:gml="http://www.opengis.net/gml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://openplans.org/topp http://qlf-gpp3-wxs-ign-fr.aw.atosorigin.com:80/geoserver/sde/wfs?service=WFS&amp;version=1.0.0&amp;request=DescribeFeatureType&amp;typeName=sde%3Acommune http://www.opengis.net/wfs http://qlf-gpp3-wxs-ign-fr.aw.atosorigin.com:80/geoserver/schemas/wfs/1.0.0/WFS-basic.xsd"><gml:boundedBy><gml:null>unknown</gml:null></gml:boundedBy><gml:featureMember><sde:commune fid="commune.36204"><sde:id>SURFCOMM0000000013681971</sde:id><sde:prec_plani>30.0</sde:prec_plani><sde:nom>Montreuil</sde:nom><sde:code_insee>93048</sde:code_insee><sde:statut>Chef-lieu de canton</sde:statut><sde:canton>MONTREUIL</sde:canton><sde:arrondisst>BOBIGNY</sde:arrondisst><sde:depart>SEINE-SAINT-DENIS</sde:depart><sde:region>ILE-DE-FRANCE</sde:region><sde:popul>102097</sde:popul><sde:multican>Oui</sde:multican><sde:the_geom><gml:MultiPolygon srsName="http://www.opengis.net/gml/srs/epsg.xml#4326"><gml:polygonMember><gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:coordinates xmlns:gml="http://www.opengis.net/gml" decimal="." cs="," ts=" ">2.416345,48.849239 2.416379,48.849234 2.416697,48.84924 2.417607,48.849286 2.416345,48.849239</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon></gml:polygonMember></gml:MultiPolygon></sde:the_geom></sde:commune></gml:featureMember><gml:featureMember><sde:commune fid="commune.33205"><sde:id>SURFCOMM0000000013681975</sde:id><sde:prec_plani>30.0</sde:prec_plani><sde:nom>Bagnolet</sde:nom><sde:code_insee>93006</sde:code_insee><sde:statut>Chef-lieu de canton</sde:statut><sde:canton>BAGNOLET</sde:canton><sde:arrondisst>BOBIGNY</sde:arrondisst><sde:depart>SEINE-SAINT-DENIS</sde:depart><sde:region>ILE-DE-FRANCE</sde:region><sde:popul>34269</sde:popul><sde:multican>Non</sde:multican><sde:the_geom><gml:MultiPolygon srsName="http://www.opengis.net/gml/srs/epsg.xml#4326"><gml:polygonMember><gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:coordinates xmlns:gml="http://www.opengis.net/gml" decimal="." cs="," ts=" ">2.413431,48.87314 2.413646,48.872438 2.414412,48.873933 2.413768,48.873411 2.413431,48.87314</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon></gml:polygonMember></gml:MultiPolygon></sde:the_geom></sde:commune></gml:featureMember><gml:featureMember><sde:commune fid="commune.35947"><sde:id>SURFCOMM0000000054741427</sde:id><sde:prec_plani>30.0</sde:prec_plani><sde:nom>Paris</sde:nom><sde:code_insee>75056</sde:code_insee><sde:statut>Capitale d\'Etat</sde:statut><sde:canton>PARIS</sde:canton><sde:arrondisst>PARIS</sde:arrondisst><sde:depart>PARIS</sde:depart><sde:region>ILE-DE-FRANCE</sde:region><sde:popul>2193030</sde:popul><sde:multican>Oui</sde:multican><sde:the_geom><gml:MultiPolygon srsName="http://www.opengis.net/gml/srs/epsg.xml#4326"><gml:polygonMember><gml:Polygon><gml:outerBoundaryIs><gml:LinearRing><gml:coordinates xmlns:gml="http://www.opengis.net/gml" decimal="." cs="," ts=" ">2.224217,48.853738 2.224219,48.853517 2.224407,48.856154 2.224315,48.855696 2.224242,48.854203 2.224217,48.853738</gml:coordinates></gml:LinearRing></gml:outerBoundaryIs></gml:Polygon></gml:polygonMember></gml:MultiPolygon></sde:the_geom></sde:commune></gml:featureMember></wfs:FeatureCollection>';

my $sample_shp = 'PK^C^D\r\n^@^@^@^@^@<bb>Eg@#^R<a9>P^H^@^@^@^H^@^@^@^K^@^\^@COMMUNE.cstUT  ^@^C1^RWO1^RWOux^K^@^A^D<e8>^C^@^@^D<e8>^C^@^@mon shp\r\nPK^C^D\r\n^@^@^@^@^@<95>Eg@#^R<a9>P^H^@^@^@^H^@^@^@^K^@^\^@COMMUNE.dbfUT  ^@^C<e9>^QWO<e9>^QWOux^K^@^A^D<e8>^C^@^@^D<e8>^C^@^@mon shp\r\nPK^C^D\r\n^@^@^@^@^@<9d>Eg@#^R<a9>P^H^@^@^@^H^@^@^@^K^@^\^@COMMUNE.prjUT  ^@^C<f9>^QWO<f9>^QWOux^K^@^A^D<e8>^C^@^@^D<e8>^C^@^@mon shp\r\nPK^C^D\r\n^@^@^@^@^@<91>Eg@#^R<a9>P^H^@^@^@^H^@^@^@^K^@^\^@COMMUNE.shpUT  ^@^C<e1>^QWO<e6>^QWOux^K^@^A^D<e8>^C^@^@^D<e8>^C^@^@mon shp\r\nPK^C^D\r\n^@^@^@^@^@<93>Eg@#^R<a9>P^H^@^@^@^H^@^@^@^K^@^\^@COMMUNE.shxUT  ^@^C<e6>^QWO<e6>^QWOux^K^@^A^D<e8>^C^@^@^D<e8>^C^@^@mon shp\r\nPK^C^D\r\n^@^@^@^@^@<b9>Eg@#^R<a9>P^H^@^@^@^H^@^@^@^K^@^\^@COMMUNE.txtUT  ^@^C.^RWO.^RWOux^K^@^A^D<e8>^C^@^@^D<e8>^C^@^@mon shp\r\nPK^A^B^^^C\r\n^@^@^@^@^@<bb>Eg@#^R<a9>P^H^@^@^@^H^@^@^@^K^@^X^@^@^@^@^@^A^@^@^@<a4><81>^@^@^@^@COMMUNE.cstUT^E^@^C1^RWOux^K^@^A^D<e8>^C^@^@^D<e8>^C^@^@PK^A^B^^^C\r\n^@^@^@^@^@<95>Eg@#^R<a9>P^H^@^@^@^H^@^@^@^K^@^X^@^@^@^@^@^A^@^@^@<a4><81>M^@^@^@COMMUNE.dbfUT^E^@^C<e9>^QWOux^K^@^A^D<e8>^C^@^@^D<e8>^C^@^@PK^A^B^^^C\r\n^@^@^@^@^@<9d>Eg@#^R<a9>P^H^@^@^@^H^@^@^@^K^@^X^@^@^@^@^@^A^@^@^@<a4><81><9a>^@^@^@COMMUNE.prjUT^E^@^C<f9>^QWOux^K^@^A^D<e8>^C^@^@^D<e8>^C^@^@PK^A^B^^^C\r\n^@^@^@^@^@<91>Eg@#^R<a9>P^H^@^@^@^H^@^@^@^K^@^X^@^@^@^@^@^A^@^@^@<a4><81><e7>^@^@^@COMMUNE.shpUT^E^@^C<e1>^QWOux^K^@^A^D<e8>^C^@^@^D<e8>^C^@^@PK^A^B^^^C\r\n^@^@^@^@^@<93>Eg@#^R<a9>P^H^@^@^@^H^@^@^@^K^@^X^@^@^@^@^@^A^@^@^@<a4><81>4^A^@^@COMMUNE.shxUT^E^@^C<e6>^QWOux^K^@^A^D<e8>^C^@^@^D<e8>^C^@^@PK^A^B^^^C\r\n^@^@^@^@^@<b9>Eg@#^R<a9>P^H^@^@^@^H^@^@^@^K^@^X^@^@^@^@^@^A^@^@^@<a4><81><81>^A^@^@COMMUNE.txtUT^E^@^C.^RWOux^K^@^A^D<e8>^C^@^@^D<e8>^C^@^@PK^E^F^@^@^@^@^F^@^F^@<e6>^A^@^@<ce>^A^@^@^@^@';

my $sample_wms =
  'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA';

  
#Le retour d'appel simulé par un mock spécifique à chaque test
my $mock_global = Test::MockObject->new();
$mock_global->fake_module( 'LWP::UserAgent',
    request => sub { return HTTP::Response->new() } );

	
ok( extraction_boutique() == 255, "testWithoutParameters" );


{
    my $mock = Test::MockObject->new();
    $mock->fake_module(
        'HTTP::Response',
        is_success      => sub { return 0; },
        decoded_content => sub { return ''; }
    );
    ok( extraction_boutique("-1") == 1, "testWithBadExtractionId" );
}


{
    my $mock = Test::MockObject->new();
    $mock->fake_module(
        'HTTP::Response',
        is_success      => sub { return 0; },
        decoded_content => sub { return ''; }
    );
    ok( extraction_boutique("22") == 1, "testWithUnreachableService" );
}


{
    my $mock = Test::MockObject->new();
    $mock->fake_module(
        'HTTP::Response',
        is_success      => sub { return 1; },
        decoded_content => sub {
            return
'{"priority":1,"extractionsWMS":[{"bboxes":[{"name":"1245012_12401401","id":909,"points":"0.0,45.0,1.0,46.0"},{"name":"1245013_12401402","id":910,"points":"0.0,46.0,0.0,47.0"}],"imageWidth":500,"imageHeight":500,"context":"geoportail","style":"","id":10,"layerName":"sde:commune","dataFolder":"","themeFolder":"mythemeFolder","outputCrs":"EPSG:4326","outputFormat":"jpeg","service":"WMS","idsMetadatasInspireToRequest":[],"idsMetadatasIsoApToRequest":["IGNF_PVA_1-0__1980__X0145-0051.xml","IGNF_PVA_1-0__1980__X0145-0051.xml"]}],"purchaseId":"2012-07-00001e","zipName":"extraction_boutique_0001e","downLoadFolder":"downLoadFolder","zipMaxSize":300,"rootFolder":"MON_REPERTOIRE","productId":"BDORTHO","geographicIdentifier":"77","isPrepackaged":null,"id":908,"parameters":[],"status":null,"jenkinsBuild":null,"creationDate":1319547210850,"broadcastDatas":[{"id":"007","storage":{"logicalName" : "tmp"}}]}';
        }
    );
    ok( extraction_boutique("908") == 253, "testWithLackOfMandatoryFolder" );
}


{
    my $mock = Test::MockObject->new();
    $mock->fake_module(
        'HTTP::Response',
        is_success      => sub { return 1; },
        decoded_content => sub {
            return
'{"managerId":"cleok","priority":1,"extractionsWMS":[{"bboxes":[{"name":"1245012_12401401","id":909,"points":"0.0,45.0,1.0,46.0"},{"name":"1245013_12401402","id":910,"points":"0.0,46.0,0.0,47.0"}],"imageWidth":500,"imageHeight":500,"context":"geoportail","style":"","id":10,"layerName":"sde:commune","dataFolder":"","themeFolder":"mythemeFolder","outputCrs":"EPSG:4326","outputFormat":"jpeg","service":"WMS","idsMetadatasInspireToRequest":[],"idsMetadatasIsoApToRequest":["IGNF_PVA_1-0__1980__X0145-0051.xml","IGNF_PVA_1-0__1980__X0145-0051.xml"]}],"purchaseId":"2012-07-00001e","zipName":"extraction_boutique_0001e","downLoadFolder":"downLoadFolder","zipMaxSize":300,"rootFolder":"MON_REPERTOIRE","productId":"BDORTHO","packagingId":"CONDITIONNEMENT_EXTRACTION_BOUTIQUE","geographicIdentifier":"77","isPrepackaged":null,"id":908,"parameters":[],"status":null,"jenkinsBuild":null,"creationDate":1319547210850,"broadcastDatas":[{"id":"007","storage":{"logicalName" : "tmp"}}]}';
        }
    );
    ok( extraction_boutique("908") == 3,      "testWithLackOfMandatoryFolderInExtraction"   );
}


{
    my $mock = Test::MockObject->new();
    $mock->fake_module(
        'HTTP::Response',
        is_success      => sub { return 1; },
        decoded_content => sub {
            return
'{"managerId":"cleok","priority":1,"extractionsWMS":[{"bboxes":[{"name":"1245012_12401401","id":909,"points":"0.0,45.0,1.0,46.0"},{"name":"1245013_12401402","id":910,"points":"0.0,46.0,0.0,47.0"}],"imageWidth":500,"imageHeight":500,"context":"geoportail","style":"","id":10,"layerName":"sde:commune","dataFolder":"","themeFolder":"mythemeFolder","outputCrs":"EPSG:4326","outputFormat":"jpeg","service":"WMS","idsMetadatasInspireToRequest":[],"idsMetadatasIsoApToRequest":["IGNF_PVA_1-0__1980__X0145-0051.xml","IGNF_PVA_1-0__1980__X0145-0051.xml"]}],"purchaseId":"2012-07-00001e","zipName":"extraction_boutique_0001e","downLoadFolder":"downLoadFolder","zipMaxSize":300,"productId":"BDORTHO","packagingId":"CONDITIONNEMENT_EXTRACTION_BOUTIQUE","geographicIdentifier":"77","isPrepackaged":null,"id":908,"parameters":[],"status":null,"jenkinsBuild":null,"creationDate":1319547210850,"broadcastDatas":[{"id":"007","storage":{"logicalName" : "tmp"}}]}';
        }
    );
    ok( extraction_boutique("908") == 253,        "testWithLackOfMandatoryRootFolder" );
}


{
    my $mock = Test::MockObject->new();
    $mock->fake_module(
        'HTTP::Response',
        is_success      => sub { return 1; },
        decoded_content => sub {
            return
'{"managerId":"cleok","priority":1,"extractionsWMS":[{"bboxes":[{"name":"1245012_12401401","id":909,"points":"0.0,45.0,1.0,46.0"},{"name":"1245013_12401402","id":910,"points":"0.0,46.0,0.0,47.0"}],"imageWidth":500,"imageHeight":500,"context":"geoportail","style":"","id":10,"layerName":"sde:commune","dataFolder":"","themeFolder":"mythemeFolder","outputCrs":"EPSG:4326","outputFormat":"jpeg","service":"WMS","idsMetadatasInspireToRequest":[],"idsMetadatasIsoApToRequest":["IGNF_PVA_1-0__1980__X0145-0051.xml","IGNF_PVA_1-0__1980__X0145-0051.xml"]}],"purchaseId":"2012-07-00001e","zipName":"extraction_boutique_0001e","downLoadFolder":"downLoadFolder","zipMaxSize":300,"rootFolder":"MON_REPERTOIRE","productId":"BDORTHO","packagingId":"CONDITIONNEMENT_EXTRACTION_BOUTIQUE","geographicIdentifier":"77","isPrepackaged":null,"id":908,"parameters":[],"status":null,"jenkinsBuild":null,"creationDate":1319547210850,"broadcastDatas":[{"id":"007"}]}';
        }
    );
    ok( extraction_boutique("908") == 253, "testWithNoStorage" );
}


{
    my $mock = Test::MockObject->new();
    $mock->fake_module(
        'HTTP::Response',
        is_success      => sub { return 1; },
        decoded_content => sub {
            return
'{"managerId":"cleok","priority":1,"extractionsWMS":[{"bboxes":[{"name":"1245012_12401401","id":909,"points":"0.0,45.0,1.0,46.0"},{"name":"1245013_12401402","id":910,"points":"0.0,46.0,0.0,47.0"}],"imageWidth":500,"imageHeight":500,"context":"geoportail","style":"","id":10,"layerName":"sde:commune","dataFolder":"","themeFolder":"mythemeFolder","outputCrs":"EPSG:4326","outputFormat":"jpeg","service":"WMS","idsMetadatasInspireToRequest":[],"idsMetadatasIsoApToRequest":["IGNF_PVA_1-0__1980__X0145-0051.xml","IGNF_PVA_1-0__1980__X0145-0051.xml"]}],"purchaseId":"2012-07-00001e","zipName":"extraction_boutique_0001e","downLoadFolder":"downLoadFolder","zipMaxSize":300,"rootFolder":"MON_REPERTOIRE","productId":"BDORTHO","packagingId":"CONDITIONNEMENT_EXTRACTION_BOUTIQUE","geographicIdentifier":"77","isPrepackaged":null,"id":908,"parameters":[],"status":null,"jenkinsBuild":null,"creationDate":1319547210850,"broadcastDatas":[{"id":"007","storage":{}}]}';
        }
    );
    ok( extraction_boutique("908") == 253, "testWithNoLogicalNameStorage" );
}


{
	local *main::update_broadcastdata_size = sub { return 0;};
    my $mock         = Test::MockObject->new();
    $mock->fake_module(
        'HTTP::Response',
        is_success      => sub { return 1; },
        decoded_content => sub {
            return
'{"managerId":"cleok","priority":1,"extractionsWMS":[{"type":"WMSRASTER","bboxes":[{"name":"1245012_12401401","id":1488,"points":"-21.5,55,-21,55.5","projection":"EPSG:4326"},{"name":"1245013_12401402","id":1489,"points":"-21,55,-20.5,55.5"}],"imageWidth":500,"imageHeight":500,"context":"geoportail","style":"","id":265,"layerName":"ORTHO_JPEG_EPSG_4326_2008_974","dataFolder":"VERSION_FORMAT_RIG_INFO_myDataFolder","themeFolder":"mythemeFolder","outputCrs":"EPSG:4326","outputFormat":"RAST_JPEG","service":"WMS","idsMetadatasInspireToRequest":[],"idsMetadatasIsoApToRequest":["IGNF_PVA_1-0__1980__X0145-0051.xml","IGNF_PVA_1-0__1980__X0145-0051.xml"]}],"purchaseId":"2012-07-00001e","zipName":"extraction_boutique_0001e","rootFolder":"rootFolder","downLoadFolder":"downLoadFolder","zipMaxSize":300,"rootFolder":"MON_REPERTOIRE","productId":"BDORTHO","packagingId":"CONDITIONNEMENT_EXTRACTION_BOUTIQUE","extentDescription":"Zone","geographicIdentifier":"77","isPrepackaged":null,"id":1487,"parameters":[],"status":null,"jenkinsBuild":null,"creationDate":1320075966706,"broadcastDatas":[{"creationDate":null,"version":null,"broadcastProduct":null,"metadatas":[{"name":"metadata_bd1","id":812,"version":null,"validated":false},{"name":"metadata_bd2","id":813,"version":null,"validated":false},{"name":"metadata_bd3","id":814,"version":null,"validated":false},{"name":"metadata_bd4","id":815,"version":4,"validated":false}],"storage":{"logicalName" : "tmp"},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"name":"broadcastData1","id":5762}]}';
        },
        content => sub {
            return $sample_mtd;
        }
    );
	
	local *extract_wms_tile = sub { Execute->run( "cp " . $resources_path . "/extraction/image.tif " . $_[0]); return 0; };

    ok( extraction_boutique("1487") == 0, "testOkCaseWMSRaster" );
	
	Execute->run( "rm -rf " . $tmp_path . $tmp_extraction . "/1487*", "true" );
	Execute->run( "rm -rf " . $root_storage . "/tmp/5762*", "true" );
}


{
	local *main::update_broadcastdata_size = sub { return 1;};
    my $mock         = Test::MockObject->new();
    $mock->fake_module(
        'HTTP::Response',
        is_success      => sub { return 1; },
        decoded_content => sub {
            return
'{"managerId":"cleok","priority":1,"extractionsWMS":[{"type":"WMSRASTER","bboxes":[{"name":"1245012_12401401","id":1488,"points":"-21.5,55,-21,55.5","projection":"EPSG:4326"},{"name":"1245013_12401402","id":1489,"points":"-21,55,-20.5,55.5"}],"imageWidth":500,"imageHeight":500,"context":"geoportail","style":"","id":265,"layerName":"ORTHO_JPEG_EPSG_4326_2008_974","dataFolder":"VERSION_FORMAT_RIG_INFO_myDataFolder","themeFolder":"mythemeFolder","outputCrs":"EPSG:4326","outputFormat":"RAST_JPEG","service":"WMS","idsMetadatasInspireToRequest":[],"idsMetadatasIsoApToRequest":["IGNF_PVA_1-0__1980__X0145-0051.xml","IGNF_PVA_1-0__1980__X0145-0051.xml"]}],"purchaseId":"2012-07-00001e","zipName":"extraction_boutique_0001e","rootFolder":"rootFolder","downLoadFolder":"downLoadFolder","zipMaxSize":300,"rootFolder":"MON_REPERTOIRE","productId":"BDORTHO","packagingId":"CONDITIONNEMENT_EXTRACTION_BOUTIQUE","extentDescription":"Zone","geographicIdentifier":"77","isPrepackaged":null,"id":1487,"parameters":[],"status":null,"jenkinsBuild":null,"creationDate":1320075966706,"broadcastDatas":[{"creationDate":null,"version":null,"broadcastProduct":null,"metadatas":[{"name":"metadata_bd1","id":812,"version":null,"validated":false},{"name":"metadata_bd2","id":813,"version":null,"validated":false},{"name":"metadata_bd3","id":814,"version":null,"validated":false},{"name":"metadata_bd4","id":815,"version":4,"validated":false}],"storage":{"logicalName" : "tmp"},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"name":"broadcastData1","id":5762}]}';
        },
        content => sub {
            return $sample_mtd;
        }
    );
	
	local *extract_wms_tile = sub { Execute->run( "cp " . $resources_path . "/extraction/image.tif " . $_[0]); return 0; };

    ok( extraction_boutique("1487") == 7, "testErrorUpdatingBdSize" );
	
	Execute->run( "rm -rf " . $tmp_path . $tmp_extraction . "/1487*", "true" );
	Execute->run( "rm -rf " . $root_storage . "/tmp/5762*", "true" );
}



{
	local *main::update_broadcastdata_size = sub { return 0;};
    my $mocked_value = 0;
    my $mock         = Test::MockObject->new();
    $mock->fake_module(
        'HTTP::Response',
        is_success      => sub { return 1; },
        decoded_content => sub {
            return
'{"managerId":"cleok","priority":1,"extractionsWFS":[{ "extractionPolygon":{"name":"ep_12401401","id":909,"points":"<gml:Polygon srsName=\"EPSG:4326\"><gml:exterior><gml:LinearRing><gml:posList srsDimension=\"2\">2.32996166,48.90116052,250 2.33433747,48.90122362,250 2.44282885,48.84554541,250 2.44755263,48.84489403000001,250</gml:posList></gml:LinearRing></gml:exterior></gml:Polygon>","projection":"EPSG:4326"},"id":400,"layerName":"sde:commune","dataFolder":"VERSION_FORMAT_RIG_INFO_myDataFolder","context":"geoportail","themeFolder":"mythemeFolder","outputCrs":"EPSG:4326","outputFormat":"VECT_GML2","service":"WFS","idsMetadatasIsoApToRequest":["IGNF_BDPARCELLAIREr_2-2_SHP_LAMB93_13.xml","IGNF_BDPARCELLAIREr_3-2_SHP_LAMB93_13.xml"],"idsMetadatasInspireToRequest":[]}],"purchaseId":"2012-07-00001e","zipName":"extraction_boutique_0001e","downLoadFolder":"downLoadFolder","zipMaxSize":300,"rootFolder":"MON_REPERTOIRE","productId":"BDTOPO","packagingId":"CONDITIONNEMENT_EXTRACTION_BOUTIQUE","geographicIdentifier":"77","isPrepackaged":null,"id":2024,"parameters":[],"status":null,"jenkinsBuild":null,"creationDate":1320412706602,"broadcastDatas":[{"creationDate":null,"version":null,"broadcastProduct":null,"metadatas":[{"name":"metadata_bd1","id":1608,"version":null,"validated":false},{"name":"metadata_bd2","id":1609,"version":null,"validated":false},{"name":"metadata_bd3","id":1610,"version":null,"validated":false},{"name":"metadata_bd4","id":1611,"version":4,"validated":false}],"storage":{"logicalName" : "tmp"},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"name":"broadcastData1","id":8734}]}';
        },
        content => sub {
            $mocked_value = $mocked_value + 1;
            if ( $mocked_value == 1 ) {
                return $sample_wfs;
            }
            else {
                return $sample_mtd;
            }
            return '';
        }
    );

    ok( extraction_boutique("2024") == 0, "testOkCaseWFS" );
	
	Execute->run( "rm -rf " . $tmp_path . $tmp_extraction . "/2024*", "true" );
	Execute->run( "rm -rf " . $root_storage . "/tmp/8734*", "true" );
}


{
	local *main::update_broadcastdata_size = sub { return 0;};
    my $mock         = Test::MockObject->new();
    $mock->fake_module(
        'HTTP::Response',
        is_success      => sub { return 1; },
        decoded_content => sub {
            return
'{"managerId":"cleok","priority":1,"extractionsWFS":[{ "extractionPolygon":{"name":"COMMUNE","id":909,"points":"<gml:Polygon srsName=\"EPSG:4326\"><gml:exterior><gml:LinearRing><gml:posList srsDimension=\"2\">-30,0,0 -31,0,0 -31,1,0 -30,1,0 -30,0,0</gml:posList></gml:LinearRing></gml:exterior></gml:Polygon>","projection":"EPSG:4326"},"id":400,"layerName":"sde:commune","dataFolder":"VERSION_FORMAT_RIG_INFO_myDataFolder","context":"geoportail","themeFolder":"mythemeFolder","outputCrs":"EPSG:4326","outputFormat":"VECT_SHP","service":"WFS","idsMetadatasIsoApToRequest":["IGNF_BDPARCELLAIREr_2-2_SHP_LAMB93_13.xml","IGNF_BDPARCELLAIREr_3-2_SHP_LAMB93_13.xml"],"idsMetadatasInspireToRequest":[]}],"purchaseId":"2012-07-00001e","zipName":"extraction_boutique_0001e","downLoadFolder":"downLoadFolder","zipMaxSize":300,"rootFolder":"MON_REPERTOIRE","productId":"BDTOPO","packagingId":"CONDITIONNEMENT_EXTRACTION_BOUTIQUE","geographicIdentifier":"77","isPrepackaged":null,"id":3492,"parameters":[],"status":null,"jenkinsBuild":null,"creationDate":1320412706602,"broadcastDatas":[{"creationDate":null,"version":null,"broadcastProduct":null,"metadatas":[{"name":"metadata_bd1","id":1608,"version":null,"validated":false},{"name":"metadata_bd2","id":1609,"version":null,"validated":false},{"name":"metadata_bd3","id":1610,"version":null,"validated":false},{"name":"metadata_bd4","id":1611,"version":4,"validated":false}],"storage":{"logicalName" : "tmp"},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"name":"broadcastData1","id":5176}]}';
        },
        content => sub {
            return $sample_mtd;
        }
    );

	local *extract_wfs_file = sub { Execute->run( "cp -r " . $resources_path . "/extraction/COMMUNE.zip " . $_[0]); return 0; };
	
    ok( extraction_boutique("3492") == 0, "testOkCaseWFSShp" );
	
	Execute->run( "rm -rf " . $tmp_path . $tmp_extraction . "/3492*", "true" );
	Execute->run( "rm -rf " . $root_storage . "/tmp/5176*", "true" );
}


{
	local *main::update_broadcastdata_size = sub { return 0;};
    my $mock         = Test::MockObject->new();
    $mock->fake_module(
        'HTTP::Response',
        is_success      => sub { return 1; },
        decoded_content => sub {
            return
'{"managerId":"cleok","priority":1,"extractionsWMS":[{"type":"WMSVECTOR","bboxes":[{"name":"1245012_12401401","id":1488,"points":"2.3,48.5,2.4,48.9","projection":"EPSG:4326"},{"name":"1245013_12401402","id":1489,"points":"2.4,48.6,2.5,49","projection":"EPSG:4326"}],"imageWidth":500,"context":"geoportail","imageHeight":500,"style":"","id":265,"layerName":"sde:commune","dataFolder":"VERSION_FORMAT_RIG_INFO_myDataFolder","themeFolder":"mythemeFolder","outputCrs":"EPSG:4326","outputFormat":"RAST_JPEG","service":"WMS","idsMetadatasIsoApToRequest":["IGNF_PVA_1-0__1980__X0145-0051.xml","IGNF_PVA_2-0__1980__X0145-0051.xml"]}],"purchaseId":"2012-07-00001e","zipName":"extraction_boutique_0001e","rootFolder":"rootFolder","downLoadFolder":"downLoadFolder","zipMaxSize":300,"rootFolder":"MON_REPERTOIRE","productId":"BDORTHO","packagingId":"CONDITIONNEMENT_EXTRACTION_BOUTIQUE","extentDescription":"Zone","geographicIdentifier":"77","isPrepackaged":null,"idsMetadatasInspireToRequest":[],"id":1488,"parameters":[],"status":null,"jenkinsBuild":null,"creationDate":1320075966706,"broadcastDatas":[{"creationDate":null,"version":null,"broadcastProduct":null,"metadatas":[{"name":"metadata_bd1","id":812,"version":null,"validated":false},{"name":"metadata_bd2","id":813,"version":null,"validated":false},{"name":"metadata_bd3","id":814,"version":null,"validated":false},{"name":"metadata_bd4","id":815,"version":4,"validated":false}],"storage":{"logicalName" : "tmp"},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"name":"broadcastData1","id":5742}]}';
        },
        content => sub {
            return $sample_mtd;
        }
    );
	
	local *extract_wms_tile = sub { Execute->run( "cp " . $resources_path . "/extraction/image.tif " . $_[0]); return 0; };

    ok( extraction_boutique("5742") == 0, "testOkCaseWMSVecteur" );
	
	Execute->run( "rm -rf " . $tmp_path . $tmp_extraction . "/1488*", "true" );
	Execute->run( "rm -rf " . $root_storage . "/tmp/5742*", "true" );
}


{
	local *main::update_broadcastdata_size = sub { return 0;};
    my $mock         = Test::MockObject->new();
    $mock->fake_module(
        'HTTP::Response',
        is_success      => sub { return 1; },
        decoded_content => sub {
            return
'{"managerId":"cleok","priority":1,"extractionsWMS":[{"type":"WMSVECTOR","bboxes":[{"name":"1245012_12401401","id":1488,"points":"-21,48.5,-20,48.9","projection":"EPSG:4326"},{"name":"1245013_12401402","id":1489,"points":"-20,48.6,-19,49","projection":"EPSG:4326"}],"imageWidth":500,"context":"geoportail","imageHeight":500,"style":"","id":265,"layerName":"sde:commune","dataFolder":"VERSION_FORMAT_RIG_INFO_myDataFolder","themeFolder":"mythemeFolder","outputCrs":"EPSG:4326","outputFormat":"RAST_JPEG","service":"WMS","idsMetadatasIsoApToRequest":["IGNF_PVA_1-0__1980__X0145-0051.xml","IGNF_PVA_2-0__1980__X0145-0051.xml"]}],"purchaseId":"2012-07-00001e","zipName":"extraction_boutique_0001e","rootFolder":"rootFolder","downLoadFolder":"downLoadFolder","zipMaxSize":300,"rootFolder":"MON_REPERTOIRE","productId":"BDORTHO","packagingId":"CONDITIONNEMENT_EXTRACTION_BOUTIQUE","extentDescription":"Zone","geographicIdentifier":"77","isPrepackaged":null,"idsMetadatasInspireToRequest":[],"id":1488,"parameters":[],"status":null,"jenkinsBuild":null,"creationDate":1320075966706,"broadcastDatas":[{"creationDate":null,"version":null,"broadcastProduct":null,"metadatas":[{"name":"metadata_bd1","id":812,"version":null,"validated":false},{"name":"metadata_bd2","id":813,"version":null,"validated":false},{"name":"metadata_bd3","id":814,"version":null,"validated":false},{"name":"metadata_bd4","id":815,"version":4,"validated":false}],"storage":{"logicalName" : "tmp"},"hasBeenPublishedOnInternzone":false,"hasBeenPublishedOnExternzone":false,"name":"broadcastData1","id":6265}]}';
        },
        content => sub {
            return $sample_mtd;
        }
    );
	
	local *extract_wms_tile = sub { Execute->run( "cp " . $resources_path . "/extraction/image.tif " . $_[0]); return 0; };

    ok( extraction_boutique("6265") == 0, "testErrorWhenDeletingTempFiles" );
	
	Execute->run( "rm -rf " . $tmp_path . $tmp_extraction . "/6265*", "true" );
	Execute->run( "rm -rf " . $root_storage . "/tmp/6265*",           "true" );
}
