-- HOME LEARNING TASK WEEK 12 BY OLAOLU AKOMOLAFE

-- ACTIVITY RETRIEVING DATA -----------------------------------------

-- Using our Uni Database
-- Question1: 
-- Obtain all information on the Students not attending course 1

USE uni;

SELECT * 
FROM student
WHERE CourseID <> 1;

-- Question2: 
-- Obtain the first name, surname and Date of Birth for the student with the email address: val.bolger@example.com  

SELECT 
	Forenames,
    Surname,
    DateOfBirth
FROM student
WHERE EmailAddress = 'val.bolger@example.com';

-- Question3: 
-- Obtain a list of the modules which have the subject Economics 

SELECT 
	ModuleName
FROM module
WHERE Subject = 'Economics';

-- Question4: 
-- Obtain a list of class numbers and their dates which are scheduled before 21st September 2020
 
 SELECT 
	ClassID,
    CDate    
FROM schedule
WHERE CDate < '2020-09-21';


-- ACTIVITY INSERTING DATA -----------------------------------------
-- Remember
-- Use the INSERT INTO clause to specify the table you are inserting the data into and the VALUES clause to specify what information is in the line your inserting 
-- The table name in the insert clause should be followed by a bracket list of the columns you are inserting into
-- The Values clause should contain all of the information for that particular row in the order listed in your insert clause
-- E.g. INSERT INTO table1(column1, column2, column3) VALUES(1,2,’three’)
-- QUESTION 1

INSERT INTO application (
	applicationID,
	Forenames,
	Surname,
	EmailAddress,
	ContactNumber,
	CourseAppliedFor,
	DateOfApplication,
	StudentID,
	accepted )
VALUES (DEFAULT,'Olaolu','Akomolafe','Olaolu.Akomolafe','08034372156',3,'2022-05-06', DEFAULT,1);

-- In the example database, write inserts to insert the following information. Screenshot the SQL query and the results obtained.
-- Insert a record for a new course named Deep-Space Radar Telemetry
-- write an insert to insert records for the following modules:
	-- String Theory
	-- Exotic Matter
	-- Harnessing the Einstein-Rosen Bridge
	-- Supercollision and miniature Black Holes
-- (these modules are worth 20 credits each, at level 6 and are taught on the Quantum Physics Course)
-- Using the information from the previous example and the LecturerID of 6, create a class for each new module.
-- QUESTION 2

INSERT INTO course 
	(
    CourseID,
	CourseName
    )
VALUES(DEFAULT,"Deep-Space Radar Telemetry");

INSERT INTO module 
	(
    ModuleID,
    ModuleName,
	Subject,
    Level,
    CourseID,
    Credits
    )
VALUES
	(DEFAULT,"String Theory","Deep-Space Radar Telemetry",6,6,20),
	(DEFAULT,"Exotic Matter","Deep-Space Radar Telemetry",6,6,20),
    (DEFAULT,"Harnessing the Einstein-Rosen Bridge","Deep-Space Radar Telemetry",6,6,20),
    (DEFAULT,"Supercollision and miniature Black Holes","Deep-Space Radar Telemetry",6,6,20);
	
INSERT INTO class (
	ClassID,
    LecturerID,
    ModuleID
)
VALUES
    (DEFAULT, 6, 109),
    (DEFAULT, 6, 110),
    (DEFAULT, 6, 111),
    (DEFAULT, 6, 112);
    

-- ACTIVITY CREATING CALCULATIONS -----------------------------------------
-- In the existing database from last week:
-- Count how students are enrolled overall

-- QUESTION 1

SELECT COUNT(*)
FROM student;

-- QUESTION 2
-- Calculate the sum of full time fees for every full-time course

SELECT SUM(FullTimeFee)
FROM fees;

-- QUESTION 3
-- Identify the cost of the least and most expensive course

SELECT MIN(FullTimeFee)
FROM fees;

SELECT MIN(PartTimeFee)
FROM fees;

-- MOST EXPENSIVE COST FOR FULLTIME

SELECT 
	CourseName
FROM course
LEFT JOIN fees
	Using (CourseID)
WHERE FullTimeFee = 
	(SELECT MAX(FullTimeFee)
FROM fees);

-- MOST EXPENSIVE COST FOR PARTTIME

SELECT 
	CourseName
FROM course 
LEFT JOIN fees
	Using (CourseID)
WHERE PartTimeFee = 
	(SELECT MAX(PartTimeFee)
FROM fees);

-- LEAST EXPENSIVE COST FOR FULLTIME

SELECT 
	CourseName
FROM course
LEFT JOIN fees
	Using (CourseID)
WHERE FullTimeFee = 
	(SELECT MIN(FullTimeFee)
FROM fees);

