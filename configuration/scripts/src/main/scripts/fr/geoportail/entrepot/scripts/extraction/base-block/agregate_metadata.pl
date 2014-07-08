#!/usr/bin/perl
##########################################################################################################################################
#
# USAGE :
#   This script will agregate a list of xml files into one unique
# ARGS :
#   - metadata_folder : folder containing metatdata xml files to agregate
#   - format : Format of extraction
#   - projection
#   - longitude_min
#   - longitude_max
#   - latitude_min
#   - latitude_max
#   - extraction_date as unix timestamp (same as localtime perl function's format)
#   - agregated_name : filename of the resulting filename where to agregate. Extension can be anyone, resulting will be in .xml.
#	- purchase ID of the extraction
#	- product name of the extraction
# RETURNS :
#   * 0 if the agregation is Ok or any metadatas can be found
#   * 1 if mtds folder is not a folder or does not exists
#   * 2 if cannot create XML agregated metadata (bad name, no rights, other error)
#   * 3 if cannot determine extraction type (RATS ? VECT ?)
#   * 4 if min date, max date or edition date could not be defined
#   * 255 if the function is called with an incorrect number of arguments
# KEYWORDS
#   $Revision 3 $
#   $Source src/main/scripts/fr/geoportail/entrepot/conditionnement/agregate_metadata.pl $
#   $Date: 26/04/12 $
#   $Author: Maimouna Deme (a510440) <maimouna.deme@atos.net> $
#   $Author: Julien Perrot  <julien.perrot@atos.net> $
#   $Author: Damien Duportal <damien.duportal@atos.net> $
############################################################################################################################################

## Loading GPP3 Perl main env. configurationuse strict;
use strict;
use warnings;
use Logger;
use Cwd;
use Config::Simple;
use File::Basename;
use XML::DOM::XPath;
use POSIX qw(strftime);
use Execute;
use File::Basename;
use Encode;
require "sort_dates.pl";
require "retrieve_properties.pl";
require "set_node.pl";
require "set_encoding.pl";
require "get_min_max_from_mtd_file.pl";
require "get_unit_from_projection.pl";

our $VERSION = "1.0";

our $config;
if ( not( defined $config ) ) {
    my $config_path = cwd() . "/src/main/config/local";
    $config = Config::Simple->new( $config_path . "/config_perl.ini" )
      or croak Config::Simple->error();
}
my $logger =
  Logger->new( "agregate_metadata.pl", $config->param("logger.levels") );

my $resources_path = $config->param("resources.path") . 'conditionnement/';
my $jpeg_properties = $resources_path . 'formats/jpeg.properties';
my $png_properties  = $resources_path . 'formats/png.properties';
my $shp_properties  = $resources_path . 'formats/shp.properties';
my $tiff_properties = $resources_path . 'formats/tiff.properties';
my $gml_properties  = $resources_path . 'formats/gml.properties';


our $tags;

$tags = Config::Simple->new(
        $resources_path . "tags_conditionnement.ini" ) ;
