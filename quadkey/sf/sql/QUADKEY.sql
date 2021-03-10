-----------------------------------------------------------------------
--
-- Copyright (C) 2021 CARTO
--
-----------------------------------------------------------------------

CREATE OR REPLACE FUNCTION @@SF_DATABASEID@@.@@SF_SCHEMA_QUADKEY@@._QUADINT_FROMQUADKEY(quadkey STRING)
    RETURNS DOUBLE
    LANGUAGE JAVASCRIPT
AS $$
    @@WASM_FILE_CONTENTS@@
    
    return quadintFromQuadkey(QUADKEY);
$$;

CREATE OR REPLACE SECURE FUNCTION @@SF_DATABASEID@@.@@SF_SCHEMA_QUADKEY@@.QUADINT_FROMQUADKEY(quadkey STRING)
    RETURNS INT
AS $$
    CAST(@@SF_DATABASEID@@.@@SF_SCHEMA_QUADKEY@@._QUADINT_FROMQUADKEY(QUADKEY) AS INT)
$$;

CREATE OR REPLACE FUNCTION @@SF_DATABASEID@@.@@SF_SCHEMA_QUADKEY@@.QUADKEY_FROMQUADINT(quadint DOUBLE)
    RETURNS STRING
    LANGUAGE JAVASCRIPT
AS $$
    @@WASM_FILE_CONTENTS@@
    
    if(QUADINT == null)
    {
        throw new Error('NULL argument passed to UDF');
    }
    return quadkeyFromQuadint(QUADINT);
$$;

CREATE OR REPLACE SECURE FUNCTION @@SF_DATABASEID@@.@@SF_SCHEMA_QUADKEY@@.QUADKEY_FROMQUADINT(quadint INT)
    RETURNS STRING
AS $$
    @@SF_DATABASEID@@.@@SF_SCHEMA_QUADKEY@@.QUADKEY_FROMQUADINT(CAST(QUADINT AS DOUBLE))
$$;