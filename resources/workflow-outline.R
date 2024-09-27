####################################################
#
# Automatically download, store + process data using R and REDCap
#
###################################################

library(stringr)
library(tinytex)
library(tidyverse) 
library(lubridate)
library(redcapAPI)
library(sendmailR)
library(httr)

# process source data ------------------------------
## fetch source data with an API ----
api_response <- GET(url = url,
                    add_headers(Authorization = key),
                    encode = "json")

# convert from json to 2x2 and do basic cleaning ----
edvol_today <- jsonlite::fromJSON(rawToChar(api_response$content)) %>%
  jsonlite::flatten() %>%
  select(name, matches("edvol")) %>%
  rename(edvol = edVolume.value,
         edvol_update = edVolume.updateTime) %>%
  mutate(record_id = as.numeric(Sys.Date() - as.Date("2023-01-01")),
         edvol = case_when(as.Date(edvol_update) == Sys.Date() ~ edvol,
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
  select(record_id, date, everything()) 

# send into REDCap ----
importRecords(redcap_con,
              data = edvol_today,
              overwriteBehavior = "normal")


# make ED Census PDF -------------------------------
today <- str_replace_all(Sys.Date(), "-", "_")
output_file <- paste0("A:/path/ed_census_", today, ".pdf") # this is where the path where you want the rendered file to live goes

rmarkdown::render(input = "A:/source-path/ed_census_markdown_pdf.Rmd", # this is the path of the .RMD file you want to render
                  output_file = output_file) 

# send email --------------------------------------
# inputs ----
body <- "text here"
final_file <- output_file
attach_name <- "text here"

weekday <- as.character(lubridate::wday(Sys.Date()-1, label = T, abbr = F))
date <- Sys.Date()-1
subject <- paste0("ED Census Update for ", weekday, " ", date)

attach_obj <- mime_part(x = final_file,
                        name = attach_name)
body_with_attach <- list(body, 
                         attach_obj)

from <- sprintf("email@email.com")
to <- sprintf(c("email@email.com"))

# send email ----
sendmail(from = from,
         to = to,
         subject = subject,
         msg = body_with_attach,
         control = list(smtpServe = "server"))