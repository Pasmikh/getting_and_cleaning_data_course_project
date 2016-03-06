#loading packages
library(readr)
library(dplyr)
library(stringr)
#creating temp file to download the data
temp=tempfile()
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",temp)
#reading test and train data
test_values = read_table(unzip(temp, "UCI HAR Dataset/test/X_test.txt"),col_names=F)
test_labels = read_table(unzip(temp, "UCI HAR Dataset/test/y_test.txt"),col_names=F)
test_subject = read_table(unzip(temp,'UCI HAR Dataset/test/subject_test.txt'),col_names = F)
#joining values,subject and activity info from test data
test=cbind(test_subject,test_labels,test_values)
train_values = read_table(unzip(temp, "UCI HAR Dataset/train/X_train.txt"),col_names=F)
train_labels = read_table(unzip(temp, "UCI HAR Dataset/train/y_train.txt"),col_names=F)
train_subject = read_table(unzip(temp,'UCI HAR Dataset/train/subject_train.txt'),col_names = F)
#joining values,subject and activity info from train data
train=cbind(train_subject,train_labels,train_values)
#binding train and test data
data=rbind(train,test)
#adding features labels. downloading them first
features=read.table(unzip(temp,'UCI HAR Dataset/features.txt'),sep=' ')
#converting from factor to character
features$V2=as.character(features$V2)
#adding 2 names for subject and activity columns
addNames=rbind(c(0,'Subject'),c(0,'Activity'))
#preparing final names vector
names=rbind(addNames,features)
#setting data names to the names vector
names(data)=names$V2
#translating coded activity values to the factor variable with actual activity names in it
#reading data first
activities=read.table(unzip(temp,'UCI HAR Dataset/activity_labels.txt'),sep=' ')
#merging by activity id
data=merge(data,activities,by.x='Activity',by.y='V1',all.x = T)
#giving activity column actual activity values
data$Activity=data$V2
#removing temp variable after merging
data=data[,1:563]
#cleaning the mess
rm(list=setdiff(ls(),"data"))
#Creating a logical vector of mean and std variables only. We need only variables
#that look like mean,Mean,std. Not meanFreq, that's why [(,)] in the end
matches=!is.na(str_match(names(data),'[M,m]ean[(,)]|[S,s]td'))
#Adding subject and activity columns to the logical vector
matches[1:2]=T
#Selecting only 1,2 and mean/std columns from data
data=data[,matches]
#removing angle variables
data=data[,1:68]
#converting final variables names to lower case characters
names(data)=tolower(names(data))
#grouping by subject and activity and counting average of every feature
tidy_data=group_by(data,activity,subject) %>% summarize_each(funs(mean))
rm(data,matches)