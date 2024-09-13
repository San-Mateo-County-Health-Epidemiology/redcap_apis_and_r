####################################################
#
# Download ED Census Data, Make ED Census Report + Send Email with info 
#
###################################################

# set up ------------------------------------------
setwd("")

library(stringr)
library(tinytex)
library(tidyverse) 
library(lubridate)
library(redcapAPI)
library(sendmailR)

# set-up -------------------------------------------
# fetch and import new data into REDCap ----------------------
source("scheduled_scripts\\sourced_scripts\\fetch_and_import_ed_census_data.R")

# make ED Census PDF -------------------------------
today <- str_replace_all(Sys.Date(), "-", "_")
output_file <- paste0("A:/path/ed_census_", today, ".pdf")

rmarkdown::render(input = "A:/source-path/ed_census_markdown_pdf.Rmd",
                  output_file = output_file)

# send email --------------------------------------
## connect to REDCap ----
redcap_con <- redcapConnection(url = '', 
                               token = '')

ed_census <- exportRecordsTyped(redcap_con)

## wrangle todays data into a string for the email ----
body <- ed_census

## compose and send email ----
weekday <- as.character(lubridate::wday(Sys.Date()-1, label = T, abbr = F))
date <- Sys.Date()-1
  
subject <- paste0("ED Census Update for ", weekday, " ", date)
  
attachmentPath <- final_file
attachmentObject <- mime_part(x = attachmentPath,
                              name = attachmentName)
bodyWithAttachment <- list(body, attachmentObject)
  
server<-list(smtpServer= "server")
  
from <- sprintf("email@email.com")
to <- sprintf(c("email@email.com"))
  
sendmail(from,
         to,
         subject,
         bodyWithAttachment,
         control = server)
