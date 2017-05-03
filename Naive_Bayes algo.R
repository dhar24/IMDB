install.packages("wordcloud")
install.packages("tm")
install.packages("e1071")
install.packages("SnowballC")

library(gmodels)
library(tm)
library(e1071)
library(SnowballC)
library(wordcloud)
#function to remove punctuation in my style
#removePunctuation<- function(x){gsub("[[:punct:]]+"," ",x)}
#Data loading
sms_raw<- read.csv("sms_spam.txt",header = TRUE,sep = ",",stringsAsFactors = FALSE)
sms_raw$type<- factor(sms_raw$type)
#Data Preparation[Cleaning & Standardizing data]
##Data Prep1--BRINGING all data from source
sms_raw_corp<- VCorpus(VectorSource(sms_raw$text))
##data prep1: converting all to lower case[content_transformer() is mandatory to use because it will convert corpus
#correct data type ]
sms_clean1<- tm_map(sms_raw_corp,content_transformer(tolower))
##data prep3:removing all numeric vallues
sms_clean2<-tm_map(sms_clean1,removeNumbers)
##data prep4: remove stopwords
sms_clean3<- tm_map(sms_clean2,removeWords,stopwords())
##data prep5: remove punctuations
sms_clean<-  tm_map(sms_clean3,removePunctuation)
##data prep 6: stemming of doc meaning converting all to base forms,wordstem()'s big brother is stemdocument
sms_clean<- tm_map(sms_clean,stemDocument)
##data prep 7: stemming of doc meaning converting all to base forms,wordstem()'s big brother is stemdocument
sms_clean<- tm_map(sms_clean,stripWhitespace)


# Data Preparaion(splitting text into words)  
sms_dtm<-DocumentTermMatrix(sms_clean)
#Alternate way of all above clearing can be done in above DTM() with parameter of control=list(functions)
#DATA PREPARATION: Make training and test datasets

sms_dtm_train<- sms_dtm[1:4200,]
sms_dtm_test<- sms_dtm[4201:5574,]
sms_train_label<- sms_raw[1:4200, ]$type
sms_test_label<- sms_raw[4201:5574, ]$type
#check the distribution among train & test[It says coooool]
#prop.table(table(sms_train_label))
#prop.table(table(sms_test_label))

#Visualize this data with wordclouds
wordcloud(sms_clean,min.freq = 50,random.order = FALSE)
#dividing spam & ham wordclouds
spam<- subset(sms_raw,type=='spam')
ham<- subset(sms_raw,type=='ham')
wordcloud(spam$text,max.words = 40,scale = c(3,0.5))
wordcloud(ham$text,max.words = 40,scale = c(3,0.5))
#DATA PREPARATION: creating indicator features for frequent words
sms_freq_words<- findFreqTerms(sms_dtm_train,5)
sms_dtm_freq_train<- sms_dtm_train[,sms_freq_words]
sms_dtm_freq_test<- sms_dtm_test[,sms_freq_words]


# As naive bayes is defined mostly over categorical data, lets make our data alike
convert_counts<- function(x){x<-ifelse(x>0,"Yes","No")}
sms_train<- apply(sms_dtm_freq_train,MARGIN = 2,convert_counts)
sms_test<- apply(sms_dtm_freq_test,MARGIN = 2,convert_counts)


#training a model on the data
sms_classifier<- naiveBayes(sms_train,sms_train_label)
sms_test_pred<- predict(sms_classifier,sms_test)

#crosstable validation to check model's efficiency

CrossTable(sms_test_pred,sms_test_label,prop.chisq = FALSE,prop.t = FALSE,
           dnn=c('predicted','actual'))

#looking at false positive & negative(25+9) lets see if we can further optimise tht
sms_classifier2<- naiveBayes(sms_train,sms_train_label,laplace = 1)
sms_test_pred2<- predict(sms_classifier2,sms_test)
CrossTable(sms_test_pred2,sms_test_label,prop.chisq = FALSE,prop.t = FALSE,
           dnn=c('predicted','actual'))


           