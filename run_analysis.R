library(dplyr)

###1.Merges the training and the test sets to create one data set
   #processing training data
    xtrain=read.table("./train/X_train.txt")
    ytrain=read.table("./train/y_train.txt")
    subjecttrain=read.table("./train/subject_train.txt")
    names(ytrain)<-'labels'
    names(subjecttrain)<-'subject'
    tottrain<-cbind(xtrain,ytrain)
    tottrain<-cbind(tottrain,subjecttrain)
    str(tottrain)

   #processing testing data
    xtest=read.table("./test/X_test.txt")
    ytest=read.table("./test/y_test.txt")
    subjecttest=read.table("./test/subject_test.txt")
    names(ytest)<-'labels'
    names(subjecttest)<-'subject'
    tottest<-cbind(xtest,ytest)
    tottest<-cbind(tottest,subjecttest)
    str(tottest)

   #combine training and testing data
    totdata<-rbind(tottrain,tottest)
    dim(totdata)

###2.Extracts only the measurements on the mean and standard deviation for each measurement.
    features<-read.table("features.txt",stringsAsFactors = FALSE)
    names(totdata)[1:561]<-features$V2
    meanstdfeature=grepl("-mean..|-std..",names(totdata))
    meanstddata3<-totdata[,meanstdfeature]
    meanstddata4<-cbind(meanstddata3,totdata[,c(562,563)])
    dim(meanstddata4)

###3.Uses descriptive activity names to name the activities in the data set
     activitylabel<-read.table("activity_labels.txt",stringsAsFactors = FALSE)
     totdata2<-merge(meanstddata4,activitylabel,by.x='labels',by.y = 'V1',all=TRUE)
     totdata3<-totdata2[,-80]
     names(totdata3)[81]<-"labels"
     head(totdata3)

###4.Appropriately labels the data set with descriptive variable names
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


# creates a second, independent tidy data set with the average of each variable for each activity and each subject
summary<-aggregate(.~labels+subject,totdata3,mean)
head(summary)
write.table(summary, file = "tidydata.txt",row.name=FALSE)


