-- complain if script is sourced in psql, rather than via CREATE EXTENSION
\echo Use "CREATE EXTENSION [ IF NOT EXISTS ] scharp_pg_@extschema@ WITH SCHEMA @extschema@ [ CASCADE ]" to load this file. \quit

CREATE SCHEMA IF NOT EXISTS @extschema@;

GRANT USAGE ON SCHEMA @extschema@ TO PUBLIC;

CREATE OR REPLACE FUNCTION @extschema@.to_boolean(hexval bytea) RETURNS boolean AS $$
    SELECT right($1::TEXT,-3)::boolean;
$$ LANGUAGE sql IMMUTABLE RETURNS NULL ON NULL INPUT;

GRANT EXECUTE ON FUNCTION @extschema@.to_boolean(hexval bytea) TO PUBLIC;

CREATE OR REPLACE FUNCTION @extschema@.to_int(hexval bytea) RETURNS integer AS $$
DECLARE
    result  int;
BEGIN
    EXECUTE E'SELECT x''' || right(hexval::TEXT,-2) || E'''::int' INTO result;
    RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE STRICT;

GRANT EXECUTE ON FUNCTION @extschema@.to_int(hexval bytea) TO PUBLIC;

CREATE OR REPLACE FUNCTION @extschema@.to_bigint(hexval bytea) RETURNS bigint AS $$
DECLARE
    result  bigint;
BEGIN
    EXECUTE E'SELECT x''' || right(hexval::TEXT,-2) || E'''::bigint' INTO result;
    RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE STRICT;

GRANT EXECUTE ON FUNCTION @extschema@.to_bigint(hexval bytea) TO PUBLIC;

CREATE OR REPLACE FUNCTION @extschema@.to_int(hexval varchar) RETURNS integer AS $$
DECLARE
    result  int;
BEGIN
    EXECUTE E'SELECT x''' || hexval || E'''::int' INTO result;
    RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE STRICT;

GRANT EXECUTE ON FUNCTION @extschema@.to_int(hexval varchar) TO PUBLIC;


CREATE OR REPLACE FUNCTION @extschema@.to_bigint(hexval varchar) RETURNS bigint AS $$
DECLARE
    result  bigint;
BEGIN
    EXECUTE E'SELECT x''' || hexval || E'''::bigint' INTO result;
    RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE STRICT;

GRANT EXECUTE ON FUNCTION @extschema@.to_bigint(hexval varchar) TO PUBLIC;


CREATE OR REPLACE FUNCTION @extschema@.to_int (chartoconvert varchar)
RETURNS integer AS
$body$
SELECT CASE WHEN trim(chartoconvert) SIMILAR TO '[0-9,]+' 
        THEN CAST(trim(REPLACE(chartoconvert,',','')) AS integer) 
    ELSE NULL END;
$body$
LANGUAGE 'sql'
IMMUTABLE
RETURNS NULL ON NULL INPUT
SECURITY INVOKER;

GRANT EXECUTE ON FUNCTION @extschema@.to_int (chartoconvert varchar) TO PUBLIC;

CREATE OR REPLACE FUNCTION @extschema@.to_numeric (chartoconvert varchar)
RETURNS numeric AS
$body$
SELECT CASE WHEN trim($1) SIMILAR TO '[0-9,.-]+' 
        THEN CAST(trim(REPLACE($1,',','')) AS numeric) 
    ELSE NULL END;
$body$
LANGUAGE 'sql'
IMMUTABLE
RETURNS NULL ON NULL INPUT
SECURITY INVOKER;

GRANT EXECUTE ON FUNCTION @extschema@.to_numeric (chartoconvert varchar) TO PUBLIC;

CREATE OR REPLACE FUNCTION @extschema@.to_int (chartoconvert text)
RETURNS integer AS
$body$
SELECT CASE WHEN trim($1) SIMILAR TO '[0-9,]+' 
        THEN CAST(trim(REPLACE($1,',','')) AS integer) 
    ELSE NULL END;
$body$
LANGUAGE 'sql'
IMMUTABLE
RETURNS NULL ON NULL INPUT
SECURITY INVOKER;

GRANT EXECUTE ON FUNCTION @extschema@.to_int (chartoconvert text) TO PUBLIC;

CREATE OR REPLACE FUNCTION @extschema@.to_numeric (chartoconvert text)
RETURNS numeric AS
$body$
SELECT CASE WHEN trim($1) SIMILAR TO '[0-9,.-]+' 
        THEN CAST(trim(REPLACE($1,',','')) AS numeric) 
    ELSE NULL END;
$body$
LANGUAGE 'sql'
IMMUTABLE
RETURNS NULL ON NULL INPUT
SECURITY INVOKER;

GRANT EXECUTE ON FUNCTION @extschema@.to_numeric (chartoconvert text) TO PUBLIC;