-- LEAST EXPENSIVE COST FOR PARTTIME

SELECT 
	CourseName
FROM course 
LEFT JOIN fees
	Using (CourseID)
WHERE PartTimeFee = 
	(SELECT MIN(PartTimeFee)
FROM fees);

-- QUESTION 4
-- Calculate the average cost of all part time courses

SELECT AVG(PartTimeFee)
FROM Fees;

-- QUESTION 4
-- Calculate the fee of each full time course after applying (subtracting) the scholarship discount

SELECT 
	FeeID,
    CourseID,
    FullTimeFee,
    ScholarshipDiscount,
    FullTimeFee - ScholarshipDiscount as 'Fee After Discount'
FROM fees;

-- QUESTION 5
-- Select only the course number of the cheapest full-time course
SELECT 
	CourseID
FROM fees
WHERE FullTimeFee = 
	(SELECT MIN(FullTimeFee)
FROM fees); 


-- QUESTION 6
-- Find cost of the most expensive course after applying the scholarship discount
SELECT 
    CourseName,
    MAX(Discounted) as nowAmount
FROM (
	SELECT c.CourseName, FullTimeFee - ScholarshipDiscount AS Discounted 
    FROM fees f
    LEFT JOIN course c
		USING(CourseID)
	) AS subqueryalias ;

-- QUESTION 7	
-- Count the number of applications for History courses made between 01/03/2020 and 30/08/2020

SELECT count(*) AS 'Count of History Courses Between 2020-03-01 AND 2020-08-30'
FROM application a
LEFT JOIN course c
	ON a.CourseAppliedFor = c.CourseID
WHERE a.DateOfApplication BETWEEN "2020-03-01" AND "2020-08-30" AND c.CourseName='History';

-- ACTIVITY CREATE TABLE----------------------------------
-- QUESTION 1
-- Use the create table functions in the previous example to create an application archive table for retaining information 
-- about successful applications. Decide on what your primary key is, as well as whatever foreign keys and data types you may need.

CREATE TABLE application_archived AS (
SELECT *
FROM application
where accepted=1
);

-- ACTIVITY WORKING WITH LISTS----------------------------------
-- QUESTION 1
-- Obtain all the course information for courses with the CourseIDs of 1,3,5 and 7

SELECT *
FROM course
WHERE CourseID IN (1,3,5,7);

-- QUESTION 2
-- Obtain a list of all modules taught on courses which have a Full Time Fee greater than 9000

SELECT 
	m.ModuleID, 
    m.ModuleName,
    f.FullTimeFee,
    m.Subject
FROM fees f
LEFT JOIN module m
	USING (CourseID)
WHERE f.FullTimeFee > 9000;

-- QUESTION 3
-- Obtain a list of classes for modules taught on courses which have a Full Time Fee greater than 9000

SELECT
	c.ClassID,
    m.ModuleID,
    co.CourseName,
    f.FullTimeFee
FROM fees f
LEFT JOIN course co
	USING (CourseID)
LEFT JOIN module m
	USING (CourseID)
LEFT JOIN class c
	ON c.ModuleID = m.ModuleID
WHERE f.FullTimeFee > 9000 ;

-- QUESTION 4
-- Find a list of studentIDs for the latest class on the most expensive course


SELECT 
	distinct 
    StudentID,
    CourseName,
    FullTimeFee
FROM (SELECT
	s.StudentID,
	-- c.ClassID,
    -- m.ModuleID,
    co.CourseName,
    f.FullTimeFee
FROM student s
JOIN fees f
	USING (CourseID)
LEFT JOIN course co
	USING (CourseID)
LEFT JOIN module m
	USING (CourseID)
LEFT JOIN class c
	ON c.ModuleID = m.ModuleID
WHERE f.FullTimeFee = ( 
	SELECT MAX(FullTimeFee)
    FROM fees
) ) as subQueries;

-- ACTIVITY INNER JOIN----------------------------------
-- QUESTION 1
-- Obtain a list of Students and the name of the Courses they are studying

SELECT 
	StudentID,
    Forenames,
    Surname,
    CourseName
FROM student s
INNER JOIN course c
	Using(CourseID);
    
-- QUESTION 2
-- Obtain a list of course names, full time fees and part time fees for each course

SELECT 
    CourseName,
    FullTimeFee,
    PartTimeFee
FROM course s
INNER JOIN fees f
	Using(CourseID);
    
-- QUESTION 3
-- Obtain a list of classIDs for the Economics Course and the modules they relate to
SELECT 
    c.ClassID,
    co.CourseName,
    m.ModuleName
FROM class c
INNER JOIN module m
	Using (ModuleID)
INNER JOIN course co
	Using(CourseID)
WHERE co.CourseName='Economics'
ORDER BY c.ClassID;