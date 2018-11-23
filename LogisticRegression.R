 
#This is a Logistic Regression model on the KDD99 dataset which predicts the normal vs abnoraml traffic. 
#What this model does is that it estimates the coefficients the parameters we input. 
#Here I included 2 models. First one consists of 41 variables, which are all we had available. 
#The second model consist of 10 chosen variables. The reason for those 10 variables for testing are explained in the report and reflection.
#The model might be modified by changing the set of variables or modyfing the selection of training and testing data.

#BEFORE RUNNING THE PROGRAM, change the below, giving the place where you saved the files.

kddata<-read.csv("~/Documents/Data Science/Week 1/kddcup.data_10_percent_corrected")
kddnames=read.table("~/Documents/Data Science/Week 1/kddcup.names",sep=":",skip=1,as.is=T)
#First download the data and split into the thaining and testing data. 
#The names of each column were not included in the table, we include it by:
colnames(kddata)=c(kddnames[,1],"normal")

#We need this package
library(tidyverse) 

# I use the function from out Lab session to avoid errors with service column. 
trans=function(x){
  stab=table(x[,"service"])
  sother=names(stab[stab<10])
  x[x[,"service"]%in%sother,"service"]="other"
  x[,"service"]=as.factor(as.character(x[,"service"]))
  
  x
}

#I leave the code below as a comment, because I decided to not use the zeroduration in the model. 
#Using zeroduration produces better results.  
#zerofunction=function(x){
#  x[,"zeroduration"]=(x[,"duration"]==0)
#x
#}
#kddata=zerofunction(kddata)


kddata2=trans(kddata)

#We start with setting the test and train data. In this model we split the data in half. 
set.seed(1)
n=dim(kddata)[1]
s=sample(1:n,n/2)
train=kddata2[s,]
test=kddata2[-s,]


# I take the training data and change the "normal" column such that 1 if it was normal data and 0 otherwise. 
train <- train %>% as_data_frame %>% mutate(response=as.factor(if_else(normal=="normal.",1,0))) 
# I get rid of the column 'normal', now it is replaces by 'response' which is binary.
#NOTE: If we use zeroduration we will get rid of the duration variable. Then the corrected code is below as a comment:
#train2 <- train %>% select(-normal,-duration)
train2 <- train %>% select(-normal)
# Now I do the same with the test data( so that it matches the training data)
test <- test %>% as_data_frame %>% mutate(response=as.factor(if_else(normal=="normal.",1,0))) 


# Below we train model using all variables. The sys.time functions measures time for the model to be trained. 
t0 <- Sys.time()
model <- glm(response~.,family=binomial(link='logit'),data=train2)
t1 <- Sys.time() - t0
print(paste("Classifier trained in",as.numeric(t1),"seconds", sep = " "))
summary(model)

#The model below takes 10(including the repsonse) variables 
model10<-glm(response~duration+src_bytes+dst_bytes+num_compromised+num_root+count+srv_count+dst_host_count+dst_host_srv_count,family=binomial(link='logit'),data=train)
summary(model10)



############################################################################################
#First I do the analysis for the 'model'. 

# We predict the normal/abnormal of out test data. Then we round-up the result to obtain a binary data.
fitted.results <- predict(model,newdata=test,type='response')
plot(fitted.results)
fitted.results <- ifelse(fitted.results > 0.5,1,0)

# We generate a table which gives the error types. We compute the accuracy of the model. FP, FN rates and F1 scores. 
predict <- predict(model, test, type = 'response')
table_mat <- table(test$response, predict > 0.5)
table_mat
accuracy_Test <- sum(diag(table_mat)) / sum(table_mat)
accuracy_Test

FalsePositiveRate<- table_mat[2,1]/ sum(table_mat[2,1]+table_mat[2,2])
FalsePositiveRate
FalseNegativeRate<- table_mat[1,2]/ sum(table_mat[1,1]+table_mat[1,2])
FalseNegativeRate
Recall<-table_mat[1,1]/ sum(table_mat[1,1]+table_mat[1,2])
Precision<-table_mat[1,1]/ sum(table_mat[1,1]+table_mat[2,1])
F1<-2*Recall*Precision/(Recall+Precision)
F1

#Below is a code for the ROC curve which shows how accurate the prediction is. 
library("ROCR")    
pred <- prediction(predict, test$response)    
perf <- performance(pred, measure = "tpr", x.measure = "fpr")     
plot(perf, col=rainbow(7), main="ROC curve Admissions", xlab="Specificity", 
     ylab="Sensitivity")  



##############################################################################################

