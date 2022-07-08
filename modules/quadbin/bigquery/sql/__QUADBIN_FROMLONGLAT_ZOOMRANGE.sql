---------------------------
-- Copyright (C) 2022 CARTO
----------------------------

CREATE OR REPLACE FUNCTION `@@BQ_PREFIX@@carto.__QUADBIN_FROMLONGLAT_ZOOMRANGE`
(longitude FLOAT64, latitude FLOAT64, zoom_min INT64, zoom_max INT64, zoom_step INT64, resolution INT64)
RETURNS ARRAY<STRUCT<id INT64, z INT64, x INT64, y INT64>>
AS ((
    WITH quadbins AS (
        SELECT 
            `@@BQ_PREFIX@@carto.QUADBIN_FROMLONGLAT`(longitude, latitude, z + resolution) as qb_agg,
            `@@BQ_PREFIX@@carto.QUADBIN_FROMLONGLAT`(longitude, latitude, z) as qb
        FROM UNNEST(GENERATE_ARRAY(zoom_min, zoom_max, zoom_step)) AS z
    ), tiles AS (
        SELECT qb_agg AS id, `carto-un`.carto.QUADBIN_TOZXY(qb) AS tile
        FROM quadbins
    )
    SELECT ARRAY_AGG(
            STRUCT(
                id,
                tile.z, tile.x, tile.y
            )
        )
    FROM tiles
));