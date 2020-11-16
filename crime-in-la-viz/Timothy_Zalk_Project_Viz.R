library(dplyr)
library(ggplot2)
library(ggmap)
library(maps)
library(mapproj)

load("lapd_crime.Rda")

crime.rows <- format(nrow(crime), big.mark = ",")
crime.cols <- format(ncol(crime), big.mark = ",")

print(crime.rows)
print(crime.cols)

summary(crime)
str(crime)

crime$record_count = 1

###################

### MAP ###

df.map <- data.frame(lon = as.numeric(crime$lon),
                     lat = as.numeric(crime$lat),
                     category = "crime",
                     color = rgb(0, 0, 0.8, 0.1)
                     )

# Remove missing location records
df.map <- df.map %>%
  filter(lon !=0) %>%
  filter(lat !=0)

ggplot(crime) +
  geom_point(aes(x = lon, y = lat), alpha = 0.1)

map <- ggplot(df.map, aes(x = lon, y = lat)) +
  geom_point(size = 0.1, alpha = .01) +
  # coord_equal() +
  # coord_cartesian(xlim = c(-118.7, -118.1),
  #                 ylim = c(33.6, 34.4)) +
  coord_map(xlim = c(-118.7, -118.1),
            ylim = c(33.6, 34.4)) +
  theme(
    panel.grid.major = element_blank(), 
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "transparent",colour = NA),
    plot.background = element_rect(fill = "transparent",colour = NA)
  )
ggsave("map.png", map, bg = "transparent")


key <- ""
register_google(key = key)
la <- get_map(location = "los angeles, california")

ggmap(la, extent = "normal") +
  geom_point(aes(x = lon, y = lat), data = crime, alpha = 0.1)


ggplot(crime, aes(x = lon, y = lat)) + 
  geom_point(size = 0.1, alpha = 0.05) + 
  coord_equal() + 
  xlab('Longitude') + 
  ylab('Latitude') + 
  coord_cartesian(xlim = c(-95.1, -95.7), 
                  ylim = c(29.5, 30.1))





############ PRECINCTS
precinct <- as.data.frame(table(crime$area_name))

ggplot(precinct, aes(x = Freq, y = reorder(Var1, Freq))) +
  geom_bar(stat = "identity")

ggplot(crime) +
  aes(area_name) +
  geom_bar() +
  ggtitle("Crime by Area") +
  coord_flip()




