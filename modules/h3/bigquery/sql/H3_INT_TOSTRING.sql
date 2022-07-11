CREATE OR REPLACE FUNCTION `@@BQ_PREFIX@@carto.H3_INT_TOSTRING`
(
  h3 INT64
)
RETURNS STRING
AS (
  FORMAT('%x', h3)
);