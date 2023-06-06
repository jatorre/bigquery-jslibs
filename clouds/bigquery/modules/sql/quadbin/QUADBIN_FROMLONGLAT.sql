----------------------------
-- Copyright (C) 2022 CARTO
----------------------------

CREATE OR REPLACE FUNCTION `@@BQ_DATASET@@.QUADBIN_FROMLONGLAT`
(longitude FLOAT64, latitude FLOAT64, resolution INT64)
RETURNS INT64
AS ((
    IF(longitude IS NULL OR latitude IS NULL OR resolution IS NULL,
        NULL,
        IF(resolution < 0 OR resolution > 26,
            ERROR('Invalid resolution; should be between 0 and 26'), (
                WITH
                __params AS (
                    select
                        longitude,
                        resolution AS z,
                        (1 << resolution) AS __z2,
                        ACOS(-1) AS pi,
                        GREATEST(-85.05, LEAST(85.05, latitude)) AS latitude
                    from __values
                ),

                ___sinlat AS (
                    select SIN(latitude * pi / 180.0) as __sinlat from __params
                ),

                ___x AS (
                    SELECT
                        CAST(
                            -- floor before cast to avoid up rounding to the next tile
                            FLOOR(
                                __z2 * ((longitude / 360.0) + 0.5)
                            ) AS INT64
                        ) & (__z2 - 1)  -- bitwise way to calc MOD
                        AS __x
                    FROM
                        __params
                ),

                __zxy AS (
                    SELECT
                        z,
                        CASE
                            WHEN __x < 0 THEN __x + __z2
                            ELSE __x
                        END AS x,
                        CAST(
                            -- floor before cast to avoid up rounding to the next tiLe
                            FLOOR(
                                __z2 * (
                                    0.5 - 0.25 * 
                                    LN(
                                        (1 + __sinlat) / (1 - __sinlat)
                                    ) / pi
                                )
                            ) AS int64
                        ) AS y
                    FROM
                        __params,
                        ___sinlat,
                        ___x

                )

                SELECT `@@BQ_DATASET@@.QUADBIN_FROMZXY`(
                        z, x, y
                    )
                FROM __zxy)
        )
    )
));
