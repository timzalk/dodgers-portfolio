##############################
#                            #
# Household Finance Database #
# Timothy Zalk               #
# IST 659                    #
#                            #
# Project Deliverabel #2     #
# data-import.R              #
# Import raw data from       #
# financial institutions     #
# into database
#                            #
##############################

# Install necessary packages
#install.packages(c("glue", "RODBC", "RODBCext", "dplyr", "here"))

library(glue)
library(RODBC)
library(RODBCext)
library(dplyr)
library(here)

# Open connection
con <- odbcConnect("proj-connection")


# American Express
# CSV downloads include the following fields:
# 
# Column  Field              Type            Imported To
#-----------------------------------------------------------
#      1  Date               mm/dd/yyyy Day  Date
#      2  Blank.1
#      3  Description        Text            Memo
#      4  Card Holder        Text            Household Member
#      5  Card               Text
#      6  Blank.2
#      7  Blank.3
#      8  Amount             Decimal         Amount
#      9  Blank.4
#     10  Blank.5
#     11  Extended Details   Text
#     12  Doing Business As  Text            Payee
#     13  Address            Text
#     14  Zip, Country       Text
#     15  Reference          Text            Memo
#

# The here package uses a relative path and attaches it's parameter to the path it considers the root directory of the project.
path <- "github/ist659/project/amex.csv"
amex <- read.csv(here(path))

#### If here and the path do not initially work, a sample of five records below can be uncommented to be imported into the database
#
#amex <- read.csv(text = "01/01/2018  Mon,,\"JAMBA JUICE - CERRITOS, CA\",Timothy W Zalk,XXXX-XXXXXX-41004,,,13.03,,,\"00500000087 5624026434\n5624026434\nFAST FOOD REST.  $13.03\n5624026434 \nDescription   Price \nFAST FOOD REST.   $13.03 \n\",Jamba Juice,\"11437 SOUTH ST\nCERRITOS\nCA\",\"90703-6600\nUNITED STATES\"ame,'320180020390349167'\n01/02/2018  Tue,,\"ADOBO TACO GRILL - LAKEWOOD, CA\",Timothy W Zalk,XXXX-XXXXXX-41004,,,19.81,,,\"84540938004 USFC90713\nUSFC90713\n\n\n\n\n\nUSFC90713 \n\",ADOBO TACO GRILL,\"5695 WOODRUFF AVE\nLAKEWOOD\nCA\",\"90713-1129\nUNITED STATES\",'320180040416250347'\n01/02/2018  Tue,,\"PAVILIONS STORE 2209 - LAKEWOOD, CA\",Marianne Zalk,XXXX-XXXXXX-41012,,,88.12,,,\"GROCERY STORE\nGROCERY STORE\n\nGROCERY STORE \n\",PAVILIONS,\"5500 WOODRUFF AVE\nLAKEWOOD\nCA\",\"90713\nUNITED STATES\",'320180040420917251'\n01/04/2018  Thu,,\"AMAZON.COM - AMZN.COM/BILL, WA\",Timothy W Zalk,XXXX-XXXXXX-41004,,,19.09,,,\"HN7CJ8XCHXH MERCHANDISE\nMERCHANDISE\n\nMERCHANDISE \n\",AMAZON.COM,\"410 TERRY AVE N\n-\nSEATTLE\nWA\",\"98109\nUNITED STATES\",'320180060452238489'\n01/04/2018  Thu,,\"IN N OUT BURGER 040 650000009324438 - LAKEWOOD, CA\",Marianne Zalk,XXXX-XXXXXX-41012,,,5.53,,,\"10156320180 8662916338\n8662916338\n\n8662916338 \n\",IN-N-OUT BURGER #40,\"5820 BELLFLOWER BLVD\nLAKEWOOD\nCA\",\"90713\nUNITED STATES\",'320180050431006536'")

amex.columns <- c("Date",
                  "Blank.1",
                  "Description",
                  "Card.Holder",
                  "Card",
                  "Blank.2",
                  "Blank.3",
                  "Amount",
                  "Blank.4",
                  "Blank.5",
                  "Extended.Details",
                  "DBA",
                  "Address",
                  "Zip.Country",
                  "Reference")

colnames(amex) <- amex.columns

# Prepare data for import
# Date must be converted to SQL Server compatible format
# Account name must be assigned
# Payee must be derived
# Name must be converted to names assigned in SQL Server
# Memo must be derived from relevant fields

