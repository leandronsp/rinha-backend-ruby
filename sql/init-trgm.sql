-- Create extensions
CREATE EXTENSION pg_stat_statements;
CREATE EXTENSION pg_trgm;
CREATE EXTENSION unaccent;

-- Create function array to string immutable
CREATE OR REPLACE FUNCTION array_ts(arr TEXT[])
RETURNS TEXT IMMUTABLE LANGUAGE SQL AS $$
SELECT unaccent(array_to_string(arr, ' ')) $$;

-- Create table people
CREATE TABLE IF NOT EXISTS people (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100),
    nickname VARCHAR(32) UNIQUE,
    birth_date DATE,
    stack VARCHAR(32)[]
);

-- Create search index
CREATE INDEX people_search_idx ON people 
USING GIN (array_ts(stack || ARRAY[name, nickname]) gin_trgm_ops);
