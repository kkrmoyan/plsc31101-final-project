# Short Description

This code scrapes tweets from Armenia and Azerbaijan's Ministry of Foreign Affairs (MFA) accounts. The code cleans and preprocesses the data, categorizes the tweets based on their content (whether they are about their authoring country or their adversary), and conducts distinct words and sentiment analysis. It then visualizes the results through wordclouds, frequency plots, and time-series sentiment graphs.

# Dependencies

List what software your code depends on, as well as version numbers, like so:.

1. R, 4.0.2
2. Package - tidyverse
3. Package - rtweet
4. Package - httr
5. Package - lubridate
6. Package - tm
7. Package - wordcloud
8. Package - tidytext
9. Package - textdata
10. Package - ggrepel


# Files

## /

1. Narrative.Rmd: Provides a 4-page narrative of the project, main challenges, solutions, and results.
2. Narrative.pdf: A knitted pdf of Narrative.Rmd.
3. Slides.pdf: Slides for my lightning talk.

## Code/

1. 1 Cleaning.R: Scrapes data from the Twitter accounts of Armenia and Azerbaijan MFAs, filters, and cleans the dataframes.
2. 2 Categorization & Preprocessing.R: Categorizes tweets based on the content of the tweets, creates new sub-dataframes, and preprocesses the sub-dataframes for text analysis. 
3. 3 Wordclouds.R: Produces wordclouds (showing top used words) based on who the author and the content of tweets are.
4. 4 Distinct Words.R: Produces relative frequency plots, segregated by author, based on the content of the tweet.
5. 5 Sentiment Analysis.R: Attaches sentiment scores to tweets and produces time-series plots segregated by author and content.

## Data/

1. all_data_processed.csv: Cleaned and processed dataset, with new variables (content and sentiment).
2. arm_tweets.csv: Tweets by Armenia's Ministry of Foreign Affairs official account (@MFAofArmenia), with preliminary, unedited variables.
3. aze_tweets.csv: Tweets by Azerbaijan's Ministry of Foreign Affairs official account (@AzerbaijanMFA), with preliminary, unedited variables.

## Results/

### Distinct Words/
 
1. distinct words (other).png: Relative frequencies of words in tweets about adversary by Armenia and Azerbaijan
2. distinct words (own).png: Relative frequencies of words in tweets about themselves by Armenia and Azerbaijan

### Sentiment Graphs/

1. sentiment_about_arm.png: Sentiment levels of tweets about Armenia
2. sentiment_about_aze.png: Sentiment levels of tweets about Azerbaijan
3. sentiment_all.png: Sentiment levels of tweets by Armenia and Azerbaijan
4. sentiment_by_arm.png: Sentiment levels of tweets by Armenia
5. sentiment_by_aze.png: Sentiment levels of tweets by Azerbaijan

### Wordclouds/

1. wordcloud (arm_about_arm).png: Top words in tweets about Armenia by Armenia
2. wordcloud (arm_about_aze).png: Top words in tweets about Armenia by Azerbaijan
3. wordcloud (aze_about_arm).png: Top words in tweets about Azerbaijan by Armenia
4. wordcloud (aze_about_aze).png: Top words in tweets about Azerbaijan by Azerbaijan

# More Information

Author: Ken Krmoyan (UChicago, Committee on International Relations)