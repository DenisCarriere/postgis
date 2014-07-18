UPDATE geocoder
SET y = To_Number(data->>'lat', '999.99999')