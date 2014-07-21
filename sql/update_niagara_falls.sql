/* Add location column to database */
ALTER TABLE public.niagara_falls ADD COLUMN location character varying(256);

/* Remove 0 routes */
delete 
FROM niagara_falls
WHERE "Street_No" is NULL;

/* Add the formatted location */
update niagara_falls
set location = "ADDRESS" || ', Niagara Falls Ontario';

/* Remove Duplicates */
DELETE
FROM niagara_falls
WHERE gid IN
	(SELECT gid FROM 
		(SELECT gid, row_number() OVER (PARTITION BY location) AS rnum FROM niagara_falls) as t
	WHERE rnum > 1);