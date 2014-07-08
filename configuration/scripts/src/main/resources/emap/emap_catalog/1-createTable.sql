-- Drop sequences

DROP SEQUENCE IF EXISTS seq_crs CASCADE
;
DROP SEQUENCE IF EXISTS seq_Format CASCADE
;
DROP SEQUENCE IF EXISTS seq_GeographicIdentifier CASCADE
;
DROP SEQUENCE IF EXISTS seq_LocalizedString CASCADE
;
DROP SEQUENCE IF EXISTS seq_MDKeywords CASCADE
;
DROP SEQUENCE IF EXISTS seq_metadata CASCADE
;
DROP SEQUENCE IF EXISTS seq_Specifications CASCADE
;
DROP SEQUENCE IF EXISTS seq_thesaurus CASCADE
;
DROP SEQUENCE IF EXISTS seq_vocabulary CASCADE
;

-- Create sequences

CREATE SEQUENCE seq_crs 
;
CREATE SEQUENCE seq_Format 
;
CREATE SEQUENCE seq_GeographicIdentifier 
;
CREATE SEQUENCE seq_LocalizedString 
;
CREATE SEQUENCE seq_MDKeywords 
;
CREATE SEQUENCE seq_metadata 
;
CREATE SEQUENCE seq_Specifications 
;
CREATE SEQUENCE seq_thesaurus 
;
CREATE SEQUENCE seq_vocabulary 
;

-- Drop tables

DROP TABLE IF EXISTS CRS CASCADE
;
DROP TABLE IF EXISTS DataMetadata CASCADE
;
DROP TABLE IF EXISTS Denominator CASCADE
;
DROP TABLE IF EXISTS Distance CASCADE
;
DROP TABLE IF EXISTS Format CASCADE
;
DROP TABLE IF EXISTS GeographicIdentifier CASCADE
;
DROP TABLE IF EXISTS LocalizedString CASCADE
;
DROP TABLE IF EXISTS MD_Format CASCADE
;
DROP TABLE IF EXISTS MD_Keywords CASCADE
;
DROP TABLE IF EXISTS Metadata CASCADE
;
DROP TABLE IF EXISTS OperatesOn CASCADE
;
DROP TABLE IF EXISTS Relations CASCADE
;
DROP TABLE IF EXISTS ResponsibleParty CASCADE
;
DROP TABLE IF EXISTS ServiceMetadata CASCADE
;
DROP TABLE IF EXISTS Specifications CASCADE
;
DROP TABLE IF EXISTS Thesaurus CASCADE
;
DROP TABLE IF EXISTS Vocabulary CASCADE
;
DROP TABLE IF EXISTS Configuration CASCADE
;
DROP TABLE IF EXISTS jobstate CASCADE
;
DROP TABLE IF EXISTS md_anytext CASCADE
;

--  Create Tables 

CREATE TABLE CRS ( 
	id integer DEFAULT nextval('seq_crs') NOT NULL,
	md_id integer NOT NULL,
	urn varchar(255) NOT NULL
)
;

CREATE TABLE DataMetadata ( 
	md_id integer NOT NULL,
	resourceLanguage varchar(50),
	temporalExtentBegin timestamp,
	temporalExtentEnd timestamp
)
;

CREATE TABLE Denominator ( 
	md_id integer NOT NULL,
	index smallint NOT NULL,
	value integer NOT NULL
)
;

COMMENT ON TABLE Denominator
    IS '<pre>ListofSpatialResolutionusingdenominatorrepresentation </pre>'
;

CREATE TABLE Distance ( 
	md_id integer NOT NULL,
	index smallint NOT NULL,
	value integer NOT NULL    --  Valueinmm 
)
;

COMMENT ON TABLE Distance
    IS 'List ofSpatialresolutionsforonemetadata.Theindexcolumnwillkeeptheorderoftheresolutionintheoriginalmetadata'
;

COMMENT ON COLUMN Distance.value
    IS 'Valueinmm'
;

CREATE TABLE Format ( 
	id integer DEFAULT nextval ('seq_Format') NOT NULL,
	name varchar(255)
)
;

