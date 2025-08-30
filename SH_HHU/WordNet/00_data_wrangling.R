library(tidyverse)
library(readxl)


# read sheets --------------------------------------------------------

# number of sheets
n <- length(excel_sheets("semantic_annotation_vocalizations.xlsx"))


for(i in 1:n) {
  d <- read_xlsx("semantic_annotation_vocalizations.xlsx", sheet = i)
  colnames(d) <- c("Right_Answer", "Answer")
  
  # remove punctuation
  gsub("[[:punct:]]", "", d$Answer)
  
  # add line number
  d$No <- 1:nrow(d)
  
  # separate at whitespace to split up multi-word units
  d <- d %>% separate_longer_delim(cols = Answer, delim = " ")
  
  if(i == 1) {
    d_all <- d
  } else {
    d_all <- rbind(d_all,d)
  }
  
  print(i)
}


# convert to lowercase
d_all$Answer <- tolower(d_all$Answer)

# export to one sheet
# write_csv(d_all, "answers_all.csv")




