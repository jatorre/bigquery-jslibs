----------------------------
-- Copyright (C) 2021 CARTO
----------------------------

CREATE OR REPLACE SECURE FUNCTION @@SF_SCHEMA@@.QUADINT_TOZXY
(quadint BIGINT)
RETURNS OBJECT
IMMUTABLE
AS $$
    OBJECT_CONSTRUCT(
        'z', BITAND(QUADINT, 31),
        'x', BITAND(BITSHIFTRIGHT(QUADINT, 5), BITSHIFTLEFT(1, BITAND(QUADINT, 31)) - 1),
        'y', BITSHIFTRIGHT(QUADINT, 5 + BITAND(QUADINT, 31)))
$$;
