/* Add location column to database */
ALTER TABLE public.hamilton ADD COLUMN location character varying(256);

/* Add the formatted location */
update hamilton
set location = "STREET_NUM" || ' ' || "NAME" || ' ' || "SUFFIX" || ', ' || "DISTRICT" || ' Ontario'

/* Remove 0 routes */
delete 
FROM hamilton
WHERE "STREET_NUM" = 0

/* Remove Duplicates */
DELETE
FROM hamilton
WHERE gid IN
	(SELECT gid FROM 
		(SELECT gid, row_number() OVER (PARTITION BY location) AS rnum FROM hamilton) as t
	WHERE rnum > 1);