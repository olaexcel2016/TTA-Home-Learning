-- HOME LEARNING TASK WEEK 13 BY OLAOLU AKOMOLAFE

-- ACTIVITY BETWEEN TWO NULLS
-- In the example database, retrieve the following information. Screenshot the SQL query used and the results obtained.
-- QUESTION 1
-- Obtain a list of applications where the CourseID is unknown

use uni;

SELECT * 
FROM application
WHERE CourseAppliedFor IS NULL;

-- QUESTION 2
-- Obtain a list of students whom were born in the month of June 2002

SELECT * 
FROM student
WHERE DateOfBirth BETWEEN '2002-06-01' AND '2002-06-30';

-- QUESTION 3
-- Obtain a list of applications where CourseID is unknown and the applications were made between 01/04/2020 and 31/07/2020

SELECT * 
FROM application
WHERE CourseAppliedFor IS NULL AND DateOfApplication BETWEEN '2020-04-01' AND '2020-07-31';

-- ACTIVITY GROUPING FUNCTIONS
-- QUESTION 4
-- Obtain the number of modules which are assigned to each course

SELECT CourseID, count(ModuleName)
FROM module
group by CourseID;

-- OR --

SELECT CourseID, count(*)
FROM module
group by CourseID;

-- QUESTION 5
-- Retrieve Information on the number of successful applications per course

SELECT *
FROM application
WHERE accepted=1;

-- QUESTION 6
-- Find the average MembershipFee of Student Clubs by the ID of the Staff member (Lecturer) supervising it

SELECT SupervisingStaff, avg(MembershipFee)
FROM club
group by SupervisingStaff;

-- QUESTION 7
-- Find the Sum total of Joining Fees for all active clubs by Staff Member supervising them

SELECT SupervisingStaff, sum(JoiningFee)
FROM club
WHERE Active = 1
group by SupervisingStaff;

-- ACTIVITY: ADVANCED JOINS
-- QUESTION 8
-- Obtain a list of all modules and the names of any courses they may be taught on (include modules without courses)

SELECT ModuleName, CourseName
FROM module
LEFT JOIN course
	USING (CourseID);
    
-- QUESTION 9
-- Obtain a list of students along with any related application numbers if they have them

SELECT s.StudentID, a.applicationID
FROM student s
LEFT JOIN application a
	ON s.StudentID=a.StudentID;

-- QUESTION 10
-- Obtain the Class ID, Class Date and Feedback score of the latest class scheduled for each Class ID

SELECT s.classid, 
	   hlt.maxDate, 
       s.feedbackscore
FROM schedule s 
	inner join
(SELECT classid, max(CDate) maxDate
FROM schedule s
group by classid) hlt
on hlt.classid = s.classid and s.CDate = hlt.maxDate

    
