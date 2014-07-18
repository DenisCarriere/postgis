UPDATE waterloo
SET location = "CIVIC_ADDR" || ', ' || "DISTRICT" || ', Waterloo Ontario';
UPDATE waterloo
SET location = "CIVIC_ADDR" || ', Waterloo Ontario'
WHERE "DISTRICT" is NULL;