-- View to calculate the total tuition

USE BUDT702_Project_0503_06
GO
DROP VIEW IF EXISTS Total_Tuition_V;
GO
CREATE VIEW Total_Tuition_V
AS
SELECT c.*, t.tutstudentType, t.tutPercredit, (c.courseCredits * t.tutPerCredit )totalTuition FROM Course C INNER JOIN
Tuition t on c.courseId = t.courseId
GO


--Q1. Consider the Return on Investment (ROI) of programs, which considers the tuition and 
--expected salary – and how does the Smith School of Business courses compare to other 
--courses for international students?

-- A CTE to fetch QS rankings for year 2023
WITH RankedCTE AS (
	SELECT * FROM Rank
	WHERE srcRankYear = '2023' AND srcId = '3'
)

SELECT
u.univName AS "University Name",
u.univLocation AS "University Location",
u.univType AS "University Type",
t.courseName As "Course Name",
ISNULL(CAST(ROUND((t.courseExpectedSalary / t.totalTuition), 2) AS DECIMAL(18, 2)),0) 
AS "Return on Investment"
FROM
Total_Tuition_V t
INNER JOIN RankedCTE r ON t.courseId = r.courseId
INNER JOIN University u ON r.univId = u.univid
WHERE
t.tutstudentType = 'International'
ORDER BY
"Return on Investment" DESC;


--Q2) For a particular course like Finance - what are the top universities 
--that offers finance courses with the lowest tuition fees for the year 2023 
--(source of data is US News rankings)?

-- A CTE to fetch US News rankings for year 2023
WITH RankedCTE AS (
	SELECT * FROM Rank
	WHERE srcRankYear = '2023' AND srcId = '1'
)

SELECT
u.univName AS "University Name",
u.univLocation AS "University Location",
u.univType AS "University Type",
t.courseName AS "Course Name",
t.totalTuition AS "Total Tuition"
FROM
Total_Tuition_V t
INNER JOIN RankedCTE r ON t.courseId = r.courseId 
INNER JOIN Course c ON c.courseId = r.courseId
INNER JOIN University u ON r.univId= u.univId
WHERE c.courseName LIKE '%finance%'
AND t.tutStudentType = 'International'
ORDER BY
t.totalTuition;



--Q3) What are the university names and their rankings that have a 
-- higher-than-average international student ratio 
-- (Source: Times higher education and Year 2023)

WITH RankedUniversities AS (
    SELECT DISTINCT univId, srcId, srcRankYear, rankUniversityNo
    FROM Rank
    WHERE srcId = 2 AND srcRankYear = 2023
)

SELECT u.univName AS "University Name",
    r.rankUniversityNo AS "University Rank",
    u.univIntlStuNo AS "International Student Ratio"
FROM
    University u
INNER JOIN RankedUniversities r ON r.univId = u.univId
AND u.univIntlStuNo > (
    SELECT AVG(univIntlStuNo) 
    FROM University )
ORDER BY
    u.univIntlStuNo DESC;




 --Q4) Finding out the university names and course names whose rankings have 
 -- improved from 2022 to 2023 based on the US News rankings

 WITH CourseRanking AS (
    SELECT
        courseId,
		univId,
        rankCourseNo AS courseRank2023,
        LAG(rankCourseNo) OVER (PARTITION BY courseId ORDER BY srcRankYear) AS courseRank2022
    FROM
        Rank
    WHERE
        srcId = 1  -- 1 represents the US News source
        AND srcRankYear IN (2022, 2023)
)

SELECT
	u.univName "University Name",
    c.courseName "Course Name",
    cr.courseRank2022 AS "Course Rank 2022",
    cr.courseRank2023 AS "Course Rank 2023"
FROM
    Course c
INNER JOIN CourseRanking cr ON c.courseId = cr.courseId
INNER JOIN University u ON cr.univId = u.univId
WHERE
    cr.courseRank2023 < cr.courseRank2022
ORDER BY cr.courseRank2023;