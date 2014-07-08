#!/usr/bin/perl
#########################################################################################################################
#
# USAGE :
#   This script extract a WFS file from an internal WFS service
# ARGS :
#	The absolute file name used for writing the file
#	A GML styled geometry filter
#	CDA key used to extract the tile
#	Feature type used in the service to do WMS request
#	Format used in the service to do WMS request
#	Projection used in the service to do WMS request
#	Context : used to build service url
# RETURNS :
#   * 1 if the WFS request generate an error
#   * 2 if an error occured during writing file
#   * 255 if the function is called an incorrect number of arguments
# KEYWORDS
#   $Revision 1 $
#   $Source src/main/scripts/fr/geoportail/entrepot/scripts/extraction/base-block/extract_wfs_file.pl $
#   $Date: 21/12/11 $
#   $Author: Julien Perrot (a145972) <julien.perrot@atos.net> $
#########################################################################################################################

## Loading GPP3 Perl main env. configuration
use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;
use WebserviceTools;

use constant true => 1;
use constant false => 0;

require "get_epsg_for_ignf_projection.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger =
  Logger->new( "extract_wfs_file.pl", $config->param("logger.levels") );

# Configuration
my $url_proxy        = $config->param("proxy.url");
my $wfs_scheme       = $config->param("wfs_extraction.scheme");
my $wfs_host         = $config->param("wfs_extraction.host");
my $wfs_port         = $config->param("wfs_extraction.port");
my $wfs_path         = $config->param("wfs_extraction.path");
my $wfs_service      = $config->param("wfs_extraction.service");
my $wfs_version      = $config->param("wfs_extraction.version");
my $wfs_request      = $config->param("wfs_extraction.request");
my $max_size         = $config->param("wfs_extraction.max_size");
my $exception_offset = $config->param("wfs_extraction.exception.offset");
my $exception_length = $config->param("wfs_extraction.exception.length");
my $retry_attempts =
  $config->param("resources.ws.extraction.entrepot.retry.attempts");
my $retry_waitingtime =
  $config->param("resources.ws.extraction.entrepot.retry.waitingtime");
my $gdaltransform = $config->param("resources.gdaltransform");

# ClÃ©s statiques
# ClÃ©s statiques
my $parameter_key_typename     = "?TYPENAME=";
my $parameter_key_version      = "&VERSION=";
my $parameter_key_outputformat = "&OUTPUTFORMAT=";
my $parameter_key_service      = "&SERVICE=";
my $parameter_key_request      = "&REQUEST=";
my $parameter_key_spatial      = "&srsName=";
my $parameter_key_filter       = "&FILTER=";

