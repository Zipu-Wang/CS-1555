---------------------------------------------
-- Sample SQL File for CS 1555/2055
---------------------------------------------

DROP SCHEMA IF EXISTS recitation CASCADE;
CREATE SCHEMA recitation;
SET SCHEMA 'recitation';

DROP TABLE IF EXISTS STUDENT CASCADE;
DROP TABLE IF EXISTS STUDENT_DIR CASCADE;
DROP TABLE IF EXISTS COURSE CASCADE;
DROP TABLE IF EXISTS COURSE_TAKEN CASCADE;

---------------------------------------------
-- Use CREATE TABLE statement to create
-- tables for each of the relations
---------------------------------------------
CREATE TABLE STUDENT (
	sid		int	NOT NULL,
	name		varchar(15)	NOT NULL,
	class		int,
	major		varchar(10),
	CONSTRAINT PK_STUDENT PRIMARY KEY(sid)
);

CREATE TABLE STUDENT_DIR (
	sid		int	NOT NULL,
	address	varchar(100),
	phone		varchar(20),
	CONSTRAINT PK_STUDENT_DIR PRIMARY KEY (sid),
	CONSTRAINT FK_STUDENT_DIR FOREIGN KEY (sid) REFERENCES STUDENT (sid)
);

CREATE TABLE COURSE (
	course_no	varchar(10)	NOT NULL,
	name		varchar(100),
	course_level	varchar(10),
	CONSTRAINT PK_COURSE PRIMARY KEY (course_no)
);

CREATE TABLE COURSE_TAKEN (
	course_no	varchar(10) NOT NULL,
	term		varchar(15) NOT NULL,
	sid		int NOT NULL,
	grade		real,
	CONSTRAINT PK_course_TAKEN PRIMARY KEY (course_no, sid, term),
	CONSTRAINT FK1_COURSE_TAKEN FOREIGN KEY (sid) REFERENCES STUDENT (sid),
	CONSTRAINT FK2_COURSE_TAKEN FOREIGN KEY (course_no) REFERENCES COURSE (course_no)
);

-- insert data into STUDENT table
INSERT INTO STUDENT (sid, class, name, major) 
	VALUES (123, 3, 'John', 'CS');

INSERT INTO STUDENT (sid, name, class, major)
	VALUES(124, 'Mary', 3, 'CS');

INSERT INTO STUDENT (sid, name, class, major)
	VALUES(126, 'Sam', 2, 'CS');

INSERT INTO STUDENT (sid, name, class, major)
	VALUES(129, 'Julie', 2, 'Math');

INSERT INTO STUDENT (sid, name, class, major)
    VALUES(130, 'Brian', 4, null);

INSERT INTO STUDENT (sid, name, class, major)
    VALUES(131, 'Rakan', 6, null);

INSERT INTO STUDENT (sid, name, class, major)
    VALUES(132, 'Pat', 3, null);

INSERT INTO STUDENT (sid, name, class, major)
    VALUES(133, 'Alex', 2, null);


--insert data into STUDENT_DIR table
INSERT INTO STUDENT_DIR (sid, address, phone)
	VALUES(123, '333 Library St', '555-535-5263');

INSERT INTO STUDENT_DIR (sid, address, phone)
	VALUES(124, '219 Library St', '555-963-9653');

INSERT INTO STUDENT_DIR (sid, address, phone)
	VALUES(129, '555 Library St', '555-123-4567');

--insert data into COURSE
INSERT INTO COURSE (course_no, name, course_level)
	VALUES('CS1520', 'Web Applications', 'UGrad');

INSERT INTO COURSE (course_no, name, course_level)
	VALUES('CS1555', 'Database Management Systems', 'UGrad');

INSERT INTO COURSE (course_no, name, course_level)
	VALUES('CS1550', 'Operating Systems', 'UGrad');

INSERT INTO COURSE (course_no, name, course_level)
	VALUES('CS2550', 'Database Management Systems', 'Grad');

INSERT INTO COURSE (course_no, name, course_level)
	VALUES('CS1655', 'Secure Data Management and Web Applications', 'UGrad');


--INSERT INTO COURSE_TAKEN
INSERT INTO COURSE_TAKEN (course_no, sid, term, grade)
	VALUES('CS1520', 123, 'Fall 23', 3.75);

INSERT INTO COURSE_TAKEN (course_no, sid, term, grade)
	VALUES('CS1520', 124, 'Fall 23', 4);

