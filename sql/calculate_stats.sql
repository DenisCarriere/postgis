SELECT count(1), count(1) * 100.0 / (SELECT count(1) from waterloo), (SELECT count(1) from waterloo)
FROM geocoder
WHERE city='waterloo'
AND distance > 5000
AND provider = 'Bing'