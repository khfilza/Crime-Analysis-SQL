-- PORTFOLIO PROJECT

set SQL_SAFE_UPDATES = 0;

-- 1. RETRIEVING ALL TABLES
SELECT 
    *
FROM
    accused_person;
SELECT 
    *
FROM
    annual_income;
SELECT 
    *
FROM
    atom_fit;
SELECT 
    *
FROM
    atomcamp_annualdinner;
SELECT 
    *
FROM
    crime_scene_report;
SELECT 
    *
FROM
    drivers_license;
SELECT 
    *
FROM
    interviews;

-- 2. CREATE PRIMARY KEYS

alter table crime_scene_report
add primary key (index_report);

alter table atomcamp_annualdinner
add primary key (person_id);

alter table interviews
add primary key (person_id);

alter table accused_person
add primary key (person_id);

alter table drivers_license
add primary key (license_id);

alter table annual_income
add primary key (ssn);

-- 3. REMOVING DUPLICATES FROM TABLE atom_fit (from both columns membership_id and person_id)

SELECT 
    person_id, COUNT(person_id)
FROM
    atom_fit
GROUP BY person_id
HAVING COUNT(person_id) > 1;

SELECT 
    membership_id, COUNT(membership_id)
FROM
    atom_fit
GROUP BY membership_id
HAVING COUNT(membership_id) > 1;

# The duplicates cannot be removed because the rows contain different information
# Without removing them, we can not define a primary key. Hence we will create a composite key

-- 4. DEFINING COMPOSITE KEYS

alter table atom_fit
modify membership_id varchar (255),
add primary key (person_id, membership_id);

-- 5. CHANGING DATE FORMATS FOR 3 TABLES
UPDATE atomcamp_annualdinner 
SET 
    date = STR_TO_DATE(CASE
                WHEN LENGTH(date) = 7 THEN CONCAT('0', date)
                WHEN LENGTH(date) = 8 THEN date
            END,
            '%m%d%Y');

alter table atomcamp_annualdinner modify column date DATE;

UPDATE crime_scene_report 
SET 
    date = STR_TO_DATE(CASE
                WHEN LENGTH(date) = 7 THEN CONCAT('0', date)
                WHEN LENGTH(date) = 8 THEN date
            END,
            '%m%d%Y')

aLTEr tabLe crime_scene_report MODIfy colUmn date DATE;

uPDAte atom_fit
SET check_in_date = STr_to_date(
    CASE
        WHEN lenGth(check_in_date) = 7 tHeN conCat('0', check_in_date)  -- Convert 7-digit int (e.g., 3092023 → 03092023)
        WHEN LengtH(check_in_date) = 8 tHeN check_in_date              -- Keep 8-digit int as-is
    END, '%m%d%Y'                                                     -- Convert to proper date format (YYYY-MM-DD)
);

ALtER table atom_fit MODIFY columN check_in_date DATE;

-- 6. SOLVING THE MYSTERY

SELECT * froM crime_scene_report
WHERE date = '2023-03-09'
AND city = 'atom-city';
     
SELECT * FROM atom_fit
WHERE check_in_date = '2023-03-09';

-- 7. RETRIEVE DETAILS FOR THE SAME PERSON_ID IN accused_person AND drivers_license TABLES

SELECT 
    ap.person_id,
    ap.name,
    ap.ssn,
    dl.age,
    dl.gender,
    dl.eye_color,
    dl.license_id,
    dl.plate_number,
    dl.car_make,
    dl.car_model
FROM
    accused_person AS ap
        JOIN
    drivers_license AS dl on ap.license_id = dl.license_id
WHERE
    ap.person_id = 184448;
   
-- 8. person_id 184448 WAS INTERVIEWED AFTER THE MURDER AND HE DID NOT HAVE AN ALIBI. HE ALSO CONFESSED OF BEING A HIRED GUN

SELECT 
    ap.person_id, ap.name, i.transcript
FROM
    accused_person AS ap
        JOIN
    interviews AS i ON ap.person_id = i.person_id
WHERE
    ap.person_id = 184448


-- 9. The 'ssn' DID NOT PROVIDE ANY USEFUL INFORMATION ABOUT THE ACCUSED, OTHER THAN INDICATING THAT HIS INCOME DOES NOT ALIGN WITH THE CAR HE DRIVES

SELECT
    ap.name, ap.license_id, ai.ssn, ai.annual_income
FROM
    accused_person AS ap
        JOIN
    annual_income AS ai ON ap.ssn = ai.ssn
WHERE
    ap.ssn = 480409449;

-- 10. 
#Hired Gun: Ali Haider, 55 years old, male, 5'9", light blue-eyed
#Vehicle: Drives a Lahore-registered Audi (license_id = 171424)
#Accused of: Murder
#Key Question: Who hired him?
#Alibi: The interviewee has no alibi but provided some information on who hired him
#Witness 1: Sanam Akhtar
  #Event: Present at the annual dinner on the specified date
  #Person ID: 541190

SELECT 
    *
FROM
    atomcamp_annualdinner
WHERE
    date = '2023-03-09';
    

-- 11.
-- Person ID 541190: Sanam Akhtar
-- Location: Lives somewhere in 'Gulshan-e-Ravi, Lahore' (according to the crime scene report)
-- Next Step: Reviewing her interview transcript for further details

SELECT 
    ap.person_id,
    ap.name,
    ap.address_street_name,
    ap.license_id,
    i.transcript
