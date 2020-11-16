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
-- tables.sql                 --
-- Create all required table  --
-- objects an associated      --
-- lookup functions           --
--                            --
--------------------------------


------------------------------------------
-- Drop tables in order of dependencies --
------------------------------------------

IF OBJECT_ID('proj.TransactionTag') IS NOT NULL
    DROP TABLE proj.TransactionTag;
GO
IF OBJECT_ID('proj.Tag') IS NOT NULL
    DROP TABLE proj.Tag;
GO
IF OBJECT_ID('proj.ChildTransaction') IS NOT NULL
    DROP TABLE proj.ChildTransaction;
GO
IF OBJECT_ID('proj.ParentTransaction') IS NOT NULL
    DROP TABLE proj.ParentTransaction;
GO
IF OBJECT_ID('proj.SavingsGoal') IS NOT NULL
    DROP TABLE proj.SavingsGoal;
GO
IF OBJECT_ID('proj.BudgetAmount') IS NOT NULL
    DROP TABLE proj.BudgetAmount;
GO
IF OBJECT_ID('proj.Budget') IS NOT NULL
    DROP TABLE proj.Budget;
GO
IF OBJECT_ID('proj.BudgetCategory') IS NOT NULL
    DROP TABLE proj.BudgetCategory;
GO
IF OBJECT_ID('proj.HouseholdMember') IS NOT NULL
    DROP TABLE proj.HouseholdMember;
GO
IF OBJECT_ID('proj.Payee') IS NOT NULL
    DROP TABLE proj.Payee;
GO
IF OBJECT_ID('proj.PayeeCategory') IS NOT NULL
    DROP TABLE proj.PayeeCategory;
GO
IF OBJECT_ID('proj.AccountProperty') IS NOT NULL
    DROP TABLE proj.AccountProperty;
GO
IF OBJECT_ID('proj.AccountChecking') IS NOT NULL
    DROP TABLE proj.AccountChecking;
GO
IF OBJECT_ID('proj.AccountSavings') IS NOT NULL
    DROP TABLE proj.AccountSavings;
GO
IF OBJECT_ID('proj.AccountCreditCard') IS NOT NULL
    DROP TABLE proj.AccountCreditCard;
GO
IF OBJECT_ID('proj.AccountLoan') IS NOT NULL
    DROP TABLE proj.AccountLoan;
GO
IF OBJECT_ID('proj.BalanceReconciliation') IS NOT NULL
    DROP TABLE proj.BalanceReconciliation;
GO
IF OBJECT_ID('proj.Account') IS NOT NULL
    DROP TABLE proj.Account;
GO
IF OBJECT_ID('proj.AccountType') IS NOT NULL
    DROP TABLE proj.AccountType;

    
---------------------
-- Drop functions  --
---------------------

IF OBJECT_ID('proj.GetAccountID') IS NOT NULL
    DROP FUNCTION proj.GetAccountID;
GO
IF OBJECT_ID('proj.GetAccountTypeID') IS NOT NULL
    DROP FUNCTION proj.GetAccountTypeID;
GO
IF OBJECT_ID('proj.GetPayeeID') IS NOT NULL
    DROP FUNCTION proj.GetPayeeID;
GO
IF OBJECT_ID('proj.GetPayeeCategoryID') IS NOT NULL
    DROP FUNCTION proj.GetPayeeCategoryID;
GO
IF OBJECT_ID('proj.GetHouseholdMemberID') IS NOT NULL
    DROP FUNCTION proj.GetHouseholdMemberID;
GO
IF OBJECT_ID('proj.GetTagID') IS NOT NULL
    DROP FUNCTION proj.GetTagID;
GO
IF OBJECT_ID('proj.GetBudgetID') IS NOT NULL
    DROP FUNCTION proj.GetBudgetID;
GO
IF OBJECT_ID('proj.GetBudgetCategoryID') IS NOT NULL
    DROP FUNCTION proj.GetBudgetCategoryID;
