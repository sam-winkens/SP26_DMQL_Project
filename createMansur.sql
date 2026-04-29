CREATE TABLE Area ( --represent lapd area
	Area_Cd INT PRIMARY KEY,
	AREA_NAME VARCHAR(100) NOT NULL
)

CREATE TABLE Occurence( -- Holds the date and time combinations for crime occurences
	Occurence_ID BIGINT PRIMARY KEY,
	DATE_OCC DATE NOT NULL,
	TIME_OCC INT NOT NULL
)

CREATE TABLE Weapon_Type ( --Tells us the weapon they used for the crime
	Weapon_Cd INT PRIMARY KEY,
	Weapond_Desc TEXT
)

CREATE TABLE Premises ( --Tells us what type of spot the crime occured 
	Premise_Cd INT PRIMARY KEY,
	Premise_Desc TEXT NOT NULL
)