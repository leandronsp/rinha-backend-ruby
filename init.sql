-- Create extensions
CREATE EXTENSION IF NOT EXISTS pg_trgm;

-- Create table people
CREATE TABLE IF NOT EXISTS people (
    id UUID PRIMARY KEY,
    nickname VARCHAR(32) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    birth_date DATE NOT NULL,
    stack VARCHAR(1024),
    search VARCHAR(1160) GENERATED ALWAYS AS (
        LOWER(name || ' ' || nickname || ' ' || stack)
    ) STORED
);

-- Create search index
CREATE INDEX people_search_idx ON people USING GIST (search gist_trgm_ops);
