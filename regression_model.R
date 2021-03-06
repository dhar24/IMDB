data()
data("airquality")
names(airquality)
head(airquality,6)
tail(airquality,6)
summary(airquality)
plot(Ozone~Solar.R,data = airquality)
mean.ozone<- mean(airquality$Ozone,na.rm=T)
abline(h=mean.ozone)
model1<- lm(Ozone~Solar.R,data=airquality)
plot(model1,col="red")
model1
abline(model1,col="red")
summary(model1)
