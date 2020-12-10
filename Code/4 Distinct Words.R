# Distinctive Words

# Writing a function to combine two dataframes and obtain the the difference in average rates of words across the two

freq <- function(doc1, doc2){
  
  df <- data.frame(rbind(doc1, doc2)) # combine dfs
  df <- Corpus(VectorSource(df$text)) # preprocessing here & below
  df <- DocumentTermMatrix(df, control = list(stopwords = TRUE,
                                              tolower = TRUE,
                                              removeNumbers = TRUE,
                                              removePunctuation = TRUE,
                                              stemming = TRUE))
  
  df.m <- as.data.frame(as.matrix(df)) # convert to dataframe
  
  d1 <- df.m[1:nrow(doc1),] # split df into two
  d2 <- df.m[(nrow(doc1) + 1):(nrow(doc1) + nrow(doc2)),]
  d1_total <- colSums(d1) # summing columns
  d2_total <- colSums(d2)
  
  df_2 <- data.frame(rbind(d1_total, d2_total)) # combining dfs again
  df_2 <- df_2[, d1_total>0 & d2_total>0] # removing 0s
  
  rowTotals <- rowSums(df_2) #  row totals
  
  df_2 <- df_2/rowTotals # changing frequencies to proportions
  
  means.d1 <- df_2[1,] # getting difference in proportions for each and both
  means.d2 <- df_2[2,]
  means.all <- colMeans(df_2) 
  
  score <- unlist((means.d1 - means.d2) / means.all) # calculating the score
  score <- sort(score, decreasing = T)   # words with highest difference
  
  return(score)
}

# Applying fn to create two vectors, where each is talking about themselves or the other country

own <- freq(arm_about_arm, aze_about_aze)
other <- freq(arm_about_aze, aze_about_arm)

# Creating dfs for each with words & their freqs, saving top 30 arm and top aze words

df_own <- data.frame(term = names(own), freq = own)
df_own <- rbind(head(df_own, 30), tail(df_own, 30))

df_other <- data.frame(term = names(other), freq = other)
df_other <- rbind(head(df_other, 30), tail(df_other, 30))

# Graphs

df_own %>%
  mutate(screen_name = ifelse(freq > 0, "arm", "aze")) %>% # grouping based on content
  mutate(freq = abs(freq)) %>% # taking absolute values of freq
  ggplot(aes(screen_name, freq)) + 
  geom_point(aes(color = screen_name)) + # color by author
  geom_label_repel(aes(label = term), # jitter the labels
                   box.padding   = 0.35, 
                   point.padding = 0.5,
                   segment.color = 'grey50') +
  xlab("Account") + ylab("Relative Frequency") + # labels
  ggtitle("Relative Frequencies of Words in Tweets about Themselves by \nArmenia And Azerbaijan's MFA Twitter Accounts") + 
  scale_x_discrete(labels=c("Armenia", "Azerbaijan"), expand=c(0.2, 0.2)) +
  theme(legend.position = "none")

df_other %>%
  mutate(screen_name = ifelse(freq > 0, "arm", "aze")) %>% # grouping based on content
  mutate(freq = abs(freq)) %>% # taking absolute values of freq
  ggplot(aes(screen_name, freq)) +
  geom_point(aes(color = screen_name)) + # color by author
  geom_label_repel(aes(label = term), # jitter the labels
                   box.padding   = 0.35, 
                   point.padding = 0.5,
                   segment.color = 'grey50')  +
  xlab("Account") + ylab("Relative Frequency") + # labels
  ggtitle("Relative Frequencies of Words in Tweets about Adversary by \nArmenia And Azerbaijan's MFA Twitter Accounts") + 
  scale_x_discrete(labels=c("Armenia", "Azerbaijan"), expand=c(0.2, 0.2)) +
  theme(legend.position = "none")