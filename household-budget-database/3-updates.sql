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
-- updates.sql                --
-- Update records created     --
-- during initialization      --
--                            --
--------------------------------

--------------------
-- update records --
--------------------

UPDATE proj.PayeeCategory
SET Name = 'Insurance'
WHERE Name = 'Insurrance';
GO

UPDATE proj.Payee
SET Name = 'Marriott'
WHERE Name = 'Marrriott';

UPDATE proj.Budget
SET FrequencyMonths = 12
WHERE Name = 'Auto Registration';

UPDATE proj.BudgetAmount
SET MonthStarting = '2019-06-01',
    Amount = 600
WHERE BudgetID = proj.GetBudgetID('Vacation') AND
      DATEPART(m, MonthStarting) = 6;

UPDATE proj.AccountCreditCard
SET ClosingDate = NULL
WHERE AccountID = proj.GetAccountID('American Express Delta');

-- Add categories to several transactions
UPDATE ct
SET ct.BudgetID = proj.GetBudgetID('Mortgage')
FROM proj.ChildTransaction ct
     INNER JOIN proj.ParentTransaction pt
                ON ct.ParentTransactionID = pt.ParentTransactionID
WHERE LOWER(proj.GetPayeeName(pt.PayeeID)) LIKE '%caliber home%';

UPDATE ct
SET ct.BudgetID = proj.GetBudgetID('Electricity')
FROM proj.ChildTransaction ct
     INNER JOIN proj.ParentTransaction pt
                ON ct.ParentTransactionID = pt.ParentTransactionID
WHERE LOWER(proj.GetPayeeName(pt.PayeeID)) LIKE '%edison%';

UPDATE ct
SET ct.BudgetID = proj.GetBudgetID('Natural Gas')
FROM proj.ChildTransaction ct
     INNER JOIN proj.ParentTransaction pt
                ON ct.ParentTransactionID = pt.ParentTransactionID
WHERE LOWER(proj.GetPayeeName(pt.PayeeID)) LIKE '%so cal gas%';

UPDATE ct
SET ct.BudgetID = proj.GetBudgetID('Internet')
FROM proj.ChildTransaction ct
     INNER JOIN proj.ParentTransaction pt
                ON ct.ParentTransactionID = pt.ParentTransactionID
WHERE LOWER(proj.GetPayeeName(pt.PayeeID)) LIKE '%spectrum%';

UPDATE ct
SET ct.BudgetID = proj.GetBudgetID('Cell Phone')
FROM proj.ChildTransaction ct
     INNER JOIN proj.ParentTransaction pt
                ON ct.ParentTransactionID = pt.ParentTransactionID
WHERE LOWER(proj.GetPayeeName(pt.PayeeID)) LIKE '%t-mobile%';

UPDATE ct
SET BudgetID = proj.GetBudgetID('Groceries')
FROM proj.ChildTransaction ct
     INNER JOIN proj.ParentTransaction pt
                ON ct.ParentTransactionID = pt.ParentTransactionID
WHERE LOWER(proj.GetPayeeName(pt.PayeeID)) LIKE '%vons%' OR
      LOWER(proj.GetPayeeName(pt.PayeeID)) LIKE '%pavilions%' OR
      LOWER(proj.GetPayeeName(pt.PayeeID)) LIKE '%sprouts%' OR
      LOWER(proj.GetPayeeName(pt.PayeeID)) LIKE '%trader joes%';