# I wanted to use the penalisation variable, but I could not install the package 'glmnet'. This could potentially improve the model.
#x <- model.matrix(response~., train2)[,-1]
#x is the dummy variable.
# Convert the outcome (class) to a numerical variable
#y <- ifelse(train2$response == "0", 1, 0)
#install.packages("glmnet")
#library(glmnet)
# Find the best lambda using cross-validation
#cv.lasso <- cv.glmnet(x, y, alpha = 1, family = "binomial")
# Fit the final model on the training data
#model <- glmnet(x, y, alpha = 1, family = "binomial",
 #               lambda = cv.lasso$lambda.min)


###############################################################################################
#Now I make an analogous anylysis for model10, which is a model with 10 variables

# We predict the normal/abnormal of out test data. Then we round-up the result to obtain a binary data.
fitted.results10 <- predict(model10,newdata=test,type='response')
plot(fitted.results10)
fitted.results10 <- ifelse(fitted.results10 > 0.5,1,0)

# We generate a table which gives the error types. We compute the accuracy of the model. FP, FN rates and F1 scores. 
predict10 <- predict(model10, test, type = 'response')
table_mat10 <- table(test$response, predict10 > 0.5)
table_mat10
accuracy_Test10 <- sum(diag(table_mat10)) / sum(table_mat10)
accuracy_Test10

FalsePositiveRate10<- table_mat10[2,1]/ sum(table_mat10[2,1]+table_mat10[2,2])
FalsePositiveRate10
FalseNegativeRate10<- table_mat10[1,2]/ sum(table_mat10[1,1]+table_mat10[1,2])
FalseNegativeRate10
Recall10<-table_mat10[1,1]/ sum(table_mat10[1,1]+table_mat10[1,2])
Precision10<-table_mat10[1,1]/ sum(table_mat10[1,1]+table_mat10[2,1])
F110<-2*Recall10*Precision10/(Recall10+Precision10)
F110

###############################################################################################
#NOTE: Change the place where the data was saved
#Now we predict the smurf data and based on smurf data predict other attacks.
kddata<-read.csv("~/Documents/Data Science/Week 1/kddcup.data_10_percent_corrected")
kddnames=read.table("~/Documents/Data Science/Week 1/kddcup.names",sep=":",skip=1,as.is=T)
colnames(kddata)=c(kddnames[,1],"normal")
library(tidyverse) 

kddata_normal <- kddata %>%
  filter(normal == "normal.")
kddata_smurf <-kddata %>%
  filter(normal == "smurf.")
kddata_restattacks <-kddata %>%
  filter(normal != "smurf." & normal!="normal.")
set.seed(1)

#####
#70 percent for training and 30 for testing. we keep balance 20% of normal and 80% of the rest
# we take how much of the normal data we use each time. we want to keep balance.
training_normal_amount <- floor(0.7*nrow(kddata)*0.2)

#this gives all the normal data for training
normal_amount <- sample(nrow(kddata_normal), training_normal_amount)

training_normal <- kddata_normal[normal_amount,]
#all the normal data for testing
testing_normal <- kddata_normal[-normal_amount,]

#how much abnormal data for training
training_attack_amount <- floor(0.7*nrow(kddata)*0.8)
#how much abnormal data for testing
testing_attack_amount <- floor(0.3*nrow(kddata)*0.8)

#FIRST case is that we train with smurf
smurf_amount_train <- sample(nrow(kddata_smurf), training_attack_amount)
smurf_train<-kddata_smurf[smurf_amount_train,]
#SECOND case where we test with smurf
smurf_amount_test <- sample(nrow(kddata_smurf), testing_attack_amount)
smurf_test<-kddata_smurf[smurf_amount_test,]


#1 we use smurf to predict the rest
training1 <- rbind(training_normal, smurf_train)
testing1 <- rbind(testing_normal, kddata_restattacks)
#use the rest to predict smurf
training2 <- rbind(training_normal, kddata_restattacks)
testing2 <- rbind(testing_normal, smurf_test)

###########################################
#I start with predicting the smurf attack.
colnames(training2)=c(kddnames[,1],"normal")
colnames(testing2)=c(kddnames[,1],"normal")

#Using the zeroduration gives worse prediction.
#trans=function(x){
#  x[,"zeroduration"]=(x[,"duration"]==0)
#  x
#}
#training2<-trans(training2)
#training2

#I take the training data and change the "normal" column such that 1 if normal, 0 otherwise 
secondtrain <- training2 %>% as_data_frame %>% mutate(response=as.factor(if_else(normal=="normal.",1,0)))%>% select(-normal)

