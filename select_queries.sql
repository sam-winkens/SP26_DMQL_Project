-- Query 1: This query returns the 5 most recent crime reports by occurence with area and location names
SELECT CR.DR_NO, O.DATE_OCC, A.AREA_NAME, L.LOCATION, CT.Crm_Cd_Desc
FROM Crime_Report CR
JOIN Occurence O ON CR.Occurence_ID = O.Occurence_ID
JOIN Location L ON CR.Location_ID = L.Location_ID
JOIN Area A ON L.Area_Cd = A.Area_Cd
JOIN Crime_Type CT ON CR.Crm_Cd = CT.Crm_Cd
ORDER BY O.DATE_OCC DESC, O.TIME_OCC DESC
LIMIT 5;

-- Query 2: This query returns the area code and area name of the places we deem have relatively high crime rates
SELECT AREA_NAME, Area_Cd
FROM Area
WHERE Area_Cd IN (
    SELECT L.Area_Cd
    FROM Crime_Report CR
    JOIN Location L ON CR.Location_ID = L.Location_ID
    GROUP BY L.Area_Cd
    HAVING COUNT(*) > 2
);

-- Query 3: This query returns the total number of incidents for every type of location defined in our database
SELECT P.Premise_Desc, COUNT(CR.DR_NO) AS Total_Crimes
FROM Crime_Report CR
JOIN Premises P ON CR.Premise_Cd = P.Premise_Cd
GROUP BY P.Premise_Desc
ORDER BY Total_Crimes DESC;

-- Query 4: This query ranks the most common combinations...
SELECT 
    CT.Crm_Cd_Desc AS Crime_Type, 
    WT.Weapon_Desc AS Weapon_Involved, 
    COUNT(*) AS Incident_Count
FROM Crime_Report CR
JOIN Crime_Type CT ON CR.Crm_Cd = CT.Crm_Cd
JOIN Weapon_Type WT ON CR.Weapon_Cd = WT.Weapon_Cd
GROUP BY CT.Crm_Cd_Desc, WT.Weapon_Desc
ORDER BY Incident_Count DESC
LIMIT 5;