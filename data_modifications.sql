--Creating fake victim

INSERT INTO Victim_Type(Vict_Age, Vict_Sex, Vict_Descent) VALUES (21, 'M', 'W');

--Creating a fake occurence
INSERT INTO Occurence (DATE_OCC, TIME_OCC) VALUES (DATE '2026-04-29', 0015);

--Creating a fake area
INSERT INTO Area (Area_Cd, AREA_NAME) VALUES (67, 'Buffalo');

--Creating a location for this crime
INSERT INTO Location(LOCATION, Cross_Street, LAT, LON, Area_Cd) VALUES ('600 Herron Dr', NULL, 34.134, -12.3442, 67);

--Creating the crime report using this information
INSERT INTO Crime_Report (DR_NO, Date_Rptd, Part_1_2, Mocodes, Rpt_Dist_No, Occurence_ID, Location_ID, Victim_ID, Crm_Cd, Weapon_Cd, Premise_Cd, Status_Cd)
VALUES(69, DATE '2026-04-29', 1,'420', 72, 21, 20, 21, 230, 400, 103, 'IC');

CREATE OR REPLACE PROCEDURE UpdateReportStatus( --This procedure will let a user update the status of a case when it changes
	new_dr_no BIGINT,
	new_status CHAR(2)
)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE Crime_Report
	SET Status_CD = new_status
	WHERE DR_NO = new_dr_no; 
END;
$$;

--call the procedure to update the status for the fake data we created
CALL UpdateReportStatus(69, 'AA');

select * from Crime_Report;

--Delete the fake data we just made to test delete
Delete from Crime_Report where dr_no=69;
