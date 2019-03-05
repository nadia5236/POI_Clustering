

-- Generating points from the trajectory linestring data so that
-- I can compare them with cells coordinates. 
-- Using ST_Within I can check which points are inside the grid cells and associate them with the cell. 
http://postgis.net/workshops/postgis-intro/spatial_relationships.html

SELECT ST_AsText(
   ST_PointN(
	  t.trajectory,
	  generate_series(1, ST_NPoints(d.trajectory))
   )) as TrajPoints
into table traj_point
FROM traj_table t; 			

-- experitmenting with st_within, to check points which are inside grid cells. To eventually store the cells and points in a seperate table.

-- putting data into new table to test

select st_astext(coordinates) as cell, st_astext(geom_point) as poi 
into table test_st_within_grid_02 
from cells, poi
limit 50


-- fixing polygon issues. first & last element of polygon should be same.

UPDATE public.cells
	SET grid_id=null, cell_names=null, coordinates=null;
	
-- Deleting previous data

DELETE FROM public.cells;

-- Imported data already, now setting srid.

update cells set coordinates = st_setsrid(coordinates, 4326)

-- inserted new stuff inside grid table.

INSERT INTO public.grids(
	grid_id, x_dim, y_dim)
	VALUES (108.0,2,3);

	
-- Retrieving points that are inside grid cells and associating them. 

select st_astext(geom_point), st_astext(coordinates)
	from cells, poi
	where st_within(geom_point, coordinates) 
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	