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
-- transactions.sql           --
-- Import transaction data    --
--                            --
--------------------------------

-----------------------------
-- Remove data from tables --
-----------------------------
DELETE FROM proj.ChildTransaction;
GO
DELETE FROM proj.ParentTransaction;
GO


---------------------
-- DROP PROCEDURES --
---------------------
IF OBJECT_ID('proj.AddParentTransaction') IS NOT NULL
	DROP PROCEDURE proj.AddParentTransaction;
GO
IF OBJECT_ID('proj.AddChildTransaction') IS NOT NULL
	DROP PROCEDURE proj.AddChildTransaction;
GO
IF OBJECT_ID('proj.NewTransaction') IS NOT NULL
	DROP PROCEDURE proj.NewTransaction
GO
IF OBJECT_ID('proj.NewTransfer') IS NOT NULL
	DROP PROCEDURE proj.NewTransfer
GO


-----------------------
-- CREATE PROCEDURES --
-----------------------


-----------------------
-- Create stored procedure for adding a new parent transaction
CREATE PROCEDURE proj.AddParentTransaction @transactionDate date,
       									   @accountName varchar(50),
       									   @payeeName varchar(50),
       									   @amount decimal(18,6),
       									   @householdMemberFirstName varchar(50),
       									   @householdMemberLastName varchar(50),
       									   @memo varchar(2000),
       									   @parentTransactionID int OUTPUT
AS
	SET NOCOUNT ON;
	
	-- Check if payee name exists. If it does, set @payeeID, if not, create payee and set @payeeID (CANNOT BE A TRANSFER)
	DECLARE @payeeID int
	IF @payeeName IN (Select Name FROM proj.Payee WHERE Name = @payeeName)
		SELECT @payeeID = PayeeID FROM proj.Payee WHERE Name = @payeeName;
	ELSE BEGIN
		INSERT INTO Payee (Name) VALUES (@payeeName);
		SET @payeeID = SCOPE_IDENTITY();
	END
	
	-- Create insert statment for parent transaction
	INSERT INTO proj.ParentTransaction (TransactionDate,
	                                    AccountID,
	                                    PayeeID,
	                                    Amount,
	                                    HouseholdMemberID,
	                                    Memo)
	VALUES (@transactionDate,
	        proj.GetAccountID(@accountName),
	        @payeeID,
	        @amount,
	        proj.GetHouseholdMemberID(@householdMemberFirstName, @householdMemberLastName),
	        @memo);
	
	-- Return the ID of the new parent transaction
	SET @parentTransactionID = SCOPE_IDENTITY();
GO


-----------------------
-- Create sotred procedure for adding a new child transaction (CANNOT BE A TRANSFER)
CREATE PROCEDURE proj.AddChildTransaction @parentTransactionID int,
										  @amount int,
										  @budgetName varchar(50),
										  @memo varchar(2000)
AS
	SET NOCOUNT ON;
	
	INSERT INTO proj.ChildTransaction (ParentTransactionID,
									   Amount,
									   BudgetID,
									   Memo)
	VALUES (@parentTransactionID,
			@amount,
			proj.GetBudgetID(@budgetName),
			@memo);
GO


-----------------------
-- New transfer transaction
CREATE PROCEDURE proj.NewTransfer @transferDate date,
                                  @transferFromAccountName varchar(50),
								  @transferToAccountName varchar(50),
								  @amount decimal(18,6),
								  @memo varchar(2000)
AS
	SET NOCOUNT ON;
	BEGIN TRANSACTION
		
		DECLARE @transferFromChildTransactionID int;
		DECLARE @transferToChildTransactionID int;
		DECLARE @payeeID int;
		DECLARE @payeeName varchar(75);

		-- Account transfer FROM (negative amount)
		SET @payeeName = @transferToAccountName + ' (Transfer)';
		IF @payeeName IN (Select Name FROM proj.Payee WHERE Name = @payeeName)
			SELECT @payeeID = PayeeID FROM proj.Payee WHERE Name = @payeeName;
		ELSE BEGIN
			INSERT INTO Payee (Name) VALUES (@payeeName);
			SET @payeeID = SCOPE_IDENTITY();
		END

		INSERT INTO proj.ParentTransaction (TransactionDate,
											AccountID,
											PayeeID,
											Amount,
											Memo)
		VALUES (@transferDate,
		        proj.GetAccountID(@transferFromAccountName),
				@payeeID,
				@amount * -1,
				@memo + CHAR(10) + 'TRNASFER')
		
		INSERT INTO proj.ChildTransaction (ParentTransactionID,
										   Amount,
										   Memo)
		VALUES (SCOPE_IDENTITY(),
		        @amount * -1,
				@memo + CHAR(10) + 'TRANSFER')
		SET @transferFromChildTransactionID = SCOPE_IDENTITY();

		-- Acount transfer TO (positive amount)
		SET @payeeName = @transferFromAccountName + ' (Transfer)';
		IF @payeeName IN (Select Name FROM proj.Payee WHERE Name = @payeeName)
			SELECT @payeeID = PayeeID FROM proj.Payee WHERE Name = @payeeName;
		ELSE BEGIN
			INSERT INTO Payee (Name) VALUES (@payeeName);
			SET @payeeID = SCOPE_IDENTITY();
		END

		INSERT INTO proj.ParentTransaction (TransactionDate,
											AccountID,
											PayeeID,
											Amount,
											Memo)
		VALUES (@transferDate,
		        proj.GetAccountID(@transferFromAccountName),
				@payeeID,
				@amount,
				@memo)

		INSERT INTO proj.ChildTransaction (ParentTransactionID,
										   Amount,
										   Memo,
										   TransferChildTransactionID)
		VALUES (SCOPE_IDENTITY(),
		        @amount,
				@memo + CHAR(10) + 'TRANSFER',
				@transferFromChildTransactionID)
		SET @transferToChildTransactionID = SCOPE_IDENTITY();
		
		-- Update transfer FROM record with reference to transfer TO record
		UPDATE proj.ChildTransaction
		SET TransferChildTransactionID = @transferToChildTransactionID
		WHERE ChildTransactionID = @transferFromChildTransactionID

	COMMIT