amex.import <- data.frame(Date = paste0(substr(amex$Date, 7, 10), substr(amex$Date, 1, 2), substr(amex$Date, 4, 5)),
                          Account = "American Express Delta",
                          Payee = gsub("'", "''", trim(amex$DBA)), #payees with apostrophes in their name must have them escaped, such as McDonald's
                          Amount = as.numeric(amex$Amount) * -1,
                          FirstName = ifelse(substr(amex$Card.Holder, 1, 7) == "Timothy", "Tim", "Marianne"),
                          LastName = "Zalk",
                          Memo = gsub("'", "", paste0(amex$Description, "; Reference: ", amex$Reference)),
                          Budget = "NULL")

# Build the SQL statement with an EXEC for each transaction
sql.amex <- ""
for (i in 1:nrow(amex.import)) {
  sql.amex <- paste0(sql.amex, "EXEC proj.NewTransaction '",
                amex.import$Date[i], "', '",
                amex.import$Account[i], "', '",
                amex.import$Payee[i], "', ",
                amex.import$Amount[i], ", '",
                amex.import$FirstName[i], "', '",
                amex.import$LastName[i], "', '",
                amex.import$Memo[i], "', ",
                amex.import$Budget[i], "; ")
}

# Execute the SQL statement
sqlExecute(con, sql.amex)



# Credit Union Checking Account
# CSV downloads include the following fields:
# 
# Column  Field              Type            Imported To
#-----------------------------------------------------------
#      1  Date               mm/dd/yyyy      Date
#      2  Description        Payee : memo    Payee, memo
#      3  Comments           Text            Memo
#      4  Check Number       Text            Memo
#      5  Amount             Decimal         Amount
#      6  Balance            Decimal
#

path <- "github/ist659/project/checking.csv"
checking <- read.csv(here(path))

#### If here and the path do not initially work, a sample of five records below can be uncommented to be imported into the database
#
#checking <- read.csv(text = "05/18/18,NITTO TIRE NORTH : DIRECT DEP  ID: 9111111101DATA: XXXXXX5043        03 CO: NITTO TIRE NORTH Entry Class Code: PPD,,,153.91,0\n05/21/18,9H7YO56P3F5173Z : TRANSFER  ID: 6192912998CO: 9H7YO56P3F5173Z Entry Class Code: WEB,,,49.14,0\n05/22/18,AAA INSURANCE : PAYMENT  ID: XXXXXX5765 CO: AAA INSURANCE Entry Class Code: PPD,,,-218.84,0\n05/25/18,NITTO TIRE USA : DIRECT DEP  ID: 9111111101DATA: XXXXXX5043        03 CO: NITTO TIRE USA Entry Class Code: PPD,,,2040.66,0\n05/29/18,VENMO : CASHOUT  ID: XXXXXX1992  CO: VENMOEntry Class Code: PPD,,,94.83,0")

checking.columns <- c("Date",
                      "Description",
                      "Comments",
                      "Check.Number",
                      "Amount",
                      "Balance")

colnames(checking) <- checking.columns

# Prepare data for import
# Date must be converted to SQL Server compatible format
# Account name must be assigned
# Payee must be derived
# Name must be converted to names assigned in SQL Server
# Memo must be derived from relevant fields

checking.import <- data.frame(Date = paste0("20", substr(checking$Date, 7, 10), substr(checking$Date, 1, 2), substr(checking$Date, 4, 5)),
                              Account = "Credit Union Checking Account",
                              Payee = trimws(substr(checking$Description, 1, regexpr(" : ", checking$Description))),
                              Amount = as.numeric(checking$Amount),
                              FirstName = "Tim",
                              LastName = "Zalk",
                              Memo = paste0(trimws(substr(checking$Description,
                                                          regexpr(" : ", checking$Description) + 2,
                                                          nchar(as.character(checking$Description)))),
                                            "; ", checking$Comments,
                                            ifelse(!is.na(checking$Check.Number), "Check Number ", ""),
                                            checking$Check.Number),
                              Budget = "NULL")

# Build the SQL statement with an EXEC for each transaction
sql.checking <- ""
for (i in 1:nrow(checking.import)) {
  sql.checking <- paste0(sql.checking, "EXEC proj.NewTransaction '",
                checking.import$Date[i], "', '",
                checking.import$Account[i], "', '",
                checking.import$Payee[i], "', ",
                checking.import$Amount[i], ", '",
                checking.import$FirstName[i], "', '",
                checking.import$LastName[i], "', '",
                checking.import$Memo[i], "', ",
                checking.import$Budget[i], "; ")
}

# Execute the SQL statement
sqlExecute(con, sql.checking)