sub extract_wfs_file {

    # Extraction des paramÃ¨tres
    my ( $file_name, $gml_geom, $cda_key, $feature_type, $format, $projection,
        $context )
      = @_;
    if (   !defined $file_name
        || !defined $gml_geom
        || !defined $cda_key
        || !defined $feature_type
        || !defined $format
        || !defined $projection
        || !defined $context )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (7)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "ParamÃ¨tre 1 : file_name = " . $file_name );
    $logger->log( "DEBUG", "ParamÃ¨tre 2 : gml_geom = " . $gml_geom );
    $logger->log( "DEBUG", "ParamÃ¨tre 3 : cda_key = " . $cda_key );
    $logger->log( "DEBUG", "ParamÃ¨tre 4 : feature_type = " . $feature_type );
    $logger->log( "DEBUG", "ParamÃ¨tre 5 : format = " . $format );
    $logger->log( "DEBUG", "ParamÃ¨tre 6 : projection = " . $projection );
    $logger->log( "DEBUG", "ParamÃ¨tre 7 : context = " . $context );

    # check if need to translete projection
    my $ignf_projection = "";
    if ( $projection =~ m/IGNF/ ) {
        $ignf_projection = $projection;
        $ignf_projection = $projection;
        $logger->log( "INFO", "Projection is an IGNF one so we change it " );

        # get the epsg projection
        my $epsgProjection = get_epsg_for_ignf_projection($projection);

        # replace output crs
        $projection = $epsgProjection;

        # replace srs in polygon
        $gml_geom =~ s/srsName=['"][^"']*["']/srsName="$projection"/g;
        $logger->log( "DEBUG", "New geom is : " . $gml_geom );

}#Fin if IGNF

# PATCH MANU POUR LA GESTION DES EXTRACTIONS EN LAMBERT 2 ETENDU #

my $order_projection = $projection;

if(lc($projection) eq "epsg:27572"){

	#GDAL utilise PROJ qui ignore pour l'instant les histoires d'axes des systemes geographiques
	#On utilise donc le code de projection correspondant au geographique lon/lat
	$projection = "urn:ogc:def:crs:CRS::84";

	$logger->log("DEBUG","La projection EPSG:27572 est mal geree par le WFS. Debut du traitement specifique");

#	my $srs_dimension = $gml_geom;
#	$srs_dimension=~ s/>\n.*</></g;
#	$srs_dimension =~s/^.*<gml:posList srsDimension="([0-9]+)">.*<\/gml:posList>.*$/$1/;

	#On recupere les points du polygone d'extraction
	my $extraction_points = $gml_geom;
	$extraction_points=~ s/>\n.*</></g;
	$extraction_points =~s/^.*<gml:posList srsDimension="[0-9]+">(.*)<\/gml:posList>.*$/$1/;

	$logger->log( "DEBUG", "points are : " . $extraction_points );

	# On commence par transformer l'emprise fournie en coordonnees geographiques

	my @ext_points = split(/ /, $extraction_points);
	my $size = scalar @ext_points;
	$size = $size / 2 ;
	my @reproj_ext_points;
	for(my $j = 0; $j < $size; $j++)
	{
		my $easting = $ext_points[(2*$j)];
		my $northing = $ext_points[(2*$j) + 1];
		my $gdaltransform_validator_pre = " | " . $gdaltransform . " -s_srs '+init=EPSG:27572 +wktext' -t_srs '+init=EPSG:4326";
		my $convert_cmd = "echo '"
		. $easting . " "
		. $northing . " 0'"
		. $gdaltransform_validator_pre
		. " +wktext';";
		$logger->log( "DEBUG", "La commande appelée est : " . $convert_cmd );
                my $convert_cmd_return = Execute->run( $convert_cmd, "true" );
		if ( $convert_cmd_return->get_return() != 0 ) {
			$logger->log( "ERROR", "La commande a renvoyé ". $convert_cmd_return->get_return() );
                	$logger->log( "DEBUG", "Sortie complète du processus :" );
                	$convert_cmd_return->log_all( $logger, "DEBUG" );
                	return 9;
		}
		my @cmd_output = $convert_cmd_return->get_log();
		my @result_point = split(/ /, $cmd_output[0]);
		my $lon = $result_point[0];
		my $lat	= $result_point[1];
		$logger->log("DEBUG", "Avant : " . $easting . " " . $northing . " Apres :" . $lon . " " . $lat);
		$reproj_ext_points[(2*$j)]=$lon	;
		$reproj_ext_points[(2*$j)+1]=$lat;
	}
	
	my $position_list;
	foreach (@reproj_ext_points)
	{
		$position_list .= $_;
		$position_list .= " ";
	}

		$logger->log("DEBUG","La nouvelle geometrie apres reprojection " . $position_list);

# On remplace la projection et les points dans le polygone GML

	$gml_geom=~ s/<gml:posList srsDimension="[0-9]+">(.*)<\/gml:posList>/<gml:posList srsDimension="2">$position_list<\/gml:posList>/g;
	$gml_geom=~ s/EPSG:27572/urn:ogc:def:crs:CRS::84/g;
	
	$logger->log("DEBUG","Le nouveau GML apres reprojection " . $gml_geom);

}# Fin if patch	

# FIN DU PATCH PREMIERE PARTIE #

# PATCH POUR GERER CORRECTEMENT LE PASSAGE DU SRSNAME

   my $projection_wfs2;
   my @projection_split = split(/:/,$projection);
   if ( lc($projection_split[0]) eq "epsg" )
   { 
	$projection_wfs2 = "urn:ogc:def:crs:EPSG:". $projection_split[1];
        $gml_geom=~ s/$projection/$projection_wfs2/g;
   }else
   {
	$projection_wfs2=$projection;
   }

# FIN DU PATCH #

# ce code commenté est a utiliser si on repasse en wfs 1.1.0 ou 1.0.0
# il est quand mm a vérifier mais normalement il doit aps etre mauvais
# en gros il inverse les 2 premières coordonnée pour chaque groupe de coordonnee

#		if ($projection eq "EPSG:4326"){
#			$logger->log( "INFO", "La projection compatible est EPSG:4326. Nous devons traduire le polygon en conséquence." );
#			# now we need to invert translate points of the polygon in EPSG:4326 system
#			# meaning we need to invert each first two coordinates
#
#			my $srs_dimension = $gml_geom;
#			# sécurité pour enlever les sauts de ligne
#			$srs_dimension=~ s/>\n.*</></g;
#
#            $srs_dimension =~
#s/^.*<gml:posList srsDimension="([0-9]+)">.*<\/gml:posList>.*$/$1/;
#            $logger->log( "DEBUG", "srs dimension is : " . $srs_dimension );
#
#			my $extraction_points = $gml_geom;
#            # sÃ©curitÃ© pour enlever les sauts de ligne
#             $extraction_points=~ s/>\n.*</></g;
#            $extraction_points =~"#
#s/^.*<gml:posList srsDimension="[0-9]+">(.*)<\/gml:posList>.*$/$1/;
#
#       $logger->log( "DEBUG", "points are : " . $extraction_points );
#            my $new_extraction_points = "";
#                        my $tmp_first_point     = "";
#                        my $tmp_second_point     = "";
#            my $count          = 0;
#            foreach my $point_cutted ( split / /, $extraction_points ) {
#				if ( $count == 0){
#						$count += 1;
#						$tmp_first_point = $point_cutted ;
#						$logger->log( "DEBUG", "tmp_first_point is : " . $tmp_first_point );
#				}else{
#					if ( $count == 1 ) {
#						$count += 1;
#						$tmp_second_point = $point_cutted ;
#						$logger->log( "DEBUG", "tmp_second_point is : " . $tmp_second_point );
#						$new_extraction_points .= $tmp_second_point  . $tmp_first_point . " ";
#						$logger->log( "DEBUG",
#							"new_extraction_points is : " . $new_extraction_points );
#
#					}elsif ( $count < $srs_dimension ){
#						$count += 1;
#						$new_extraction_points .=  	$point_cutted . " ";
#						$logger->log( "DEBUG",
#							"new_extraction_points is : " . $new_extraction_points );
#					}elsif{
#						$count      = 1;
#						$tmp_first_point     = $point_cutted . " ";
#						$logger->log( "DEBUG", "tmp_first_point is : " . $tmp_first_point );
#						$tmp_second_point    = "";
#					}
#				}
#           }
#		# now replace list of points with new points
#			$gml_geom=~ s/<gml:posList srsDimension="[0-9]+">(.*)<\/gml:posList>/<gml:posList srsDimension="$srs_dimension">$new_extraction_points<\/gml:posList>"/g;
#		}
#
#
   # }

    my $filter_start =
"<Filter xmlns:gml=\"http://www.opengis.net/gml/3.2\"><Intersects><ValueReference>the_geom</ValueReference>";
    my $filter_end = "</Intersects></Filter>";
    my $filter     = $filter_start . $gml_geom . $filter_end;

    # CrÃ©ation de la requÃªte WMS
    my $request =
        $wfs_scheme . "://"
      . $wfs_host . "/"
      . $cda_key . "/"
      . lc($context)
      . $wfs_path
      . $parameter_key_typename
      . $feature_type
      . $parameter_key_version
      . $wfs_version
      . $parameter_key_outputformat
      . $format
      . $parameter_key_service
      . $wfs_service
      . $parameter_key_request
      . $wfs_request
      . $parameter_key_spatial
      # Patch WFS 2.0.0
      # .$projection
      . $projection_wfs2
      . $parameter_key_filter
      . $filter;
    $logger->log( "INFO", "requete WFS  : " . $request );

    # Péparation de la requête WMS
    my $ws = WebserviceTools->new( 'GET', $request, $url_proxy );

    # Requête WMS
    my $result = $ws->run( $retry_attempts, $retry_waitingtime );

    if ( !$result ) {

        # Erreur de requÃªte WFS
        $logger->log( "ERROR",
"Une erreur s'est produite lors de la requête sur le service WFS : "
              . $request );
        return 1;
    }

    # RequÃªte WFS

    $logger->log( "DEBUG", "requête WFS exécutée avec succès" );

    # Ecriture du fichier de sortie
    my $hdl_wfs_file;
    if ( !open $hdl_wfs_file, ">", $file_name ) {
        $logger->log( "ERROR",
            "Impossible de crÃ©er le fichier " . $file_name );
        return 2;
    }

    # check if exception was returned is size is small
    my $content = $ws->get_content();
    my $length  = length($content);
    $logger->log( "DEBUG", "Longueur du fichier récupéré : " . $length );
    if ( $length < $max_size ) {

        $logger->log( "DEBUG",
            "Le fichier fait moins de " . $max_size . " caractères" );

        # check the first characters to check exception
        my $tmp_exception_offset = $exception_offset;
        my $tmp_exception_length = $exception_length;

        # sécurité
        if ( ( $tmp_exception_offset + $tmp_exception_length ) > $length ) {
            $logger->log( "INFO", "Le fichier reçu est très petit. " );
            $tmp_exception_offset = 0;
            $tmp_exception_length = $length;
        }

        my $sub_string = substr $content, $tmp_exception_offset,
          $tmp_exception_length;
        chomp $sub_string;

        # sécurité pour enlever les sauts de ligne
        $sub_string =~ s/\n/ /g;

        $logger->log( "DEBUG",
            "première partie du fichier :  " . $sub_string );

        if ( $sub_string =~ /.*ows:Exception.*/i ) {
            $logger->log( "ERROR", "Le geoserver a renvoyé une exception : " );
            $logger->log( "ERROR", $content );
            return 1;
        }

    }

    if ( $format eq "GML32" && !( $ignf_projection eq "" ) ) {
        $logger->log(
            "INFO",
"C'est une requête en gml et nous avons traduit la projection IGNF en EPSG 
		donc il est nécessaire de remettre le bon srsName dans le gml"
        );

        $content =~ s/srsName=['"][^'"]*["']/srsName="$ignf_projection"/g;

    }

    print {$hdl_wfs_file} $content;

    if ( !close $hdl_wfs_file ) {
        $logger->log( "ERROR",
            "Impossible de fermer le fichier " . $file_name );
        return 2;
    }

    #PATCH MANU LAMBERT 2 BEGIN

    if(!($order_projection eq $projection))
    {	
        return $order_projection;
    }

    #PATCH END

    return 0;
}
