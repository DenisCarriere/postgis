delete
from geocoder
WHERE NOT EXISTS (
    SELECT location
    FROM toronto
    WHERE geocoder.location = toronto.location)
and city = 'toronto'