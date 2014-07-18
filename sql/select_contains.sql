SELECT count(1) geocoder
WHERE NOT ST_Contains((SELECT geom FROM bbox WHERE city='ottawa'), geom)
AND city = 'ottawa'