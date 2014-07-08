--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

-- SET search_path = admindata_temp, pg_catalog;

-- -- SET default_tablespace = '';

SET default_with_oids = true;

--
-- Name: rgp_geoportail_metro; Type: TABLE; Schema: admindata_temp; Owner: visiteur; Tablespace: 
--

CREATE TABLE rgp_geoportail_metro (
    identifiant oid,
    type text,
    pictogramme text,
    url text,
    x double precision,
    y double precision,
    territoire text,
    postgis_geom_wgs84 geometry
);


-- ALTER TABLE admindata_temp.rgp_geoportail_metro OWNER TO visiteur;

--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database dump
--

SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

-- SET search_path = admindata_temp, pg_catalog;

