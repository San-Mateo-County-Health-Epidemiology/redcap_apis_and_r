
library(redcapAPI)

# set up connection ----
url <- ""
token <- ""

con <- redcapConnection(url = url, 
                        token = token) 

# fetch data from REDCap ----
## get all fields for all records ----
ed_census <- exportRecordsTyped(con)

## get all fields from a certain form ----
ed_census_form <- exportRecordsTyped(rcon = con,
                                     forms = "dsat")

## get only certain fields ----
ed_census_fields <- exportRecordsTyped(rcon = con,
                                       fields = c("record_id", "date", "edvol_tot"))




library(redcapAPI)

# set up connection ----
url <- ""
token <- ""

con <- redcapConnection(url = url, 
                        token = token) 

# send data into REDCap ----
importRecords(con,
              data = ed_data,
              overwriteBehavior = "normal",
              returnContent = "count",
              returnData = F)

