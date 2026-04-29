CREATE OR REPLACE PROCEDURE UpdateReportStatus( --This procedure will let a user update the status of a case when it changes
	new_dr_no BIGINT,
	new_status CHAR(2)
)
LANGUAGE plqsql
AS $$
BEGIN
	UPDATE Crime_Report
	SET Status_CD = new_status
	WHERE DR_NO = new_dr_no; 
END;
$$;