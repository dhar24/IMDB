library(data.table)
#main database z with only delivered items orders
z_customer<- fread("Sales_Data_Jan_Mar17.csv",header = TRUE)
z<-subset(z_customer,z_customer$Status=='Delivered')
#z_rev_channnel is channel*rev*month matrix
z_rev_channel<- z[,sum(`Net Payable`),by=list(Month,`UTM Channel`)]
#unique of customers*channel
unique_customers<-z[,length(unique(Email)),by=`UTM Channel`]
#unique of customers*channel*visitors
z_rev_channel_visitors<-data.frame(unique_customers,z_rev_channel[,sum(V1),by=`UTM Channel`][,2])
colnames(z_rev_channel_visitors)[2]<- "visitors"
colnames(z_rev_channel_visitors)[3]<- "rev"
historical_ltv<- z_rev_channel_visitors$rev/z_rev_channel_visitors$visitors
z_rev_channel_visitors<-data.frame(z_rev_channel_visitors,historical_ltv)
z_rev_channel_visitors<- z_rev_channel_visitors[order(historical_ltv,decreasing = TRUE),c(1:4)]
repeat_visitors<- subset(z,z$`Customer Type`=='Repeat')
repeat_visitors<- repeat_visitors[,length(unique(Email)),by=`UTM Channel`]
#z_rev_channel_visitors<- merge(z_rev_channel_visitors,repeat_visitors)
num_transactions<- z[,length(Email),by=`UTM Channel`]
colnames(num_transactions)[1]<- "UTM.Channel"
z_rev_channel_visitors<-merge(z_rev_channel_visitors,num_transactions)
