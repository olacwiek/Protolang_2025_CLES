# This script aims at making the assessment of mismatches
# easier by removing all duplicates (including
# spelling variants that only differ in capitalization)

library(tidyverse)
library(readxl)
library(writexl)


# read data
apes <- read_xlsx("mismatches/Mismatches.xlsx", sheet = "Apes")
vocs <- read_xlsx("mismatches/Mismatches.xlsx", sheet = "Vocalizations")

# to lowercase
apes$Answer <- tolower(apes$Answer)
vocs$Answer <- tolower(vocs$Answer)

# unique
apes01 <- apes[,1:5] %>% pivot_longer(cols = starts_with("Rating"), names_prefix = "Rating", names_to="Rating_No", values_to="Rating")
apes01 <- apes01 %>% group_by(`Right answer`, Answer) %>% summarise(
  min_rating = min(na.omit(Rating)),
  max_rating = max(na.omit(Rating))
)

apes02 <- apes %>% select(`Right answer`, Answer, Comment) %>% unique
left_join(apes01, apes02)# %>% write_xlsx("apes_mismatches.xlsx")


# unique
vocs01 <- vocs[,1:5] %>% pivot_longer(cols = starts_with("Rating"), names_prefix = "Rating", names_to="Rating_No", values_to="Rating")
vocs01 <- vocs01 %>% group_by(`Right answer`, Answer) %>% summarise(
  min_rating = min(na.omit(Rating)),
  max_rating = max(na.omit(Rating))
)

vocs02 <- vocs %>% select(`Right answer`, Answer, Comment_MiP) %>% unique
left_join(vocs01, vocs02)# %>% write_xlsx("vocs_mismatches.xlsx")


