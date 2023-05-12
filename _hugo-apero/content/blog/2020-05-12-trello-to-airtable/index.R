## ----setup, echo=FALSE-----------------------------------------------------------------
htmltools::tagList(
  xaringanExtra::use_clipboard(
    button_text = "<i class=\"fa fa-clipboard\"></i> Copy Code",
    success_text = "<i class=\"fa fa-check\" style=\"color: #90BE6D\"></i> Copied!",
  ),
  rmarkdown::html_dependency_font_awesome()
)

knitr::opts_chunk$set(eval = FALSE)


## ---- include = FALSE------------------------------------------------------------------
library(emo)

knitr::opts_chunk$set(warning = FALSE, message = FALSE,
                      eval=FALSE)


## ----import, results=FALSE-------------------------------------------------------------
# loading libraries
library(jsonlite)
library(lubridate)
library(tidyverse)


## ----import-json, results=FALSE--------------------------------------------------------
trello <- stream_in(file("program-mgmt.json")) # produces a data frame


## ----glimpse-trello--------------------------------------------------------------------
glimpse(trello)


## ----flatten-and-wrangle, paged.print=TRUE---------------------------------------------
# selecting cards information
cards <- trello$cards # list of 1

# flattening
cards_flat <- flatten(cards) #list of 37

# tibble time
cards_flat_tbl <- as_tibble(cards_flat) # 32 obs of 37 variables
glimpse(cards_flat_tbl)

# selecting wanted variables
cards_trim <- cards_flat_tbl %>%
  select(id, idShort, idList, dateLastActivity, name, desc, dueComplete, due,
         labels, attachments, shortUrl, closed) %>%
  arrange(desc(dateLastActivity))


## ----wrangle-labels--------------------------------------------------------------------
# extracting labels details
labels_info <- cards_trim %>%
  select(id, idShort, labels) %>%
  unnest() %>% # no arguments because the nested items don't have names
  rename(labelName = name) %>%
  select(id, idShort, labelName) %>%
  group_by(id, idShort) %>%
  summarize(labelList = list(labelName)) %>%
  mutate(labelList = as.character(labelList)) %>%
  mutate(labelList_tidy = str_remove_all(labelList, pattern = "\"")) %>%
  mutate(labelList_tidy = str_remove_all(labelList_tidy, pattern ="c\\(")) %>%
  mutate(labelList_tidy = str_remove_all(labelList_tidy, pattern ="\\)")) %>%
  unique()

knitr::kable(labels_info %>% head(n = 3L))

# joining back with main cards data frame
ct_labels <- left_join(cards_trim %>% select(-labels), labels_info %>% select(-labelList))


## ---- eval=FALSE-----------------------------------------------------------------------
## # expanding the attachment lists into separate url records
## att_urls <- ct_labels %>%
##   select(idShort, attachments) %>%
##   unnest() %>%
##   select(idShort, url) %>%
##   mutate(url = as.character(url),
##          attachmentError = 'FALSE')
## knitr::kable(att_urls %>% head(n = 3L))
## 
## # creating directory for attachments
## dirAttachments <- "attachments/"
## dir.create(dirAttachments)
## 
## # downloading urls and checking for errors using try()
## for (i in 1:length(att_urls$url)){
##   locAttachments <-
##         paste(dirAttachments, "/", att_urls$idShort[i], "_", basename(att_urls$url[i]), sep = "")
##   step_to_try <- try(attachment_check <- download.file(att_urls$url[i], destfile = locAttachments))
##   if("try-error" %in% class(step_to_try)) {
##     cat("Error row: ", i, "\n", "Error message: ", step_to_try[1], sep = "")
##     att_urls$attachmentError[i] = 'TRUE'
##   }
## }


## ---- eval=FALSE-----------------------------------------------------------------------
## # preparing data frame for export to CSV
## attachment_errors <- att_urls %>%
##   filter(attachmentError == TRUE) %>%
##   rename(Task_Id = idShort, Attachment_URL = url, Attachment_Error = attachmentError)
## 
## # exporting to CSV
## write.csv(attachment_errors, file = "attachment_errors.csv")


## ----attachment-dir, eval=FALSE--------------------------------------------------------
## # creates individual directory folders for each card id
## for (i in 1:length(att_urls$url)){
##   dirAttachments <- paste(dirFiles, "attachments", att_urls$idShort[i], sep = "/")
##   dir.create(dirAttachments) # creates directory for each unique card id
##   locAttachments <- paste(dirAttachments, basename(url[i]), sep = "/")
##   download.file(url[i], destfile = locAttachments)
## }


## ----attachment-var, eval=FALSE--------------------------------------------------------
## # converts the attachment column to a categorical variable in the main cards+labels data frame
## ct_labels <- ct_labels %>%
##   mutate(attachments = ifelse(idShort %in% att_urls$idShort, TRUE, FALSE))


## ----select-list-info------------------------------------------------------------------
# selecting lists information
lists <- trello$lists # list of 1 data frame
glimpse(lists)

# flattening
lists_flat <- lists[[1]] # 17 obs of 9 variables

# selecting wanted variables
lists_trim <- lists_flat %>%
  select(id, name, closed) %>%
  rename(idList = id, nameList = name, closedList = closed)
knitr::kable(lists_trim %>% head(n = 3L))

# joining back with main cards+labels data frame
ct_labels_list <- left_join(ct_labels, lists_trim) %>%
  select(id:shortUrl, labelList_tidy:nameList, closed, closedList)


## ----export-prep, paged.print=TRUE-----------------------------------------------------
# changing variable names
tidy_cards <- ct_labels_list %>%
  select(-id, -idList, -closedList) %>%
  rename(Task = name, Task_ID = idShort, Notes = desc, Done = dueComplete, Date_Due = due,
         Labels = labelList_tidy, Trello_List = nameList, Trello_Last_Modified = dateLastActivity,
         Trello_Url = shortUrl, Trello_Attachments = attachments, Archived = closed) %>%
  select(Task, Task_ID, Notes, Done, Date_Due, Labels, Trello_List, Trello_Last_Modified,
         Trello_Url, Trello_Attachments, Archived) %>%
  mutate(Trello_Last_Modified = as_datetime(Trello_Last_Modified, tz = ""),
         Date_Due = as_datetime(Date_Due, tz = ""),
         Done = ifelse(is.na(Date_Due) == TRUE, 'NA', Done)) # ensures only undone tasks assigned a due date get marked as "FALSE"


## ----collapse=TRUE---------------------------------------------------------------------
# determining the number of unique tasks
length(unique(tidy_cards$Task_ID))

# final look at tidy_cards
glimpse(tidy_cards)


## ----export-csv, eval=FALSE------------------------------------------------------------
## write.csv(tidy_cards, file = "tidy_cards.csv")

