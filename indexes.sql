--Problematic Query 1: Searching by occurence date
--Searching for crimes on a specific date will eventually slow down by reading every single row.
EXPLAIN SELECT * FROM Occurence WHERE DATE_OCC = '2026-01-01';

--Create the b-tree index for the DATE_OCC column on the occurence table
CREATE INDEX idx_occurence_date ON Occurence(DATE_OCC);


--Problematic Query 2: Doing one big crime reports join on Areas table
--Dealing with a huge temporary hash table in memory?
EXPLAIN SELECT A.AREA_NAME, COUNT(*) 
FROM Crime_Report CR
JOIN Location L ON CR.Location_ID = L.Location_ID
JOIN Area A ON L.Area_Cd = A.Area_Cd
GROUP BY A.AREA_NAME;

--We create b-tree index for the foreign keys 
CREATE INDEX idx_report_location ON Crime_Report(Location_ID);
CREATE INDEX idx_location_area ON Location(Area_Cd);


--Problematic Query 3: Identifying Crimes Involving a Specific Weapon
--Searching the largest table for a specific weapon signature
EXPLAIN SELECT * FROM Crime_Report WHERE Weapon_Cd = 101;

--Creating an index on the Weapon_Cd foreign key
CREATE INDEX idx_report_weapon ON Crime_Report(Weapon_Cd);