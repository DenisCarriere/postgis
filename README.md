# Postgis Geo Cookbook

A collection of snippets and best practices for using PostGIS.

## Select

Select feature that does not exists in database
```sql
SELECT location
FROM kingston
WHERE NOT EXISTS (
    SELECT location
    FROM geocoder
    WHERE kingston.location = geocoder.location AND
    geocoder.provider = 'Bing')
```

Cross Join
```sql
SELECT count(*)
FROM kingston as p1
CROSS JOIN (SELECT provider FROM geocoder GROUP by provider) AS p2 
```

Remove Duplicate
```sql
DELETE FROM tablename
WHERE id IN (SELECT id
              FROM (SELECT id,
                             row_number() over (partition BY column1, column2, column3 ORDER BY id) AS rnum
                     FROM tablename) t
              WHERE t.rnum > 1);
```


Make a line from two points
```sql
DELETE FROM lines;

INSERT INTO lines (provider, location, address, geom, distance)
SELECT p1.provider, p2.location, p1.address, ST_MakeLine(ST_Union(p1.geom),ST_Centroid(ST_Union(p2.geom))), ST_Length(ST_MakeLine(ST_Union(p1.geom),ST_Centroid(ST_Union(p2.geom))), True)
FROM geocoder as p1
LEFT JOIN kingston as p2
ON p1.location = p2.location
GROUP BY p1.provider, p2.location, p1.address
```

Copy a select to CSV document
```sql
COPY (

SELECT line.address as address, line.location as location, ST_X(kingston.geom) as x, ST_Y(kingston.geom) as y, line.distance as distance
FROM line
LEFT JOIN kingston
ON line.location = kingston.location
WHERE provider = 'OSM' and distance > 200

) to 'C:/tmp/Kingston Geocoding - OSM Errors 200m.csv' WITH CSV HEADER
```

Copy a selection which does not exists to CSV document
```sql
COPY (

SELECT location, ST_X(kingston.geom) as x, ST_Y(kingston.geom) as y
FROM kingston
WHERE NOT EXISTS (
    SELECT location
    FROM geocoder
    WHERE kingston.location = geocoder.location AND
    geocoder.provider = 'MapQuest')

) to 'C:/tmp/Kingston Geocoding - MapQuest Errors NOT FOUND.csv' WITH CSV HEADER
```

Copy a selection with a distance greater than 200m
```sql
COPY (

SELECT line.address as address, line.location as location, ST_X(kingston.geom) as x, ST_Y(kingston.geom) as y, line.distance as distance
FROM line
LEFT JOIN kingston
ON line.location = kingston.location
WHERE provider = 'Google' and distance > 200

) to 'C:/tmp/Kingston Geocoding - Google Errors 200m.csv' WITH CSV HEADER
```

Select the postal code from a single point
```sql
select kingston.location, postal.fsa
from kingston, postal
WHERE ST_Contains(postal.geom, kingston.geom)
```

Select the greatest distance between multiple points
```sql
SELECT p1.provider, p1.name, SUM(ST_Distance(p1.geom, p2.geom, true)) as distance
FROM location as p1
LEFT JOIN location as p2
ON p1.name = p2.name and p1.provider <> p2.provider
GROUP BY p1.provider, p1.name
ORDER BY distance
```

Fix issue when sequence is not working, skips next value
```sql
SELECT max(gid) FROM geocoder LIMIT 1;

SELECT nextval('geocoder_template_gid_seq');
```

2D Point as Lat & Lng
```sql
SELECT ST_AsText('POINT(0 0'::geography);
```

3D Point with Elevation
```sql
SELECT ST_AsText('POINT(1 1 5)'::geography) AS pointz;
```

3D Point with Elevation & Measurement
```sql
SELECT ST_AsText('POINT(1 1 5 10)'::geography) AS pointzm;
```

Calculate Distance in meters between two points
* Boolean True = Uses WGS84 Spheroid
* Boolean False = Uses World Sphere, faster calculations, less accurate

```sql
SELECT ST_Distance(point1, point2, true) AS distance
FROM (SELECT
  'POINT(0 0)'::geography AS point1,
  'POINT(1 1)'::geography AS point2) AS foo;
```

Calculates the Distance between a Line to a Point
```sql
SELECT ST_Distance(
    'LINESTRING(0 0, 5 5)'::geography,
    'POINT(3 3)'::geography);
```

Does this Polygon contain this point
```sql
SELECT point
FROM (SELECT
    'POINT(5 5)'::geography AS point,
    'POLYGON((0 0,0 10,10 10,10 0,0 0))'::geography AS poly) AS foo
WHERE ST_Contains(poly, point);
```

