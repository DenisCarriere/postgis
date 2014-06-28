COPY (

SELECT 
	p1.location as location,
	p2.provider as provider,
	p2.address as address,
	ST_Y(p1.geom) as y,
	ST_X(p1.geom) as x,
	ST_Distance(p1.geom, p2.geom, true) as distance
FROM kingston AS p1
LEFT OUTER JOIN geocoder as p2 ON p1.location = p2.location

) to 'C:/tmp/Kingston Geocoding - MapQuest Errors NOT FOUND.csv' WITH CSV HEADER