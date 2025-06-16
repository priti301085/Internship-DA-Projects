-- Create the HR database
CREATE DATABASE IF NOT EXISTS HR;

-- Use the HR database
USE HR;

-- Create the EmployeeData table
CREATE TABLE EmployeeData (
    Age INT,
    Attrition VARCHAR(3),
    BusinessTravel VARCHAR(20),
    DailyRate INT,
    Department VARCHAR(50),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EmployeeNumber INT,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(6),
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(50),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(10),
    EmployeeID INT PRIMARY KEY,
    YearOfJoining INT,
    MonthOfJoining INT,
    DayOfJoining INT,
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 VARCHAR(1),
    OverTime VARCHAR(3),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);

-- Load data from the CSV file into the EmployeeData table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/HR_Merge.csv'
INTO TABLE EmployeeData
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(Age, Attrition, BusinessTravel, DailyRate, Department, DistanceFromHome, Education, EducationField, EmployeeCount, EmployeeNumber, EnvironmentSatisfaction, Gender, HourlyRate, JobInvolvement, JobLevel, JobRole, JobSatisfaction, MaritalStatus, EmployeeID, YearOfJoining, MonthOfJoining, DayOfJoining, MonthlyIncome, MonthlyRate, NumCompaniesWorked, Over18, OverTime, PercentSalaryHike, PerformanceRating, RelationshipSatisfaction, StandardHours, StockOptionLevel, TotalWorkingYears, TrainingTimesLastYear, WorkLifeBalance, YearsAtCompany, YearsInCurrentRole, YearsSinceLastPromotion, YearsWithCurrManager);


-- Disable safe updates to allow updates
SET SQL_SAFE_UPDATES = 0;

-- Adding a new date column to store the combined date
ALTER TABLE EmployeeData ADD COLUMN JoiningDate DATE;

-- Updating the new date column by combining the year, month, and day columns
UPDATE EmployeeData
SET JoiningDate = STR_TO_DATE(CONCAT(YearOfJoining, '-', LPAD(MonthOfJoining, 2, '0'), '-', LPAD(DayOfJoining, 2, '0')), '%Y-%m-%d');

SET SQL_SAFE_UPDATES = 1;




-- 1. Average Attrition rate for all Departments
SELECT 
    Department, 
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100 AS AvgAttritionRate
FROM 
    EmployeeData
GROUP BY 
    Department
ORDER BY
	AvgAttritionRate DESC;






-- 2. Average Hourly rate of Male Research Scientist
SELECT 
    AVG(HourlyRate) AS AvgHourlyRate
FROM 
    EmployeeData
WHERE 
    Gender = 'Male' AND JobRole = 'Research Scientist';




-- 3. Attrition rate Vs Monthly income stats
SELECT 
    AVG(MonthlyIncome) AS AvgMonthlyIncome, 
    MIN(MonthlyIncome) AS MinMonthlyIncome, 
    MAX(MonthlyIncome) AS MaxMonthlyIncome,
    Attrition
FROM 
    EmployeeData
GROUP BY 
    Attrition;




-- 4. Average working years for each Department
SELECT 
    Department, 
    AVG(TotalWorkingYears) AS AvgWorkingYears
FROM 
    EmployeeData
GROUP BY 
    Department
ORDER BY
	AvgWorkingYears DESC;





-- 5. Job Role Vs Work life balance
SELECT 
    JobRole, 
    AVG(WorkLifeBalance) AS AvgWorkLifeBalance
FROM 
    EmployeeData
GROUP BY 
    JobRole
ORDER BY
	AvgWorkLifeBalance;
    
    
    
    

-- 6. Attrition rate Vs Years since last promotion relation
SELECT 
    YearsSinceLastPromotion, 
    AVG(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100 AS AvgAttritionRate
FROM 
    EmployeeData
GROUP BY 
    YearsSinceLastPromotion
ORDER BY
	YearsSinceLastPromotion DESC;

