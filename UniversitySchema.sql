 
create database universityData

use universityData

USE universityData;
GO


CREATE TABLE faculty 
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	FacultyName VARCHAR(100) NOT NULL,
	FacultyCampus VARCHAR(100) NOT NULL
);


CREATE TABLE department 
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	departmentName VARCHAR(100) NOT NULL,
	facultyId INT NOT NULL,
	CONSTRAINT FK_Department_Faculty FOREIGN KEY (facultyId) REFERENCES faculty(id)
);


CREATE TABLE teacher
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	departmentId INT NOT NULL,
	firstName VARCHAR(100) NOT NULL,
	lastName VARCHAR(100) NOT NULL,
	email VARCHAR(255) NOT NULL UNIQUE CHECK (email LIKE '%_@__%.__%'),
	salary DECIMAL(18,2),
	contact VARCHAR(20),
	age INT,
	CONSTRAINT FK_Teacher_Department FOREIGN KEY (departmentId) REFERENCES department(id)
);


CREATE TABLE student 
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	departmentId INT NOT NULL,
	firstName VARCHAR(100),
	lastName VARCHAR(100),
	gender VARCHAR(10),
	age INT, 
	dateOfBirth DATE,
	enrollmentDate DATETIME DEFAULT GETDATE(),
	email VARCHAR(255) NOT NULL UNIQUE CHECK (email LIKE '%_@__%.__%'),
	CONSTRAINT FK_Student_Department FOREIGN KEY (departmentId) REFERENCES department(id)
);


CREATE TABLE course
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	departmentId INT NOT NULL,
	teacherId INT NOT NULL,
	courseCode VARCHAR(20) NOT NULL,
	courseName VARCHAR(100) NOT NULL,
	credits INT CHECK (credits BETWEEN 1 AND 6),
	semester VARCHAR(10),
	CONSTRAINT FK_Course_Department FOREIGN KEY (departmentId) REFERENCES department(id),
	CONSTRAINT FK_Course_Teacher FOREIGN KEY (teacherId) REFERENCES teacher(id)
);


CREATE TABLE courseOffering
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	courseId INT NOT NULL,
	teacherId INT NOT NULL,
	semester VARCHAR(10),
	creditHours INT CHECK (creditHours BETWEEN 1 AND 6),
	academicYear VARCHAR(10),
	section VARCHAR(10),
	CONSTRAINT FK_CourseOffering_Course FOREIGN KEY (courseId) REFERENCES course(id),
	CONSTRAINT FK_CourseOffering_Teacher FOREIGN KEY (teacherId) REFERENCES teacher(id)
);


CREATE TABLE enrollment
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	studentId INT NOT NULL,
	courseId INT NOT NULL,
	teacherId INT NOT NULL,
	enrollmentDate DATE DEFAULT GETDATE(),
	grade VARCHAR(2),
	CONSTRAINT FK_Enrollment_Student FOREIGN KEY (studentId) REFERENCES student(id),
	CONSTRAINT FK_Enrollment_Teacher FOREIGN KEY (teacherId) REFERENCES teacher(id),
	CONSTRAINT FK_Enrollment_Course FOREIGN KEY (courseId) REFERENCES course(id),
	CONSTRAINT UQ_Enrollment UNIQUE (studentId, courseId)
);


CREATE TABLE exam
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	courseId INT NOT NULL,
	examDate DATE NOT NULL,
	maxMarks INT NOT NULL,
	FOREIGN KEY (courseId) REFERENCES course(id)
);


CREATE TABLE examResult
(
	id INT IDENTITY(1,1) PRIMARY KEY,
	examId INT NOT NULL,
	studentId INT NOT NULL,
	marksObtained INT,
	FOREIGN KEY (examId) REFERENCES exam(id),
	FOREIGN KEY (studentId) REFERENCES student(id)
);


INSERT INTO faculty (FacultyName, FacultyCampus)
VALUES 
('Engineering', 'Main Campus'),
('Science', 'North Campus'),
('Arts', 'West Campus');

INSERT INTO department (departmentName, facultyId)
VALUES
('Computer Science', 1),
('Mechanical Engineering', 1),
('Physics', 2),
('Mathematics', 2),
('History', 3);

