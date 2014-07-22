SELECT count(1), count(1) * 100.0 / (SELECT count(1) from toronto), (SELECT count(1) from toronto)
FROM geocoder
WHERE city='toronto'
AND distance > 5000
AND provider = 'Bing'