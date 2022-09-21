----------------------------
-- Copyright (C) 2021 CARTO
----------------------------

CREATE OR REPLACE FUNCTION @@SF_SCHEMA@@._S2_FROMHILBERTQUADKEY
(quadkey STRING)
RETURNS STRING
LANGUAGE JAVASCRIPT
IMMUTABLE
AS $$
    if (!QUADKEY) {
        throw new Error('NULL argument passed to UDF');
    }

    @@SF_LIBRARY_S2@@

    return s2Lib.keyToId(QUADKEY);
$$;

CREATE OR REPLACE SECURE FUNCTION @@SF_SCHEMA@@.S2_FROMHILBERTQUADKEY
(quadkey STRING)
RETURNS BIGINT
IMMUTABLE
AS $$
    CAST(@@SF_SCHEMA@@._S2_FROMHILBERTQUADKEY(QUADKEY) AS BIGINT)
$$;