CREATE TABLE GeographicIdentifier ( 
	id integer DEFAULT nextval ('seq_GeographicIdentifier') NOT NULL,
	md_id integer NOT NULL,
	code text NOT NULL
)
;

CREATE TABLE LocalizedString ( 
	id integer DEFAULT nextval ('seq_LocalizedString') NOT NULL,
	md_id integer NOT NULL,
	propertyName varchar(50) NOT NULL,
	propertyValue text NOT NULL,
	language varchar(3) NOT NULL
)
;

CREATE TABLE MD_Format ( 
	md_id integer NOT NULL,
	fmt_id integer NOT NULL
)
;

CREATE TABLE MD_Keywords ( 
	id integer DEFAULT nextval('seq_MDKeywords') NOT NULL,
	md_id integer NOT NULL,
	voca_id integer NOT NULL,
	kw_type varchar(32)
)
;

CREATE TABLE Metadata ( 
	id integer DEFAULT nextval('seq_metadata') NOT NULL,
	fileIdentifier varchar(255) NOT NULL,
	title text,
	abstract text,
	metadataType varchar(32),
	resourceIdentifier varchar(255),
	creationDate timestamp,
	revisionDate timestamp,
	modified timestamp,
	publicationDate timestamp,
	url varchar(255),
	alternateTitle varchar(255),
	anyText text,
	language varchar(3),
	hasSecurityConstraints boolean,
	isInspireCompliant boolean,
	parentIdentifier varchar(255),
	version smallint,
	isLastVersion boolean,
	status varchar(32),
	lastModifiedDate timestamp,
	accessConstraints text,
	otherConstraints text,
	classification text,
	conditionApplyingToAccessAndUse text,    --  Concatenationofvalues 
	lineage text,    --  Concatenationofvalues
	hierarchyLevelName varchar(255),
	repositoryPath varchar(255),
	jobId varchar(36),
    originalFolder varchar(255),
    resourcetype varchar(80)
);

SELECT AddGeometryColumn('public', 'metadata','geom',4326,'MULTIPOLYGON',2)
;

ALTER TABLE Metadata ADD CONSTRAINT PK_Metadata
	PRIMARY KEY (id)
;

COMMENT ON COLUMN Metadata.conditionApplyingToAccessAndUse
    IS 'Concatenationofvalues'
;
COMMENT ON COLUMN Metadata.lineage
    IS 'Concatenationofvalues'
;

CREATE TABLE OperatesOn ( 
	datamd_id integer NOT NULL,
	svcmd_id integer NOT NULL,
	name varchar(255)
)
;

CREATE TABLE Relations ( 
	id_src integer NOT NULL,
	id_target integer NOT NULL,
	type bigint NOT NULL
)
;

CREATE TABLE ResponsibleParty ( 
	md_id integer NOT NULL,
	organisationType varchar(32) NOT NULL,
	organisationName varchar(255)
)
;

CREATE TABLE ServiceMetadata ( 
	md_id integer NOT NULL,
	serviceType varchar(20),
	serviceTypeVersion varchar(20),
	operation varchar(50),
	couplingType varchar(15)    --  loose,mixed,tight 
)
;

COMMENT ON COLUMN ServiceMetadata.couplingType
    IS 'loose,mixed,tight'
;

CREATE TABLE Specifications ( 
	id integer DEFAULT nextval ('seq_Specifications') NOT NULL,
	md_id integer NOT NULL,
	title text,
	date timestamp,
	dateType varchar(20),
	degree boolean
)
;

CREATE TABLE Thesaurus ( 
	id integer DEFAULT nextval('seq_thesaurus') NOT NULL,
	name text
)
;

CREATE TABLE Vocabulary ( 
	id integer DEFAULT nextval('seq_vocabulary') NOT NULL,
	urn varchar(255),
	concept varchar(255),
	thesaurus_id integer
)
;

CREATE TABLE Configuration (
    version INTEGER NOT NULL,
    info VARCHAR(4000)
)
;

