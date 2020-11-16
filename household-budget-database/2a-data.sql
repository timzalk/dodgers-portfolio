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
-- data.sql                   --
-- Import all initial data    --
--                            --
--------------------------------


-----------------------------
-- Remove data from tables --
-----------------------------
DELETE FROM proj.TransactionTag;
GO
DELETE FROM proj.Tag;
GO
DELETE FROM proj.ChildTransaction;
GO
DELETE FROM proj.ParentTransaction;
GO
DELETE FROM proj.SavingsGoal;
GO
DELETE FROM proj.BudgetAmount;
GO
DELETE FROM proj.Budget;
GO
DELETE FROM proj.BudgetCategory;
GO
DELETE FROM proj.HouseholdMember;
GO
DELETE FROM proj.Payee;
GO
DELETE FROM proj.PayeeCategory;
GO
DELETE FROM proj.AccountProperty;
GO
DELETE FROM proj.AccountChecking;
GO
DELETE FROM proj.AccountSavings;
GO
DELETE FROM proj.AccountCreditCard;
GO
DELETE FROM proj.AccountLoan;
GO
DELETE FROM proj.BalanceReconciliation;
GO
DELETE FROM proj.Account;
GO
DELETE FROM proj.AccountType;


-------------------------------------
-- Insert initial data into tables --
-------------------------------------

INSERT INTO proj.AccountType (Name)
VALUES ('Cash'),
       ('Checking'),
       ('Savings'),
       ('Loan'),
       ('Property'),
       ('Credit Card');
GO

INSERT INTO proj.Account (Name, AccountTypeID)
VALUES ('Credit Union Savings Account', proj.GetAccountTypeID('Savings')),
       ('Credit Union Checking Account', proj.GetAccountTypeID('Checking')),
       ('American Express Delta', proj.GetAccountTypeID('Credit Card')),
       ('Visa Marriott', proj.GetAccountTypeID('Credit Card')),
       ('Home Mortgage', proj.GetAccountTypeID('Loan')),
       ('Ford Explorer Auto Loan', proj.GetAccountTypeID('Loan')),
       ('Home Equity Loan', proj.GetAccountTypeID('Loan')),
       ('House', proj.GetAccountTypeID('Property')),
       ('Ford Explorer Vehicle', proj.GetAccountTypeID('Property')),
       ('Hyundai Elantra Vehicle', proj.GetAccountTypeID('Property'));
GO

INSERT INTO proj.BalanceReconciliation (AccountID, Balance, DateTime)
VALUES (proj.GetAccountID('Credit Union Savings Account'), 5263.9, '20190529'),
       (proj.GetAccountID('Credit Union Checking Account'), 25768.57, '20190529'),
       (proj.GetAccountID('American Express Delta'), -3819.12, '20190529'),
       (proj.GetAccountID('Visa Marriott'), -1832.65, '20190529'),
       (proj.GetAccountID('Home Mortgage'), -338612.98, '20190529'),
       (proj.GetAccountID('Ford Explorer Auto Loan'), -12345.26, '20190529'),
       (proj.GetAccountID('Home Equity Loan'), -19011.77, '20190529'),
       (proj.GetAccountID('House'), 615792.05, '2019-05-29'),
       (proj.GetAccountID('Ford Explorer Vehicle'), 23660.62, '20190529'),
       (proj.GetAccountID('Hyundai Elantra Vehicle'), 5084.81, '20190529');
GO

--Keeps throwing date conversion error?
INSERT INTO proj.AccountLoan (AccountID, OriginationDate, Term, AnnualRate, MonthlyPayment)
VALUES (proj.GetAccountID('Home Mortgage'), '20150515', 360, 0.03625, 1875),
       (proj.GetAccountID('Ford Explorer Auto Loan'), '20160131', 72, 0.0274, 425),
       (proj.GetAccountID('Home Equity Loan'), '20160901', 240, 0.04325, 135.75)
GO

INSERT INTO proj.AccountCreditCard (AccountID, OpeningDate, ClosingDate, ExpectedAnnualRate, AnnualFee)
VALUES (proj.GetAccountID('American Express Delta'), '20160127', '2019-12-31', 0.1949, 450),
       (proj.GetAccountID('Visa Marriott'), '20190516', NULL, 0.1824, 95);
