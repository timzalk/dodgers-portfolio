--USE IST659_M411_twzalk
--GO

--USE tzsyr
--GO

--------------------------------
--                            --
-- Household Finance Database --
-- Timothy Zalk               --
-- IST 659                    --
--                            --
-- Project Deliverable #2     --
-- views.sql                  --
-- Create views to answer     --
-- data questions             --
--                            --
--------------------------------

----------------
-- Drop views --
----------------

IF OBJECT_ID('proj.TopMerchants') IS NOT NULL
    DROP VIEW proj.TopMerchants;
GO

IF OBJECT_ID('proj.TopCategories') IS NOT NULL
    DROP VIEW proj.TopCategories;
GO

IF OBJECT_ID('proj.MonthTotals') IS NOT NULL
    DROP VIEW proj.MonthTotals;
GO

IF OBJECT_ID('proj.WeekdayTotals') IS NOT NULL
    DROP VIEW proj.WeekdayTotals;
GO

IF OBJECT_ID('proj.BestMonths') IS NOT NULL
    DROP VIEW proj.BestMonths;
GO

IF OBJECT_ID('proj.WorstMonths') IS NOT NULL
    DROP VIEW proj.WorstMonths;
GO

IF OBJECT_ID('proj.WorstDays') IS NOT NULL
    DROP VIEW proj.WorstDays;
GO


---------------------------------------------------------------
-- Create views and procedures used to answer data questions --
---------------------------------------------------------------

-- What merchants do I spend the most money at?
CREATE VIEW proj.TopMerchants
AS
SELECT TOP 10 p.Name,
       SUM(pt.Amount) AS TotalAmount
FROM proj.ParentTransaction pt
     LEFT JOIN proj.Payee p ON pt.PayeeID = p.PayeeID
GROUP BY p.Name
ORDER BY SUM(pt.Amount) ASC;
GO


-- What non-essential categories do I spend the most money on?
CREATE VIEW proj.TopCategories
AS
SELECT TOP 10 b.Name,
       SUM(ct.Amount) AS TotalAmount
FROM proj.ChildTransaction ct
     LEFT JOIN proj.Budget b ON ct.BudgetID = b.BudgetID
GROUP BY b.Name
ORDER BY SUM(ct.Amount) ASC;
GO


-- What months do I typically spend the most money?
CREATE VIEW proj.MonthTotals
AS
SELECT TOP 12 TransactionMonth =
           CASE DATEPART(m, pt.TransactionDate)
                WHEN 1  THEN 'January'
                WHEN 2  THEN 'February'
                WHEN 3  THEN 'March'
                WHEN 4  THEN 'April'
                WHEN 5  THEN 'May'
                WHEN 6  THEN 'June'
                WHEN 7  THEN 'July'
                WHEN 8  THEN 'August'
                WHEN 9  THEN 'September'
                WHEN 10 THEN 'October'
                WHEN 11 THEN 'November'
                WHEN 12 THEN 'December'
                ELSE 'Month DATEPART error' 
           END,
       AVG(IIF(tot.TotalAmount < 0, tot.TotalAmount, 0)) AS AverageAmount
FROM proj.ParentTransaction pt
     INNER JOIN (SELECT DATEPART(m, pt2.TransactionDate) AS TransactionMonth,
                        SUM(IIF(pt2.Amount < 0, pt2.Amount, 0)) AS TotalAmount
                 FROM proj.ParentTransaction pt2
                 GROUP BY DATEPART(m, pt2.TransactionDate)) tot
         ON DATEPART(m, pt.TransactionDate) = tot.TransactionMonth
GROUP BY DATEPART(m,  pt.TransactionDate)
ORDER BY AverageAmount ASC
GO


-- What days of the week do I spend the most/least money?
CREATE VIEW proj.WeekdayTotals
AS
SELECT TOP 12 TransactionWeekday =
           CASE DATEPART(w, pt.TransactionDate)
                WHEN 1  THEN 'Sunday'
                WHEN 2  THEN 'Monday'
                WHEN 3  THEN 'Tuesday'
                WHEN 4  THEN 'Wednesday'
                WHEN 5  THEN 'Thursday'
                WHEN 6  THEN 'Friday'
                WHEN 7  THEN 'Saturday'
                ELSE 'Weekday DATEPART error' 
           END,
       SUM(IIF(pt.Amount < 0, pt.Amount, 0)) AS TotalAmount
FROM proj.ParentTransaction pt
GROUP BY DATEPART(w, pt.TransactionDate)
ORDER BY DATEPART(w, pt.TransactionDate);
GO


-- What spending habits lead to spending/saving the most in a month?
---- This data question was replaced by the one below, but the views have been left as reference
CREATE VIEW proj.BestMonths
AS
SELECT TOP 3 TransactionMonth =
           CASE DATEPART(m, pt.TransactionDate)
                WHEN 1  THEN 'January'
                WHEN 2  THEN 'February'
                WHEN 3  THEN 'March'
                WHEN 4  THEN 'April'
                WHEN 5  THEN 'May'
                WHEN 6  THEN 'June'
                WHEN 7  THEN 'July'
                WHEN 8  THEN 'August'
                WHEN 9  THEN 'September'
                WHEN 10 THEN 'October'
                WHEN 11 THEN 'November'
                WHEN 12 THEN 'December'
                ELSE 'Month DATEPART error' 
           END,
       DATEPART(yy, pt.TransactionDate) AS Year,
       SUM(pt.Amount) AS TotalAmountSpent
FROM ParentTransaction pt
GROUP BY DATEPART(m,  pt.TransactionDate),
         DATEPART(yy, pt.TransactionDate)
ORDER BY SUM(pt.Amount) ASC;
GO

CREATE VIEW proj.WorstMonths
AS
SELECT TOP 3 TransactionMonth =
           CASE DATEPART(m, pt.TransactionDate)
                WHEN 1  THEN 'January'
                WHEN 2  THEN 'February'
                WHEN 3  THEN 'March'
                WHEN 4  THEN 'April'
                WHEN 5  THEN 'May'
                WHEN 6  THEN 'June'
                WHEN 7  THEN 'July'
                WHEN 8  THEN 'August'
                WHEN 9  THEN 'September'
                WHEN 10 THEN 'October'
                WHEN 11 THEN 'November'
                WHEN 12 THEN 'December'
                ELSE 'Month DATEPART error' 
           END,
        DATEPART(yy, pt.TransactionDate) AS Year,
        SUM(pt.Amount) AS TotalAmountSaved
FROM ParentTransaction pt
GROUP BY DATEPART(m,  pt.TransactionDate),
         DATEPART(yy, pt.TransactionDate)
ORDER BY SUM(pt.Amount) DESC;
GO

-- On what day did I spend the most?
CREATE VIEW proj.WorstDays
AS
SELECT TOP 5 pt.TransactionDate,
             SUM(pt.Amount) AS TotalAmountSpent
FROM ParentTransaction pt
GROUP BY pt.TransactionDate
ORDER BY SUM(pt.Amount) ASC;
GO
