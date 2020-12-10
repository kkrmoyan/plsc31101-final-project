# Visualizations

# Word clouds for each dataframe

word_cloud <- function(i){
  freq <- colSums(as.matrix(all[[i]]))
  sorted <- sort(freq, decreasing = T) # top used words
  
  set.seed(123)
  return(wordcloud(names(sorted), sorted, max.words=100, colors=brewer.pal(6,"Dark2")))
}

word_cloud(1) # arm about arm
word_cloud(2) # arm about aze
word_cloud(3) # aze about aze
word_cloud(4) # aze about arm