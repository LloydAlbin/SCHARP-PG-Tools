
CREATE SCHEMA IF NOT EXISTS tools;

GRANT USAGE ON SCHEMA tools TO PUBLIC;

CREATE OR REPLACE FUNCTION tools.to_text(hexval bytea) RETURNS text AS $$
    SELECT convert_from($1,(SELECT pg_encoding_to_char(encoding) FROM pg_database WHERE datname = current_database()));
$$ LANGUAGE sql IMMUTABLE RETURNS NULL ON NULL INPUT;

GRANT EXECUTE ON FUNCTION tools.to_text(hexval bytea) TO PUBLIC;

CREATE OR REPLACE FUNCTION tools.to_text(hexval bytea, encoding name) RETURNS text AS $$
    SELECT convert_from($1, encoding);
$$ LANGUAGE sql IMMUTABLE RETURNS NULL ON NULL INPUT;

GRANT EXECUTE ON FUNCTION tools.to_text(hexval bytea, encoding name) TO PUBLIC;

CREATE OR REPLACE FUNCTION tools.to_name(hexval bytea) RETURNS name AS $$
    SELECT convert_from($1,(SELECT pg_encoding_to_char(encoding) FROM pg_database WHERE datname = current_database()));
$$ LANGUAGE sql IMMUTABLE RETURNS NULL ON NULL INPUT;

GRANT EXECUTE ON FUNCTION tools.to_name(hexval bytea) TO PUBLIC;

CREATE OR REPLACE FUNCTION tools.to_name(hexval bytea, encoding name) RETURNS name AS $$
    SELECT convert_from($1, encoding);
$$ LANGUAGE sql IMMUTABLE RETURNS NULL ON NULL INPUT;

GRANT EXECUTE ON FUNCTION tools.to_name(hexval bytea, encoding name) TO PUBLIC;

CREATE OR REPLACE FUNCTION tools.to_varchar(hexval bytea) RETURNS varchar AS $$
    SELECT convert_from($1,(SELECT pg_encoding_to_char(encoding) FROM pg_database WHERE datname = current_database()));
$$ LANGUAGE sql IMMUTABLE RETURNS NULL ON NULL INPUT;

GRANT EXECUTE ON FUNCTION tools.to_varchar(hexval bytea) TO PUBLIC;

CREATE OR REPLACE FUNCTION tools.to_varchar(hexval bytea, encoding name) RETURNS varchar AS $$
    SELECT convert_from($1, encoding);
$$ LANGUAGE sql IMMUTABLE RETURNS NULL ON NULL INPUT;

GRANT EXECUTE ON FUNCTION tools.to_varchar(hexval bytea, encoding name) TO PUBLIC;

CREATE OR REPLACE FUNCTION tools.to_boolean(hexval bytea) RETURNS boolean AS $$
    SELECT right($1::TEXT,-3)::boolean;
$$ LANGUAGE sql IMMUTABLE RETURNS NULL ON NULL INPUT;

GRANT EXECUTE ON FUNCTION tools.to_boolean(hexval bytea) TO PUBLIC;

CREATE OR REPLACE FUNCTION tools.to_int(hexval bytea) RETURNS integer AS $$
DECLARE
    result  int;
BEGIN
    EXECUTE E'SELECT x''' || right(hexval::TEXT,-2) || E'''::int' INTO result;
    RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE STRICT;

GRANT EXECUTE ON FUNCTION tools.to_int(hexval bytea) TO PUBLIC;

CREATE OR REPLACE FUNCTION tools.to_bigint(hexval bytea) RETURNS bigint AS $$
DECLARE
    result  bigint;
BEGIN
    EXECUTE E'SELECT x''' || right(hexval::TEXT,-2) || E'''::bigint' INTO result;
    RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE STRICT;

GRANT EXECUTE ON FUNCTION tools.to_bigint(hexval bytea) TO PUBLIC;

CREATE OR REPLACE FUNCTION tools.to_int(hexval varchar) RETURNS integer AS $$
DECLARE
    result  int;
BEGIN
    EXECUTE E'SELECT x''' || hexval || E'''::int' INTO result;
    RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE STRICT;

GRANT EXECUTE ON FUNCTION tools.to_int(hexval varchar) TO PUBLIC;


CREATE OR REPLACE FUNCTION tools.to_bigint(hexval varchar) RETURNS bigint AS $$
DECLARE
    result  bigint;
BEGIN
    EXECUTE E'SELECT x''' || hexval || E'''::bigint' INTO result;
    RETURN result;
END;
$$ LANGUAGE plpgsql IMMUTABLE STRICT;

GRANT EXECUTE ON FUNCTION tools.to_bigint(hexval varchar) TO PUBLIC;


CREATE OR REPLACE FUNCTION tools.to_int (chartoconvert varchar)
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

GRANT EXECUTE ON FUNCTION tools.to_int (chartoconvert varchar) TO PUBLIC;

CREATE OR REPLACE FUNCTION tools.to_numeric (chartoconvert varchar)
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

GRANT EXECUTE ON FUNCTION tools.to_numeric (chartoconvert varchar) TO PUBLIC;

CREATE OR REPLACE FUNCTION tools.to_int (chartoconvert text)
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

GRANT EXECUTE ON FUNCTION tools.to_int (chartoconvert text) TO PUBLIC;

CREATE OR REPLACE FUNCTION tools.to_numeric (chartoconvert text)
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

GRANT EXECUTE ON FUNCTION tools.to_numeric (chartoconvert text) TO PUBLIC;

CREATE OR REPLACE FUNCTION tools.update_query_with_parameters (
  query text,
  parameter text []
)
RETURNS text AS
$body$
DECLARE
  return_query TEXT;
  array_len INTEGER;
BEGIN
    return_query = query;
    IF return_query IS NULL THEN
        RETURN NULL;
    ELSIF parameter IS NULL THEN
        RETURN return_query;
    ELSE
        array_len = array_length(parameter, 1);

        FOR i IN 1..array_len LOOP
            return_query = regexp_replace(return_query, '\$' || i || '([^0-9]|$)', quote_nullable(parameter[i]) || E'\\1', 'g');
        END LOOP; 

        RETURN return_query;
    END IF;
END;
$body$
LANGUAGE 'plpgsql'
VOLATILE
CALLED ON NULL INPUT
SECURITY INVOKER;

GRANT EXECUTE ON FUNCTION tools.update_query_with_parameters (query text, parameter text[]) TO PUBLIC;

