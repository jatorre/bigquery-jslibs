----------------------------
-- Copyright (C) 2021 CARTO
----------------------------

CREATE OR REPLACE SECURE FUNCTION ST_DELAUNAYPOLYGONS
(points ARRAY)
RETURNS ARRAY
IMMUTABLE
AS $$(
    SELECT ARRAY_AGG(ST_ASGEOJSON(ST_MAKEPOLYGON(TO_GEOGRAPHY(unnested.VALUE)))::STRING)
    FROM LATERAL FLATTEN(input => __DELAUNAYHELPER(points)) AS unnested
)$$;