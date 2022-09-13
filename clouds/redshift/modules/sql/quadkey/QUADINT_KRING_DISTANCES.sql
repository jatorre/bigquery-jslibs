----------------------------
-- Copyright (C) 2021 CARTO
----------------------------

CREATE OR REPLACE FUNCTION @@RS_SCHEMA@@.__QUADINT_KRING_DISTANCES
(origin BIGINT, size INT)
RETURNS VARCHAR(MAX)
STABLE
AS $$
    from @@RS_LIBRARY@@.quadkey import kring_distances
    import json

    if origin is None or origin <= 0:
        raise Exception('Invalid input origin')

    if size is None or size < 0:
        raise Exception('Invalid input size')

    return json.dumps(kring_distances(origin, size))
$$ LANGUAGE PLPYTHONU;

CREATE OR REPLACE FUNCTION @@RS_SCHEMA@@.QUADINT_KRING_DISTANCES
(BIGINT, INT)
-- (origin, size)
RETURNS SUPER
STABLE
AS $$
    SELECT json_parse(@@RS_SCHEMA@@.__QUADINT_KRING_DISTANCES($1, $2))
$$ LANGUAGE SQL;
