----------------------------
-- Copyright (C) 2021 CARTO
----------------------------

CREATE OR REPLACE SECURE FUNCTION @@SF_PREFIX@@constructors._BEZIERSPLINE
(geojson STRING, resolution DOUBLE, sharpness DOUBLE)
RETURNS STRING
LANGUAGE JAVASCRIPT
AS $$
    @@SF_LIBRARY_CONTENT@@

    if (!GEOJSON) {
        return null;
    }
    const options = {};
    if (RESOLUTION != null) {
        options.resolution = Number(RESOLUTION);
    }
    if (SHARPNESS != null) {
        options.sharpness = Number(SHARPNESS);
    }
    const curved = constructorsLib.bezierSpline(JSON.parse(GEOJSON), options);
    return JSON.stringify(curved.geometry);
$$;

CREATE OR REPLACE FUNCTION @@SF_PREFIX@@constructors.ST_BEZIERSPLINE
(geog GEOGRAPHY)
RETURNS GEOGRAPHY
AS $$
    TO_GEOGRAPHY(@@SF_PREFIX@@constructors._BEZIERSPLINE(CAST(ST_ASGEOJSON(GEOG) AS STRING), NULL, NULL))
$$;

CREATE OR REPLACE FUNCTION @@SF_PREFIX@@constructors.ST_BEZIERSPLINE
(geog GEOGRAPHY, resolution INT)
RETURNS GEOGRAPHY
AS $$
    TO_GEOGRAPHY(@@SF_PREFIX@@constructors._BEZIERSPLINE(CAST(ST_ASGEOJSON(GEOG) AS STRING), CAST(RESOLUTION AS DOUBLE), NULL))
$$;

CREATE OR REPLACE FUNCTION @@SF_PREFIX@@constructors.ST_BEZIERSPLINE
(geog GEOGRAPHY, resolution INT, sharpness DOUBLE)
RETURNS GEOGRAPHY
AS $$
    TO_GEOGRAPHY(@@SF_PREFIX@@constructors._BEZIERSPLINE(CAST(ST_ASGEOJSON(GEOG) AS STRING), CAST(RESOLUTION AS DOUBLE), SHARPNESS))
$$;
