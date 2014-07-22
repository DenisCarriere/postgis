/* Add location column to database */
ALTER TABLE public.saskatoon ADD COLUMN location character varying(256);

/* Add the formatted location */
update saskatoon
set location = "Name";

/* Remove Duplicates */
DELETE
FROM saskatoon
WHERE gid IN
	(SELECT gid FROM 
		(SELECT gid, row_number() OVER (PARTITION BY location) AS rnum FROM saskatoon) as t
	WHERE rnum > 1);