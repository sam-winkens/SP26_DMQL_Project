CREATE OR REPLACE FUNCTION valid_age() --function that makes sure victim ages is between 0 and 120
RETURNS TRIGGER AS $$
BEGIN 
	IF NEW.Vict_Age < 0 THEN 
		RAISE EXCEPTION 'Cannot have victim age be less than 0';
	END IF;
	IF NEW.Vict_Age > 120 THEN 
		RAISE EXCEPTION 'Cannot have victim age be greater than 120';
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_age --Trigger that runs before insertion in victim table that uses above function to make sure age is valid
BEFORE INSERT ON Victim_Type
FOR EACH ROW
EXECUTE FUNCTION valid_age();


BEGIN;

INSERT INTO Victim_Type(Vict_Age, Vict_Sex, Vict_Descent) VALUES (67, 'M', 'I'); --valid

INSERT INTO Victim_Type(Vict_Age, Vict_Sex, Vict_Descent) VALUES (-420, 'M', 'W'); --invalid

COMMIT; --Does not commit the valid one either because in the transaction one of them raises an exception