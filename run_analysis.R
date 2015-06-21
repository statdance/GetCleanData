## Import the features table
features <- read.table("UCI HAR Dataset/features.txt",col.names=c("rowid","Variable"))

## Creates a data frame of the variables with mean and std in their names.
use_feat <- features[grepl("mean", features$Variable) | grepl("std", features$Variable), ]

## Import all of the data into individual data frames. Activity and subject
## data are given column names. 
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt",col.names = "Activity")
subtrain <- read.table("UCI HAR Dataset/train/subject_train.txt",col.names="Subject")
xtest <- read.table("UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("UCI HAR Dataset/test/y_test.txt",col.names = "Activity")
subtest <- read.table("UCI HAR Dataset/test/subject_test.txt",col.names="Subject")

## Each data frame is given observation numbers, one at a time, to 
## allow for seamless integration
xtrain$obs <- as.numeric(rownames(xtrain))
ytrain$obs <- as.numeric(rownames(ytrain))
subtrain$obs <- as.numeric(rownames(subtrain))
xtest$obs <- as.numeric(rownames(xtest))
ytest$obs <- as.numeric(rownames(ytest))
subtest$obs <- as.numeric(rownames(subtest))

## The dataframes are merged together, keeping only one final observation number
traindata <- merge(ytrain,subtrain,by.x="obs",by.y="obs")
traindata <- merge(traindata,xtrain,by.x="obs",by.y="obs")

testdata <- merge(ytest,subtest,by.x="obs",by.y="obs")
testdata <- merge(testdata,xtest,by.x="obs",by.y="obs")

## The testdata and the training data are combined, making the obs column
## obselete. This column is deleted.
alldata <-rbind(testdata,traindata)
alldata$obs <- NULL

## Removes the non-useful data from the alldata data frame by only 
## using the columns that use_feat directs.

alldata <- alldata[,c(1,2,2+use_feat$rowid)]

activitynames = read.table("UCI HAR Dataset/activity_labels.txt",
                           col.names=c("Activity", "ActivityName"),)
labelledalldata <- merge(alldata, activitynames)