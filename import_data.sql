CREATE TABLE staging_crime_data (
    "DR_NO" TEXT,
    "Date Rptd" TEXT,
    "DATE OCC" TEXT,
    "TIME OCC" TEXT,
    "AREA" TEXT,
    "AREA NAME" TEXT,
    "Rpt Dist No" TEXT,
    "Part 1-2" TEXT,
    "Crm Cd" TEXT,
    "Crm Cd Desc" TEXT,
    "Mocodes" TEXT,
    "Vict Age" TEXT,
    "Vict Sex" TEXT,
    "Vict Descent" TEXT,
    "Premis Cd" TEXT,
    "Premis Desc" TEXT,
    "Weapon Used Cd" TEXT,
    "Weapon Desc" TEXT,
    "Status" TEXT,
    "Status Desc" TEXT,
    "Crm Cd 1" TEXT,
    "Crm Cd 2" TEXT,
    "Crm Cd 3" TEXT,
    "Crm Cd 4" TEXT,
    "LOCATION" TEXT,
    "Cross Street" TEXT,
    "LAT" TEXT,
    "LON" TEXT
);

DELETE FROM staging_crime_data
WHERE "AREA" = 'AREA'
   OR "DR_NO" = 'DR_NO';

SELECT "DR_NO", "AREA", "AREA NAME"
FROM staging_crime_data
LIMIT 10;

INSERT INTO Area (Area_Cd, AREA_NAME)
SELECT DISTINCT
    NULLIF("AREA", '')::INT,
    NULLIF("AREA NAME", '')
FROM staging_crime_data
WHERE NULLIF("AREA", '') IS NOT NULL
ON CONFLICT (Area_Cd) DO NOTHING;

INSERT INTO Case_Status (Status_Cd, Status_Desc)
SELECT DISTINCT
    NULLIF("Status", ''),
    NULLIF("Status Desc", '')
FROM staging_crime_data
WHERE NULLIF("Status", '') IS NOT NULL
ON CONFLICT (Status_Cd) DO NOTHING;

INSERT INTO Weapon_Type (Weapon_Cd, Weapon_Desc)
SELECT DISTINCT
    NULLIF("Weapon Used Cd", '')::INT,
    NULLIF("Weapon Desc", '')
FROM staging_crime_data
WHERE NULLIF("Weapon Used Cd", '') IS NOT NULL
ON CONFLICT (Weapon_Cd) DO NOTHING;

INSERT INTO Premises (Premise_Cd, Premise_Desc)
SELECT DISTINCT
    NULLIF("Premis Cd", '')::INT,
    COALESCE(NULLIF("Premis Desc", ''), 'Unknown')
FROM staging_crime_data
WHERE NULLIF("Premis Cd", '') IS NOT NULL
ON CONFLICT (Premise_Cd) DO NOTHING;

INSERT INTO Crime_Type (
    Crm_Cd,
    Crm_Cd_Desc,
    Crm_Cd_1,
    Crm_Cd_2,
    Crm_Cd_3,
    Crm_Cd_4
)
SELECT DISTINCT ON (NULLIF("Crm Cd", '')::INT)
    NULLIF("Crm Cd", '')::INT,
    NULLIF("Crm Cd Desc", ''),
    COALESCE(NULLIF("Crm Cd 1", '')::INT, NULLIF("Crm Cd", '')::INT),
    NULLIF("Crm Cd 2", '')::INT,
    NULLIF("Crm Cd 3", '')::INT,
    NULLIF("Crm Cd 4", '')::INT
FROM staging_crime_data
WHERE NULLIF("Crm Cd", '') IS NOT NULL
ORDER BY NULLIF("Crm Cd", '')::INT
ON CONFLICT (Crm_Cd) DO NOTHING;

INSERT INTO Occurence (DATE_OCC, TIME_OCC)
SELECT DISTINCT
    TO_TIMESTAMP(NULLIF("DATE OCC", ''), 'MM/DD/YY HH24:MI')::DATE,
    NULLIF("TIME OCC", '')::INT
FROM staging_crime_data
WHERE NULLIF("DATE OCC", '') IS NOT NULL
  AND NULLIF("TIME OCC", '') IS NOT NULL;

INSERT INTO Victim_Type (Vict_Age, Vict_Sex, Vict_Descent)
SELECT DISTINCT
    NULLIF("Vict Age", '')::INT,
    NULLIF("Vict Sex", ''),
    NULLIF("Vict Descent", '')
FROM staging_crime_data;

INSERT INTO Location (
    LOCATION,
    Cross_Street,
    LAT,
    LON,
    Area_Cd
)
SELECT DISTINCT
    NULLIF("LOCATION", ''),
    NULLIF("Cross Street", ''),
    NULLIF("LAT", '')::FLOAT,
    NULLIF("LON", '')::FLOAT,
    NULLIF("AREA", '')::INT
