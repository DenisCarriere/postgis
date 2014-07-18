UPDATE geocoder as g
SET city = 'kingston'
FROM kingston
WHERE kingston.location = g.location