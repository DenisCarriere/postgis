delete
FROM waterloo
WHERE gid IN
	(SELECT gid FROM 
		(SELECT gid, row_number() OVER (PARTITION BY location) AS rnum 
		FROM waterloo) as t
	WHERE rnum > 1
	)