#Training of the model
t0 <- Sys.time()
Smodel <- glm(response~.,family=binomial(link='logit'),data=secondtrain)
t1 <- Sys.time() - t0
print(paste("Classifier trained in",as.numeric(t1),"seconds", sep = " "))
summary(Smodel)

#Preparing the testing data
secondtest <- testing2 %>% as_data_frame %>% mutate(response=as.factor(if_else(normal=="normal.",1,0))) 
secondtest2<- secondtest%>% select(-normal)
 
Sfitted.results <- predict(Smodel,newdata=secondtest2,type='response')
Sfitted.results <- ifelse(Sfitted.results > 0.5,1,0)

# This table give the error types 
Spredict <- predict(Smodel, secondtest2, type = 'response')
Stable_mat <- table(secondtest2$response, Spredict > 0.5)
Stable_mat

# Correct prediction/ all predictions
Saccuracy_Test <- sum(diag(Stable_mat)) / sum(Stable_mat)
Saccuracy_Test

SFalsePositiveRate<- Stable_mat[2,1]/ sum(Stable_mat[2,1]+Stable_mat[2,2])
SFalsePositiveRate
SFalseNegativeRate<- Stable_mat[1,2]/ sum(Stable_mat[1,1]+Stable_mat[1,2])
SFalseNegativeRate
SRecall<-Stable_mat[1,1]/ sum(Stable_mat[1,1]+Stable_mat[1,2])
SPrecision<-Stable_mat[1,1]/ sum(Stable_mat[1,1]+Stable_mat[2,1])
SF1<-2*SRecall*SPrecision/(SRecall+SPrecision)
SF1

#Using the zeroduration the result are every bad: 
#ACC 0.186632
#FalsePositiveRate 0.02632047
#FalseNegativeRate 1

#########################
#Now I train the smurf data and predict  the other attacks.
colnames(training1)=c(kddnames[,1],"normal")
colnames(testing1)=c(kddnames[,1],"normal")

#I had to change the variables into factors, otherwise the model could not deal with new kinds of variables.
training1$protocol_type <- as.integer(factor(training1$protocol_type))
training1$service <- as.integer(factor(training1$service))
training1$flag <- as.integer(factor(training1$flag))

testing1$protocol_type <- as.integer(factor(testing1$protocol_type))
testing1$service <- as.integer(factor(testing1$service))
testing1$flag <- as.integer(factor(testing1$flag))

# I take the training data and change the "normal" column such that 1 if normal, 0 otherwise 
firsttrain <- training1 %>% as_data_frame %>% mutate(response=as.factor(if_else(normal=="normal.",1,0)))%>% select(-normal)

t0 <- Sys.time()
Rmodel <- glm(response~.,family=binomial(link='logit'),data=firsttrain)
t1 <- Sys.time() - t0
print(paste("Classifier trained in",as.numeric(t1),"seconds", sep = " "))
summary(Rmodel)


firsttest <- testing1 %>% as_data_frame %>% mutate(response=as.factor(if_else(normal=="normal.",1,0))) 
firsttest<- firsttest%>% select(-normal)

# We predict the normal/abnormal of out test data 
Rfitted.results <- predict(Rmodel,newdata=firsttest,type='response')
Rfitted.results <- ifelse(Rfitted.results > 0.5,1,0)

# This table give the error types 
Rpredict <- predict(Rmodel, firsttest, type = 'response')
Rtable_mat <- table(firsttest$response, Rpredict > 0.5)
Rtable_mat
# Correct prediction/ all predictions
Raccuracy_Test <-sum(diag(Rtable_mat)) / sum(Rtable_mat)
Raccuracy_Test
RFalsePositiveRate<- Rtable_mat[2,1]/ sum(Rtable_mat[2,1]+Rtable_mat[2,2])
RFalsePositiveRate
RFalseNegativeRate<- Rtable_mat[1,2]/ sum(Rtable_mat[1,1]+Rtable_mat[1,2])
RFalseNegativeRate
RRecall<-Rtable_mat[1,1]/ sum(Rtable_mat[1,1]+Rtable_mat[1,2])
RPrecision<-Rtable_mat[1,1]/ sum(Rtable_mat[1,1]+Rtable_mat[2,1])
RF1<-2*RRecall*RPrecision/(RRecall+RPrecision)
RF1

#Below is a code for the ROC curve which shows how accurate the prediction is. 
library("ROCR")    
pred <- prediction(Rpredict, firsttest$response)    
perf <- performance(pred, measure = "tpr", x.measure = "fpr")     
plot(perf, col=rainbow(7), main="ROC curve Admissions", xlab="Specificity", 
     ylab="Sensitivity")  
