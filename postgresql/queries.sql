
Steps:

-- Creating 1st Table (poi_latlong):

create Table poi_latlong(
latitude double precision,
longitude double precision,
)

-- Adding geom column:

Alter Table poi_latlong add column geom geometry(POINT,4326)

-- 4326 is SRID - {A spatial reference identifier (SRID) is a unique identifier associated with a specific coordinate system, tolerance, and resolution.}

update poi_latlong set geom = st_setsrid(st_point(longitude,latitude),4326)

-- Creating 2nd Table (driving)

create Table driving (
id integer primary key,
distance text,
time text,
trajectory text
)

-- Changing trajectory column:

ALTER TABLE driving ALTER COLUMN trajectory TYPE Geometry(POINT, 4326) USING ST_SetSRID(trajectory::Geometry,4326);

-- Trajectory points gets converted into LineString geometry type.

-- Experimenting with ST_DWithin:

select st_astext(geom)
from poi_latlong
where st_dwithin(geom, 
				 ST_GeomFromText('POINT(43.741117 -79.520321)', 4326), 0.02) -- takes 0.02 as 2km (is a radius value)


select st_astext(geom_02)
from poi_latlong
where st_dwithin(geom_02, 
				 ST_GeomFromText('POINT(43.737906 -79.505976)', 26918), 0.003) 

-- takes 0.001 as 100m
-- takes 0.01 as 1km

-- Changing SRID doesn't effect specified radius value.

-- Getting points from trajectory LineString:

SELECT ST_AsText(
   ST_PointN(
	  d.trajectory,
	  generate_series(1, ST_NPoints(d.trajectory))
   ))
FROM driving d;

-- Storing points in a table.

SELECT ST_AsText(
   ST_PointN(
	  d.trajectory,
	  generate_series(1, ST_NPoints(d.trajectory))
   )) as TrajPoints
into table traj_point
FROM driving d; 

-- Now using both trajectories {a set of points} and POIs to relate them based on a threshold value.

select st_astext(tr.trajpoints) as t_coordinates, st_astext(p.geom_02) as POI
from traj_point_01 tr, poi_latlong p 
where st_dwithin(tr.trajpoints, p.geom_02, 0.001)

-- 0.001 {100m threshold}

-- Storing Area grid cells:

create table area_grid_cells(
	cell_names text,
	coordinates text
)

-- Changing coordinates column:

ALTER TABLE area_grid_cells ALTER COLUMN coordinates TYPE Geometry(POINT, 4326) USING ST_SetSRID(coordinates::Geometry,4326);



















