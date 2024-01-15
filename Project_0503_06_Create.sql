USE BUDT702_Project_0503_06

BEGIN TRANSACTION;

-- Droping tables IF they exist for the creation

DROP TABLE IF EXISTS [Rank];
DROP TABLE IF EXISTS [University];
DROP TABLE IF EXISTS [Tuition];
DROP TABLE IF EXISTS [Course];
DROP TABLE IF EXISTS [Source];


-- Creating University Table

CREATE TABLE University (
	univId INT NOT NULL,
	univName VARCHAR(255),
	univLocation VARCHAR(255),
	univType VARCHAR(50),
	univWebsite VARCHAR(255),
	univAccpRate DECIMAL (3,2),
	univIntlStuNo DECIMAL (3,2)

CONSTRAINT pk_University_univId PRIMARY KEY (univId),
);

-- Creating Course Table

CREATE TABLE [Course] (
	courseId INT  NOT NULL,
	courseIdPublic VARCHAR(12),
	courseName VARCHAR(255),
	courseType VARCHAR(5),
	courseWebsite VARCHAR(255),
	courseCredits INT,
	courseDuration INT,
	courseExpectedSalary DECIMAL(10, 2)
CONSTRAINT pk_Course_courseId PRIMARY KEY (courseId),

);

-- creating Source Table

CREATE TABLE [Source] (
	srcId INT NOT NULL,
	srcName VARCHAR(255),
	srcWebsite VARCHAR(255),
	srcRankYear INT

CONSTRAINT pk_Source_srcId PRIMARY KEY (srcId,srcRankYear)
);

-- Creating Tuition Table

CREATE TABLE [Tuition] (
	courseId INT  NOT NULL,
	tutStudentType VARCHAR(50) NOT NULL,
	tutPerCredit DECIMAL(10, 2),


CONSTRAINT pk_Tuition_courseId_tutStudentType PRIMARY KEY (courseId,tutStudentType), 


CONSTRAINT fk_Tuition_courseId FOREIGN KEY (courseId)
        	REFERENCES [Course] (courseId)
        	ON DELETE CASCADE ON UPDATE CASCADE


);

-- Creating Rank Table

 CREATE TABLE [Rank] (
	srcId INT NOT NULL,
	srcRankYear INT NOT NULL,
	univId INT NOT NULL,
	courseId INT  NOT NULL,
	rankUniversityNo INT,
	rankCourseNo INT,

CONSTRAINT pk_Rank_srcId_univId_courseId
 PRIMARY KEY (srcId, srcRankYear, univId, courseId),

CONSTRAINT fk_Rank_univId FOREIGN KEY (univId)
        	REFERENCES [University] (univId)
        	ON DELETE CASCADE ON UPDATE CASCADE,


CONSTRAINT fk_Rank_srcId FOREIGN KEY (srcId, srcRankYear)
        	REFERENCES [Source] (srcId, srcRankYear)
        	ON DELETE CASCADE ON UPDATE CASCADE,



CONSTRAINT fk_Rank_courseId FOREIGN KEY (courseId)
        	REFERENCES [Course] (courseId)
        	ON DELETE CASCADE ON UPDATE CASCADE
);

-- commiting the changes to the database
COMMIT;

-- Verifying the newly created tables

SELECT * FROM Course;
SELECT * FROM University;
SELECT * FROM Source;
SELECT * FROM Rank;
SELECT * FROM Tuition; 