GO

INSERT INTO proj.AccountSavings (AccountID, AnnualReturn)
VALUES (proj.GetAccountID('Credit Union Savings Account'), 0.001);
GO

INSERT INTO proj.AccountChecking (AccountID, AnnualReturn)
VALUES (proj.GetAccountID('Credit Union Checking Account'), 0);
GO

INSERT INTO proj.AccountProperty (AccountID, Appreciation)
VALUES (proj.GetAccountID('House'), 0.065),
       (proj.GetAccountID('Ford Explorer Vehicle'), -0.1),
       (proj.GetAccountID('Hyundai Elantra Vehicle'), -0.1);
GO

INSERT INTO proj.PayeeCategory (Name)
VALUES ('Retail'),
       ('E-Commerce'),
       ('Food & Dining'),
       ('Online'),
       ('Entertainment'),
       ('Government'),
       ('Utility'),
       ('Insurrance'),
       ('Transportation & Auto'),
       ('Education'),
       ('Loan & Credit Card'),
       ('Service'),
       ('Financial'),
       ('Travel'),
       ('Charity & Donation'),
       ('Medical');
GO

INSERT INTO proj.Payee (Name, PayeeCategoryID)
VALUES ('Amazon', proj.GetAccountID('E-Commerce')),
       ('Costco', proj.GetAccountID('Food & Dining')),
       ('Vons', proj.GetAccountID('Food & Dining')),
       ('Instacart', proj.GetAccountID('Food & Dining')),
       ('Caliber Home Loans', proj.GetAccountID('Loan & Credit Card')),
       ('LA County Tax Board', proj.GetAccountID('Government')),
       ('Partners Mortgage', proj.GetAccountID('Loan & Credit Card')),
       ('Partners Auto Loan', proj.GetAccountID('Loan & Credit Card')),
       ('SoCal Gas', proj.GetAccountID('Utility')),
       ('SoCal Edison', proj.GetAccountID('Utility')),
       ('Geico', proj.GetAccountID('Insurance')),
       ('Disneyland', proj.GetAccountID('Entertainment')),
       ('T-Mobile', proj.GetAccountID('Utility')),
       ('Spectrum', proj.GetAccountID('Utility')),
       ('MemorialCare Medical Group', proj.GetAccountID('Medical')),
       ('City of Lakewood Utilities', proj.GetAccountID('Utility')),
       ('Delta Airlines', proj.GetAccountID('Travel')),
       ('Marrriott', proj.GetAccountID('Travel')),
       ('CA DMV', proj.GetAccountID('Government')),
       ('Pavilions', proj.GetAccountID('Food & Dining')),
       ('Arbor Road', proj.GetAccountID('Charity & Donation')),
       ('The Big D', proj.GetAccountID('Food & Dining')),
       ('iTunes', proj.GetAccountID('Entertainment')),
       ('Rite Aid', proj.GetAccountID('Retail')),
       ('Sprouts', proj.GetAccountID('Food & Dining')),
       ('Shell Gas', proj.GetAccountID('Transportation & Auto')),
       ('Cassidy''s Corner', proj.GetAccountID('Food & Dining')),
       ('76 Gas', proj.GetAccountID('Transportation & Auto')),
       ('Bakers & Baristas', proj.GetAccountID('Food & Dining')),
       ('Time Warner Cable', proj.GetAccountID('Utility')),
       ('The Home Depot', proj.GetAccountID('Retail')),
       ('McDonald''s', proj.GetAccountID('Food & Dining')),
       ('Starbucks', proj.GetAccountID('Food & Dining')),
       ('Chick-fil-a', proj.GetAccountID('Food & Dining')),
       ('Spotify', proj.GetAccountID('Entertainment')),
       ('Total Wine & More', proj.GetAccountID('Food & Dining')),
       ('Doc''s Pie Shop', proj.GetAccountID('Food & Dining')),
       ('Adobo Taco Grill', proj.GetAccountID('Food & Dining')),
       ('Portola Coffee Roasters', proj.GetAccountID('Food & Dining')),
       ('Jack in the Box', proj.GetAccountID('Food & Dining')),
       ('In-N-Out Burger', proj.GetAccountID('Food & Dining')),
       ('Stonefire Grill', proj.GetAccountID('Food & Dining')),
       ('Crema Café & Artisan Bakery', proj.GetAccountID('Food & Dining')),
       ('Trader Joe''s', proj.GetAccountID('Food & Dining')),
       ('Dairy Queen', proj.GetAccountID('Food & Dining')),
       ('Carl''s Jr', proj.GetAccountID('Food & Dining')),
       ('Chipotle Mexican Grill', proj.GetAccountID('Food & Dining')),
       ('Stater Bros. Markets', proj.GetAccountID('Food & Dining')),
       ('Pizza Hut', proj.GetAccountID('Food & Dining')),
       ('Ding Tea', proj.GetAccountID('Food & Dining')),
       ('The Abbey', proj.GetAccountID('Food & Dining')),
       ('The Habbit Burger Grill', proj.GetAccountID('Food & Dining')),
       ('Frostbites Crepes & Frozen Delights', proj.GetAccountID('Food & Dining')),
       ('Hulu', proj.GetAccountID('Entertainment')),
       ('NY Times', proj.GetAccountID('Entertainment')),
       ('Poke Bar', proj.GetAccountID('Food & Dining')),
       ('Grubhub', proj.GetAccountID('Food & Dining')),
       ('Lyft', proj.GetAccountID('Transportation & Auto')),
       ('Uber', proj.GetAccountID('Transportation & Auto')),
       ('Old Navy', proj.GetAccountID('Retail')),
       ('Creamistry', proj.GetAccountID('Food & Dining')),
       ('California Fish Grill', proj.GetAccountID('Food & Dining')),
       ('Chevron', proj.GetAccountID('Transportation & Auto')),
       ('ExxonMobil', proj.GetAccountID('Transportation & Auto')),
       ('Ballast Point Long Beach', proj.GetAccountID('Food & Dining')),
       ('Postmates', proj.GetAccountID('Food & Dining')),
       ('Nordstrom', proj.GetAccountID('Retail')),
       ('City of Lakewood Utilities', proj.GetAccountID('Utility')),
       ('Hippo Insurance', proj.GetAccountID('Insurance')),
       ('Geico', proj.GetAccountID('Insurance')),
       ('AAA Insurance', proj.GetAccountID('Insurance')),
       ('Columbia Pediatrics Medical Group', proj.GetAccountID('Medical')),
       ('Dodger Stadium', proj.GetAccountID('Entertainment')),
       ('Staples Center', proj.GetAccountID('Entertainment')),
       ('StubHub', proj.GetAccountID('Entertainment')),
       ('Ticketmaster', proj.GetAccountID('Entertainment')),
       ('Allen Tire Co.', proj.GetAccountID('Transportation & Auto')),
       ('Norm Reeves Ford Cerritos', proj.GetAccountID('Transportation & Auto')),
       ('MVP Plumbing', proj.GetAccountID('Service'));
