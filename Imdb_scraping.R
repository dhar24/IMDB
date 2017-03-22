library(rvest)
url<- read_html("http://www.imdb.com/title/tt2771200/")
title<- url %>% html_nodes(".title_wrapper h1") %>% html_text()
rating<-  url %>% html_nodes(".ratingValue strong span") %>% html_text()%>% as.numeric()
num_users<-  url %>% html_nodes(".ratings_wrapper a span") %>% html_text()%>% as.numeric()
type<-  url %>% html_nodes(" .subtext .itemprop") %>% html_text()
type<- 

data<-data.frame(title,rating,num_users,type)
