SELECT count(1), count(1) * 100.0 / (SELECT count(1) from kingston)
FROM geocoder
WHERE city='kingston'
AND distance > 200
AND provider = 'Bing'