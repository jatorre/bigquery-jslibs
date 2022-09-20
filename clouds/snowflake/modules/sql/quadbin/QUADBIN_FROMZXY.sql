----------------------------
-- Copyright (C) 2022 CARTO
----------------------------

CREATE OR REPLACE FUNCTION @@SF_SCHEMA@@._QUADBIN_FROMZXY
(z DOUBLE, x DOUBLE, y DOUBLE)
RETURNS STRING
LANGUAGE JAVASCRIPT
IMMUTABLE
AS $$

    @@SF_LIBRARY_QUADBIN@@

    const tile = {
        z: Number(Z),
        x: Number(X),
        y: Number(Y)
    };

    return quadbinLib.tileToQuadbin(tile);
$$;

CREATE OR REPLACE FUNCTION @@SF_SCHEMA@@.QUADBIN_FROMZXY
(z INT, x INT, y INT)
RETURNS BIGINT
IMMUTABLE
AS $$
    @@SF_SCHEMA@@._QUADBIN_STRING_TOINT(
       @@SF_SCHEMA@@._QUADBIN_FROMZXY(Z, X, Y)
    )
$$;
