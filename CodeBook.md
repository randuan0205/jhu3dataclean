---
title: "getting and cleaning data code book"
author: "Ran Duan"
date: "May 30, 2017"
output: html_document
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

##1.Merges the training and the test sets to create one data set
- **processing training data**
```{r}
xtrain=read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain=read.table("./UCI HAR Dataset/train/y_train.txt")
subjecttrain=read.table("./UCI HAR Dataset/train/subject_train.txt")
names(ytrain)<-'labels'
names(subjecttrain)<-'subject'
tottrain<-cbind(xtrain,ytrain)
tottrain<-cbind(tottrain,subjecttrain)
str(tottrain)
```
- **processing testing data**
```{r}
xtest=read.table("./UCI HAR Dataset/test/X_test.txt")
ytest=read.table("./UCI HAR Dataset/test/y_test.txt")
subjecttest=read.table("./UCI HAR Dataset/test/subject_test.txt")
names(ytest)<-'labels'
names(subjecttest)<-'subject'
tottest<-cbind(xtest,ytest)
tottest<-cbind(tottest,subjecttest)
str(tottest)
```
      
- **combine training and testing data**
```{r}
totdata<-rbind(tottrain,tottest)
dim(totdata)
```
##2.Extracts only the measurements on the mean and standard deviation for each measurement.
```{r}
features<-read.table("./UCI HAR Dataset/features.txt",stringsAsFactors = FALSE)
names(totdata)[1:561]<-features$V2
meanstdfeature=grepl("-mean..|-std..",names(totdata))
meanstddata3<-totdata[,meanstdfeature]
meanstddata4<-cbind(meanstddata3,totdata[,c(562,563)])
dim(meanstddata4)
```
##3.Uses descriptive activity names to name the activities in the data set
```{r}
activitylabel<-read.table("./UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE)
totdata2<-merge(meanstddata4,activitylabel,by.x='labels',by.y = 'V1',all=TRUE)
totdata3<-totdata2[,-80]
names(totdata3)[81]<-"labels"
head(totdata3)
```
##4.Appropriately labels the data set with descriptive variable names
###utilize gsub function to replace old feature names with more descriptive ones
```{r}
names(totdata3)<-gsub("Acc", "Accelerometer", names(totdata3))
names(totdata3)<-gsub("Gyro", "Gyroscope", names(totdata3))
names(totdata3)<-gsub("BodyBody", "Body", names(totdata3))
names(totdata3)<-gsub("Mag", "Magnitude", names(totdata3))
names(totdata3)<-gsub("^t", "Time", names(totdata3))
names(totdata3)<-gsub("^f", "Frequency", names(totdata3))
names(totdata3)<-gsub("tBody", "TimeBody", names(totdata3))
names(totdata3)<-gsub("-mean()", "Mean", names(totdata3), ignore.case = TRUE)
names(totdata3)<-gsub("-std()", "STD", names(totdata3), ignore.case = TRUE)
names(totdata3)<-gsub("-freq()", "Frequency", names(totdata3), ignore.case = TRUE)
names(totdata3)<-gsub("angle", "Angle", names(totdata3))
names(totdata3)<-gsub("gravity", "Gravity", names(totdata3))
names(totdata3)
```

##5.creates a second, independent tidy data set with the average of each variable for each activity and each subject
```{r}   
summary<-aggregate(.~labels+subject,totdata3,mean)
head(summary)
###produce the tidy data set in txt format
write.table(summary, file = "tidydata.txt",row.name=FALSE)
```

