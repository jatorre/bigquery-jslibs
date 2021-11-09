----------------------------
-- Copyright (C) 2021 CARTO
----------------------------

CREATE OR REPLACE FUNCTION @@SF_PREFIX@@quadkey._KRING
(origin STRING, size DOUBLE)
RETURNS ARRAY
LANGUAGE JAVASCRIPT
IMMUTABLE
AS $$
    if (ORIGIN == null || ORIGIN <= 0) {
        throw new Error('Invalid input origin')
    }

    if (SIZE == null || SIZE < 0) {
        throw new Error('Invalid input size')
    }

    function setup() {
        @@SF_LIBRARY_CONTENT@@
        quadkeyLibGlobal = quadkeyLib;
    }

    if (typeof(quadkeyLibGlobal) === "undefined") {
        setup();
    }

    return quadkeyLibGlobal.kRing(ORIGIN, parseInt(SIZE));
$$;

CREATE OR REPLACE SECURE FUNCTION @@SF_PREFIX@@quadkey.KRING
(origin BIGINT, size INT)
RETURNS ARRAY
IMMUTABLE
AS $$
    @@SF_PREFIX@@quadkey._KRING(CAST(ORIGIN AS STRING), CAST(SIZE AS DOUBLE))
$$;