my $gmd_root 									=  $tags->param("metadata_agregation_livraison.gmd.root");
my $gmd_file_name 								=  $tags->param("metadata_agregation_livraison.gmd.file_name");
my $gmd_date 									=  $tags->param("metadata_agregation_livraison.gmd.date");
my $gmd_reference_system 						=  $tags->param("metadata_agregation_livraison.gmd.reference_system");
my $gmd_resource_title 							=  $tags->param("metadata_agregation_livraison.gmd.resource_title");
my $gmd_resource_alternate_title				=  $tags->param("metadata_agregation_livraison.gmd.resource_alternate_title");
my $gmd_resource_creation_date 					=  $tags->param("metadata_agregation_livraison.gmd.resource_creation_date");
my $gmd_edition									=  $tags->param("metadata_agregation_livraison.gmd.edition");
my $gmd_edition_date							=  $tags->param("metadata_agregation_livraison.gmd.edition_date");
my $gmd_resourceIdentifier 						=  $tags->param("metadata_agregation_livraison.gmd.resourceIdentifier");
my $gmd_resourceIdentifier_attribute 			=  $tags->param("metadata_agregation_livraison.gmd.resourceIdentifier_attribute");
my $gmd_resource_format_id 						=  $tags->param("metadata_agregation_livraison.gmd.resource_format_id");
my $gmd_resource_format 						=  $tags->param("metadata_agregation_livraison.gmd.resource_format");
my $gmd_resource_version 						=  $tags->param("metadata_agregation_livraison.gmd.resource_version");
my $gmd_resource_maintenance 					=  $tags->param("metadata_agregation_livraison.gmd.resource_maintenance");
my $gmd_resolution 								=  $tags->param("metadata_agregation_livraison.gmd.resolution");
my $gmd_extent_description 						=  $tags->param("metadata_agregation_livraison.gmd.extent_description");
my $gmd_bbox_west_bound_longitude 				=  $tags->param("metadata_agregation_livraison.gmd.bbox_west_bound_longitude");
my $gmd_bbox_east_bound_longitude 				=  $tags->param("metadata_agregation_livraison.gmd.bbox_east_bound_longitude");
my $gmd_bbox_south_bound_latitude 				=  $tags->param("metadata_agregation_livraison.gmd.bbox_south_bound_latitude");
my $gmd_bbox_north_bound_latitude 				=  $tags->param("metadata_agregation_livraison.gmd.bbox_north_bound_latitude");
my $gmd_geographic_identifier 					=  $tags->param("metadata_agregation_livraison.gmd.geographic_identifier");
my $gmd_temporal_extent_id 						=  $tags->param("metadata_agregation_livraison.gmd.temporal_extent_id");
my $gmd_temporal_extent_begin_position 			=  $tags->param("metadata_agregation_livraison.gmd.temporal_extent_begin_position");
my $gmd_temporal_extent_end_position 			=  $tags->param("metadata_agregation_livraison.gmd.temporal_extent_end_position");
my $gmd_distribution_format_id 					=  $tags->param("metadata_agregation_livraison.gmd.distribution_format_id");
my $gmd_distribution_format_name 				=  $tags->param("metadata_agregation_livraison.gmd.distribution_format_name");
my $gmd_distribution_format_version 			=  $tags->param("metadata_agregation_livraison.gmd.distribution_format_version");
my $gmd_decompression_technique 				=  $tags->param("metadata_agregation_livraison.gmd.decompression_technique");
my $gmd_organisationName 						=  $tags->param("metadata_agregation_livraison.gmd.organisationName");
my $gmd_onlineResource 							=  $tags->param("metadata_agregation_livraison.gmd.onlineResource");
my $gmd_onlineResourceProtocol 					=  $tags->param("metadata_agregation_livraison.gmd.onlineResourceProtocol");
my $gmd_distributionContactRole 				=  $tags->param("metadata_agregation_livraison.gmd.distributionContactRole");
my $gmd_dataQualityLineageDescription 			=  $tags->param("metadata_agregation_livraison.gmd.dataQualityLineageDescription");
my $gmd_rationale 								=  $tags->param("metadata_agregation_livraison.gmd.rationale");
my $gmd_completeDateTime 						=  $tags->param("metadata_agregation_livraison.gmd.completeDateTime");
my $gmd_responsibleParty 						=  $tags->param("metadata_agregation_livraison.gmd.responsibleParty");



