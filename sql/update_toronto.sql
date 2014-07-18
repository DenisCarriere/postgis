UPDATE toronto
SET location = "ADDRESS" || ' ' || "LFNAME"  || ', ' || "MUN_NAME" || ', Toronto Ontario';
UPDATE toronto
SET location = "ADDRESS" || ' ' || "LFNAME"  || ', Toronto Ontario'
WHERE "MUN_NAME" is NULL;