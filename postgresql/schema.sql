
-- creating person id table with unique ID's
-- Unique IDs are generated by using pandas uuid library
-- there limit is calculated by scanning total number of rows in the trajectory.csv file
create table Person_ID (
	P_ID text primary key
)

-- creating POI table with unique id retrieved from .json files
-- This unique id is provided by google places api
		   
create table POI(
	p_id text primary key,
	latitude double precision,
	longitude double precision
)
-- Adding geom column to store latitude and longitude as geometry type
alter table poi add column geom geometry(POINT,4326)

update poi set geom = st_setsrid(st_point(latitude, longitude), 4326)

-- Creating table for bicycling trajectory data.

 create table bicycling_traj (
 	id_no integer primary key, 
 	total_distance text, 
 	travel_time text, 
 	trajectory_path text references poi(p_id)
 )
 
-- Adding a geom column to store trajectories as geometry type
 
alter table bicycling_traj add column geom geometry(LINESTRING, 4326)
  
-- stroing trajectory data as geometry LINESTRING type. 
 update bicycling_traj set geom = st_setsrid(ST_GeomFromText(concat('LINESTRING', 
            regexp_replace(trajectory_path, '(\[|\])','', 'g'))), 4326)


			
-- From the python code we divide the area into specified grids
-- Creating area grid table to store grid coordinates

create table area_grid_cells(
	cell_names text,
	coordinates text
)

-- Converting coordinates column into POLYGON geometry type (not working yet)  
ALTER TABLE area_grid_cells ALTER COLUMN coordinates TYPE Geometry(POLYGON, 4326) 
USING ST_SetSRID(ST_GeomFromText(concat('POLYGON', 
           regexp_replace(coordinates, '(\[|\])','', 'g'))), 4326);			
			
			
-- Generating points from the trajectory linestring data so that
-- I can compare them with area grid coordinates. 
-- Using ST_Within I can check which points are inside the grid and associate them with the grid. 
http://postgis.net/workshops/postgis-intro/spatial_relationships.html

SELECT ST_AsText(
   ST_PointN(
	  t.trajectory,
	  generate_series(1, ST_NPoints(d.trajectory))
   )) as TrajPoints
into table traj_point
FROM traj_table t; 			
















			