sub agregate_metadata {

    # Extraction des paramètres
    my (
        $metadata_folder, $format,          $projection,
        $longitude_min,   $longitude_max,   $latitude_min,
        $latitude_max,    $extraction_date, $agregated_name,
		$purchase_id, $product_name
    ) = @_;
    if (   !defined $metadata_folder
        || !defined $format
        || !defined $projection
        || !defined $longitude_min
        || !defined $longitude_max
        || !defined $latitude_min
        || !defined $latitude_max
        || !defined $extraction_date
        || !defined $agregated_name
		|| !defined $purchase_id 		
		|| !defined $product_name )
    {
        $logger->log( "ERROR",
            "Le nombre de paramètres renseignés n'est pas celui attendu (11)"
        );
        return 255;
    }

    $logger->log( "DEBUG", "Paramètre 1 : metadata_folder = " . $metadata_folder );
    $logger->log( "DEBUG", "Paramètre 2 : format = " . $format );
    $logger->log( "DEBUG", "Paramètre 3 : projection = " . $projection );
    $logger->log( "DEBUG", "Paramètre 4 : longitude_min = " . $longitude_min );
    $logger->log( "DEBUG", "Paramètre 5 : longitude_max = " . $longitude_max );
    $logger->log( "DEBUG", "Paramètre 6 : latitude_min = " . $latitude_min );
    $logger->log( "DEBUG", "Paramètre 7 : latitude_max = " . $latitude_max );
    $logger->log( "DEBUG", "Paramètre 8 : extraction_date = " . $extraction_date );
    $logger->log( "DEBUG", "Paramètre 9 : agregated_name = " . $agregated_name );
	$logger->log( "DEBUG", "Paramètre 10 : purchase_id = " . $purchase_id );
	$logger->log( "DEBUG", "Paramètre 11 : product_name = " . $product_name );

	# Determining from format (the 4th chars of $format) if this extraction is vector. If not, it's raster.
    my $extract_type_from_format = substr $format, 0, 4;
    my $is_vector;
    if ( $extract_type_from_format eq "RAST" ) {
        $is_vector = 0;
        $logger->log( "DEBUG","Le type de l'extraction est RASTER, déterminé depuis le format : "
              . $format );
    }
    elsif ( $extract_type_from_format eq "VECT" ) {
        $is_vector = 1;
        $logger->log( "DEBUG",
"Le type de l'extraction est VECTEUR, déterminé depuis le format : "
              . $format );
    }
    else {
        $logger->log( "ERROR",
"Impossible de déterminer le type de l'extraction (raster ou vecteur ?) à partir du format fourni ("
              . $format
              . "). Ce dernier doit commencer par RAST ou VECT." );
        return 3;
    }	
	

############################# Getting dates from metadata  ############################
	
	# check if folder exists
	if ( !-d $metadata_folder ) {
        $logger->log( "ERROR",
                "Le répertoire source des métadonnées "
              . $metadata_folder
              . " n'existe pas" );
        return 1;
    }

    # Checks if the metadata folder is empty or not
    my $liste_mtds_run =
      Execute->run( "ls -1 " . $metadata_folder . "/*.xml | wc -l", "true" );
    if ( $liste_mtds_run->get_log() < 1 ) {
        $logger->log( "DEBUG",
                "Le répertoire de métadonnées "
              . $metadata_folder
              . " est vide" );
        return 0;
    }

    #opens the directory and retrieves the list of files
    my @files = `ls $metadata_folder*.xml`;

    $logger->log( "DEBUG",
            "Le dossier de métadonnées contient:"
          . ( scalar @files )
          . " fichiers" );




	# Récupération de l'ensemble des dates des métadonnées
    my @begin_positions = ();
    my @end_positions   = ();
	my @edition_dates 	= ();

    foreach my $file (@files) {
        chomp $file;
		$logger->log( "INFO", "Traitement du fichier :" . $file );
		
        ## On ajoute aux collections de dates (begin et end positions) les dates min et max du fichier de metadonnée
        ( my $mtd_min_date, my $mtd_max_date, my $mtd_date_edition ) =
          get_min_max_from_mtd_file($file);
		  
		if ( $mtd_min_date eq "null" &&  $mtd_max_date eq "null" &&  $mtd_max_date eq "null"){
			$logger->log( "DEBUG", "Aucune date valide pour ce fichier");
			next;
		}
		if ( $mtd_min_date eq "null" && $mtd_date_edition ne "null"){
			push( @begin_positions, $mtd_date_edition );
		} else{
			push( @begin_positions, $mtd_min_date );
		}
		
		if ( $mtd_max_date eq "null" && $mtd_date_edition ne "null" ){
			push( @end_positions, $mtd_date_edition );
		} else{
			push( @end_positions, $mtd_max_date );
		}
		
		if ( $mtd_date_edition ne "null" ){
			push( @edition_dates, $mtd_date_edition );
		} 
		elsif( $mtd_max_date ne "null" ){
			push( @edition_dates, $mtd_max_date );
		} 
		elsif( $mtd_min_date ne "null" ){
			push( @edition_dates, $mtd_min_date );
		}
		

    }

	# Détermination de la date la plus ancienne (min date) de la totalité des méta données
    $logger->log( "DEBUG",
        "Liste des begins dates trouvés : " . @begin_positions );
    my $min_date = sort_dates( "min", @begin_positions );
	if ( $min_date == 254){
		$logger->log( "ERROR",
                "La date min n'a pas pu être déterminée ");
				return 4;
	}
    $logger->log( "DEBUG", "Date min trouvée : " . $min_date );

	# Détermination de la date la plus récente (max date) de la totalité des méta données
    $logger->log( "DEBUG", "Liste des end dates trouvés : " . @end_positions );
    my $max_date = sort_dates( "max", @end_positions );
	if ( $max_date == 254){
		$logger->log( "ERROR",
                "La date max n'a pas pu être déterminée ");
				return 4;
	}
    $logger->log( "DEBUG", "Date max trouvée : " . $max_date );
	
	# Détermination de la date la plus récente (max date) de la totalité des méta données
    $logger->log( "DEBUG", "Liste des edition dates trouvés : " . @edition_dates );
    my $max_edition_date = sort_dates( "max", @edition_dates );
	if ( $max_edition_date == 254){
		$logger->log( "ERROR",
                "La date d'édition max n'a pas pu être déterminée ");
				return 4;
	}
    $logger->log( "DEBUG", "Date d'édition max trouvée : " . $max_edition_date );
	

############################# Creating the agregation XML file  ############################

	
	# Le second argument de fileparse est une regexp permettant d'attraper l'extension même si le fichier contient des caractères '.'/
    ( my $agregated_filename, my $content_dir, my $agregated_file_extension ) =
      fileparse( $agregated_name, qr/\.[^.]*/ );
	if (! $agregated_filename){
		$logger->log( "ERROR",
			"Erreur avec le nom du fichier agrégé "  );
			return 2;
	}
    my $agregated_filename_full = $agregated_filename . ".xml";
    my $agregated_file_path     = $metadata_folder . $agregated_filename_full;
    $logger->log( "DEBUG",
        "Le fichier de destination pour agréger les métadonnées est : "
          . $agregated_file_path );
	
	


	# On effectue la copie du premier fichier vers $agregated_file_path si on a une ou plusieurs métadonnées, sinon on sort.
    
	my $cp_run =
	  Execute->run( "cp " . $files[0] . "  " . $agregated_file_path,
		"true" );
	if ( $cp_run->get_return() != 0 ) {
		$logger->log( "ERROR",
			"La commande à renvoyé " . $cp_run->get_return() );
		$logger->log( "DEBUG", "Sortie complète du processus :" );
		$cp_run->log_all( $logger, "DEBUG" );

		return 2;
	}
    
	
	# suppression des anciens fichiers 
	foreach my $file (@files) {
        chomp $file;
		$logger->log( "DEBUG", "Supression du fichier :" . $file );
		
        ## Supression du fichier une fois traité
        Execute->run( "rm -rf " . $file, "true" );

    }


############################# Setting all the nodes values  ############################
    
	# fix pour changer des caractères

	open ( FILE, $agregated_file_path) or die "Cannot open file: $!";
my $line;
my @outLines;

	while ( $line = <FILE> ) {
		# i is case insensative
		# ([^>]*) match zero or more characters but not '>'
		$line =~ s/–/-/g;
		push(@outLines, $line);
	}

	close FILE;

	open ( OUTFILE, ">$agregated_file_path" );
	print ( OUTFILE @outLines );
	close ( OUTFILE );
	
	
	
	
	
	# ouverture du fichier en lecture
	my $parser = XML::DOM::Parser->new();
    my $doc    = $parser->parsefile($agregated_file_path);
	
	
	
	#Ouverture du bon fichier de propriétés de format selon le format
    my %hash_format_properties;
    if ( $format =~ /jpeg/i ) {
        %hash_format_properties = retrieve_properties($jpeg_properties);
		$logger->log( "DEBUG", "On recupère les propriétés des fichiers jpeg " );
    }

    if (   $format =~ /shp/i
        || $format =~ /shape-zip/i )
    {
        %hash_format_properties = retrieve_properties($shp_properties);
		$logger->log( "DEBUG", "On recupère les propriétés des fichiers shape " );
    }

    if ( $format =~ /tiff/i ) {
        %hash_format_properties = retrieve_properties($tiff_properties);
		$logger->log( "DEBUG", "On recupère les propriétés des fichiers tiff " );
    }

    if ( $format =~ /png/i ) {
        %hash_format_properties = retrieve_properties($png_properties);
		$logger->log( "DEBUG", "On recupère les propriétés des fichiers png " );
    }

    if ( $format =~ /gml/i || $format =~ /gml2/i ) {
        %hash_format_properties = retrieve_properties($gml_properties);
		$logger->log( "DEBUG", "On recupère les propriétés des fichiers gml " );
    }
	my $format_name = $hash_format_properties{'name'};

	
	# defining values
	my %hash;
	my $node;
	
	# uuid --> attribut
	$logger->log( "DEBUG", "setting uuid attribute" );
	$node = ( $doc->findnodes($gmd_root) )[0] ;
	if ($node) {
		$node->setAttribute( "uuid", $agregated_filename );
	}else{
		$logger->log( "WARN", "Impossble de trouver le noeud : " . $gmd_root );
	}


	# Filename
	$hash{$gmd_file_name} = $agregated_filename_full;

	# Extraction date
	$hash{$gmd_date } = $extraction_date;

	# Reference System 
	my $rig_url;
	
	if ( length($projection) < 6){
	
		$rig_url = "http://librairies.ign.fr/geoportail/resources/RIG.xml#" . $projection;
	} 
	elsif( (substr $projection, 0, 4)  eq "EPSG") {
		# si projection EPSG
        $rig_url = "http://spatialreference.org/ref/epsg/" . substr $projection, 5, (length($projection)-1);
    }
    elsif ( (substr $projection, 0, 4) eq "IGNF" ) {
		# si projection IGNF
        $rig_url = "http://librairies.ign.fr/geoportail/resources/RIG.xml#" . substr $projection, 5, (length($projection)-1);
    }else{
		# sinon, selon ce qui a été discuté avec Nicolas Viel, on laisse la projection avec l'url des projections IGNF 
		# --> a corriger pour les projections type CRS:84
		$rig_url = "http://librairies.ign.fr/geoportail/resources/RIG.xml#" . $projection;
	}
	
	 $logger->log( "DEBUG", "setting xlink:href attribute" );
	$node = ( $doc->findnodes($gmd_reference_system) )[0] ;
	if ($node) {
		$node->setAttribute( "xlink:href", $rig_url );
	}else{
		$logger->log( "WARN", "Impossble de trouver le noeud : " . $gmd_reference_system );
	}
	$hash{$gmd_reference_system} = $projection;

	# Resource title
	$hash{$gmd_resource_title} = $product_name . " traitement du " . $extraction_date; ;

	# Resource alternate title
	$hash{$gmd_resource_alternate_title} = $agregated_filename;

	# Resource creation date
	$hash{$gmd_resource_creation_date} = $extraction_date; 

	# Edition 
	$hash{$gmd_edition} = substr $max_edition_date, 0, 4;

	# Edition date
	$hash{$gmd_edition_date} = $max_edition_date;

	# 
	$logger->log( "DEBUG", "setting id attribute for resource identifier" );
	$node = ( $doc->findnodes($gmd_resourceIdentifier) )[0] ;
	if ($node) {
		$node->setAttribute( "id", $agregated_filename . ".identifier" );
	}else{
		$logger->log( "WARN", "Impossble de trouver le noeud : " . $gmd_resourceIdentifier );
	}
	
	
	
	# 
	$hash{$gmd_resourceIdentifier_attribute} = $agregated_filename;
	
	# 
	$logger->log( "DEBUG", "setting id attribute for resource format" );
	$node = ( $doc->findnodes($gmd_resource_format_id) )[0] ;
	if ($node) {
		$node->setAttribute( "id", $agregated_filename . ".resourceFormat." . $format_name );
	}else{
		$logger->log( "WARN", "Impossble de trouver le noeud : " . $gmd_resource_format_id );
	}
	
	
	
	#
	$hash{$gmd_resource_format} = $format_name;

	#
	$hash{$gmd_resource_version} = $hash_format_properties{'version'};

	# 
	$logger->log( "DEBUG", "setting id attribute for resource resource maintenance" );
	$node = ( $doc->findnodes($gmd_resource_maintenance) )[0] ;
	if ($node) {
		$node->setAttribute( "id", $agregated_filename . ".resourceMaintenance" );
	}else{
		$logger->log( "WARN", "Impossble de trouver le noeud : " . $gmd_resource_maintenance );
	}
	

	# a ne pas setter pour le vecteur !!!!!!!
	# 
	if ( ! $is_vector) {
	
		my $resolution = (abs($longitude_max - $longitude_min) + abs($latitude_max - $latitude_min))/2;
	
		my $unit = get_unit_from_projection( $projection) ;
		if ( $unit == 1){
		
		} elsif ( $unit eq "d" ){
			# si projection en degres, besoin de multiplier la resolution par le rayon terrestre pour l'avoir en mètres
			$resolution = $resolution * 6378137;
		}
		
		$hash{$gmd_resolution} = $resolution ;
		$logger->log( "DEBUG", "setting uom attribute for resolution" );
		$node = ( $doc->findnodes($gmd_resolution) )[0] ;
		if ($node) {
			$node ->setAttribute( "uom", "m" );
		}else{
			$logger->log( "WARN", "Impossble de trouver le noeud : " . $gmd_resolution );
		}
		
		
	}
	
	
	#
	$hash{$gmd_extent_description} = "Extraction - Commande : " . $purchase_id;

	#
	$hash{$gmd_bbox_west_bound_longitude} = $longitude_min;

	#
	$hash{$gmd_bbox_east_bound_longitude} = $longitude_max;

	#
	$hash{$gmd_bbox_south_bound_latitude} = $latitude_min;

	#
	$hash{$gmd_bbox_north_bound_latitude} = $latitude_max;

	#  Vu avec Anais, aucune idee de quelle valeur indiquer pour ce champ
	#$hash{$gmd_geographic_identifier} =  ?????;

	# 
	$logger->log( "DEBUG", "setting gml:id attribute for resource identifier" );
	my @nodes = $doc->findnodes($gmd_temporal_extent_id);
	$logger->log( "DEBUG", "iterating over " . scalar(@nodes) ." temporalExtent" );
	my $i = 1;
	foreach my $node_single (@nodes) {
		$node_single ->setAttribute( "gml:id", $agregated_filename .  ".temporalExtent_" . $i );
		$i+=1;
	}
	

	#
	$hash{$gmd_temporal_extent_begin_position} = $min_date;

	#
	$hash{$gmd_temporal_extent_end_position} = $max_date;

	# 
	$node = ( $doc->findnodes($gmd_distribution_format_id) )[0] ;
	if ($node) {
		$node ->setAttribute( "id", $agregated_filename . ".distributionFormat." . $format_name );
	}else{
		$logger->log( "WARN", "Impossble de trouver le noeud : " . $gmd_distribution_format_id );
	}


	#
	$hash{$gmd_distribution_format_name} = $hash_format_properties{'name'};

	#
	$hash{$gmd_distribution_format_version} = $hash_format_properties{'version'};

	#
	if (   $format =~ /shp/i
        || $format =~ /shape-zip/i )
    {
        $hash{$gmd_decompression_technique} =
          $hash_format_properties{'decompression_techique'};
    }

	#
	$hash{$gmd_organisationName} = $hash_format_properties{'compagny'};

	#
	$hash{$gmd_onlineResource} = $hash_format_properties{'url'};

	#
	$hash{$gmd_onlineResourceProtocol} = $hash_format_properties{'protocol'};

	#
	$logger->log( "DEBUG", "setting codeListValue attribute for distribution contact role" );
	$node = ( $doc->findnodes($gmd_distributionContactRole) )[0] ;
	if ($node) {
		$node ->setAttribute( "codeListValue", $hash_format_properties{'distributionContactRole'} );
	}else{
		$logger->log( "WARN", "Impossble de trouver le noeud : " . $gmd_distributionContactRole );
	}

	#
	$hash{$gmd_dataQualityLineageDescription} = decode("utf8","Extraction à partir de lots IGN");

	#
	$hash{$gmd_rationale} = "production";

	#
	$hash{$gmd_completeDateTime} = ( strftime "%Y-%m-%dT%H:%M:%S", localtime );

	#
	$hash{$gmd_responsibleParty} = decode("utf8","Géoportail");
	
	

   

    # Setting nodes values of hash
    while ( my ( $key, $value ) = each %hash ) {
        $logger->log( "DEBUG", "Tag à modifier : " . $key );
        $logger->log( "DEBUG", "Valeur à insérer : " . $value );
        set_node( $doc, $key, $value );
   }

    $doc->printToFile($agregated_file_path);
    $doc->dispose;
    $logger->log( "DEBUG", "Fin de l'agrégation de métadonnées" );

    return $agregated_file_path;
}
