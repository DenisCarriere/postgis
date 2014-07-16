DELETE FROM geocoder
WHERE gid IN
	(SELECT gid FROM 
		(SELECT gid, location, row_number() OVER (PARTITION BY location) AS rnum FROM geocoder) as t
	WHERE rnum > 1)