 create table poi_new_york(
  	poi_id text primary key,  this key is fetched from the data retrieved from Google Places API.
  	geom_point geometry  I'm adding POINT inside the datasets using python script. Just mentioning it as "geometry(POINT, 4326)" doesn't work.
 )

 update poi_new_york set geom_point = st_setsrid(geom_point, 4326)

 create table real_traj (
  	traj_id serial primary key,  
 	traj_path geometry  Adding LINESTRING in the data column through notepad++
  )

 update real_traj set traj_path = st_setsrid(traj_path, 4326) 

create table cells_new_york (
	cell_id serial primary key,  changed to serial in cell_01
	grid_id float references grids(grid_id),
	cell_names text,
	coordinates geometry  -- Creating POLYGON geometry: need to specify first and last coordinate same for each of them. 
)

update cells_new_york set coordinates = st_setsrid(coordinates, 4326) 


  SELECT traj_id, cell_id, cell_names into table traj_as_cells_new_york
  FROM   (
    SELECT tr.traj_id, ce.cell_id, ce.cell_names, ce.grid_id, 
           ST_LineLocatePoint(tr.traj_path, ST_Centroid(ce.coordinates)) AS frac
    FROM   cells_new_york AS ce
    JOIN   real_traj AS tr
      ON   ST_Intersects(ce.coordinates, tr.traj_path)
  	where ce.grid_id = 1225
  ) q
  ORDER BY
         frac
  ; 


-- cell_poi_new_york contains cell ids and poi ids for the POIs that are inside cell coordinates.

 select c.cell_id, p.poi_id into table cell_poi_new_york
   from poi_new_york p, cells_new_york c
   where st_within(p.geom_point, c.coordinates) and grid_id = 1225
   
   
-- Getting the above cell coordinates that contains POI. (Doing visualization)
 
select cp.cell_id, st_astext(cn.coordinates)
	from cell_poi_new_york cp, cells_new_york cn
	where cp.cell_id = cn.cell_id
	

-- Getting poi's value from poi_new_york based on their ids from cell_poi_new_york 

select cp.poi_id, st_astext(pn.geom_point)
	from cell_poi_new_york cp, poi_new_york pn
	where cp.poi_id = pn.poi_id

-- Storing traj_id and poi_id based on if they are part of the same cell.
	
select tn.traj_id, cp.poi_id into table traj_as_poi_new_york
	from traj_as_cells_new_york tn, cell_poi_new_york cp
	where tn.cell_id = cp.cell_id 	
	
	
	
	
	
	
	
