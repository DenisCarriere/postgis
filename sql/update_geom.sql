UPDATE geocoder as g
SET geom = ottawa.geom
FROM ottawa
WHERE ottawa.location = g.location