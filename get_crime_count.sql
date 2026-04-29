--This will be our function requirement and the user could utilize this function to get the total amount of crimes given an input area name.

CREATE OR REPLACE FUNCTION GetTotalCrimesByArea(p_area_name VARCHAR)
RETURNS INTEGER AS $$
DECLARE
    crime_count INTEGER;
BEGIN
    SELECT COUNT(CR.DR_NO) INTO crime_count
    FROM Crime_Report CR
    JOIN Location L ON CR.Location_ID = L.Location_ID
    JOIN Area A ON L.Area_Cd = A.Area_Cd
    WHERE A.AREA_NAME = p_area_name;

    RETURN crime_count;
END;
$$ LANGUAGE plpgsql;

select GetTotalCrimesByArea('N Hollywood');