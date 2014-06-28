INSERT INTO point(location, provider, address, x, y, distance, geom)
SELECT
	p1.location as location,
	'MapQuest',
	'None',
	ST_Y(p1.geom) as y,
	ST_X(p1.geom) as x,
	99999999,
	p1.geom as geom
FROM kingston as p1
WHERE NOT EXISTS (
    SELECT location
    FROM geocoder as p2
    WHERE p1.location = p2.location AND
    p2.provider = 'Google')