#############
crime_groups <- Vectorize(vectorize.args = "a",
                          FUN = function(a) {
                            as.character(switch(as.character(a),
                                   "ABORTION/ILLEGAL" = "Other",
                                   "ARSON" = "Arson",
                                   "ASSAULT WITH DEADLY WEAPON ON POLICE OFFICER" = "Assault",
                                   "ASSAULT WITH DEADLY WEAPON, AGGRAVATED ASSAULT" = "Assault",
                                   "ATTEMPTED ROBBERY" = "Robbery",
                                   "BATTERY - SIMPLE ASSAULT" = "Battery",
                                   "BATTERY ON A FIREFIGHTER" = "Battery",
                                   "BATTERY POLICE (SIMPLE)" = "Battery",
                                   "BATTERY WITH SEXUAL CONTACT" = "Battery",
                                   "BEASTIALITY, CRIME AGAINST NATURE SEXUAL ASSLT WITH ANIM" = "Sexual",
                                   "BIGAMY" = "Other",
                                   "BIKE - ATTEMPTED STOLEN" = "Theft",
                                   "BIKE - STOLEN" = "Theft",
                                   "BLOCKING DOOR INDUCTION CENTER" = "Other",
                                   "BOAT - STOLEN" = "Theft",
                                   "BOMB SCARE" = "Weapon",
                                   "BRANDISH WEAPON" = "Threat",
                                   "BRIBERY" = "Other",
                                   "BUNCO, ATTEMPT" = "Theft",
                                   "BUNCO, GRAND THEFT" = "Theft",
                                   "BUNCO, PETTY THEFT" = "Theft",
                                   "BURGLARY" = "Burglary",
                                   "BURGLARY FROM VEHICLE" = "Burglary",
                                   "BURGLARY FROM VEHICLE, ATTEMPTED" = "Burglary",
                                   "BURGLARY, ATTEMPTED" = "Burglary",
                                   "CHILD ABANDONMENT" = "Child",
                                   "CHILD ABUSE (PHYSICAL) - AGGRAVATED ASSAULT" = "Child",
                                   "CHILD ABUSE (PHYSICAL) - SIMPLE ASSAULT" = "Child",
                                   "CHILD ANNOYING (17YRS & UNDER)" = "Child",
                                   "CHILD NEGLECT (SEE 300 W.I.C.)" = "Child",
                                   "CHILD PORNOGRAPHY" = "Sexual",
                                   "CHILD STEALING" = "Theft",
                                   "CONSPIRACY" = "Other",
                                   "CONTEMPT OF COURT" = "Court",
                                   "CONTRIBUTING" = "Other",
                                   "COUNTERFEIT" = "Fraud",
                                   "CREDIT CARDS, FRAUD USE ($950 & UNDER" = "Fraud",
                                   "CREDIT CARDS, FRAUD USE ($950.01 & OVER)" = "Fraud",
                                   "CRIMINAL HOMICIDE" = "Homicide-Death",
                                   "CRIMINAL THREATS - NO WEAPON DISPLAYED" = "Threat",
                                   "CRM AGNST CHLD (13 OR UNDER) (14-15 & SUSP 10 YRS OLDER)" = "Other",
                                   "CRUELTY TO ANIMALS" = "Other",
                                   "DEFRAUDING INNKEEPER/THEFT OF SERVICES, $400 & UNDER" = "Fraud",
                                   "DEFRAUDING INNKEEPER/THEFT OF SERVICES, OVER $400" = "Fraud",
                                   "DISCHARGE FIREARMS/SHOTS FIRED" = "Weapon",
                                   "DISHONEST EMPLOYEE - GRAND THEFT" = "Theft",
                                   "DISHONEST EMPLOYEE - PETTY THEFT" = "Theft",
                                   "DISHONEST EMPLOYEE ATTEMPTED THEFT" = "Theft",
                                   "DISRUPT SCHOOL" = "Other",
                                   "DISTURBING THE PEACE" = "Other",
                                   "DOCUMENT FORGERY / STOLEN FELONY" = "Other",
                                   "DOCUMENT WORTHLESS ($200 & UNDER)" = "Other",
                                   "DOCUMENT WORTHLESS ($200.01 & OVER)" = "Other",
                                   "DRIVING WITHOUT OWNER CONSENT (DWOC)" = "Theft",
                                   "DRUGS, TO A MINOR" = "Other",
                                   "DRUNK ROLL" = "Other",
                                   "DRUNK ROLL - ATTEMPT" = "Other",
                                   "EMBEZZLEMENT, GRAND THEFT ($950.01 & OVER)" = "Theft",
                                   "EMBEZZLEMENT, PETTY THEFT ($950 & UNDER)" = "Theft",
                                   "EXTORTION" = "Other",
                                   "FAILURE TO DISPERSE" = "Other",
                                   "FAILURE TO YIELD" = "Other",
                                   "FALSE IMPRISONMENT" = "Other",
                                   "FALSE POLICE REPORT" = "Other",
                                   "FIREARMS RESTRAINING ORDER (FIREARMS RO)" = "Other",
                                   "FIREARMS TEMPORARY RESTRAINING ORDER (TEMP FIREARMS RO)" = "Other",
                                   "GRAND THEFT / AUTO REPAIR" = "Theft",
                                   "GRAND THEFT / INSURANCE FRAUD" = "Fraud",
                                   "HUMAN TRAFFICKING - COMMERCIAL SEX ACTS" = "Sexual",
                                   "HUMAN TRAFFICKING - INVOLUNTARY SERVITUDE" = "Other",
                                   "ILLEGAL DUMPING" = "Other",
                                   "INCEST (SEXUAL ACTS BETWEEN BLOOD RELATIVES)" = "Sexual",
                                   "INCITING A RIOT" = "Other",
                                   "INDECENT EXPOSURE" = "Sexual",
                                   "INTIMATE PARTNER - AGGRAVATED ASSAULT" = "Assault",
                                   "INTIMATE PARTNER - SIMPLE ASSAULT" = "Assault",
                                   "KIDNAPPING" = "Other",
                                   "KIDNAPPING - GRAND ATTEMPT" = "Other",
                                   "LETTERS, LEWD - TELEPHONE CALLS, LEWD" = "Sexual",
                                   "LEWD CONDUCT" = "Sexual",
                                   "LEWD/LASCIVIOUS ACTS WITH CHILD" = "Sexual",
                                   "LYNCHING" = "Homicide-Death",
                                   "LYNCHING - ATTEMPTED" = "Homicide-Death",
                                   "MANSLAUGHTER, NEGLIGENT" = "Homicide-Death",
                                   "ORAL COPULATION" = "Sexual",
                                   "OTHER ASSAULT" = "Assault",
                                   "OTHER MISCELLANEOUS CRIME" = "Other",
                                   "PANDERING" = "Sexual",
                                   "PEEPING TOM" = "Sexual",
                                   "PETTY THEFT - AUTO REPAIR" = "Theft",
                                   "PICKPOCKET" = "Theft",
                                   "PICKPOCKET, ATTEMPT" = "Theft",
                                   "PIMPING" = "Sexual",
                                   "PROWLER" = "Theft",
                                   "PURSE SNATCHING" = "Theft",
                                   "PURSE SNATCHING - ATTEMPT" = "Theft",
                                   "RAPE, ATTEMPTED" = "Sexual",
                                   "RAPE, FORCIBLE" = "Sexual",
                                   "RECKLESS DRIVING" = "Other",
                                   "REPLICA FIREARMS(SALE,DISPLAY,MANUFACTURE OR DISTRIBUTE)" = "Other",
                                   "RESISTING ARREST" = "Resisting Arrest",
                                   "ROBBERY" = "Robbery",
                                   "SEX OFFENDER REGISTRANT OUT OF COMPLIANCE" = "Sexual",
                                   "SEX,UNLAWFUL(INC MUTUAL CONSENT, PENETRATION W/ FRGN OBJ" = "Sexual",
                                   "SEXUAL PENETRATION W/FOREIGN OBJECT" = "Sexual",
                                   "SHOPLIFTING - ATTEMPT" = "Theft",
                                   "SHOPLIFTING - PETTY THEFT ($950 & UNDER)" = "Theft",
                                   "SHOPLIFTING-GRAND THEFT ($950.01 & OVER)" = "Theft",
                                   "SHOTS FIRED AT INHABITED DWELLING" = "Weapon",
                                   "SHOTS FIRED AT MOVING VEHICLE, TRAIN OR AIRCRAFT" = "Weapon",
                                   "SODOMY/SEXUAL CONTACT B/W PENIS OF ONE PERS TO ANUS OTH" = "Sexual",
                                   "STALKING" = "Other",
                                   "TELEPHONE PROPERTY - DAMAGE" = "Vandalism",
                                   "THEFT FROM MOTOR VEHICLE - ATTEMPT" = "Theft",
                                   "THEFT FROM MOTOR VEHICLE - GRAND ($400 AND OVER)" = "Theft",
                                   "THEFT FROM MOTOR VEHICLE - PETTY ($950 & UNDER)" = "Theft",
                                   "THEFT FROM PERSON - ATTEMPT" = "Theft",
                                   "THEFT OF IDENTITY" = "Theft",
                                   "THEFT PLAIN - ATTEMPT" = "Theft",
                                   "THEFT PLAIN - PETTY ($950 & UNDER)" = "Theft",
                                   "THEFT-GRAND ($950.01 & OVER)EXCPT,GUNS,FOWL,LIVESTK,PROD" = "Theft",
                                   "THEFT, COIN MACHINE - ATTEMPT" = "Theft",
                                   "THEFT, COIN MACHINE - GRAND ($950.01 & OVER)" = "Theft",
                                   "THEFT, COIN MACHINE - PETTY ($950 & UNDER)" = "Theft",
                                   "THEFT, PERSON" = "Theft",
                                   "THREATENING PHONE CALLS/LETTERS" = "Threat",
                                   "THROWING OBJECT AT MOVING VEHICLE" = "Weapon",
                                   "TILL TAP - ATTEMPT" = "Theft",
                                   "TILL TAP - GRAND THEFT ($950.01 & OVER)" = "Theft",
                                   "TILL TAP - PETTY ($950 & UNDER)" = "Theft",
                                   "TRAIN WRECKING" = "Other",
                                   "TRESPASSING" = "Trespassing",
                                   "UNAUTHORIZED COMPUTER ACCESS" = "Other",
                                   "VANDALISM - FELONY ($400 & OVER, ALL CHURCH VANDALISMS)" = "Vandalism",
                                   "VANDALISM - MISDEAMEANOR ($399 OR UNDER)" = "Vandalism",
                                   "VEHICLE - ATTEMPT STOLEN" = "Theft",
                                   "VEHICLE - MOTORIZED SCOOTERS, BICYCLES, AND WHEELCHAIRS" = "Theft",
                                   "VEHICLE - STOLEN" = "Theft",
                                   "VIOLATION OF COURT ORDER" = "Court Order",
                                   "VIOLATION OF RESTRAINING ORDER" = "Court Order",
                                   "VIOLATION OF TEMPORARY RESTRAINING ORDER" = "Court Order",
                                   "WEAPONS POSSESSION/BOMBING" = "Weapon"))
                            }
                          )

