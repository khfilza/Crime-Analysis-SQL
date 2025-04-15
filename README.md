# Crime-Analysis-SQL

**SQL Murder Mystery Investigation: Atom City Case**


🔎 **Project Overview**

This project investigates a murder case in Atom City using SQL to analyze crime scene data, witness testimonies, and suspect profiles. Through database exploration and forensic analysis, we identify the murderer (Ali Haider) and uncover the employer (Shabnam Akhtar) who hired him—demonstrating how data-driven approaches can solve complex criminal cases.


💻 **Key Features & Methodology**

_**1. Database Exploration & Cleaning**_
   
- Initial Data Retrieval
- Data Standardization (Converted unstructured date strings (e.g., "3092023") into proper DATE format)
- Duplicate Handling (Removed duplicates and implemented composite primary keys to maintain data integrity)

_**2. Suspect Profiling & Alibi Verification**_

- Cross-Referencing Data using JOINS
- Time-Based Alibi Checks (Compared gym check-ins (atom_fit.check_in_time) with event attendance (atomcamp_annualdinner.date))

_**3. Witness Analysis & Confession Extraction**_

- Interview Transcripts (Queried the interviews table for key confessions (e.g., Ali Haider’s admission of being a "hired gun"))
- Geospatial Clues (Linked addresses (Gulshan-e-Ravi, Lahore) from crime_scene_report to suspect profiles)


🎯 **SQL Techniques Used**

- _**Basic Queries:**_	SELECT, WHERE, GROUP BY, COUNT(), ORDER BY
- _**Joins:**_	INNER JOIN, LEFT JOIN (for alibi verification)
- _**Data Cleaning:**_ UPDATE, ALTER TABLE, STR_TO_DATE(), MODIFY COLUMN
- _**Advanced Queries:**_ CASE WHEN (conditional formatting), HAVING (filtering aggregates), subqueries
- _**Database Design:**_	Primary/Composite keys, indexing (implicit via PKs), safe update handling


💡 **Key Findings**

_**1. The Murderer: Ali Haider**_
- Profile: 55-year-old male, drives an Audi (license_id = 171424).
- Evidence:
  - Confessed in police interviews (transcript analysis).
  - Income (annual_income) did not justify his car’s luxury, suggesting external payments.

_**2. The Employer: Shabnam Akhtar**_
- Motive: Matched the killer’s description (wealthy, blue-eyed, Mercedes owner).
- Proof:
  - Income: 5.5 million/year (annual_income table).
  - Alibi: Attended the AtomCamp Annual Dinner on the murder date.

_**3. Unresolved Lead: Sanam Akhtar**_
- Suspicious Activity: Gym check-in timestamps didn’t fully clear her.
- Open Question: Could she be involved? (Needs further investigation).


📊 **Future Enhancements**

- _**Geospatial Mapping:**_ Plot suspect addresses on maps using coordinates.
- _**Time-Series Analysis:**_ Track movements before/after the crime.
- _**Network Graphs:**_ Model relationships between suspects (e.g., call logs).

**Credits**

This project was completed as part of the requirement of Data Analytics bootcamp with atomcamp.
