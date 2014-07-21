/* Add location column to database */
ALTER TABLE public.burlington ADD COLUMN location character varying(256);


/* Add the formatted location */
update burlington
set location = "ADDRESS" || ', Burlington Ontario';

/* Remove Duplicates */
DELETE
FROM burlington
WHERE gid IN
	(SELECT gid FROM 
		(SELECT gid, row_number() OVER (PARTITION BY location) AS rnum FROM burlington) as t
	WHERE rnum > 1)