crime$crime_type_grp <- as.character(crime_groups(a = crime$crm_cd_desc))

crime_types <- as.data.frame(table(crime$crime_type_grp))

ggplot(crime_types, aes(x = Freq, y = reorder(Var1, Freq))) +
  geom_bar(stat = "identity")



ggplot(crime) +
  aes(crime_type_grp) +
  geom_bar() +
  ggtitle("Crime by Type") +
  theme(axis.text.x = element_text(angle = 90))




##########

crime$dayname <- weekdays(as.Date(crime$date_occ))

crime.by.day <- as.data.frame(table(crime$dayname))
crime.by.day <- crime.by.day[c(4, 2, 6, 7, 5, 1, 3), ]
crime.by.date <- as.data.frame(table(crime$date_occ))
# ggplot(crime.by.date, aes(x = Var1, y = Freq)) +
#   geom_line()
plot(crime.by.date$Var1, crime.by.date$Freq,
     type = "l", cex = 1.1)

ggplot(crime.by.date, aes(x = Var1, y = Freq)) +
  geom_point()

ggplot(crime.by.day, aes(x = Var1, y = Freq)) +
  geom_bar(stat = "identity")

ggplot(crime.by.day, aes(x = Var1, y = Freq)) +
  geom_point() +
  geom_segment(aes(x = Var1, xend = Var1, y = 0, yend = Freq))


###########
# crime.matrix <- as.matrix(crime$area_name, crime$crime_type_grp)

library(viridis)

crime.matrix <- aggregate(crime$record_count, by = list(area = crime$area_name, crime_group = crime$crime_type_grp), FUN = count)

crime.matrix <- as.matrix(table(crime$area_name, crime$crime_type_grp))

heatmap(crime.matrix, scale = "column",
        col = magma(255))

