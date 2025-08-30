library(tidyverse)
library(stringr)
library(stringi)
library(readxl)
library(writexl)


# read participant metadata -----------------------------------------------

f_meta <- list.files("../data_raw/Vocalization study participants answers/all 200 answers/", recursive = T, pattern = "trials.csv", full.names = T)
f_meta2 <- list.files("../data_raw/Vocalization study participants answers/all 200 answers/", recursive = T, pattern = "sessions.csv", full.names = T)
metadata <- do.call(rbind, lapply(1:length(f_meta), function(i) mutate(read_csv(f_meta[i], guess_max = 10000), file = gsub(".*/", "", f_meta[i]))))
metadata2 <- do.call(rbind, lapply(1:length(f_meta2), function(i) mutate(read_csv(f_meta2[i], guess_max = 10000), file = gsub(".*/", "", f_meta2[i]))))


# only keep actual metadata
metadata <- metadata[grep("survey", metadata$Task_Name, ignore.case = T),]

# only keep relevant columns
metadata <- select(metadata, -`English translation`, 
       -`English translation 1`, 
       -`English translation 2`, 
       -`Environment`, -`Environment 1`, 
       -`Environment_copy_c417`, -`Input device`, 
       -`Output device`, -`Countdown`)

# split opening survey from closing survey...
metadata_survey <- select(filter(metadata, Task_Name == "Survey"), Rec_Session_Id,
       Trial_Id, Block_Name, 
       Block_Nr, Task_Name, Task_Nr, `Audio device`, Condition_Id,
       `environment choice`, `Hearing disabilities`,
       `Native language`, `Other languages`, `Text device`, file)

metadata_closing_survey <- select(filter(metadata, Task_Name == "Closing survey"), 
       Rec_Session_Id,
       Trial_Id, Block_Name, 
       Block_Nr, Task_Name, Task_Nr,
       Condition_Id, Goal, quantity, `toughness...29`, file)

# ... and merge them together so that we have
# one row per participant
metadata_closing_survey$Goal <- trimws(metadata_closing_survey$Goal)

metadata <- left_join(metadata_survey, metadata_closing_survey,
          by = intersect(colnames(metadata_survey), 
                         colnames(metadata_closing_survey))) 

# some character columns lost in left_join,
# hence we add them manually
metadata$Goal <- metadata_closing_survey$Goal
metadata$quantity <- metadata_closing_survey$quantity
metadata$toughness...29 <- metadata_closing_survey$toughness...29


# also add the data from the sessions files
any(metadata2$Rec_Session_Id != metadata$Rec_Session_Id)
# metadata <- left_join(metadata, metadata2)
metadata <- cbind(metadata, 
      select(metadata2, -intersect(colnames(metadata), colnames(metadata2))))


# export ------------------------------------------------------------------

# write_xlsx(metadata, "../metadata/all_metadata_vocalizations.xlsx")