GO

INSERT INTO proj.HouseholdMember (FirstName, LastName)
VALUES ('Tim', 'Zalk'),
       ('Marianne', 'Zalk'),
       ('Wyatt', 'Zalk'),
       ('Owen', 'Zalk');
GO

INSERT INTO proj.BudgetCategory (Name)
VALUES ('Entertainment'),
       ('Food and Dining'),
       ('General Expenses'),
       ('Home'),
       ('Taxes, Fees, and Fines'),
       ('Personal, Friends, and Family'),
       ('Utilities and Insurance'),
       ('Work Expenses'),
       ('Savings and Goals'),
       ('Annual Expenses'),
       ('Debt Payments');
GO

INSERT INTO proj.Budget (Name, CarryoverOption, FrequencyMonths, BudgetCategoryID)
VALUES ('Uncategorized', 1, 0, NULL),
       ('General Entertainment', 0, 1, proj.GetBudgetCategoryID('Entertainment')),
       ('Music', 0, 1, proj.GetBudgetCategoryID('Entertainment')),
       ('Dates', 0, 1, proj.GetBudgetCategoryID('Food and Dining')),
       ('Dining Out', 0, 1, proj.GetBudgetCategoryID('Food and Dining')),
       ('Groceries', 0, 1, proj.GetBudgetCategoryID('Food and Dining')),
       ('Auto Maintenance', 0, 1, proj.GetBudgetCategoryID('General Expenses')),
       ('Baby', 0, 1, proj.GetBudgetCategoryID('General Expenses')),
       ('Charity', 0, 1, proj.GetBudgetCategoryID('General Expenses')),
       ('Household Supplies', 0, 1, proj.GetBudgetCategoryID('General Expenses')),
       ('Legal & Finance', 0, 1, proj.GetBudgetCategoryID('General Expenses')),
       ('Medical', 0, 1, proj.GetBudgetCategoryID('General Expenses')),
       ('Toiletries', 0, 1, proj.GetBudgetCategoryID('General Expenses')),
       ('Transportation', 0, 1, proj.GetBudgetCategoryID('General Expenses')),
       ('Furniture', 0, 1, proj.GetBudgetCategoryID('Home')),
       ('Home Improvement', 0, 1, proj.GetBudgetCategoryID('Home')),
       ('Home Maintenance', 0, 1, proj.GetBudgetCategoryID('Home')),
       ('Office & Supplies', 0, 1, proj.GetBudgetCategoryID('Home')),
       ('Technology', 0, 1, proj.GetBudgetCategoryID('Home')),
       ('Taxes', 0, 1, proj.GetBudgetCategoryID('Taxes, Fees, and Fines')),
       ('Interest', 0, 1, proj.GetBudgetCategoryID('Taxes, Fees, and Fines')),
       ('Fees', 0, 1, proj.GetBudgetCategoryID('Taxes, Fees, and Fines')),
       ('Fines', 0, 1, proj.GetBudgetCategoryID('Taxes, Fees, and Fines')),
       ('Holidays', 0, 1, proj.GetBudgetCategoryID('Personal, Friends, and Family')),
       ('Clothing', 0, 1, proj.GetBudgetCategoryID('Personal, Friends, and Family')),
       ('Gifts', 0, 1, proj.GetBudgetCategoryID('Personal, Friends, and Family')),
       ('Family Spending', 0, 1, proj.GetBudgetCategoryID('Personal, Friends, and Family')),
       ('Auto Insurance', 0, 6, proj.GetBudgetCategoryID('Utilities and Insurance')),
       ('Home Insurance', 0, 3, proj.GetBudgetCategoryID('Utilities and Insurance')),
       ('Cell Phone', 0, 1, proj.GetBudgetCategoryID('Utilities and Insurance')),
       ('Electricity', 0, 1, proj.GetBudgetCategoryID('Utilities and Insurance')),
       ('Internet', 0, 1, proj.GetBudgetCategoryID('Utilities and Insurance')),
       ('Natural Gas', 0, 1, proj.GetBudgetCategoryID('Utilities and Insurance')),
       ('Water, Trash, & Sewer', 0, 2, proj.GetBudgetCategoryID('Utilities and Insurance')),
       ('Emergency', 0, 1, proj.GetBudgetCategoryID('Savings and Goals')),
       ('Savings', 0, 1, proj.GetBudgetCategoryID('Savings and Goals')),
       ('Vacation', 0, 12, proj.GetBudgetCategoryID('Savings and Goals')),
       ('Amex Card Fee', 0, 12, proj.GetBudgetCategoryID('Annual Expenses')),
       ('Chase Card Fee', 0, 12, proj.GetBudgetCategoryID('Annual Expenses')),
       ('Amazon Prime', 0, 12, proj.GetBudgetCategoryID('Annual Expenses')),
       ('Auto Registration', 0, 1, proj.GetBudgetCategoryID('Annual Expenses')),
       ('Costco Membership', 0, 12, proj.GetBudgetCategoryID('Annual Expenses')),
       ('Property Tax', 0, 12, proj.GetBudgetCategoryID('Annual Expenses')),
       ('Auto Loan', 0, 1, proj.GetBudgetCategoryID('Debt Payments')),
       ('Mortgage', 0, 1, proj.GetBudgetCategoryID('Debt Payments')),
       ('Home Equity Loan', 0, 1, proj.GetBudgetCategoryID('Debt Payments'));