GO
IF OBJECT_ID('proj.GetPayeeName') IS NOT NULL
    DROP FUNCTION proj.GetPayeeName;
GO


----------------------
-- Drop procedures  --
----------------------

IF OBJECT_ID('proj.GetOrCreatePayee') IS NOT NULL
	DROP PROCEDURE proj.GetOrCreatePayee


--------------------------------------------
-- Create tables in order of dependencies --
--------------------------------------------

-- AccountType
CREATE TABLE proj.AccountType (
    AccountTypeID int IDENTITY NOT NULL, -- PK
    Name          varchar(50)  NOT NULL,

    CONSTRAINT PK_AccountType PRIMARY KEY (AccountTypeID)
    );
GO

-- Account
CREATE TABLE proj.Account (
    AccountID     int IDENTITY  NOT NULL, -- PK
    Name          varchar(50)   NOT NULL,
    AccountTypeID int           NOT NULL, -- FK
    Comments      varchar(2000)     NULL,

    CONSTRAINT PK_Account  PRIMARY KEY (AccountID),
    CONSTRAINT FK1_Account FOREIGN KEY (AccountTypeID) REFERENCES proj.AccountType(AccountTypeID)
    );
GO

-- BalanceReconciliation
CREATE TABLE proj.BalanceReconciliation (
    BalanceReconciliationID int IDENTITY  NOT NULL, -- PK
    AccountID               int           NOT NULL, -- FK
    Balance                 decimal(18,2) NOT NULL,
    DateTime                datetime2     NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT PK_BalanceReconciliation  PRIMARY KEY (BalanceReconciliationID),
    CONSTRAINT FK1_BalanceReconciliation FOREIGN KEY (AccountID) REFERENCES proj.Account(AccountID),
    CONSTRAINT U1_BalanceReconciliation  UNIQUE (AccountID, DateTime)
    );
GO

-- AccountLoan
CREATE TABLE proj.AccountLoan (
    AccountID       int          NOT NULL, -- PK, FK
    OriginationDate date         NOT NULL,
    Term            smallint     NOT NULL,
    AnnualRate      decimal(8,6) NOT NULL,
    MonthlyPayment  decimal(7,2) NOT NULL,

    CONSTRAINT PK_AccountLoan  PRIMARY KEY (AccountID),
    CONSTRAINT FK1_AccountLoan FOREIGN KEY (AccountID) REFERENCES proj.Account(AccountID)
    );
GO

-- AccountCreditCard
CREATE TABLE proj.AccountCreditCard (
    AccountID          int          NOT NULL, -- PK, FK
    OpeningDate        date         NOT NULL,
    ClosingDate        date             NULL,
    ExpectedAnnualRate decimal(8,6) NOT NULL,
    AnnualFee          decimal(8,2) NOT NULL DEFAULT 0,
    
    CONSTRAINT PK_AccountCreditCard  PRIMARY KEY (AccountID),
    CONSTRAINT FK1_AccountCreditCard FOREIGN KEY (AccountID) REFERENCES proj.Account(AccountID)
    );
GO

-- AccountSavings
CREATE TABLE proj.AccountSavings (
    AccountID    int          NOT NULL, -- PK, FK
    AnnualReturn decimal(8,6) NOT NULL,
    
    CONSTRAINT PK_AccountSavings  PRIMARY KEY (AccountID),
    CONSTRAINT FK1_AccountSavings FOREIGN KEY (AccountID) REFERENCES proj.Account(AccountID)
    );
GO

-- AccountChecking
CREATE TABLE proj.AccountChecking (
    AccountID    int          NOT NULL, -- PK, FK
    AnnualReturn decimal(8,6) NOT NULL,
    
    CONSTRAINT PK_AccountChecking  PRIMARY KEY (AccountID),
    CONSTRAINT FK1_AccountChecking FOREIGN KEY (AccountID) REFERENCES proj.Account(AccountID)
    );
