select count(1)
from geocoder
WHERE NOT EXISTS (
    SELECT location
    FROM windsor
    WHERE geocoder.location = windsor.location)
and city = 'windsor'