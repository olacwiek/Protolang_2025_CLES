# This script checks if the number of coders 
# mentioned in the file name matches the
# actual number of coders in the data.

library(tidyverse)
library(readxl)
library(writexl)
library(stringr)
library(stringi)



# list of files -----------------------------------------------------------

f_stefan <- list.files("../Coders/Sheets for Stefan, Sveta and Michael/", pattern = "^SH", full.names = T)
f_sveta <- list.files("../Coders/Sheets for Stefan, Sveta and Michael/", pattern = "^SK", full.names = T)
f_michael <- list.files("../Coders/Sheets for Stefan, Sveta and Michael/", pattern = "^MP", full.names = T)
f_f <- list.files("../Coders/Sheets for coders/", pattern = "^F", full.names = T) # coder F


# dataframe with coder (= crowdsourced participant), annotator (= person who rated the crowdsourced participant's answer), task number. Each spreadsheet contains data from multiple coders, but the rating of the answers was conducted by one individual.
files <- tibble ( file = c(f_stefan, f_sveta, f_michael, f_f))
files <- separate_wider_delim(files, file, delim = "TASK", names = c("file_rest", "task"), cols_remove = F)
files <- separate_wider_delim(files, task, "_", names = c("task", "coders"), too_many = "merge")
files$annotator <- gsub(".*//", "", files$file_rest)
files <- select(files, -file_rest)

# check column
files$check <- NA

# list of relevant sheets
relevant_sheets <- c("Vocalizations", "Vocalizations (2)", "Ape 1", "Ape 2")

# get number of participants in 1 file
for(j in 1:nrow(files)) {
  my_sheets <- excel_sheets(files$file[j])
  my_sheets <- intersect(my_sheets, relevant_sheets)
  no_participants <- length(unlist(sapply(1:length(my_sheets), function(i) grep("Participant", colnames(read_excel(files$file[j], my_sheets[i]))))))
  
  # get coder IDs from file name
  coder_ids <- gsub(".xlsx", "", unlist(strsplit(files$file[1], "TASK.*?_"))[2])
  coder_ids <- unlist(strsplit(trimws(coder_ids), ", ?| +|(?<=v)_(?! )", perl = T))
  coder_ids <- length(coder_ids)
  
  if(no_participants == coder_ids) {
    files$check <- TRUE
  } else {
    files$check <- FALSE
  }
  
  print(j)
  
}

all(files$check) # good