CREATE TABLE jobstate (
    jobid varchar(36),
    state varchar(36),
    folder varchar(256),
    success integer,
    failure integer
)
;

CREATE TABLE md_anytext(
    md_id integer NOT NULL,
    anytext_vector tsvector,
    CONSTRAINT pk_md_anytext PRIMARY KEY (md_id),
    CONSTRAINT "fk_md_anytext -> metadata" FOREIGN KEY (md_id)
        REFERENCES metadata (id) MATCH SIMPLE
        ON UPDATE CASCADE ON DELETE CASCADE
)
WITH (
    OIDS=FALSE
)
;

--  Create Primary Key Constraints

ALTER TABLE CRS ADD CONSTRAINT PK_CRS 
	PRIMARY KEY (id)
;

ALTER TABLE DataMetadata ADD CONSTRAINT PK_DataMetadata 
	PRIMARY KEY (md_id)
;

ALTER TABLE Denominator ADD CONSTRAINT PK_Denominator 
	PRIMARY KEY (md_id, index)
;

ALTER TABLE Distance ADD CONSTRAINT PK_Distance 
	PRIMARY KEY (md_id, index)
;

ALTER TABLE Format ADD CONSTRAINT PK_Format 
	PRIMARY KEY (id)
;

ALTER TABLE GeographicIdentifier ADD CONSTRAINT PK_GeographicIdentifier 
	PRIMARY KEY (id)
;

ALTER TABLE LocalizedString ADD CONSTRAINT PK_LocalizedString 
	PRIMARY KEY (id)
;

ALTER TABLE MD_Format ADD CONSTRAINT PK_MD_Format 
	PRIMARY KEY (md_id, fmt_id)
;

ALTER TABLE MD_Keywords ADD CONSTRAINT PK_Keywords 
	PRIMARY KEY (id)
;

ALTER TABLE OperatesOn ADD CONSTRAINT PK_OperatesOn
	PRIMARY KEY (datamd_id, svcmd_id)
;

ALTER TABLE Relations ADD CONSTRAINT PK_Relations 
	PRIMARY KEY (id_src, id_target, type)
;

-- Remove the primary key because some metadata has several contact with "pointOfContact" organisationType
-- TODO add a primary key
-- ALTER TABLE ResponsibleParty ADD CONSTRAINT PK_Organisation
--	PRIMARY KEY (md_id, organisationType)
-- ;

ALTER TABLE ServiceMetadata ADD CONSTRAINT PK_ServiceMetadata 
	PRIMARY KEY (md_id)
;

ALTER TABLE Specifications ADD CONSTRAINT PK_Specifications 
	PRIMARY KEY (id)
;

ALTER TABLE Thesaurus ADD CONSTRAINT PK_Thesaurus 
	PRIMARY KEY (id)
;

ALTER TABLE Vocabulary ADD CONSTRAINT PK_Vocabulary 
	PRIMARY KEY (id)
;

ALTER TABLE jobstate ADD CONSTRAINT PK_JobState
    PRIMARY KEY (jobid)
;

--  Create Indexes 

ALTER TABLE CRS
	ADD CONSTRAINT UQ_CRS_id UNIQUE (id)
;

ALTER TABLE DataMetadata
	ADD CONSTRAINT UNDX_DataMetadata_md_id UNIQUE (md_id)
;

ALTER TABLE Format
	ADD CONSTRAINT UNDX_Format_id UNIQUE (id)
;

ALTER TABLE Format
	ADD CONSTRAINT UNDX_Format_name UNIQUE (name)
;

ALTER TABLE GeographicIdentifier
	ADD CONSTRAINT UQ_GeographicIdentifier_id UNIQUE (id)
;

ALTER TABLE MD_Keywords
	ADD CONSTRAINT UQ_MD_Keywords_id UNIQUE (id)
;

ALTER TABLE Metadata
	ADD CONSTRAINT UNDX_resourceIdentifier_version UNIQUE (resourceIdentifier, version)
;

ALTER TABLE Metadata
	ADD CONSTRAINT UNDX_fileIdentifier_version UNIQUE (fileIdentifier, version)
