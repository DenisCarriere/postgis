/* Add location column to database */
ALTER TABLE public.york ADD COLUMN location character varying(256);

/* Remove Zero Street address */
DELETE
from york
where "ADDRESS_NU" is Null;

/* Add the formatted location */
update york
set location = "FULL_CIVIC" || ', ' || "MUNICIPALI" || ' Ontario';

/* Remove Duplicates */
DELETE
FROM york
WHERE gid IN
	(SELECT gid FROM 
		(SELECT gid, row_number() OVER (PARTITION BY location) AS rnum FROM york) as t
	WHERE rnum > 1);