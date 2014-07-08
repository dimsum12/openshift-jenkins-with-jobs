SELECT AddGeometryColumn('','cave_1910_rgf93g','the_geom','2154','MULTIPOLYGON',2);
CREATE INDEX "cave_1910_rgf93g_the_geom_gist" ON "cave_1910_rgf93g" using gist ("the_geom" gist_geometry_ops);
