CREATE TABLE Victim_Type ( --Stores demographic information for victim
	Victim_ID INT PRIMARY KEY,
	Vict_Age INT,
	Vict_Sex VARCHAR(1),
	Vict_Descent VARCHAR(1)
);

CREATE TABLE Crime_Type ( --Classifies the type of crime committed
	Crm_Cd INT PRIMARY KEY,
	Crm_Cd_Desc TEXT NOT NULL,
	Crm_Cd_1 INT NOT NULL, 
    Crm_Cd_2 INT, 
    Crm_Cd_3 INT,
    Crm_Cd_4 INT
);

CREATE TABLE Case_Status( --Tracks the current status of the criminal case
	Status_Cd CHAR(2) PRIMARY KEY,
	Status_Desc VARCHAR(100) NOT NULL
);

