----------------------------
-- Copyright (C) 2021 CARTO
----------------------------

CREATE OR REPLACE FUNCTION @@RS_PREFIX@@s2.LONGLAT_ASID(
    longitude FLOAT,
    latitude FLOAT,
    resolution INTEGER
) 
RETURNS INT8
IMMUTABLE
AS $$
    from @@RS_PREFIX@@s2Lib import longlat_as_int64_id
    
    return longlat_as_int64_id(longitude, latitude, resolution)
    
$$ LANGUAGE plpythonu;
