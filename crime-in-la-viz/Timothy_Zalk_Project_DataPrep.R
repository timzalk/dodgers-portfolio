# IST 719
# Project

# Data Prep

# Data Sources
# City of Los Angeles Public Data
# https://data.lacity.org
# 
# ARRESTS
#  Rows  Columns
# 1.34M      17
# Each row is a the booking of an arrestee
# https://data.lacity.org/A-Safe-City/Arrest-Data-from-2010-to-Present/yru6-6re4
# Columns
# Report.ID                 ID of arrest
# Arrest.Date               Date of arrest
# Time                      time of arrest
# Area.ID                   LAPD area id
# Area.Name                 LAPD area name
# Reporting.District        LAPD District (Sub-area)
# Age                       Age
# Sex.Code                  sex
# Descent.Code              Race/Ethnicity Code
# Charge.Group.Code         Category of arrest charge
# Charge.Group.Description  Desc of charge group code
# Arrest.Type.Code          Arrest type code
# Charge                    Charge code the individual was arrested for
# Charge.Description        Desc of charge code
# Address                   Address of arrest (rounded)
# Cross.Street              Cross streets
# Location                  Coordinates
#
#
# CRIME
# 2010-2019
#  Rows  Columns
# 2.11M       28
# Each row is a crime incident
#
# 2020
#  Rows  Columns
# 61.2K       28
# Each row is a crime incident
#
# https://data.lacity.org/A-Safe-City/Crime-Data-from-2010-to-2019/63jg-8b9z
# https://data.lacity.org/A-Safe-City/Crime-Data-from-2020-to-Present/2nrs-mtv8
# Columns
# DR_NO           file number (official ID)
# Date.Rptd       Date reported
# DATE.OCC        Date occured
# TIME.OCC        Time Occured
# AREA            LAPD Area ID
# AREA.NAME       LAPD Area Name
# Rpt.Dist.No     District (Sub-area)
# Part.1.2        ?
# Crm.Cd          Crime Committed
# Crm.Cd.Desc     Crime description
# Mocodes         Activities associated with the suspect in commission of the crime
# Vict.Age        Victim age
# Vict.Sex        Victim Sex
# Vict.Descent    Victim Race/Ethnicity Code
# Premis.Cd       Type of structure/location of crime
# Premis.Desc     Desc of premis code
# Weapon.Used.Cd  Weapon code used for crime
# Weapon.Desc     Desc of weapon code
# Status          Status code of crime
# Status.Desc     Desc of status code
# Crm.Cd.1        Primary Crime (Same as Crm.Cd)
# Crm.Cd.2        Additional crime
# Crm.Cd.3        Additional crime
# Crm.Cd.4        Additional crime
# LOCATION        Street address of crime (rounded)
# Cross.Street    Cross street of crime
# LAT             Latitude of crime
# LON             Longitude of crime


library(RSocrata)

app.token <- ""
app.secret <- ""
api.key <- ""
api.secret <- ""

crime1.uri  <- "https://data.lacity.org/resource/63jg-8b9z.json"
crime2.uri  <- "https://data.lacity.org/resource/2nrs-mtv8.json"
arrests.uri <- "https://data.lacity.org/resource/yru6-6re4.json"

crime1 <- read.socrata(crime1.uri, app_token = app.token)
crime2 <- read.socrata(crime2.uri, app_token = app.token)

crime <- rbind(crime1, crime2)
save(crime, file="project/data/lapd_crime.Rda")

# rm(list = c("crime1", "crime2", "crime"))

arrests <- read.socrata(arrests.uri, app_token = app.token)
save(arrests, file="project/data/lapd_arrests.Rda")

# crime.sample <- crime[sample(nrow(crime), 1000), ]
# arrests.sample <- arrests[sample(nrow(arrests), 1000), ]
# 
# rm(list = c("crime", "arrests", "crime1", "crime2"))


