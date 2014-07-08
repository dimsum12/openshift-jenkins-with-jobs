DROP INDEX IF EXISTS NDX_crs_urn
;

DROP INDEX IF EXISTS NDX_temporalExtent
;

DROP INDEX IF EXISTS NDX_language_value
;

DROP INDEX IF EXISTS NDX_Voca
;

DROP INDEX IF EXISTS metadata_geom
;

DROP INDEX IF EXISTS ndx_metadata_type
;

DROP INDEX IF EXISTS ndx_creation_date
;

DROP INDEX IF EXISTS ndx_revision_date
;

DROP INDEX IF EXISTS ndx_modified_date
;

DROP INDEX IF EXISTS ndx_last_modified_date
;

DROP INDEX IF EXISTS ndx_file_identifier
;

DROP INDEX IF EXISTS ndx_securityConstraints
;

DROP INDEX IF EXISTS ndx_lastVersion
;

DROP INDEX IF EXISTS ndx_last_modified_date
;

DROP INDEX IF EXISTS ndx_metadata_title
;

DROP INDEX IF EXISTS ndx_metadata_abstract
;

DROP INDEX IF EXISTS ndx_file_identifier
;

DROP INDEX IF EXISTS NDX_Organisation_name
;

DROP INDEX IF EXISTS NDX_Value
;

DROP INDEX IF EXISTS ndx_anytext_vector
;


CREATE INDEX NDX_crs_urn
	ON CRS (md_id, urn)
;

CREATE INDEX NDX_temporalExtent
	ON DataMetadata (temporalExtentBegin, temporalExtentEnd)
;

CREATE INDEX NDX_language_value
	ON LocalizedString (language, propertyValue)
;

CREATE INDEX NDX_Voca
	ON MD_Keywords (voca_id)
;

CREATE INDEX metadata_geom
  ON metadata USING gist(geom);

--CREATE INDEX ndx_metadata_subject ON Metadata (anyText)
;

CREATE INDEX ndx_metadata_type
	ON Metadata (metadataType)
;

CREATE INDEX ndx_creation_date
	ON Metadata (creationDate)
;

CREATE INDEX ndx_revision_date
	ON Metadata (revisionDate)
;

CREATE INDEX ndx_modified_date
	ON Metadata (modified)
;

CREATE INDEX ndx_securityConstraints
	ON Metadata (hasSecurityConstraints)
;

CREATE INDEX ndx_lastVersion
	ON Metadata (isLastVersion)
;

CREATE INDEX ndx_last_modified_date 
	ON Metadata (lastmodifieddate)
;

CREATE INDEX ndx_metadata_title 
	ON Metadata (title text_pattern_ops)
;

CREATE INDEX ndx_metadata_abstract 
	ON Metadata (abstract text_pattern_ops)
;

CREATE INDEX ndx_file_identifier 
	ON Metadata (fileIdentifier varchar_pattern_ops)
;

CREATE INDEX NDX_Organisation_name
	ON ResponsibleParty (md_id, organisationName)
;

CREATE INDEX NDX_Value
	ON Vocabulary (concept)
;

CREATE INDEX ndx_anytext_vector
    ON md_anytext
    USING gin
      (anytext_vector)
;