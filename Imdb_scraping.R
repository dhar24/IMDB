
library(rvest)
df2<-data.frame()
urls<-0
base_url<-"http://www.imdb.com/title/"
for(c in 1:50){
  urls[c]<- paste(base_url,"tt",c,sep="")
}


for(c in 1:50){
  

url1<- read_html(urls[c])
titles<- url1 %>% html_nodes(".title_wrapper h1") %>% html_text()
#print(titles)
rating<-  url1 %>% html_nodes(".ratingValue strong span") %>% html_text()%>% as.numeric()
num_users<-  url1 %>% html_nodes(".ratings_wrapper a span") %>% html_text()
type<-  url1 %>% html_nodes(" .subtext .itemprop") %>% html_text()
type<- paste(type,collapse = " ")
df<- data.frame(titles,rating,num_users,type)
df2<-rbind(df2,df)

#df<-rbind(df,df1)
}
