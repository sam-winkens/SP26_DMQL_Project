
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

CREATE TABLE Area ( --represent lapd area
	Area_Cd INT PRIMARY KEY,
	AREA_NAME VARCHAR(100) NOT NULL
);

CREATE TABLE Occurence( -- Holds the date and time combinations for crime occurences
	Occurence_ID BIGINT PRIMARY KEY,
	DATE_OCC DATE NOT NULL,
	TIME_OCC INT NOT NULL
);

CREATE TABLE Weapon_Type ( --Tells us the weapon they used for the crime
	Weapon_Cd INT PRIMARY KEY,
	Weapond_Desc TEXT
);

CREATE TABLE Premises ( --Tells us what type of spot the crime occured 
	Premise_Cd INT PRIMARY KEY,
	Premise_Desc TEXT NOT NULL
);

CREATE TABLE Location (
	Location_ID INT PRIMARY KEY,
	LOCATION VARCHAR(100),
	Cross_Street VARCHAR(100),
	LAT FLOAT,
	LON FLOAT,
	Area_Cd INT NOT NULL,
	FOREIGN KEY (Area_Cd) REFERENCES Area(Area_Cd) ON DELETE RESTRICT
);

CREATE TABLE Crime_Report (
	DR_NO BIGINT PRIMARY KEY,
	Date_Rptd DATE NOT NULL,
	Part_1_2 INT,
	Mocodes VARCHAR(100),
	Rpt_Dist_No INT,
	Occurence_ID BIGINT NOT NULL,
	FOREIGN KEY (Occurence_ID) REFERENCES Occurence(Occurence_ID) ON DELETE RESTRICT,
	Location_ID INT NOT NULL,
	FOREIGN KEY (Location_ID) REFERENCES Location(Location_ID) ON DELETE RESTRICT,
	Victim_ID INT,
	FOREIGN KEY (Victim_ID) REFERENCES Victim_Type(Victim_ID) ON DELETE RESTRICT,
	Crm_Cd INT NOT NULL,
	FOREIGN KEY (Crm_Cd) REFERENCES Crime_Type(Crm_Cd) ON DELETE RESTRICT,
	Weapon_Cd INT,
	FOREIGN KEY (Weapon_Cd) REFERENCES Weapon_Type(Weapon_Cd) ON DELETE RESTRICT,
	Premise_Cd INT NOT NULL,
	FOREIGN KEY (Premise_Cd) REFERENCES Premises(Premise_Cd) ON DELETE RESTRICT,
	Status_Cd CHAR(2) NOT NULL,
	FOREIGN KEY (Status_Cd) REFERENCES Case_Status(Status_Cd) ON DELETE RESTRICT
)