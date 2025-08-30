library(tidyverse)
library(ggbeeswarm)
library(wizard)
library(patchwork)

# read data
d <- read_csv("answers_wordnet.csv")

# unique identifiers
d$ID <- paste0(d$Right_Answer, d$No)


# Path Distance -----------------------------------------------------------

# only keep the highest distance value for each 
# item (which can be recognized by the number,
# column No)
d01 <- d %>% group_by(ID) %>% summarise(
  dist_path_max = max(na.omit(dist_path))
)

# join both
d001 <- left_join(d, d01)

# remove all duplicates
d002 <- d001[-which(duplicated(d001$ID)),]

# remove NAs
d003 <- d002 %>% select(Right_Answer, Answer, dist_path) %>% na.omit()

# visualize:
d003 %>% group_by(Right_Answer) %>% 
  mutate(median = median(dist_path, na.rm = T)) %>%
  ggplot(aes(x = fct_reorder(Right_Answer, median), y = dist_path)) +
  geom_boxplot()

# type level:
d003 %>% unique %>% group_by(Right_Answer) %>% 
  mutate(median = median(dist_path, na.rm = T)) %>%
  ggplot(aes(x = fct_reorder(Right_Answer, median), y = dist_path)) +
  geom_jitter(col = "lightblue") + 
  geom_boxplot(col = "red", alpha = .2, outliers = FALSE)

# with text in plot:
(dpath <- d003 %>% 
    unique %>% 
    group_by(Right_Answer) %>% 
  mutate(median = median(dist_path, na.rm = T)) %>% 
  ggplot(aes(x = fct_reorder(Right_Answer, median), 
             y = dist_path)) +
  geom_text(aes(label = Answer), size = 1.2, col = "blue",
            position = position_jitter(width = .01, height = .01, seed = 1)) +
  geom_boxplot(col = "red", alpha = .5, outliers = FALSE) +
  theme_bw() + xlab("Target answer") + ylab("Path distance") +
  theme(axis.text.x = element_text(angle=45, hjust=.9, size=12)) )
# ggsave("distance_path.png")



# WUP distance ------------------------------------------------------------

# only keep the highest distance value for each 
# item (which can be recognized by the number,
# column No)
d01 <- d %>% group_by(ID) %>% summarise(
  dist_wup_max = max(na.omit(dist_wup))
)

# join both
d001 <- left_join(d, d01)

# remove all duplicates
d002 <- d001[-which(duplicated(d001$ID)),]

# remove NAs
d003 <- d002 %>% select(Right_Answer, Answer, dist_wup) %>% na.omit()

# visualize:
d003 %>% group_by(Right_Answer) %>% 
  mutate(median = median(dist_wup, na.rm = T)) %>%
  ggplot(aes(x = fct_reorder(Right_Answer, median), 
             y = dist_wup)) +
  geom_boxplot()

# type level:
d003 %>% unique %>% group_by(Right_Answer) %>% 
  mutate(median = median(dist_wup, na.rm = T)) %>%
  ggplot(aes(x = fct_reorder(Right_Answer, median), y = dist_wup)) +
  geom_jitter(col = "lightblue") + 
  geom_boxplot(col = "red", alpha = .2, outliers = FALSE)

# with text in plot:
(wup <- d003 %>% unique %>% group_by(Right_Answer) %>% 
  mutate(median = median(dist_wup, na.rm = T)) %>% 
  ggplot(aes(x = fct_reorder(Right_Answer, median), 
             y = dist_wup)) +
  geom_text(aes(label = Answer), size = 1.2, col = "blue",
            position = position_jitter(width = .01, height = .01, seed = 1)) +
  geom_boxplot(col = "red", alpha = .5, outliers = FALSE) +
  theme_bw() + xlab("Target answer") + ylab("WUP distance") +
  theme(axis.text.x = element_text(angle=45, hjust=.9, size=12)) )
# ggsave("distance_wup.png")


# both plots in one grid:
dpath + wup
# ggsave("distance_path_wup.png", width = 13, height = 5.5)

