--
--
--
--
--
ALTER TABLE test OWNER TO testeur;
GRANT ALL ON TABLE test TO testeur;
GRANT SELECT ON TABLE test TO testeur;
--
GRANT ALL ON SCHEMA test TO testeur;
COMMENT ON SCHEMA test IS 'Standard public schema';
--
CREATE ROLE testeur LOGIN
  NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE;
--
ALTER TABLE test OWNER TO testeur;
