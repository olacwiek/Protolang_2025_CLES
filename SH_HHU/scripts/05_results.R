library(tidyverse)
library(readxl)
library(writexl)
library(likert)
library(scales)
library(patchwork)

# read data ---------------------------------------------------------------

apes <- read_xlsx("../data_annotated/final_decisions/apes.xlsx")
vocs <- read_xlsx("../data_annotated/final_decisions/vocs.xlsx")


# add metadata ------------------------------------------------------------

metadata_vocs <- read_xlsx("../metadata/all_metadata.xlsx", sheet = "Metadata_Vocalizations")
metadata_apes <- read_xlsx("../metadata/all_metadata.xlsx", sheet = "Metadata_Apes")


# combine datasets: apes

# "clean" ID column without _v / _a (for "_vocalization /
# _apes")

apes$Rec_Session_Id <- gsub("_.*", "", apes$Coder_ID)

# make sure both have the same data type
metadata_apes$Rec_Session_Id <- as.character(metadata_apes$Rec_Session_Id)

# join
apes <- left_join(apes, metadata_apes, by = "Rec_Session_Id")


# combine datasets: vocalizations

# "clean" ID column without _v / _a (for "_vocalization /
# _vocs")

vocs$Rec_Session_Id <- gsub("_.*", "", vocs$Coder_ID)

# make sure both have the same data type
metadata_vocs$Rec_Session_Id <- as.character(metadata_vocs$Rec_Session_Id)

# join
vocs <- left_join(vocs, metadata_vocs, by = "Rec_Session_Id")


# check for duplicates using session IDs
vocs_no_duplicates <- select(vocs, `Right answer`, Answer, Session_Token) %>% unique

# Overview: most frequent answers
vocs_no_duplicates %>% group_by(`Right answer`, Answer) %>% summarise(
  n=n()
) %>% arrange(`Right answer`, desc(n)) #%>% View()

# frequency of chew in eat responses
vocs_no_duplicates %>% filter(`Right answer`=="eat") %>% summarise(
  chew = length(which(grepl("chew", Answer)))
)


# total number of results for individual terms
vocs_no_duplicates %>% filter(`Right answer`=="sleep") %>% nrow()
vocs_no_duplicates %>% filter(`Right answer`=="bad") %>% nrow()
vocs_no_duplicates %>% filter(`Right answer`=="eat") %>% nrow()
vocs_no_duplicates %>% filter(`Right answer`=="pound") %>% nrow()



# Vocalizations -----------------------------------------------------------

vocs001 <- vocs %>% group_by(`Right answer`) %>% add_count(name = "Freq_all") %>% ungroup %>% group_by(`Right answer`, Final_decision) %>%
  summarise(
    n = n(),
    Freq_all = unique(Freq_all)
  ) %>% ungroup %>% setNames(c("Right_answer", "Final_decision", "Freq_dec", "Freq_all")) %>%
  mutate(rel = Freq_dec / Freq_all)

# relative frequency of all > 0
vocs001a <- vocs001 %>% filter(Final_decision != 0) %>% group_by(Right_answer) %>% summarise(
  Freq_bigger0 = sum(Freq_dec),
  Freq_all = unique(Freq_all)
) %>% mutate(rel_bigger0 = Freq_bigger0 / Freq_all)

# combine
vocs001 <- left_join(vocs001, select(vocs001a, Right_answer, rel_bigger0))

# replace NAs
vocs001 <- replace_na(vocs001, list(rel_bigger0 = 0))

# add color of label
vocs001$text_col <- ifelse(vocs001$Final_decision==0, "white", "black")

# plot
(vplot <- ggplot(filter(vocs001, Final_decision < 4), aes(x = fct_reorder(Right_answer, rel_bigger0), 
                    y = rel, 
                    fill = factor(Final_decision), group = factor(Final_decision))) + geom_col() +
  geom_text(aes(label = Freq_dec, colour = text_col), size = 3, position = position_fill(vjust = .5)) +
  scale_fill_viridis_d(option = "magma", begin = .1, end = .9) +
  scale_y_continuous(labels = percent) +
  scale_color_identity() + coord_flip() +
  guides(fill = guide_legend(title = "Correctness")) + ylab("Frequency") + xlab("Item") +
  theme(axis.text = element_text(size = 18)) +
  theme(axis.title = element_text(size = 18)) +
  theme(strip.text = element_text(size = 18)) +
  theme(legend.text = element_text(size = 18)) +
  theme(legend.title = element_text(size = 18, face = "bold")) +
  ggtitle("Vocalizations") +
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 19)) )
# ggsave("vocalizations.png")


