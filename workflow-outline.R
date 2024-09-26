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
library(httr)

# set-up -------------------------------------------
## fetch and import new data into REDCap ----
api_response <- GET(url = url,
                    add_headers(Authorization = key),
                    encode = "json")

### convert to flat file + do basic cleaning ----
edvol_today <- jsonlite::fromJSON(rawToChar(api_response$content)) %>%
  jsonlite::flatten() %>%
  filter(name %in% hosp_names) %>%
  select(name, matches("edvol")) %>%
  rename(edvol = edVolume.value,
         edvol_update = edVolume.updateTime) %>%
  mutate(edvol = case_when(as.Date(edvol_update) == Sys.Date() ~ edvol,
                           TRUE ~ NA_integer_, 
                           as.Date(edvol_update) < Sys.Date() ~ NA_integer_),
         edvol_update = case_when(!is.na(edvol) ~ edvol_update, 
                                  TRUE ~ NA_character_),
         across(matches("edvol"), ~ as.character(.x))) %>%
  pivot_longer(names_to = "var",
               values_to = "val",
               cols = matches("edvol")) %>%
  mutate(new_var = paste0(var, "_", name_new)) %>%
  select(-c(name_new, var)) %>%
  pivot_wider(names_from = new_var, values_from = val) %>%
  select(record_id, date, everything()) %>%
  select_if(!is.na(.))

### send into REDCap ----
import_data <- importRecords(redcap_con,
                             data = edvol_today,
                             overwriteBehavior = "normal",
                             returnContent = "count",
                             returnData = F)

# make ED Census PDF -------------------------------
today <- str_replace_all(Sys.Date(), "-", "_")
output_file <- paste0("A:/path/ed_census_", today, ".pdf")

rmarkdown::render(input = "A:/source-path/ed_census_markdown_pdf.Rmd",
                  output_file = output_file)

# send email --------------------------------------
## connect to REDCap ----
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
