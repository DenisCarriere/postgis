----------------
-- REFERENCES --
----------------

-- OpenGIS Consortium Standards
-- http://postgis.net/docs/manual-2.0/PostGIS_FAQ.html
-- http://www.opengeospatial.org/standards/sfs
-- International Standards SQL 92 & OGC-SFS
-- Great Circle Mapper || http://gc.kls2.com/cgi-bin/gc?PATH=SEA-LHR

-----------------
-- PROJECTIONS --
-----------------

-- WGS84: 4326
-- NAD83: 4269

--------------
-- GEOMETRY --
--------------

-- POINT(0 0)
-- POINTZ(0 0 0)
-- LINESTRING(0 0,1 1,1 2)
-- POLYGON((0 0,4 0,4 4,0 4,0 0),(1 1, 2 1, 2 2, 1 2,1 1))
-- MULTIPOINT(0 0,1 2)
-- MULTILINESTRING((0 0,1 1,1 2),(2 3,3 2,5 4))
-- MULTIPOLYGON(((0 0,4 0,4 4,0 4,0 0),(1 1,2 1,2 2,1 2,1 1)), ((-1 -1,-1 -2,-2 -2,-2 -1,-1 -1)))
-- GEOMETRYCOLLECTION(POINT(2 3),LINESTRING(2 3,3 4))

---------------
-- ACCRONYMS --
---------------

-- OGC-SFS (Open Geospatial Consortium - Simple Feature Specification)
-- SQL-92 (Structured Query Language)
-- ODBC (Open Database Connectivity)
-- API (Application Programming Interface)
-- RDBMS (Relational Database Management System)
-- WKB (Well-Known Binary)
-- WKT (Well-Known Text)
-- EWKT (Extended WKT)

-----------
-- TABLE --
-----------

CREATE TABLE gtest(
    gid serial PRIMARY KEY,
    geom geography(POINT, 4326)
);

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

------------
-- INSERT --
------------

INSERT INTO points(name, geom)
    VALUES('Denis', ST_GeomFromText('POINT(-71.060316 48.432044)', 4326));

INSERT INTO gtest
    VALUES (3, 'First Geometry', ST_GeomFromText('LINESTRING(2 3,4 5,6 5,7 8)'));

-----------
-- INDEX --
-----------

CREATE INDEX gtest_index ON gtest USING GIST (geom);
VACUUM ANALYZE;

---------------
-- FUNCTIONS --
---------------

-- ST_Distance() ST_MaxDistance()
-- ST_Intersects(), ST_Contains() and ST_Within()
-- ST_Transform()

------------
-- SELECT --
------------

-- 2D Point (lng/lat) - (x/y)
SELECT ST_AsText('POINT(0 0'::geography);


-- 3D Point with Elevation
SELECT ST_AsText('POINT(1 1 5)'::geography) AS pointz;


-- 3D Point with Elevation & Measurement
SELECT ST_AsText('POINT(1 1 5 10)'::geography) AS pointzm;


-- Calculate Distance in meters between two points
-- Boolean True = Uses WGS84 Spheroid
-- Boolean False = Uses World Sphere, faster calculations, less accurate
SELECT ST_Distance(point1, point2, true) AS distance
FROM (SELECT
  'POINT(0 0)'::geography AS point1,
  'POINT(1 1)'::geography AS point2) AS foo;


-- Calculates the Distance between a Line to a Point
SELECT ST_Distance(
    'LINESTRING(0 0, 5 5)'::geography,
    'POINT(3 3)'::geography);


-- Does this Polygon contain this point
SELECT point
FROM (SELECT
    'POINT(5 5)'::geography AS point,
    'POLYGON((0 0,0 10,10 10,10 0,0 0))'::geography AS poly) AS foo
WHERE ST_Contains(poly, point);


-- Is Point within this Polygon
SELECT point
FROM (SELECT
    'POINT(5 5)'::geography AS point,
    'POLYGON((0 0,0 10,10 10,10 0,0 0))'::geography AS poly) AS foo
WHERE ST_Within(point, poly);


-- Is Point within a Radius of another Point
SELECT point
FROM (SELECT
    'POINT(5 5)'::geography AS point,
    'POINT(3 3)'::geography AS center) AS foo
WHERE ST_DWithin(point, center, 3.0);


-- WGS84 Data to Nad83
SELECT ST_Transform(point, 4269)
FROM (SELECT
    'POINT(0 0)':geography AS point) AS Foo;


-- Select only points that have a distance between them by 1000 meters
SELECT ST_Distance(point1, point2) as distance
FROM (SELECT
    'POINT(0 0)'::geography as point1,
    'POINT(1 1)'::geography as point2) AS Foo
WHERE ST_Distance(point1, point2) > 1000


-- Normalize Address
SELECT * FROM  normalize_address('1552 Payette drive Ottawa ON');
SELECT * FROM  normalize_address('K1E1S9');

-- Fuzzy Matching
SELECT soundex('Three'), soundex('Tree'), difference('Three', 'Tree');

-- Index using GIST
CREATE INDEX kingston_location_index ON kingston USING GIST(location)

-- Search Postal Codes
select kingston.location, postal.fsa
from kingston, postal
WHERE ST_Contains(postal.geom, kingston.geom)