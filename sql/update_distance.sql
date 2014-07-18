UPDATE geocoder
SET distance = ST_Distance(geom, ST_GeomFromText(wkt, 4326), True)