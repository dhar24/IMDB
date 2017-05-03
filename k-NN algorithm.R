#Note: it also depend on how you're loading your data as it depends on how you will be manipulating it, e.g fread() 
#will not work here as we're manipulating data.frame here and it gives us data.table output so.


library(data.table)
library(class)
library(gmodels)

# File Reading from system
#wbcd<- fread(input = "wisc_bc_data.txt", sep = ",")
wbcd<- read.csv("wisc_bc_data.txt", stringsAsFactors = FALSE)
# Data preparation for analysis
wbcd<- wbcd[,-1]
normalize<- function(x)
{ return ((x-min(x))/(max(x)-min(x)))}

##Normalizing all columns from 2 to 31
wbcd_n <- as.data.frame(lapply(wbcd[,2:31],normalize))

#divide test and train dataset
train_data<- wbcd_n[1:469,]
test_data<- wbcd_n[470:569,]
#train_label needs to be a vector not a data frame then only length(Class) and length(train_data) will match
train_label <- wbcd[1:469,1]
test_label <- wbcd[470:569,1]
#cl=  is a factor vector with class for each row in  train data, k is root of number of observation as of now
wbcd_test_pred<- knn(train = train_data,test = test_data, cl = train_label
                     ,k = 21)
#Evaluating the model performance[pro,chisq =FALSE will remove unncedssary chi2 values from  output]
CrossTable(x = test_label,y = wbcd_test_pred, prop.chisq = FALSE)

# we can further analyze with the help of diff values of k and using scale() for z score standardization and 
#after repeating same procedure



