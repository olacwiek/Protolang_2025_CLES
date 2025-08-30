library(tidyverse)
library(stringr)
library(stringi)
library(readxl)
library(writexl)


# read participant metadata -----------------------------------------------

f_meta <- list.files("../Ape study participants answers/", recursive = T, pattern = "trials.csv", full.names = T)
f_meta2 <- list.files("../Ape study participants answers/", recursive = T, pattern = "sessions.csv", full.names = T)
metadata <- do.call(rbind, lapply(1:length(f_meta), function(i) mutate(read_csv(f_meta[i], guess_max = 10000), file = gsub(".*/", "", f_meta[i]))))
metadata2 <- do.call(rbind, lapply(1:length(f_meta2), function(i) mutate(read_csv(f_meta2[i], guess_max = 10000), file = gsub(".*/", "", f_meta2[i]))))


# only keep actual metadata
metadata <- metadata[grep("survey", metadata$Task_Name, ignore.case = T),]

# only keep relevant columns
metatata <- select(metadata, -matches("copy"), -matches("Translation"))



# split opening survey from closing survey...

# different columns are filled in the opening and closing survey,
# this finds out which ones:
colnames01 <- metadata[which(!is.na(metadata[1,]))] %>% colnames
colnames02 <- metadata[which(!is.na(metadata[2,]))] %>% colnames
colnames02 <- setdiff(colnames02, colnames01)

# survey and closing survey:
metadata_survey <- select(filter(metadata, Task_Name == "Survey"), all_of(colnames01))
metadata_closing_survey <- select(filter(metadata, Task_Name == "imported_Closing survey"), all_of(c(colnames02, "Rec_Session_Id")))
metadata_closing_survey <- rename(metadata_closing_survey, "Rec_Session_Id02" = Rec_Session_Id)


# ... and merge them together so that we have one row per participant:
metadata <- bind_cols(metadata_survey, metadata_closing_survey)
any(metadata$Rec_Session_Id != metadata$Rec_Session_Id02) # good


# update "previous work" options
metadata$`previous work` <- ifelse(metadata$`previous work`=="option_0", "yes", "no")
metadata$`other animals` <- ifelse(metadata$`other animals` =="option_0", "yes", "no")


# export ------------------------------------------------------------------

# write_xlsx(metadata, "all_metadata_apes.xlsx")

# # time to complete
# 
# library(lubridate)
# metadata$time_diff_sec <- sapply(1:nrow(metadata), function(i) as.numeric(difftime(metadata$Start_Time_Local[i], metadata$End_Time_Local[i], units = "sec")))
# 
# metadata[which(metadata$time_diff_sec>-1000),]$Rec_Session_Id