# Apes -----------------------------------------------------------

apes001 <- apes %>% group_by(`Right answer`) %>% add_count(name = "Freq_all") %>% ungroup %>% group_by(`Right answer`, Final_decision) %>%
  summarise(
    n = n(),
    Freq_all = unique(Freq_all)
  ) %>% ungroup %>% setNames(c("Right_answer", "Final_decision", "Freq_dec", "Freq_all")) %>%
  mutate(rel = Freq_dec / Freq_all)

# relative frequency of all > 0
apes001a <- apes001 %>% filter(Final_decision != 0) %>% group_by(Right_answer) %>% summarise(
  Freq_bigger0 = sum(Freq_dec),
  Freq_all = unique(Freq_all)
) %>% mutate(rel_bigger0 = Freq_bigger0 / Freq_all)

# combine
apes001 <- left_join(apes001, select(apes001a, Right_answer, rel_bigger0))

# replace NAs
apes001 <- replace_na(apes001, list(rel_bigger0 = 0))

# add color of label
apes001$text_col <- ifelse(apes001$Final_decision==0, "white", "black")

# plot
( aplot <- ggplot(filter(apes001, Final_decision < 4), aes(x = fct_reorder(Right_answer, rel_bigger0), 
                                                y = rel, 
                                                fill = factor(Final_decision), group = factor(Final_decision))) + geom_col() +
  geom_text(aes(label = Freq_dec, colour = text_col), size = 3, position = position_fill(vjust = .5)) +
  scale_fill_viridis_d(option = "magma", begin = .1, end = .9) +
  scale_y_continuous(labels = percent) +
  scale_color_identity() + coord_flip() +
  guides(fill = guide_legend(title = "Correctness")) + ylab("Frequency") + xlab("Item") +
  theme(axis.text = element_text(size = 18)) +
  theme(axis.title = element_text(size = 18)) +
  theme(strip.text = element_text(size = 18)) +
  theme(legend.text = element_text(size = 18)) +
  theme(legend.title = element_text(size = 18, face = "bold")) +
  ggtitle("Apes") +
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 19)) )
# ggsave("apes.png")


# both plots
aplot + vplot + plot_layout(guides = "collect")
# ggsave("apes_vocalizations.png", width = 19, height = 10)





# get relative frequencies for both categories separately
apes_with <- filter(apes, `previous work` == "yes")
apes_without <- filter(apes, `previous work` == "no")

# add full frequencies
apes_with <- apes_with %>% group_by(`Right answer`, `previous work`) %>% add_count(name = "Freq_all")
apes_without <- apes_without %>% group_by(`Right answer`, `previous work`) %>% add_count(name = "Freq_all")

# frequencies of individual ratings
apes_with <- apes_with %>% group_by(`Right answer`, Final_decision) %>% summarise(
  Freq_dec = n(),
  Freq_all = unique(Freq_all),
  rel = Freq_dec / Freq_all
)

apes_without <- apes_without %>% group_by(`Right answer`, Final_decision) %>% summarise(
  Freq_dec = n(),
  Freq_all = unique(Freq_all),
  rel = Freq_dec / Freq_all
)


# non-zero frequencies

apes_with1a <- apes_with %>% filter(Final_decision>0) %>% summarise(
  Freqnonzero = sum(Freq_dec)
)

apes_with <- left_join(apes_with, apes_with1a)
apes_with <- replace_na(apes_with, list(Freqnonzero = 0))
apes_with$rel_nonzero <- apes_with$Freqnonzero / apes_with$Freq_all
apes_with <- replace_na(apes_with, list(rel_nonzero = 0))

apes_without1a <- apes_without %>% filter(Final_decision>0) %>% summarise(
  Freqnonzero = sum(Freq_dec)
)

apes_without <- left_join(apes_without, apes_without1a)
apes_without$rel_nonzero <- apes_without$Freqnonzero / apes_without$Freq_all
apes_without <- replace_na(apes_without, list(rel_nonzero = 0))