;

ALTER TABLE Metadata
	ADD CONSTRAINT UNDX_Metadata_id UNIQUE (id)
;

ALTER TABLE ServiceMetadata
	ADD CONSTRAINT UNDX_ServiceMetadata_md_id UNIQUE (md_id)
;

ALTER TABLE Specifications
	ADD CONSTRAINT UNDX_Specifications_id UNIQUE (id)
;

ALTER TABLE Thesaurus
	ADD CONSTRAINT UNDX_Thesaurus_id UNIQUE (id)
;

ALTER TABLE Vocabulary
	ADD CONSTRAINT UQ_Vocabulary_id UNIQUE (id)
;

ALTER TABLE Vocabulary
	ADD CONSTRAINT UNDX_Vocabulary_urn UNIQUE (urn)
;

--  Create Foreign Key Constraints 

ALTER TABLE CRS ADD CONSTRAINT FK_CRS_Metadata 
	FOREIGN KEY (md_id) REFERENCES Metadata (id)
ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE DataMetadata ADD CONSTRAINT FK_DataMetadata_Metadata 
	FOREIGN KEY (md_id) REFERENCES Metadata (id)
ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE Denominator ADD CONSTRAINT FK_Denominator_Metadata 
	FOREIGN KEY (md_id) REFERENCES Metadata (id)
ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE Distance ADD CONSTRAINT FK_Distance_Metadata 
	FOREIGN KEY (md_id) REFERENCES Metadata (id)
ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE GeographicIdentifier ADD CONSTRAINT FK_GeographicIdentifier_Metadata 
	FOREIGN KEY (md_id) REFERENCES Metadata (id)
ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE LocalizedString ADD CONSTRAINT FK_LocalizedString_Metadata 
	FOREIGN KEY (md_id) REFERENCES Metadata (id)
ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE MD_Format ADD CONSTRAINT FK_MD_Format_Format 
	FOREIGN KEY (fmt_id) REFERENCES Format (id)
ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE MD_Format ADD CONSTRAINT FK_MD_Format_Metadata 
	FOREIGN KEY (md_id) REFERENCES Metadata (id)
ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE MD_Keywords ADD CONSTRAINT FK_MD_Keywords_Metadata 
	FOREIGN KEY (md_id) REFERENCES Metadata (id)
ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE MD_Keywords ADD CONSTRAINT FK_MD_Keywords_Vocabulary 
	FOREIGN KEY (voca_id) REFERENCES Vocabulary (id)
ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE OperatesOn ADD CONSTRAINT FK_OperatesOn_DataMetadata 
	FOREIGN KEY (datamd_id) REFERENCES DataMetadata (md_id)
ON DELETE RESTRICT ON UPDATE CASCADE
;

ALTER TABLE OperatesOn ADD CONSTRAINT FK_OperatesOn_ServiceMetadata 
	FOREIGN KEY (svcmd_id) REFERENCES ServiceMetadata (md_id)
ON DELETE RESTRICT ON UPDATE CASCADE
;

ALTER TABLE Relations ADD CONSTRAINT FK_Relations_Metadata 
	FOREIGN KEY (id_target) REFERENCES Metadata (id)
;

ALTER TABLE ResponsibleParty ADD CONSTRAINT FK_Organisation_Metadata 
	FOREIGN KEY (md_id) REFERENCES Metadata (id)
ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE ServiceMetadata ADD CONSTRAINT FK_ServiceMetadata_Metadata 
	FOREIGN KEY (md_id) REFERENCES Metadata (id)
ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE Specifications ADD CONSTRAINT FK_Specifications_Metadata 
	FOREIGN KEY (md_id) REFERENCES Metadata (id)
ON DELETE CASCADE ON UPDATE CASCADE
;

ALTER TABLE Vocabulary ADD CONSTRAINT FK_Vocabulary_Thesaurus 
	FOREIGN KEY (thesaurus_id) REFERENCES Thesaurus (id)
ON DELETE CASCADE ON UPDATE CASCADE
;

INSERT INTO Configuration (version) VALUES (20110812)
;