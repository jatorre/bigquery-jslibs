----------------------------
-- Copyright (C) 2022 CARTO
----------------------------

CREATE OR REPLACE FUNCTION @@RS_SCHEMA@@.__QUADBIN_TOZXY_XY_INTERLEAVED5
(BIGINT)
-- (quadbin)
RETURNS BIGINT
STABLE
AS $$
    SELECT ($1 | ($1 >> 16)) & CAST(FROM_HEX('00000000FFFFFFFF') AS BIGINT)
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION @@RS_SCHEMA@@.__QUADBIN_TOZXY_XY_INTERLEAVED4
(BIGINT)
-- (quadbin)
RETURNS BIGINT
STABLE
AS $$
    SELECT @@RS_SCHEMA@@.__QUADBIN_TOZXY_XY_INTERLEAVED5(
        ($1 | ($1 >> 8)) & CAST(FROM_HEX('0000FFFF0000FFFF') AS BIGINT)
        )
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION @@RS_SCHEMA@@.__QUADBIN_TOZXY_XY_INTERLEAVED3
(BIGINT)
-- (quadbin)
RETURNS BIGINT
STABLE
AS $$
    SELECT @@RS_SCHEMA@@.__QUADBIN_TOZXY_XY_INTERLEAVED4(
        ($1 | ($1 >> 4)) & CAST(FROM_HEX('00FF00FF00FF00FF') AS BIGINT)
        )
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION @@RS_SCHEMA@@.__QUADBIN_TOZXY_XY_INTERLEAVED2
(BIGINT)
-- (quadbin)
RETURNS BIGINT
STABLE
AS $$
    SELECT @@RS_SCHEMA@@.__QUADBIN_TOZXY_XY_INTERLEAVED3(
        ($1 | ($1 >> 2)) & CAST(FROM_HEX('0F0F0F0F0F0F0F0F') AS BIGINT)
        )
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION @@RS_SCHEMA@@.__QUADBIN_TOZXY_XY_INTERLEAVED1
(BIGINT)
-- (quadbin)
RETURNS BIGINT
STABLE
AS $$
    SELECT @@RS_SCHEMA@@.__QUADBIN_TOZXY_XY_INTERLEAVED2(
        ($1 | ($1 >> 1)) & CAST(FROM_HEX('3333333333333333') AS BIGINT)
        )
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION @@RS_SCHEMA@@.__QUADBIN_TOZXY_XY_PREINTERLEAVED
(BIGINT)
-- (quadbin)
RETURNS BIGINT
STABLE
AS $$
    SELECT @@RS_SCHEMA@@.__QUADBIN_TOZXY_XY_INTERLEAVED1(
        $1 & CAST(FROM_HEX('5555555555555555') AS BIGINT)
        )
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION @@RS_SCHEMA@@.__QUADBIN_TOZXY_X
(BIGINT)
-- (quadbin)
RETURNS BIGINT
STABLE
AS $$
    SELECT @@RS_SCHEMA@@.__QUADBIN_TOZXY_XY_PREINTERLEAVED(
        ($1 & CAST(FROM_HEX('00FFFFFFFFFFFFF') AS BIGINT)) << 12
        )
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION @@RS_SCHEMA@@.__QUADBIN_TOZXY_Y
(BIGINT)
-- (quadbin)
RETURNS BIGINT
STABLE
AS $$
    SELECT @@RS_SCHEMA@@.__QUADBIN_TOZXY_X($1 >> 1)
$$ LANGUAGE sql;

CREATE OR REPLACE FUNCTION @@RS_SCHEMA@@.QUADBIN_TOZXY
(BIGINT)
-- (quadbin)
RETURNS SUPER
STABLE
AS $$
    SELECT json_parse('{' ||
        '"z": ' || @@RS_SCHEMA@@.QUADBIN_RESOLUTION($1) || ',' ||
        '"x": ' || (@@RS_SCHEMA@@.__QUADBIN_TOZXY_X($1) >> (32 - CAST(@@RS_SCHEMA@@.QUADBIN_RESOLUTION($1) AS INT))) || ',' ||
        '"y": ' || (@@RS_SCHEMA@@.__QUADBIN_TOZXY_Y($1) >> (32 - CAST(@@RS_SCHEMA@@.QUADBIN_RESOLUTION($1) AS INT))) || '}'
        )
$$ LANGUAGE sql;