# bind and plot -----------------------------------------------------------
rbind(mutate(apes_with, previous_work = "yes"), 
      mutate(apes_without, previous_work = "no")) %>% 
  mutate(text_col = ifelse(Final_decision == 0, "white", "black")) %>%
  filter(Final_decision < 4) %>% 
  ggplot(aes(x = fct_reorder(`Right answer`, rel_nonzero), y = rel,
             fill = factor(Final_decision), group = factor(Final_decision))) + 
  geom_col() +
  facet_wrap(~previous_work) +
  geom_text(aes(label = Freq_dec, colour = text_col), size = 3, position = position_fill(vjust = .5)) +
  scale_fill_viridis_d(option = "magma", begin = .1, end = .9) +
  scale_y_continuous(labels = percent) +
  scale_color_identity() + coord_flip() +
  guides(fill = guide_legend(title = "Correctness")) + ylab("Frequency") + xlab("Item") +
  theme(axis.text = element_text(size = 18)) +
  theme(axis.title = element_text(size = 18)) +
  theme(strip.text = element_text(size = 18)) +
  theme(legend.text = element_text(size = 18)) +
  theme(legend.title = element_text(size = 18, face = "bold")) +
  ggtitle("Apes: Participants with vs. without experience with non-human primates") +
  theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 19))
# ggsave("apes_with_without_experience.png", width = 15, height = 8)


# get metadata for apes participants: context vs no context ---------------

f <- list.files("../data_raw/Ape study participants answers/", pattern = "trials.csv", full.names = T, recursive = T)

for(i in 1:length(f)) {
  # get current file
  cur_file <- read_csv(f[i])
  
  # get current participant ID
  cur_session_id <- unique(cur_file$Rec_Session_Id)
  
  # get current condition
  cur_condition <- unique(grep("context", cur_file$Task_Name, value = T))
  
  # as df
  cur_df <- tibble(Rec_Session_Id = cur_session_id,
                   Condition = cur_condition)
  
  # bind together
  if(i == 1) {
    all_df <- cur_df
  } else {
    all_df <- rbind(all_df, cur_df)
  }
  
  
  
}


# combine with existing data ----------------------------------------------
all_df$Rec_Session_Id <- as.character(all_df$Rec_Session_Id)
apes <- left_join(apes, all_df, by = "Rec_Session_Id")
apes$Condition <- gsub(".*(?=[12])", "", apes$Condition, perl = T)



# visualize ---------------------------------------------------------------

apes0001 <- apes %>% group_by(`Right answer`, Condition) %>% add_count(name = "Freq_all") %>% 
  ungroup %>% group_by(`Right answer`, Final_decision, Condition) %>%
  summarise(
    n = n(),
    Freq_all = unique(Freq_all)
  )  %>% setNames(c("Right_answer", "Final_decision", "Condition", "Freq_dec", "Freq_all")) %>%
  mutate(rel = Freq_dec / Freq_all)

# relative frequency of all > 0
apes0001a <- apes0001 %>% filter(Final_decision != 0 ) %>% 
  group_by(Right_answer, Condition) %>% summarise(
  Freq_bigger0 = sum(Freq_dec),
  Freq_all = unique(Freq_all)
) %>% mutate(rel_bigger0 = Freq_bigger0 / Freq_all)

# combine

apes0001 <- left_join(apes0001, dplyr::select(apes0001a, Right_answer, Condition, rel_bigger0))

# replace NAs
apes0001 <- replace_na(apes0001, list(rel_bigger0 = 0))

# add color of label
apes0001$text_col <- ifelse(apes0001$Final_decision==0, "white", "black")

# more descriptive names for condition
apes0001$Condition <- case_when(apes0001$Condition=="1" ~ "without context",
          apes0001$Condition=="2" ~ "with context")

# plot
( aplot2 <- ggplot(filter(apes0001, !is.na(Condition)), aes(x = fct_reorder(Right_answer, rel_bigger0), 
                                                           y = rel, 
                                                           fill = factor(Final_decision), group = factor(Final_decision))) + geom_col() +
    geom_text(aes(label = Freq_dec, colour = text_col), size = 3, position = position_fill(vjust = .5)) +
    facet_wrap(~Condition) +
    scale_fill_viridis_d(option = "magma", begin = .1, end = .9) +
    scale_y_continuous(labels = percent) +
    scale_color_identity() + coord_flip() +
    guides(fill = guide_legend(title = "Correctness")) + ylab("Frequency") + xlab("Item") +
    theme(axis.text = element_text(size = 18)) +
    theme(axis.title = element_text(size = 18)) +
    theme(strip.text = element_text(size = 18)) +
    theme(legend.text = element_text(size = 18)) +
    theme(legend.title = element_text(size = 18, face = "bold")) +
    ggtitle("Apes") +
    theme(plot.title = element_text(face = "bold", hjust = 0.5, size = 19)) )
# ggsave("apes_by_condition.png", width = 13, height = 5)