GO

-- AccountProperty  
CREATE TABLE proj.AccountProperty (
    AccountID    int          NOT NULL, -- PK, FK
    Appreciation decimal(8,6) NOT NULL,
    
    CONSTRAINT PK_AccountProperty  PRIMARY KEY (AccountID),
    CONSTRAINT FK1_AccountProperty FOREIGN KEY (AccountID) REFERENCES proj.Account(AccountID)
    );
GO

-- PayeeCategory
CREATE TABLE proj.PayeeCategory (
    PayeeCategoryID int IDENTITY NOT NULL, -- PK
    Name            varchar(50)  NOT NULL,

    CONSTRAINT PK_PayeeCategory PRIMARY KEY (PayeeCategoryID)
    );
GO

-- Payee
CREATE TABLE proj.Payee (
    PayeeID         int IDENTITY  NOT NULL, -- PK
    Name            varchar(50)   NOT NULL,
    PayeeCategoryID int               NULL, -- FK
    Comments        varchar(2000)     NULL,

    CONSTRAINT PK_Payee  PRIMARY KEY (PayeeID),
    CONSTRAINT FK1_Payee FOREIGN KEY (PayeeCategoryID) REFERENCES proj.PayeeCategory(PayeeCategoryID)
    );
GO

-- HouseholdMember
CREATE TABLE proj.HouseholdMember (
    HouseholdMemberID int IDENTITY NOT NULL, -- PK
    FirstName         varchar(50)  NOT NULL,
    LastName          varchar(50)  NOT NULL,

    CONSTRAINT PK_HouseholdMember PRIMARY KEY (HouseholdMemberID)
    );
GO

-- BudgetCategory
CREATE TABLE proj.BudgetCategory (
    BudgetCategoryID int IDENTITY  NOT NULL, -- PK
    Name             varchar(50)   NOT NULL,
    Comments         varchar(2000)     NULL,

    CONSTRAINT PK_BudgetCategory PRIMARY KEY (BudgetCategoryID)
    );
GO

-- Budget
CREATE TABLE proj.Budget (
    BudgetID         int IDENTITY  NOT NULL, -- PK
    Name             varchar(50)   NOT NULL,
    CarryoverOption  tinyint       NOT NULL DEFAULT 0,
      -- -1 = No Carryover
      --  0 = Positive Balance Carryover
      --  1 = Positive and Negative Balance Caryover
    FrequencyMonths  smallint      NOT NULL DEFAULT 1,
    BudgetCategoryID int               NULL, -- FK
    Comments         varchar(2000)     NULL,

    CONSTRAINT PK_Budget  PRIMARY KEY (BudgetID),
    CONSTRAINT FK1_Budget FOREIGN KEY (BudgetCategoryID) REFERENCES proj.BudgetCategory(BudgetCategoryID),
    
    CONSTRAINT CHK_Budget_CarryoverOption CHECK (CarryoverOption = -1 OR
                                                 CarryoverOption = 0  OR
                                                 CarryoverOption = 1)
    );
GO

-- BudgetAmount
CREATE TABLE proj.BudgetAmount (
    BudgetAmountID int IDENTITY  NOT NULL, -- PK
    BudgetID       int           NOT NULL, -- FK
    MonthStarting  date          NOT NULL,
    Amount         decimal(18,2) NOT NULL,
    Comments       varchar(2000)     NULL,

    CONSTRAINT PK_BudgetAmount  PRIMARY KEY (BudgetAmountID),
    CONSTRAINT FK1_BudgetAmount FOREIGN KEY (BudgetID) REFERENCES proj.Budget(BudgetID)
    );
GO