GO

INSERT INTO proj.BudgetAmount (BudgetID, MonthStarting, Amount)
VALUES (proj.GetBudgetID('General Entertainment'), '2019-04-01', 0.99),
       (proj.GetBudgetID('Music'), '2019-04-01', 5),
       (proj.GetBudgetID('Dates'), '2019-04-01', 150),
       (proj.GetBudgetID('Dining Out'), '2019-04-01', 250),
       (proj.GetBudgetID('Groceries'), '2019-04-01', 325),
       (proj.GetBudgetID('Auto Maintenance'), '2019-04-01', 83.34),
       (proj.GetBudgetID('Baby'), '2019-04-01', 100),
       (proj.GetBudgetID('Charity'), '2019-04-01', 300),
       (proj.GetBudgetID('Household Supplies'), '2019-04-01', 50),
       (proj.GetBudgetID('Legal & Finance'), '2019-04-01', 0),
       (proj.GetBudgetID('Medical'), '2019-04-01', 100),
       (proj.GetBudgetID('Toiletries'), '2019-04-01', 35),
       (proj.GetBudgetID('Transportation'), '2019-04-01', 185),
       (proj.GetBudgetID('Furniture'), '2019-04-01', 100),
       (proj.GetBudgetID('Home Improvement'), '2019-04-01', 50),
       (proj.GetBudgetID('Home Maintenance'), '2019-04-01', 100),
       (proj.GetBudgetID('Office & Supplies'), '2019-04-01', 25),
       (proj.GetBudgetID('Technology'), '2019-04-01', 10),
       (proj.GetBudgetID('Taxes'), '2019-04-01', 0),
       (proj.GetBudgetID('Interest'), '2019-04-01', 0),
       (proj.GetBudgetID('Fees'), '2019-04-01', 0),
       (proj.GetBudgetID('Fines'), '2019-04-01', 0),
       (proj.GetBudgetID('Holidays'), '2019-04-01', 100),
       (proj.GetBudgetID('Clothing'), '2019-04-01', 50),
       (proj.GetBudgetID('Gifts'), '2019-04-01', 100),
       (proj.GetBudgetID('Family Spending'), '2019-04-01', 50),
       (proj.GetBudgetID('Auto Insurance'), '2019-04-01', 798.76),
       (proj.GetBudgetID('Home Insurance'), '2019-04-01', 126),
       (proj.GetBudgetID('Cell Phone'), '2019-04-01', 110),
       (proj.GetBudgetID('Electricity'), '2019-04-01', 80),
       (proj.GetBudgetID('Internet'), '2019-04-01', 69.99),
       (proj.GetBudgetID('Natural Gas'), '2019-04-01', 40),
       (proj.GetBudgetID('Water, Trash, & Sewer'), '2019-04-01', 83.34),
       (proj.GetBudgetID('Emergency'), '2019-04-01', 250),
       (proj.GetBudgetID('Savings'), '2019-04-01', 500),
       (proj.GetBudgetID('Vacation'), '2019-04-01', 600),
       (proj.GetBudgetID('Amex Card Fee'), '2019-04-01', 450),
       (proj.GetBudgetID('Chase Card Fee'), '2019-04-01', 99),
       (proj.GetBudgetID('Amazon Prime'), '2019-04-01', 129),
       (proj.GetBudgetID('Auto Registration'), '2019-04-01', 446),
       (proj.GetBudgetID('Costco Membership'), '2019-04-01', 120),
       (proj.GetBudgetID('Property Tax'), '2019-04-01', 6000),
       (proj.GetBudgetID('Auto Loan'), '2019-04-01', 425.75),
       (proj.GetBudgetID('Mortgage'), '2019-04-01', 2131.12),
       (proj.GetBudgetID('Home Equity Loan'), '2019-04-01', 135.79),
       (proj.GetBudgetID('General Entertainment'), '2019-05-01', 0.99),
       (proj.GetBudgetID('Music'), '2019-05-01', 5),
       (proj.GetBudgetID('Dates'), '2019-05-01', 150),
       (proj.GetBudgetID('Dining Out'), '2019-05-01', 250),
       (proj.GetBudgetID('Groceries'), '2019-05-01', 325),
       (proj.GetBudgetID('Auto Maintenance'), '2019-05-01', 83.34),
       (proj.GetBudgetID('Baby'), '2019-05-01', 100),
       (proj.GetBudgetID('Charity'), '2019-05-01', 300),
       (proj.GetBudgetID('Household Supplies'), '2019-05-01', 50),
       (proj.GetBudgetID('Legal & Finance'), '2019-05-01', 0),
       (proj.GetBudgetID('Medical'), '2019-05-01', 100),
       (proj.GetBudgetID('Toiletries'), '2019-05-01', 35),
       (proj.GetBudgetID('Transportation'), '2019-05-01', 185),
       (proj.GetBudgetID('Furniture'), '2019-05-01', 100),
       (proj.GetBudgetID('Home Improvement'), '2019-05-01', 50),
       (proj.GetBudgetID('Home Maintenance'), '2019-05-01', 100),
       (proj.GetBudgetID('Office & Supplies'), '2019-05-01', 25),
       (proj.GetBudgetID('Technology'), '2019-05-01', 10),
       (proj.GetBudgetID('Taxes'), '2019-05-01', 0),
       (proj.GetBudgetID('Interest'), '2019-05-01', 0),
       (proj.GetBudgetID('Fees'), '2019-05-01', 0),
       (proj.GetBudgetID('Fines'), '2019-05-01', 0),
       (proj.GetBudgetID('Holidays'), '2019-05-01', 100),
       (proj.GetBudgetID('Clothing'), '2019-05-01', 50),
       (proj.GetBudgetID('Gifts'), '2019-05-01', 100),
       (proj.GetBudgetID('Family Spending'), '2019-05-01', 50),
       (proj.GetBudgetID('Auto Insurance'), '2019-05-01', 798.76),
       (proj.GetBudgetID('Home Insurance'), '2019-05-01', 126),
       (proj.GetBudgetID('Cell Phone'), '2019-05-01', 110),
       (proj.GetBudgetID('Electricity'), '2019-05-01', 80),
       (proj.GetBudgetID('Internet'), '2019-05-01', 69.99),
       (proj.GetBudgetID('Natural Gas'), '2019-05-01', 40),
       (proj.GetBudgetID('Water, Trash, & Sewer'), '2019-05-01', 83.34),
       (proj.GetBudgetID('Emergency'), '2019-05-01', 250),
       (proj.GetBudgetID('Savings'), '2019-05-01', 500),
       (proj.GetBudgetID('Vacation'), '2019-05-01', 600),
       (proj.GetBudgetID('Amex Card Fee'), '2019-05-01', 450),
       (proj.GetBudgetID('Chase Card Fee'), '2019-05-01', 99),
       (proj.GetBudgetID('Amazon Prime'), '2019-05-01', 129),
       (proj.GetBudgetID('Auto Registration'), '2019-05-01', 446),
       (proj.GetBudgetID('Costco Membership'), '2019-05-01', 120),
       (proj.GetBudgetID('Property Tax'), '2019-05-01', 6000),
       (proj.GetBudgetID('Auto Loan'), '2019-05-01', 425.75),
       (proj.GetBudgetID('Mortgage'), '2019-05-01', 2131.12),
       (proj.GetBudgetID('Home Equity Loan'), '2019-05-01', 135.79),
       (proj.GetBudgetID('General Entertainment'), '2019-06-01', 0.99),
       (proj.GetBudgetID('Music'), '2019-06-01', 5),
       (proj.GetBudgetID('Dates'), '2019-06-01', 150),
       (proj.GetBudgetID('Dining Out'), '2019-06-01', 250),
       (proj.GetBudgetID('Groceries'), '2019-06-01', 325),
       (proj.GetBudgetID('Auto Maintenance'), '2019-06-01', 83.34),
       (proj.GetBudgetID('Baby'), '2019-06-01', 100),
       (proj.GetBudgetID('Charity'), '2019-06-01', 300),
       (proj.GetBudgetID('Household Supplies'), '2019-06-01', 50),
       (proj.GetBudgetID('Legal & Finance'), '2019-06-01', 0),
       (proj.GetBudgetID('Medical'), '2019-06-01', 100),
       (proj.GetBudgetID('Toiletries'), '2019-06-01', 35),
       (proj.GetBudgetID('Transportation'), '2019-06-01', 185),
       (proj.GetBudgetID('Furniture'), '2019-06-01', 100),
       (proj.GetBudgetID('Home Improvement'), '2019-06-01', 50),
       (proj.GetBudgetID('Home Maintenance'), '2019-06-01', 100),
       (proj.GetBudgetID('Office & Supplies'), '2019-06-01', 25),
       (proj.GetBudgetID('Technology'), '2019-06-01', 10),
       (proj.GetBudgetID('Taxes'), '2019-06-01', 0),
       (proj.GetBudgetID('Interest'), '2019-06-01', 0),
       (proj.GetBudgetID('Fees'), '2019-06-01', 0),
       (proj.GetBudgetID('Fines'), '2019-06-01', 0),
       (proj.GetBudgetID('Holidays'), '2019-06-01', 100),
       (proj.GetBudgetID('Clothing'), '2019-06-01', 50),
       (proj.GetBudgetID('Gifts'), '2019-06-01', 100),
       (proj.GetBudgetID('Family Spending'), '2019-06-01', 50),
       (proj.GetBudgetID('Auto Insurance'), '2019-06-01', 798.76),
       (proj.GetBudgetID('Home Insurance'), '2019-06-01', 126),
       (proj.GetBudgetID('Cell Phone'), '2019-06-01', 110),
       (proj.GetBudgetID('Electricity'), '2019-06-01', 80),
       (proj.GetBudgetID('Internet'), '2019-06-01', 69.99),
       (proj.GetBudgetID('Natural Gas'), '2019-06-01', 40),
       (proj.GetBudgetID('Water, Trash, & Sewer'), '2019-06-01', 83.34),
       (proj.GetBudgetID('Emergency'), '2019-06-01', 250),
       (proj.GetBudgetID('Savings'), '2019-06-01', 500),
       (proj.GetBudgetID('Vacation'), '2019-06-10', 850),
       (proj.GetBudgetID('Amex Card Fee'), '2019-06-01', 450),
       (proj.GetBudgetID('Chase Card Fee'), '2019-06-01', 99),
       (proj.GetBudgetID('Amazon Prime'), '2019-06-01', 129),
       (proj.GetBudgetID('Auto Registration'), '2019-06-01', 446),
       (proj.GetBudgetID('Costco Membership'), '2019-06-01', 120),
       (proj.GetBudgetID('Property Tax'), '2019-06-01', 6000),
       (proj.GetBudgetID('Auto Loan'), '2019-06-01', 425.75),
       (proj.GetBudgetID('Mortgage'), '2019-06-01', 2131.12),
       (proj.GetBudgetID('Home Equity Loan'), '2019-06-01', 135.79);
GO

INSERT INTO proj.SavingsGoal (BudgetID, Amount, EndDate)
VALUES (proj.GetBudgetID('Medical'), 5000, '2020-06-30'),
       (proj.GetBudgetID('Holidays'), 1200, '2019-12-31'),
       (proj.GetBudgetID('Gifts'), 1200, '2019-12-31'),
       (proj.GetBudgetID('Emergency'), 6000, '2020-12-31'),
       (proj.GetBudgetID('Vacation'), 1000, '2020-05-31');
GO

INSERT INTO proj.Tag (Name)
VALUES ('Vacation'),
       ('Tax Deductible'),
       ('Reimbursable');
GO

-- NOTE: Transaction details (data for proj.ParentTransaction, proj.ChildTransaction, and proj.TransactionTag) are inserted through procedures (created in 5-transactions.sql) to ensure data integrity