INSERT INTO teacher (departmentId, firstName, lastName, email, salary, contact, age)
VALUES
(1, 'Alice', 'Johnson', 'alice.johnson@univ.edu', 5000.00, '0551234567', 40),
(2, 'Bob', 'Smith', 'bob.smith@univ.edu', 4500.00, '0552345678', 38),
(3, 'Charlie', 'Brown', 'charlie.brown@univ.edu', 4800.00, '0553456789', 35),
(4, 'Diana', 'White', 'diana.white@univ.edu', 4600.00, '0554567890', 37),
(5, 'Edward', 'Green', 'edward.green@univ.edu', 4700.00, '0555678901', 42);

INSERT INTO student (departmentId, firstName, lastName, gender, age, dateOfBirth, enrollmentDate, email)
VALUES
(1, 'David', 'Lee', 'Male', 20, '2005-02-14', GETDATE(), 'david.lee@student.edu'),
(2, 'Eva', 'Green', 'Female', 21, '2004-07-20', GETDATE(), 'eva.green@student.edu'),
(3, 'Frank', 'Wright', 'Male', 22, '2003-09-11', GETDATE(), 'frank.wright@student.edu');

INSERT INTO course (departmentId, teacherId, courseCode, courseName, credits, semester)
VALUES
(1, 1, 'CS101', 'Introduction to Programming', 3, 'Fall'),
(2, 2, 'ME201', 'Thermodynamics', 4, 'Spring'),
(3, 3, 'PH301', 'Classical Mechanics', 4, 'Fall'),
(4, 4, 'MA202', 'Linear Algebra', 3, 'Spring'),
(5, 5, 'HI101', 'World History', 2, 'Fall');

INSERT INTO courseOffering (courseId, teacherId, semester, creditHours, academicYear, section)
VALUES
(1, 1, 'Fall', 3, '2025-2026', 'A'),
(1, 1, 'Fall', 3, '2025-2026', 'B'),
(2, 2, 'Spring', 4, '2025-2026', 'A'),
(3, 3, 'Fall', 4, '2025-2026', 'A'),
(4, 4, 'Spring', 3, '2025-2026', 'A'),
(5, 5, 'Fall', 2, '2025-2026', 'A');

INSERT INTO enrollment (studentId, courseId, teacherId, grade)
VALUES
(1, 1, 1, 'A'),
(1, 2, 2, 'B'),
(2, 3, 3, 'A'),
(3, 4, 4, 'B'),
(3, 5, 5, 'A');

INSERT INTO exam (courseId, examDate, maxMarks)
VALUES
(1, '2025-12-10', 100),
(2, '2025-12-15', 100),
(3, '2025-12-20', 100),
(4, '2025-12-22', 100),
(5, '2025-12-25', 100);

INSERT INTO examResult (examId, studentId, marksObtained)
VALUES
(1, 1, 90),
(2, 1, 80),
(3, 2, 85),
(4, 3, 75),
(5, 3, 95);


SELECT * FROM faculty;
SELECT * FROM department;
SELECT * FROM teacher;
SELECT * FROM student;
SELECT * FROM course;
SELECT * FROM courseOffering;
SELECT * FROM enrollment;
SELECT * FROM exam;
SELECT * FROM examResult;

ALTER TABLE course
ADD price DECIMAL(10,2);

UPDATE course SET price = 1500.00 WHERE id = 1; 
UPDATE course SET price = 1800.00 WHERE id = 2; 
UPDATE course SET price = 1750.00 WHERE id = 3; 
UPDATE course SET price = 1600.00 WHERE id = 4; 
UPDATE course SET price = 1400.00 WHERE id = 5; 

SELECT id, courseName, credits, price
FROM course;

ALTER TABLE enrollment
ADD academicYear VARCHAR(10); 

UPDATE enrollment SET academicYear = '2024-2025' WHERE id IN (1, 3);
UPDATE enrollment SET academicYear = '2025-2026' WHERE id IN (2, 5);
UPDATE enrollment SET academicYear = '2026-2027' WHERE id IN (4);

SELECT id, studentId, courseId, academicYear
FROM enrollment
ORDER BY academicYear, studentId;

CREATE OR ALTER VIEW vw_StudentPopulationPerYear
AS
SELECT 
    academicYear,
    COUNT(DISTINCT studentId) AS totalStudents
FROM enrollment
GROUP BY academicYear;
GO

SELECT * FROM vw_StudentPopulationPerYear
ORDER BY academicYear;

ALTER TABLE courseOffering
ADD programLevel VARCHAR(20); 

INSERT INTO courseOffering (courseId, teacherId, semester, creditHours, academicYear, section, programLevel)
VALUES
(1, 1, 'Fall', 3, '2025-2026', 'A', 'Bachelors'),
(1, 1, 'Fall', 4, '2025-2026', 'B', 'Masters');
