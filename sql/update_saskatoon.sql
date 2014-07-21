/* Add location column to database */
ALTER TABLE public.regina ADD COLUMN location character varying(256);

/* Add the formatted location */
update regina
set location = "FULLADDRSS" || ', Regina Saskatchewan';

/* Remove Duplicates */
DELETE
FROM regina
WHERE gid IN
	(SELECT gid FROM 
		(SELECT gid, row_number() OVER (PARTITION BY location) AS rnum FROM regina) as t
	WHERE rnum > 1);