----------------------------
-- Copyright (C) 2021 CARTO
----------------------------

CREATE OR REPLACE FUNCTION @@SF_PREFIX@@s2._ID_FROMHILBERTQUADKEY
(quadkey STRING)
RETURNS STRING
LANGUAGE JAVASCRIPT
IMMUTABLE
AS $$
    if (!QUADKEY) {
        throw new Error('NULL argument passed to UDF');
    }

    function setup() {
        @@SF_LIBRARY_CONTENT@@
        s2LibGlobal = s2Lib;
    }

    if (typeof(s2LibGlobal) === "undefined") {
        setup();
    }

    return s2LibGlobal.keyToId(QUADKEY);
$$;

CREATE OR REPLACE SECURE FUNCTION @@SF_PREFIX@@s2.ID_FROMHILBERTQUADKEY
(quadkey STRING)
RETURNS BIGINT
IMMUTABLE
AS $$
    CAST(@@SF_PREFIX@@s2._ID_FROMHILBERTQUADKEY(QUADKEY) AS BIGINT)
$$;