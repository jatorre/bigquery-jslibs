----------------------------
-- Copyright (C) 2021 CARTO
----------------------------

CREATE OR REPLACE FUNCTION @@SF_PREFIX@@h3._TOPARENT
(index STRING, resolution DOUBLE)
RETURNS STRING
LANGUAGE JAVASCRIPT
AS $$
    @@SF_LIBRARY_CONTENT@@

    if (!INDEX)
        return null;
        
    if (!h3.h3IsValid(INDEX))
        return null;

    return h3.h3ToParent(INDEX, Number(RESOLUTION));
$$;

CREATE OR REPLACE SECURE FUNCTION @@SF_PREFIX@@h3.TOPARENT
(index STRING, resolution INT)
RETURNS STRING
AS $$
    @@SF_PREFIX@@h3._TOPARENT(INDEX, CAST(RESOLUTION AS DOUBLE))
$$;
