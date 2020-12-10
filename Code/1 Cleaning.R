# Loading Necessary Packages

library(tidyverse)
library(rtweet)
library(httr)
library(lubridate)
library(tm)
library(wordcloud)
library(tidytext)
library(textdata)
library(ggrepel)

# Scraping Tweets from Armenia and Azerbaijan's MFA accounts

arm <- get_timeline(
  user = c("MFAofArmenia"),
  n = 1000
)

arm <- arm %>%
  mutate(created_at = as.Date(created_at)) %>% # standardizing dates
  filter(created_at >= "2020-09-27" & created_at <= "2020-11-10") %>% # filter conflict period
  filter(lang == "en") %>% # only English tweets
  select(created_at, screen_name, text) # keep date, author, text

aze <- get_timeline(
  user = c("AzerbaijanMFA"),
  n = 1000
)

aze <- aze %>%
  mutate(created_at = as.Date(created_at)) %>% # standardizing dates
  filter(created_at >= "2020-09-27" & created_at <= "2020-11-10") %>% # filter conflict period
  filter(lang == "en") %>% # only English tweets
  select(created_at, screen_name, text) # keep date, author, text

# Cleaning up the tweets via a function applied to both dataframes

clean_up <- function(i, country){
  text1 <- country$text[i]
  text1 <- str_replace_all(text1, "http\\S+\\s*", "") ## Remove URLs
  text1 <- str_replace_all(text1, "@\\S+", "") ## Remove Mentions
  text1 <- str_replace_all(text1, "([[:upper:]])", " \\1") # Split Hashtags
  text1 <- str_replace_all(text1, "&amp", "") ## Remove Ampersands
  text1 <- str_replace_all(text1, "[^\x01-\x7F]", "") ## Remove Emojis & Special Characters
  return(text1)
}

arm <- arm %>%
  mutate(text = map_chr(1:nrow(arm), clean_up, arm)) # applying fn to Arm

aze <- aze %>%
  mutate(text = map_chr(1:nrow(aze), clean_up, aze)) # applying fn to Aze