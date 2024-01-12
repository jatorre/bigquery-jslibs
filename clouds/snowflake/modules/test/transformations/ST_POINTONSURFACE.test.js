const { runQuery } = require('../../../common/test-utils');

test('ST_POINTONSURFACE should work', async () => {
    const query = `SELECT @@SF_SCHEMA@@.ST_POINTONSURFACE(TO_GEOGRAPHY('MULTIPOLYGON ( (( 1.432239 38.774949 ,  1.430004 38.776613 ,  1.429594 38.779004 ,  1.429017 38.780159 ,  1.427593 38.781527 ,  1.425098 38.782440 ,  1.423667 38.782105 ,  1.423500 38.780778 ,  1.421648 38.780213 ,  1.420044 38.778803 ,  1.419783 38.779692 ,  1.419998 38.780884 ,  1.418469 38.782359 ,  1.417274 38.784848 ,  1.417280 38.785641 ,  1.418790 38.786572 ,  1.419115 38.787496 ,  1.420219 38.788078 ,  1.422245 38.790701 ,  1.422430 38.792226 ,  1.421102 38.794001 ,  1.419421 38.794483 ,  1.419112 38.794921 ,  1.420578 38.795797 ,  1.421985 38.797293 ,  1.424319 38.796379 ,  1.425594 38.795468 ,  1.424784 38.794619 ,  1.424858 38.793340 ,  1.426658 38.791067 ,  1.428010 38.789823 ,  1.428901 38.787502 ,  1.429748 38.786711 ,  1.430096 38.785544 ,  1.430951 38.785375 ,  1.431356 38.784263 ,  1.431377 38.781200 ,  1.431665 38.780104 ,  1.431531 38.778868 ,  1.432695 38.777271 ,  1.432404 38.776888 ,  1.433254 38.775386 ,  1.432239 38.774949)), (( 1.479401 38.788441 ,  1.477737 38.789852 ,  1.477167 38.791727 ,  1.476344 38.792537 ,  1.475231 38.795045 ,  1.474967 38.796087 ,  1.474324 38.796538 ,  1.474129 38.799221 ,  1.475761 38.800972 ,  1.477059 38.804368 ,  1.477770 38.805054 ,  1.478568 38.804866 ,  1.477156 38.801982 ,  1.477438 38.800634 ,  1.479283 38.799423 ,  1.481316 38.799135 ,  1.481027 38.798076 ,  1.479663 38.797248 ,  1.478855 38.796246 ,  1.478892 38.794525 ,  1.479432 38.794064 ,  1.479328 38.791900 ,  1.479850 38.789546 ,  1.479401 38.788441)))')) as centerOfMass1,
    @@SF_SCHEMA@@.ST_POINTONSURFACE(TO_GEOGRAPHY('POLYGON ((1.444057 38.791203 ,  1.450457 38.793763 ,  1.457178 38.792403 ,  1.458298 38.781282 ,  1.453418 38.778242 ,  1.445977 38.780482 ,  1.453498 38.781042 ,  1.456218 38.786883 ,  1.450617 38.790643 ,  1.444057 38.791203))')) as centerOfMass2`;
    const rows = await runQuery(query);
    expect(rows.length).toEqual(1);
    expect(JSON.stringify(rows[0].POINTONSURFACE1)).toEqual('{"coordinates":[1.430951,38.785375],"type":"Point"}');
    expect(JSON.stringify(rows[0].POINTONSURFACE2)).toEqual('{"coordinates":[1.456218,38.786883],"type":"Point"}');
});

test('ST_POINTONSURFACE should return NULL if any NULL mandatory argument', async () => {
    const query = 'SELECT ST_POINTONSURFACE(NULL) as centerofmass1';
    const rows = await runQuery(query);
    expect(rows.length).toEqual(1);
    expect(rows[0].POINTONSURFACE1).toEqual(null);
});
