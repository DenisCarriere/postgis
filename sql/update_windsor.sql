/* Add location column to database */
ALTER TABLE public.windsor ADD COLUMN location character varying(256);

/* Add the formatted location */
update windsor
set location = "ADD_RANGE" || ', Windsor Ontario';

/* Remove Duplicates */
DELETE
FROM windsor
WHERE gid IN
	(SELECT gid FROM 
		(SELECT gid, row_number() OVER (PARTITION BY location) AS rnum FROM windsor) as t
	WHERE rnum > 1);