-- SavingsGoal
CREATE TABLE proj.SavingsGoal (
    SavingsGoalID int IDENTITY  NOT NULL, -- PK
    BudgetID      int           NOT NULL, -- FK
    Amount        decimal(18,2) NOT NULL,
    StartDate     date          NOT NULL DEFAULT GETDATE(),
    EndDate       date          NOT NULL,
    Comments      varchar(2000)     NULL,

    CONSTRAINT PK_SavingsGoal  PRIMARY KEY (SavingsGoalID),
    CONSTRAINT FK1_SavingsGoal FOREIGN KEY (BudgetID) REFERENCES proj.Budget(BudgetID)
    );
GO

-- ParentTransaction
CREATE TABLE proj.ParentTransaction (
    ParentTransactionID int IDENTITY  NOT NULL, -- PK
    TransactionDate     date          NOT NULL DEFAULT GETDATE(),
    AccountID           int           NOT NULL, -- FK
    PayeeID             int           NOT NULL, -- FK
    Amount              decimal(18,2) NOT NULL,
    HouseholdMemberID   int           NOT NULL, -- FK
    Memo                varchar(2000)     NULL,

    CONSTRAINT PK_ParentTransaction  PRIMARY KEY (ParentTransactionID),
    CONSTRAINT FK1_ParentTransaction FOREIGN KEY (AccountID)         REFERENCES proj.Account(AccountID),
    CONSTRAINT FK2_ParentTransaction FOREIGN KEY (PayeeID)           REFERENCES proj.Payee(PayeeID),
    CONSTRAINT FK3_ParentTransaction FOREIGN KEY (HouseholdMemberID) REFERENCES proj.HouseholdMember(HouseholdMemberID)
    );
GO

-- ChildTransaction
CREATE TABLE proj.ChildTransaction (
    ChildTransactionID         int IDENTITY  NOT NULL, -- PK
    ParentTransactionID        int           NOT NULL, -- FK
    Amount                     decimal(18,2) NOT NULL,
    BudgetID                   int               NULL, -- FK
    Memo                       varchar(2000)     NULL,
    TransferChildTransactionID int               NULL, -- FK

    CONSTRAINT PK_ChildTransaction  PRIMARY KEY (ChildTransactionID),
    CONSTRAINT FK1_ChildTransaction FOREIGN KEY (ParentTransactionID)       REFERENCES proj.ParentTransaction(ParentTransactionID),
    CONSTRAINT FK2_ChildTransaction FOREIGN KEY (BudgetID)                  REFERENCES proj.Budget(BudgetID),
    CONSTRAINT FK3_ChildTransaction FOREIGN KEY (TransferChildTransactionID) REFERENCES proj.ChildTransaction(ChildTransactionID)
    );
GO

-- Tag
CREATE TABLE proj.Tag (
    TagID int IDENTITY NOT NULL, -- PK
    Name  varchar(50)  NOT NULL,

    CONSTRAINT PK_Tag PRIMARY KEY (TagID)
    );
GO

-- TransactionTag
CREATE TABLE proj.TransactionTag (
    ChildTransactionID int NOT NULL, -- PK, FK
    TagID              int NOT NULL, -- PK, FK

    CONSTRAINT PK_TransactionTag  PRIMARY KEY (ChildTransactionID, TagID),
    CONSTRAINT FK1_TransactionTag FOREIGN KEY (ChildTransactionID) REFERENCES proj.ChildTransaction(ChildTransactionID),
    CONSTRAINT FK2_TransactionTag FOREIGN KEY (TagID)              REFERENCES proj.Tag(TagID)
    );
GO


--------------------------------------------------
-- Create functinos used in data initialization --
--------------------------------------------------

-- GetAccountID
---- Lookup AccountID given an account Name
CREATE FUNCTION proj.GetAccountID (@accountName varchar(50))
    RETURNS int
    BEGIN
        DECLARE @accountID int
            SELECT @accountID = AccountID
            FROM proj.Account
            WHERE Name = @accountName;
        RETURN @accountID;
    END;
GO

