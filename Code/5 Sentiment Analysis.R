# Sentiment analysis

sent <- get_sentiments("bing") # dictionary
sent$score <- ifelse(sent$sentiment=="positive", 1, -1) # assign score

# Writing a function that will add the sentiment score of each tweet to its dataframe

sentiment <- function(author_about_subject, i){
  
  all[[i]] <- as.data.frame(as.matrix(all[[i]])) # as df
  
  words <- data.frame(word = colnames(all[[i]]), stringsAsFactors = F)
  
  words_sent <- words %>%
    left_join(sent) %>% 
    mutate(score = replace_na(score, 0)) # merging w dictionary
  
  doc_scores <- as.matrix(all[[i]]) %*% words_sent$score # calculating scores
  
  author_about_subject$sentiment <- doc_scores # creating col
  
  return(author_about_subject)
}

# Applying to all dataframes

arm_about_arm <- arm_about_arm %>% 
  sentiment(1)

arm_about_aze <- arm_about_aze %>% 
  sentiment(2)

aze_about_aze <- aze_about_aze %>% 
  sentiment(3)

aze_about_arm <- aze_about_arm %>% 
  sentiment(4)

# Combining dataframes

arm <- arm %>%
  left_join(rbind(arm_about_arm, arm_about_aze))

aze <- aze %>%
  left_join(rbind(aze_about_arm, aze_about_aze))

dat <- rbind(arm, aze) # combining arm and aze

# Graphs

# All tweets

dat %>%
  na.omit() %>%
  group_by(created_at) %>%
  ggplot(aes(created_at, sentiment)) +
  geom_point(aes(shape = screen_name, color = content), 
             position = position_jitter(width = 0.3, height = 0.3)) +
  xlab("Date") + ylab("Sentiment") + # labels
  ggtitle("Sentiment Levels of Tweets by Armenia and Azerbaijan's \nMFA Accounts, Sep 27 - Nov 10, 2020") + 
  scale_shape_discrete(name = "Author", breaks = c("MFAofArmenia", "AzerbaijanMFA"), 
                       labels = c("Armenia", "Azerbaijan")) + # relabelling legend
  scale_color_discrete(name = "Content", breaks = c("arm", "aze"), 
                       labels = c("Armenia", "Azerbaijan"))

# Tweets about arm

dat %>%
  na.omit() %>%
  group_by(created_at) %>%
  filter(content == "arm") %>%
  ggplot(aes(created_at, sentiment)) +
  geom_point(aes(color = screen_name), 
             position = position_jitter(width = 0.3, height = 0.3)) +
  geom_smooth(aes(color = screen_name)) +
  xlab("Date") + ylab("Sentiment") + # labels
  ggtitle("Sentiment Levels of Tweets about Armenia by \nArmenia and Azerbaijan's MFA Accounts, Sep 27 - Nov 10, 2020") + 
  scale_color_discrete(name = "Author", breaks = c("MFAofArmenia", "AzerbaijanMFA"), 
                       labels = c("Armenia", "Azerbaijan"))

# Tweets about aze

dat %>%
  na.omit() %>%
  group_by(created_at) %>%
  filter(content == "aze") %>%
  ggplot(aes(created_at, sentiment)) +
  geom_point(aes(color = screen_name), 
             position = position_jitter(width = 0.3, height = 0.3)) +
  geom_smooth(aes(color = screen_name)) +
  xlab("Date") + ylab("Sentiment") + # labels
  ggtitle("Sentiment Levels of Tweets about Azerbaijan by \nArmenia and Azerbaijan's MFA Accounts, Sep 27 - Nov 10, 2020") + 
  scale_color_discrete(name = "Author", breaks = c("MFAofArmenia", "AzerbaijanMFA"), 
                       labels = c("Armenia", "Azerbaijan"))

# Tweets by arm

dat %>%
  na.omit() %>%
  group_by(created_at) %>%
  filter(screen_name == "MFAofArmenia") %>%
  ggplot(aes(created_at, sentiment)) +
  geom_point(aes(color = content), 
             position = position_jitter(width = 0.3, height = 0.3)) +
  geom_smooth(aes(color = content)) +
  xlab("Date") + ylab("Sentiment") + # labels
  ggtitle("Sentiment Levels of Tweets by Armenia's MFA Account, \nSep 27 - Nov 10, 2020") + 
  scale_color_discrete(name = "Content", breaks = c("arm", "aze"), 
                       labels = c("Armenia", "Azerbaijan"))

# Tweets by aze

dat %>%
  na.omit() %>%
  group_by(created_at) %>%
  filter(screen_name == "AzerbaijanMFA") %>%
  ggplot(aes(created_at, sentiment)) +
  geom_point(aes(color = content), 
             position = position_jitter(width = 0.3, height = 0.3)) +
  geom_smooth(aes(color = content)) +
  xlab("Date") + ylab("Sentiment") + # labels
  ggtitle("Sentiment Levels of Tweets by Azerbaijan's MFA Account, \nSep 27 - Nov 10, 2020") + 
  scale_color_discrete(name = "Content", breaks = c("arm", "aze"), 
                       labels = c("Armenia", "Azerbaijan"))