GO


-----------------------
-- Add new Transaction WITHOUT split
CREATE PROCEDURE proj.NewTransaction @transactionDate date,
       								 @accountName varchar(50),
       							     @payeeName varchar(50),
       								 @amount decimal(18,6),
       							     @householdMemberFirstName varchar(50),
       							     @householdMemberLastName varchar(50),
       							     @memo varchar(2000),
									 @budgetName varchar(50)
AS
	SET NOCOUNT ON;
	BEGIN TRANSACTION
		DECLARE @parentIdentity int
		EXEC proj.AddParentTransaction @transactionDate,
		                               @accountName,
									   @payeeName,
									   @amount,
									   @householdMemberFirstName,
									   @householdMemberLastName,
									   @memo,
									   @parentIdentity OUTPUT;
		EXEC proj.AddChildTransaction @parentIdentity,
		                              @amount,
									  @budgetName,
									  NULL;
	COMMIT
GO


-----------------------
-- Add new Transaction WITH split

IF OBJECT_ID('proj.NewSplitTransaction') IS NOT NULL
	DROP PROCEDURE proj.NewSplitTransaction;
GO
IF TYPE_ID('proj.SplitTransactionType') IS NOT NULL
	DROP TYPE proj.SplitTransactionType;
GO

CREATE TYPE proj.SplitTransactionType AS TABLE
	(ID          int IDENTITY PRIMARY KEY,
	 SplitAmount decimal(18,6),
	 BudgetName  varchar(50),
	 Memo        varchar(2000));
GO

CREATE PROCEDURE proj.NewSplitTransaction @transactionDate date,
										  @accountName varchar(50),
										  @payeeName varchar(50),
										  @totalTransactionAmount decimal(18,6),
										  @householdMemberFirstName varchar(50),
										  @householdMemberLastName varchar(50),
										  @parentTransactionMemo varchar(2000),
										  @transactionSplits SplitTransactionType READONLY
AS
	SET NOCOUNT ON;
	BEGIN TRANSACTION
		
		DECLARE @parentIdentity INT
		EXEC proj.AddParentTransaction @transactionDate,
		                               @accountName,
									   @payeeName,
									   @totalTransactionAmount,
									   @householdMemberFirstName,
									   @householdMemberLastName,
									   @parentTransactionMemo,
									   @parentIdentity OUTPUT;
		
		INSERT INTO proj.ChildTransaction (ParentTransactionID,
									       Amount,
								    	   BudgetID,
									       Memo)
		SELECT @parentIdentity, SplitAmount, proj.GetBudgetID(BudgetName), Memo
		FROM @transactionSplits

		IF (SELECT SUM(Amount)
		    FROM proj.ChildTransaction
			WHERE ParentTransactionID = @parentIdentity)
		    = (SELECT Amount
		       FROM proj.ParentTransaction
			   WHERE ParentTransactionID = @parentIdentity)
		    COMMIT
		ELSE
		    ROLLBACK
GO


-----------------
-- Import data --
-----------------

DECLARE @transactionSplits proj.SplitTransactionType;
INSERT INTO @transactionSplits (SplitAmount, BudgetName, Memo)
VALUES (-100, 'Household', 'Cleaning Supplies'),
       (-150, 'Technology', 'Computer accessories');
EXEC proj.NewSplitTransaction '20190101', 'American Express Delta', 'Amazon', -250, 'Tim', 'Zalk', 'Reference Number 987654321', @transactionSplits
GO

DECLARE @transactionSplits proj.SplitTransactionType;
INSERT INTO @transactionSplits (SplitAmount, BudgetName, Memo)
VALUES (-100, 'Household Supplies', 'Cleaning Supplies'),
       (-100, 'Baby', 'Computer accessories');
EXEC proj.NewSplitTransaction '20190101', 'American Express Delta', 'Amazon', -250, 'Tim', 'Zalk', 'Reference Number 987654321', @transactionSplits
GO


