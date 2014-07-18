SELECT count(1)/41601.0 * 100 FROM geocoder
WHERE city='kingston'
AND distance > 5000
AND provider = 'Bing'