FROM
    accused_person AS ap
        JOIN
    interviews AS i ON ap.person_id = i.person_id
WHERE
    ap.person_id = 541190;

-- 12. 
-- Person ID 541190: Identified as Shabnam Akhtar
-- Claim: Denies being at the murder site during the crime
-- Details:
	# Visited the murder site after the crime for 42 minutes on 2023-03-09
	# Later attended the annual dinner
	# Significance: Her account aligns with information provided by the murderer to the police

SELECT 
    af.person_id,
    af.membership_id,
    af.check_in_date,
    af.check_in_time,
    af.check_out_time,
    ad.person_id,
    ad.event_name,
    ad.date
fROM
    atom_fit AS af
        JOIN
    atomcamp_annualdinner AS ad
whERE
    af.person_id = 541190
        AND ad.date = '2023-03-09';

-- 13. 
# Second Witness: Shabnam Akhtar is most likely the unnamed second witness mentioned in the crime scene report.
# Residence: Lives "at the last house in 'Saddar Bazaar, Rawalpindi'."
# Checking Profile Against Murderer’s Description:
	# Employer's Description:
	# Hired by a woman.
	# Wealth: A millionaire.
	# Physical Traits: Blue eyes, age 60.
	# Vehicle: Drives a Mercedes Benz.
	# Key Detail: Mentioned attending a dinner of a data company on 2023-03-09.

-- Relevance: Shabnam Akhtar’s profile and activities are being compared to these details for a potential match.


SELECT 
    ap.person_id,
    ap.name,
    ap.ssn,
    dl.age,
    dl.gender,
    dl.eye_color,
    dl.license_id,
    dl.plate_number,
    dl.car_make,
    dl.car_model
FROM
    accused_person AS ap
        JOIN
    drivers_license AS dl on ap.license_id = dl.license_id
WHERE
    ap.person_id = 541190;


-- 14. 
# Suspect: Shabnam Akhtar
	# Details:
	# 60 years old, female
	# Blue-eyed
	# Drives a Lahore-registered Mercedes Benz
# Profile Fit: Nearly matches the employer’s description provided by the murderer.

-- Next Step: Verify if she is a millionaire to confirm the match.

SELECT 
    ap.name, ap.license_id, ai.ssn, ai.annual_income
FROM
    accused_person AS ap
        JOIN
    annual_income AS ai on ap.ssn = ai.ssn
WhERE
    ap.ssn = 967694038;

# we can see that the annual income of the person is around 5.5million

-- 15. 
-- Finding out more about the 1st witness Sanam Akhtar to see if she was involved or can be absolved beyond reasonable doubt
-- crime scene report tells us she lives in Gulshan-e-Ravi Lahore
-- since the police only has her name and address (not personal ID), so we go this way

SELECT 
    *
FROM
    accused_person
WHERE
    name = 'Sanam Akhtar'
        AND address_street_name = 'Gulshan-e-Ravi, Lahore';

SELECT 
    ap.name,
    ap.license_id,
    ap.ssn,
    i.person_id,
    i.transcript,
    ap.ssn
FrOM
    accused_person AS ap
        JOIN
    interviews AS i On ap.person_id = i.person_id
WHERE
    ap.name = 'Sanam Akhtar'
        AND ap.person_id = 205019;

-- 16. As Sanam Akhtar was at the gym on 2023-03-09, retreiving here gym details

SELECT 
    *
FROM
    atom_fit
WHERE
    person_id = 205019
        OR membership_id = 'AT3318' checking if she was in at the dinner on 2023-03-09

SELECT 
    af.person_id,
    af.membership_id,
    af.check_in_date,
    af.check_in_time,
    af.check_out_time,
    ad.person_id,
    ad.date,
    ad.event_name
FROM
    atom_fit AS af
        JOIN
    atomcamp_annualdinner AS ad
whERE
    af.person_id = 205019
        AND ad.date = '2023-03-09';
     

-- 17. Checking for Sanam's biodata, car she drives, and income

SELECT 
    ap.name,
    ap.license_id,
    dl.age,
    dl.gender,
    dl.eye_color,
    dl.license_id,
    dl.plate_number,
    dl.car_make,
    dl.car_model,
    ap.ssn,
    ai.annual_income
FROM
    accused_person AS ap
        JOIN
    drivers_license AS dl ON ap.license_id = dl.license_id
        INNER JOIN
    annual_income AS ai ON ap.ssn = ai.ssn
WHERE
    ap.license_id = 641569
        AND ap.ssn = 146551420;
        

-- Conclusion:

-- Most Probable Scenario:
	#Shabnam Akhtar is likely the employer based on her profile and activities matching the murderer's description.
	#Ali Haider's confession, along with Shabnam’s presence at both the gym and dinner, supports this conclusion.

-- Key Doubt:
	#Sanam Akhtar’s involvement cannot be ruled out entirely due to her unclear alibi and unexplained activities on the day of the crime.

-- Case Strength:
	#The evidence is heavily circumstantial and lacks direct proof, such as communication records between Shabnam Akhtar and Ali Haider or witnesses confirming their connection.
    #This weakens the likelihood of the case holding up in court.

-- Alternative Consideration:
	#If new evidence surfaces regarding Sanam Akhtar's activities or a direct link between her and the murder (or the employer), she could emerge as a stronger suspect.

-- Final Assessment:
	#Shabnam Akhtar is the most plausible employer, based on the available evidence, but further investigation is needed to solidify the case and address lingering doubts regarding Sanam Akhtar.