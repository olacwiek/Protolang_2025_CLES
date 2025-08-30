# This script resolves the mismatches that occurred between
# different annotators by implementing the final decisions
# that have been agreed upon in discussions among the
# project team.

library(tidyverse)
library(stringi)
library(stringr)
library(readxl)
library(writexl)


# read data ---------------------------------------------------------------


# all vocalizations (full list created in 02_iaa.qmd)
vocs <- read_xlsx("../data_annotated/helpers/all_vocs.xlsx")

# all apes (full list created in 02_iaa.qmd)
apes <- read_xlsx("../data_annotated/helpers/all_apes.xlsx")

# mismatches and final decisions
mismatches_vocs <- read_xlsx("../data_annotated/helpers/mismatches/Mismatches.xlsx", sheet = "Vocalizations")
mismatches_apes <- read_xlsx("../data_annotated/helpers/mismatches/Mismatches.xlsx", sheet = "Apes")


# convert answers to lowercase --------------------------------------------

vocs$Answer <- tolower(vocs$Answer)
apes$Answer <- tolower(apes$Answer)


# replace multiple whitespaces because there 
# are some mismatches between the mismatches 
# sheet and the original data (maybe accidentally
# someone used a data cleanup function in 
# Excel or Googledocs....)

vocs$Answer <- gsub("  +", " ", vocs$Answer)
mismatches_vocs$Answer <- gsub("  +", " ", mismatches_vocs$Answer)


apes$Answer <- gsub("  +", " ", apes$Answer)
mismatches_apes$Answer <- gsub("  +", " ", mismatches_apes$Answer)


# combine sheets with mismatches ------------------------------------------

# select relevant columns
mismatches_apes <- mismatches_apes %>% select(`Right answer`, Answer, `Final_decision`)
mismatches_vocs <- mismatches_vocs %>% select(`Right answer`, Answer, `Final_decision`)
mismatches_vocs <- unique(mismatches_vocs)
mismatches_apes <- unique(mismatches_apes)




# combine
vocs <- left_join(vocs, mismatches_vocs, by = c("Right answer", "Answer"), multiple = "all")


apes <- left_join(apes, mismatches_apes, by = c("Right answer", "Answer"))



# Vocalizations -----------------------------------------------------------


# make sure each combination of Answer, Right Answer, Coder will
# occur only once after unifying the retaings
vocs %>% select(-Rating, -Final_decision) %>% unique %>% nrow == vocs %>% select(-Rating) %>% unique %>% nrow



# fill up final decision column with unambiguous ratings
vocs <- mutate(vocs, Final_decision = ifelse(is.na(Final_decision), Rating, Final_decision))

# remove old Rating column 
vocs <- vocs %>% select(-Rating)


# make sure each combination of Answer, Right Answer, Coder occurs only once
vocs <- unique(vocs)

# remove all NAs in rating column
vocs <- vocs[!is.na(vocs$Final_decision),]

# export
# write_xlsx(vocs, "../data_annotated/final_decisions/vocs.xlsx")




# Apes --------------------------------------------------------------------


# make sure each combination of Answer, Right Answer, Coder will
# occur only once after unifying the retaings
apes %>% select(-Rating, -Final_decision) %>% unique %>% nrow == apes %>% select(-Rating) %>% unique %>% nrow


# fill up final decision column with unambiguous ratings
apes <- mutate(apes, Final_decision = ifelse(is.na(Final_decision), Rating, Final_decision))

# remove old Rating column 
apes <- apes %>% select(-Rating)


# make sure each combination of Answer, Right Answer, Coder occurs only once
apes <- unique(apes)

# remove all NAs in rating column
apes <- apes[!is.na(apes$Final_decision),]

# export
# write_xlsx(apes, "../data_annotated/final_decisions/apes.xlsx")