Is Point within this Polygon
```sql
SELECT point
FROM (SELECT
    'POINT(5 5)'::geography AS point,
    'POLYGON((0 0,0 10,10 10,10 0,0 0))'::geography AS poly) AS foo
WHERE ST_Within(point, poly);
```

Is Point within a Radius of another Point
```sql
SELECT point
FROM (SELECT
    'POINT(5 5)'::geography AS point,
    'POINT(3 3)'::geography AS center) AS foo
WHERE ST_DWithin(point, center, 3.0);
```

WGS84 Data to Nad83
```sql
SELECT ST_Transform(point, 4269)
FROM (SELECT
    'POINT(0 0)':geography AS point) AS Foo;
```

Distance between greater than 1000 meters
```sql
SELECT ST_Distance(point1, point2) as distance
FROM (SELECT
    'POINT(0 0)'::geography as point1,
    'POINT(1 1)'::geography as point2) AS Foo
WHERE ST_Distance(point1, point2) > 1000
```

Normalize Address
```sql
SELECT * FROM  normalize_address('1552 Payette drive Ottawa ON');
SELECT * FROM  normalize_address('K1E1S9');
```

Fuzzy Matching
```sql
SELECT soundex('Three'), soundex('Tree'), difference('Three', 'Tree');
```

Index using GIST
```sql
CREATE INDEX kingston_location_index ON kingston USING GIST(location)
```

Search Postal Codes
```sql
select kingston.location, postal.fsa
from kingston, postal
WHERE ST_Contains(postal.geom, kingston.geom)
```

## Table

```sql
CREATE TABLE gtest(
    gid serial PRIMARY KEY,
    geom geography(POINT, 4326)
);
```

```sql
CREATE TABLE toronto(
    id int,
    x real,
    y real,
    geom geography(POINT, 4326),
    street_number int,
    street_name varchar(80),
    street_suffix varchar(10),
    street_side varchar(2)
);
```
```sql
CREATE TABLE toronto_google(
    id int,
    x real,
    y real,
    geom geography(POINT, 4326),
    street_number int,
    street_name varchar(80),
    types varchar(20),
    location_type varchar(20)
);
```

## Insert

```sql
INSERT INTO points(name, geom)
    VALUES('Denis', ST_GeomFromText('POINT(-71.060316 48.432044)', 4326));
```

```sql
INSERT INTO gtest
    VALUES (3, 'First Geometry', ST_GeomFromText('LINESTRING(2 3,4 5,6 5,7 8)'));
```

## Index

```sql
CREATE INDEX gtest_index ON gtest USING GIST (geom);
VACUUM ANALYZE;
```

## Functions

* ST_Distance()
* ST_MaxDistance()
* ST_Intersects()
* ST_Contains()
* ST_Within()
* ST_Transform()

## Geometry Types

* POINT(0 0)
* POINTZ(0 0 0)
* LINESTRING(0 0,1 1,1 2)
* POLYGON((0 0,4 0,4 4,0 4,0 0),(1 1, 2 1, 2 2, 1 2,1 1))
* MULTIPOINT(0 0,1 2)
* MULTILINESTRING((0 0,1 1,1 2),(2 3,3 2,5 4))
* MULTIPOLYGON(((0 0,4 0,4 4,0 4,0 0),(1 1,2 1,2 2,1 2,1 1)), ((-1 -1,-1 -2,-2 -2,-2 -1,-1 -1)))
* GEOMETRYCOLLECTION(POINT(2 3),LINESTRING(2 3,3 4))

## Projections

- WGS84 => EPSG:4326
- NAD83 => EPSG:4269
- Web Mercator => EPSG:3857

## References

* OpenGIS Consortium Standards
* [PostGIS manual](http://postgis.net/docs/manual-2.0/PostGIS_FAQ.html)
* [Open Geospatial standards](http://www.opengeospatial.org/standards/sfs)
* International Standards SQL 92 & OGC-SFS
* [Great Circle Mapper](http://gc.kls2.com/cgi-bin/gc?PATH=SEA-LHR)

## Accronyms

* OGC-SFS (Open Geospatial Consortium - Simple Feature Specification)
* SQL-92 (Structured Query Language)
* ODBC (Open Database Connectivity)
* API (Application Programming Interface)
* RDBMS (Relational Database Management System)
* WKB (Well-Known Binary)
* WKT (Well-Known Text)
* EWKT (Extended WKT)
