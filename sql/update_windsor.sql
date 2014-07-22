/* Add location column to database */
ALTER TABLE public.windsor ADD COLUMN location character varying(256);

/* Modifify the Suffix Column */
update windsor
set "SUFFIX"='ST'
where "STREET" = 'LAURENDEAU';

update windsor
set "ADD_RANGE" = "ADD_NUMBER" || ' ' || "STREET" || ' ' || "SUFFIX"
where "STREET" = 'LAURENDEAU';

update windsor
set "ADD_RANGE" = "ADD_NUMBER" || ' ' || "STREET"
where "SUFFIX" is NULL;

/* Remove Data set that contains ; or multiple ,

?? UNKNOWN CODE - Did it in QuantumGIS

*/

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