SET NAMES 'LATIN9';
--
-- SET NAMES 'LATIN9';
--
start transaction;
--Pseudo classe d'objets tronçon de route pour coder le lien inter-lots
--
create table TRONROUT (gid SERIAL not null, CLEABS varchar(24) not null, constraint TRONROUT_pkey primary key (gid));
--
--Pseudo classe d'objets PAI équipement pour coder le lien inter-lots
--
create table EQUADMIL (gid SERIAL not null, CLEABS varchar(24) not null, constraint EQUADMIL_pkey primary key (gid));
--
--Pseudo classe d'objets PAI culture pour coder le lien inter-lots
--
create table CULTLOIS (gid SERIAL not null, CLEABS varchar(24) not null, constraint CULTLOIS_pkey primary key (gid));
--
--Pseudo classe d'objets PAI science pour coder le lien inter-lots
--
create table SCIENENS (gid SERIAL not null, CLEABS varchar(24) not null, constraint SCIENENS_pkey primary key (gid));
--
--Pseudo classe d'objets PAI eau pour coder le lien inter-lots
--
create table GESTEAUX (gid SERIAL not null, CLEABS varchar(24) not null, constraint GESTEAUX_pkey primary key (gid));
--
--Pseudo classe d'objets PAI industrie pour coder le lien inter-lots
--
create table INDUSCOM (gid SERIAL not null, CLEABS varchar(24) not null, constraint INDUSCOM_pkey primary key (gid));
--
--Pseudo classe d'objets PAI religieux pour coder le lien inter-lots
--
create table RELIGIE (gid SERIAL not null, CLEABS varchar(24) not null, constraint RELIGIE_pkey primary key (gid));
--
--Pseudo classe d'objets PAI santé pour coder le lien inter-lots
--
create table SANTE (gid SERIAL not null, CLEABS varchar(24) not null, constraint SANTE_pkey primary key (gid));
--
--Pseudo classe d'objets PAI sport pour coder le lien inter-lots
--
create table SPORT (gid SERIAL not null, CLEABS varchar(24) not null, constraint SPORT_pkey primary key (gid));
--
--Pseudo classe d'objets PAI transport pour coder le lien inter-lots
--
create table TRANSPOR (gid SERIAL not null, CLEABS varchar(24) not null, constraint TRANSPOR_pkey primary key (gid));
--
--Pseudo classe d'objets PAI habitation pour coder le lien inter-lots
--
create table ZONEHABI (gid SERIAL not null, CLEABS varchar(24) not null, constraint ZONEHABI_pkey primary key (gid));
--
--Pseudo classe d'objets PAI hydrographie pour coder le lien inter-lots
