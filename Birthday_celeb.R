
library(rvest)
df2<-data.frame()
num_people<-0
Date1 <- readline(prompt="Enter date in MM-DD Format: ")
base_url1<-"http://www.imdb.com/search/name?birth_monthday="
base_url2<-"&ref_=nv_cel_brn_1&refine=birth_monthday&start="

  url_base<- paste(base_url1,Date1,base_url2,c,sep="")
  url1<- read_html(url_base)
  num_people<- url1 %>% html_nodes("#main .leftright #left") %>% html_text()
  num_people<-strsplit(strsplit(num_people[1], " ")[[1]][3],"\n")[[1]][1]
  num_people<- gsub(",","",num_people)
  num_people<-as.numeric(num_people)
  i<-0
  c<-1
while(i< num_people/50){
  link[i]<- paste(base_url1,Date1,base_url2,c,sep="")
  url1<- read_html(link[i])
  name<- url1 %>% html_nodes(".name > a") %>% html_text()
  df<- data.frame(name)
  df2<-rbind(df2,df)
  i<-i+1
  c<-c+50
  }
 


