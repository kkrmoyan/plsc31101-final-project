# Categorizing tweets based on what it is about (Arm or Aze) via a function applied to both dataframes

about <- function(i, country){
  text1 <- country$text[i]
  text1 <- text1 %>%
    str_split(" ", simplify = T) # splitting each tweet by words
  aze_index <- match(TRUE, str_detect(text1, 
                        regex("Azerbaijan|Azeri|Turkey|Turk", ignore_case = TRUE)))
                  # recording the index position of any Aze-related word, including Turkey since it is Aze's ally
  arm_index <- match(TRUE, str_detect(text1, 
                        regex("Armenia|Artsakh", ignore_case = TRUE)))
                  # recording the index position of any Arm-related word
  content <- if(is.na(aze_index) == T & is.na(arm_index) == T){
      NA # if no Arm or Aze word is detected
    } else if(is.na(aze_index) == F & is.na(arm_index) == T){
      "aze" # if no Arm word is detected but Aze word is detected
    } else if(is.na(aze_index) == T & is.na(arm_index) == F){
      "arm" # if no Aze word is detected but Arm word is detected
    } else if(aze_index < arm_index){
      "aze" # if both words are detected and Aze comes up at an earlier position
    } else {
      "arm" # if both words are detected and Arm comes up at an earlier position
    }
  return(content)
}

arm <- arm %>% # applying fn to arm, adding 'content' col as a categorical var
  mutate(content = as.factor(map_chr(1:nrow(arm), about, arm)))

aze <- aze %>% # applying fn to aze, adding 'content' col as a categorical var
  mutate(content = as.factor(map_chr(1:nrow(aze), about, aze)))

# Creating a function that will split the existing dataframes into four based on who the author is and who the tweet is about

split_about <- function(author, subject){
  author_about_subject <- author %>% # taking dataframe by author
    filter(content == subject) %>% # subsetting only specified subject
    select(text) %>%
    mutate(text = str_conv(text, "UTF-8")) # converting to UTF-8
  return(author_about_subject)
}

# Applying function to all permutations

arm_about_arm <- split_about(arm, "arm")
arm_about_aze <- split_about(arm, "aze")
aze_about_aze <- split_about(aze, "aze")
aze_about_arm <- split_about(aze, "arm")

# Combining four dataframes into a list

all <- list(arm_about_arm, arm_about_aze, aze_about_aze, aze_about_arm)

# Writing a function to apply preprocessing functions to dataframes

preprocessing <- function(author_about_subject){
  author_about_subject <- Corpus(VectorSource(author_about_subject$text))
  
  author_about_subject <- DocumentTermMatrix(author_about_subject,
                                      control = list(stopwords = TRUE,
                                                     tolower = TRUE,
                                                     removeNumbers = TRUE,
                                                     removePunctuation = TRUE,
                                                     stemming = TRUE))
  return(author_about_subject)
}

# Applying function to all dataframes in the list

all <- all %>%
  map(preprocessing)