INSERT INTO COURSE_TAKEN (course_no, sid, term, grade)
	VALUES('CS1520', 126, 'Fall 23', 3);

INSERT INTO COURSE_TAKEN (course_no, sid, term, grade)
	VALUES('CS1555', 123, 'Fall 23', 4);

INSERT INTO COURSE_TAKEN (course_no, sid, term, grade)
	VALUES('CS1555', 124, 'Fall 23', null);

INSERT INTO COURSE_TAKEN (course_no, sid, term, grade)
    VALUES('CS1555', 130, 'Fall 23', null);

INSERT INTO COURSE_TAKEN (course_no, sid, term, grade)
    VALUES('CS1555', 131, 'Fall 23', null);

INSERT INTO COURSE_TAKEN (course_no, sid, term, grade)
    VALUES('CS1555', 132, 'Fall 23', null);

INSERT INTO COURSE_TAKEN (course_no, sid, term, grade)
    VALUES('CS1555', 133, 'Fall 23', null);

INSERT INTO COURSE_TAKEN (course_no, sid, term, grade)
	VALUES('CS1550', 123, 'Spring 22', null );

INSERT INTO COURSE_TAKEN (course_no, sid, term, grade)
	VALUES('CS1550', 124, 'Spring 22', null );

INSERT INTO COURSE_TAKEN (course_no, sid, term, grade)
	VALUES('CS1550', 126, 'Spring 22', null );

INSERT INTO COURSE_TAKEN (course_no, sid, term, grade)
	VALUES('CS1550', 129, 'Spring 22', null );

INSERT INTO COURSE_TAKEN (course_no, sid, term, grade)
	VALUES('CS2550', 124, 'Spring 22', null );

INSERT INTO COURSE_TAKEN (course_no, sid, term, grade)
	VALUES('CS1520', 126, 'Spring 22', null );

-------------------------------------------------------
-- Q1: List the student id and course number for every
--     student who took a course in Fall 23 but has
--     not received a grade yet.
-------------------------------------------------------
SELECT sid, course_no
FROM course_taken
WHERE term = 'Fall 23'
	AND grade IS NULL;

-------------------------------------------------------
-- Q2: List the sid(s) and gpa(s) of the students whose
--     gpa(s) are greater than 3.7. List them in the
--     descending order of the gpa(s).
-------------------------------------------------------
SELECT sid, AVG(grade) as gpa
FROM course_taken
GROUP BY sid
HAVING AVG(grade) > 3.7
ORDER BY gpa DESC;

-------------------------------------------------------
-- Q3: List the sid(s) of all the students and the
--     number of courses they have taken.
-------------------------------------------------------
SELECT sid, COUNT(DISTINCT course_no) AS num_courses
FROM course_taken
GROUP BY sid;

-------------------------------------------------------
-- What if we want names too?
-------------------------------------------------------
SELECT s.sid, s.name, COUNT (DISTINCT course_no) AS num_courses
FROM student s JOIN course_taken ON s.sid = sid
GROUP BY s.sid, s.name;

-------------------------------------------------------
-- How about another way?
-------------------------------------------------------
SELECT sid, name, COUNT (DISTINCT course_no) AS num_courses
FROM student s NATURAL JOIN course_taken
GROUP BY sid, name;

------------------------------------------------------------------
-- Q4: List the course_no(s) and names of the courses that contain
--     'Data' within their course name.
------------------------------------------------------------------
SELECT C.course_no, C.name
FROM COURSE C
WHERE C.name LIKE '%Data%';

------------------------------------------------------------------
-- Q5: List the sid(s) and GPA for the top three students with the
--     highest GPAs. Note that NULL grades should not be counted
--     towards the GPA as these classes are still in-progress.
------------------------------------------------------------------
SELECT sid, AVG(grade) AS gpa
FROM COURSE_TAKEN
WHERE grade IS NOT NULL
GROUP BY sid
ORDER BY gpa DESC
LIMIT 3;

-------------------------------------------------------------------
-- Q6: List all students (sid) and their majors who were enrolled in
--     a course during the FALL 23 term. Any students that don't
--     currently have a major should be displayed as 'Undecided'.
-------------------------------------------------------------------
SELECT sid, CASE
	WHEN major IS NULL THEN 'Undecided'
	ELSE major
	END AS major
	Page 3 of 3
	FROM STUDENT NATURAL JOIN COURSE_TAKEN
	WHERE term = 'Fall 23';