FROM staging_crime_data
WHERE NULLIF("AREA", '') IS NOT NULL;


INSERT INTO Weapon_Type (Weapon_Cd, Weapon_Desc)
VALUES (0, 'No Weapon / Unknown')
ON CONFLICT (Weapon_Cd) DO NOTHING;

INSERT INTO Premises (Premise_Cd, Premise_Desc)
VALUES (0, 'Unknown')
ON CONFLICT (Premise_Cd) DO NOTHING;

INSERT INTO Case_Status (Status_Cd, Status_Desc)
VALUES ('UN', 'Unknown')
ON CONFLICT (Status_Cd) DO NOTHING;


INSERT INTO Crime_Report (
    DR_NO,
    Date_Rptd,
    Part_1_2,
    Mocodes,
    Rpt_Dist_No,
    Occurence_ID,
    Location_ID,
    Victim_ID,
    Crm_Cd,
    Weapon_Cd,
    Premise_Cd,
    Status_Cd
)
SELECT
    s."DR_NO"::BIGINT,

    TO_TIMESTAMP(NULLIF(s."Date Rptd", ''), 'MM/DD/YY HH24:MI')::DATE,

    CASE 
        WHEN s."Part 1-2" ~ '^[0-9]+$' THEN s."Part 1-2"::INT
        ELSE NULL
    END,

    NULLIF(s."Mocodes", ''),

    CASE 
        WHEN s."Rpt Dist No" ~ '^[0-9]+$' THEN s."Rpt Dist No"::INT
        ELSE NULL
    END,

    o.Occurence_ID,
    l.Location_ID,
    COALESCE(v.Victim_ID, v.Victim_ID),

    CASE 
        WHEN s."Crm Cd" ~ '^[0-9]+$' THEN s."Crm Cd"::INT
        ELSE NULL
    END,

    CASE 
        WHEN s."Weapon Used Cd" ~ '^[0-9]+$' THEN s."Weapon Used Cd"::INT
        ELSE 0
    END,

    CASE 
        WHEN s."Premis Cd" ~ '^[0-9]+$' THEN s."Premis Cd"::INT
        ELSE 0
    END,

    COALESCE(cs.Status_Cd, 'UN')

FROM staging_crime_data s

JOIN Occurence o
    ON o.DATE_OCC = TO_TIMESTAMP(NULLIF(s."DATE OCC", ''), 'MM/DD/YY HH24:MI')::DATE
   AND o.TIME_OCC =
        CASE 
            WHEN s."TIME OCC" ~ '^[0-9]+$' THEN s."TIME OCC"::INT
            ELSE NULL
        END

JOIN Location l
    ON COALESCE(l.LOCATION, '') = COALESCE(NULLIF(s."LOCATION", ''), '')
   AND COALESCE(l.Cross_Street, '') = COALESCE(NULLIF(s."Cross Street", ''), '')
   AND COALESCE(l.LAT, 0) =
        COALESCE(
            CASE 
                WHEN s."LAT" ~ '^-?[0-9]+(\.[0-9]+)?$' THEN s."LAT"::FLOAT
                ELSE NULL
            END,
            0
        )
   AND COALESCE(l.LON, 0) =
        COALESCE(
            CASE 
                WHEN s."LON" ~ '^-?[0-9]+(\.[0-9]+)?$' THEN s."LON"::FLOAT
                ELSE NULL
            END,
            0
        )
   AND l.Area_Cd =
        CASE 
            WHEN s."AREA" ~ '^[0-9]+$' THEN s."AREA"::INT
            ELSE NULL
        END

LEFT JOIN Victim_Type v
    ON COALESCE(v.Vict_Age, -1) =
        COALESCE(
            CASE 
                WHEN s."Vict Age" ~ '^-?[0-9]+$' THEN s."Vict Age"::INT
                ELSE NULL
            END,
            -1
        )
   AND COALESCE(v.Vict_Sex, '') = COALESCE(NULLIF(s."Vict Sex", ''), '')
   AND COALESCE(v.Vict_Descent, '') = COALESCE(NULLIF(s."Vict Descent", ''), '')

LEFT JOIN Case_Status cs
    ON cs.Status_Cd = NULLIF(s."Status", '')

WHERE s."DR_NO" ~ '^[0-9]+$'
  AND s."DATE OCC" IS NOT NULL
  AND s."Date Rptd" IS NOT NULL
  AND s."Crm Cd" ~ '^[0-9]+$'

ON CONFLICT (DR_NO) DO NOTHING;