-- GetAccountTypeID
---- Lookup AccountTypeID given an account type Name
CREATE FUNCTION proj.GetAccountTypeID (@accountTypeName varchar(50))
    RETURNS int
    BEGIN
        DECLARE @accountTypeID int
            SELECT @accountTypeID = AccountTypeID
            FROM proj.AccountType
            WHERE Name = @accountTypeName;
        RETURN @accountTypeID;
    END;
GO

-- GetPayeeID
---- Lookup PayeeID given an Payee Name
CREATE FUNCTION proj.GetPayeeID (@payeeName varchar(50))
    RETURNS int
    BEGIN
        DECLARE @payeeID int
            SELECT @payeeID = PayeeID
            FROM proj.Payee
            WHERE Name = @payeeName;
        RETURN @payeeID;
    END;
GO

-- GetPayeeCategoryID
---- Lookup PayeeCategoryID given an Payee Name
CREATE FUNCTION proj.GetPayeeCategoryID (@payeeCategoryName varchar(50))
    RETURNS int
    BEGIN
        DECLARE @payeeCategoryID int
            SELECT @payeeCategoryID = PayeeCategoryID
            FROM proj.PayeeCategory
            WHERE Name = @payeeCategoryName;
        RETURN @payeeCategoryID;
    END;
GO

-- GetHouseholdMemberID
---- Lookup HouseholdMemberID given an HouseholdMember Name
CREATE FUNCTION proj.GetHouseholdMemberID (@firstName varchar(50), @lastName varchar(50))
    RETURNS int
    BEGIN
        DECLARE @householdMemberID int
            SELECT @householdMemberID = HouseholdMemberID
            FROM proj.HouseholdMember
            WHERE FirstName = @firstName AND
                  LastName  = @lastName;
        RETURN @householdMemberID;
    END;
GO

-- GetTagID
---- Lookup TagID given an Tag Name
CREATE FUNCTION proj.GetTagID (@tagName varchar(50))
    RETURNS int
    BEGIN
        DECLARE @tagID int
            SELECT @tagID = TagID
            FROM proj.Tag
            WHERE Name = @tagName;
        RETURN @tagID;
    END;
GO

-- GetBudgetID
---- Lookup BudgetID given an Budget Name
CREATE FUNCTION proj.GetBudgetID (@budgetName varchar(50))
    RETURNS int
    BEGIN
        DECLARE @budgetID int
            SELECT @budgetID = BudgetID
            FROM proj.Budget
            WHERE Name = @budgetName;
        RETURN @budgetID;
    END;
GO

-- GetBudgetCategoryID
---- Lookup BudgetCategoryID given an BudgetCategory Name
CREATE FUNCTION proj.GetBudgetCategoryID (@budgetCategoryName varchar(50))
    RETURNS int
    BEGIN
        DECLARE @budgetCategoryID int
            SELECT @budgetCategoryID = BudgetCategoryID
            FROM proj.BudgetCategory
            WHERE Name = @budgetCategoryName;
        RETURN @budgetCategoryID;
    END;
GO

-- GetOrCreatePayee
---- Lookup PayeeID if Payee exists, otherwise create a new Payee and return the PayeeID
CREATE PROCEDURE proj.GetOrCreatePayee @payeeName varchar(50), @payeeID int OUTPUT
AS
	SET NOCOUNT ON;
	IF @payeeName IN (Select Name FROM proj.Payee WHERE Name = @payeeName)
		SELECT @payeeID = PayeeID FROM proj.Payee WHERE Name = @payeeName;
	ELSE
		INSERT INTO Payee (Name) VALUES (@payeeName);
		SET @payeeID = SCOPE_IDENTITY();
GO


-- GetPayeeName
---- Lookup Payee Name based on ID
CREATE FUNCTION proj.GetPayeeName (@payeeID int)
    RETURNS varchar(50)
    BEGIN
        DECLARE @payeeName varchar(50)
        SELECT @payeeName = Name
        FROM proj.Payee
        WHERE PayeeID = @payeeID;
        RETURN @payeeName;
    END;
GO
