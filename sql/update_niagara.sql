/* Add location column to database */
ALTER TABLE public.niagara ADD COLUMN location character varying(256);

/* Remove 0 routes */
delete 
FROM niagara
WHERE "Full_Stree" = '0';

/* Add the formatted location */
update niagara
set location = "Full_Stree" || ' ' || "StreetName" || ' ' || "StreetType" || ', ' || "Municipali" || ' Ontario';

update niagara
set location = "Full_Stree" || ' ' || "StreetName" || ', ' || "Municipali" || ' Ontario'
WHERE "StreetType" is NULL;

/* Remove Duplicates */
DELETE
FROM niagara
WHERE gid IN
	(SELECT gid FROM 
		(SELECT gid, row_number() OVER (PARTITION BY location) AS rnum FROM niagara) as t
	WHERE rnum > 1);