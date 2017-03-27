library(rvest)
df<-data.frame()
titles<-0
scrape<-function(urlss)
{
url1<- read_html(urlss)
titles<- url1 %>% html_nodes(".title_wrapper h1") %>% html_text()
print(title)
rating<-  url1 %>% html_nodes(".ratingValue strong span") %>% html_text()%>% as.numeric()
num_users<-  url1 %>% html_nodes(".ratings_wrapper a span") %>% html_text()
type<-  url1 %>% html_nodes(" .subtext .itemprop") %>% html_text()
type<- paste(type,collapse = " ")
df1<-data.frame(title,rating,num_users,type)
df<-rbind(df,df1)
}
urls<-0
base_url<-"http://www.imdb.com/title/"
for(c in 1:2){
  urls[c]<- paste(base_url,"tt",c,sep="")
  scrape(urls[c])
  
}
