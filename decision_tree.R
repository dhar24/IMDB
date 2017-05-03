
library(ISLR)
library(tree)
attach(Carseats)
high<- ifelse(Sales>8,"Yes","No")
carseat_1 <- data.frame(Carseats,high)

carseat_2 <- carseat_1 [,-1]
#split into training and testing data
set.seed(2)
train_set<- sample(1:nrow(carseat_2), nrow(carseat_2)/2)
test_set<- -train_set
train_data<- carseat_2[train_set,]
test_data<- carseat_2[test_set,]
testin_high<- high[test_set]

#fit the tree model using training data
tree_model<- tree(high~.,train_data)# predict high from all the predictors
plot(tree_model)
text(tree_model,pretty = 0)
#using test data set
tree_pred<- predict(tree_model,test_data,type = "class")
mean(tree_pred!=testin_high)

### Pruning the tree
## cross validation to check where to stop pruning(it tells me the plot between size of tree and dev-cv error rate
# and will tell where exactly to prune)
set.seed(3)
cv_tree<- cv.tree(tree_model,FUN = prune.misclass)
plot(cv_tree$size,
     cv_tree$dev,
     type="b")
#prune the tree
pruned_model<- prune.misclass(tree_model,best=9)
plot(pruned_model)
text(pruned_model)
tree_pred<- predict(pruned_model,test_data,type="class")
mean(tree_pred!=testin_high)
