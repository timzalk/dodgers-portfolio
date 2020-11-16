IST 659 - Budget Database

project-files

Personal budget database for tracking expenditures, savings goals, and budgets. There was no presentation or report for this project. Scripts in the "project-files" folder are used to create the database in SQL Server.

The following DDL scripts create the database objects:
	1-tables.sql
	2a-data.sql
	2b-data.sql
	3-updates.sql
	4-views.sql
	
The following files provided raw csv data to import through the data-import.R script, using R as an interface to the database.
	amex.csv
	checking.csv
	
The project required data questions to be answered through SQL queries. These queries are in data-questions.Rmd, and the output in data-questions.html.