### Getting and Cleaning Data Course Project
### Author:  Barbara Henning
### 2016, October 03rd

# This script performs the required steps for the final project from Getting and Cleaning Data Course.

# The instructions for the script are the following:
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names.
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# To run the following script you should:
# 1. Download the original data set from:
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
# 2. Unzip the downloaded file.
# 3. Start running the following steps in the working directory created when you unziped the downloaded file.

###
# 1. Merges the training and the test sets to create one data set.
###

### Read data into R
# go to the directory containing the test data
old.dir <- getwd()
wd <- paste(old.dir,'/', 'Dataset/test', sep='')
setwd(wd) 
# reading test measurements
testMeasure <- read.table('X_test.txt')
# reading labels for test measurements
testLabel <- read.table('y_test.txt')
# reading subject info for test measurements
testSubjects <- read.table('subject_test.txt')
# returning to original directory
setwd(old.dir)


# go to the directory containing the train data
old.dir <- getwd()
wd <- paste(old.dir,'/', 'Dataset/train', sep='')
setwd(wd) 
# reading train measurements
trainMeasure <- read.table('X_train.txt')
# reading labels for train measurements
trainLabel <- read.table('y_train.txt')
# reading subject info for train measurements
trainSubjects <- read.table('subject_train.txt')
# returning to original directory
setwd(old.dir)

# reading features labels
old.dir <- getwd()
wd <- paste(old.dir,'/', 'Dataset', sep='')
setwd(wd) 
features <- read.table('features.txt')
setwd(old.dir)

# adding colnames to measurement datasets
colnames(testMeasure) <- features$V2
colnames(trainMeasure) <- features$V2

# merging datasets
testData <- cbind(testSubjects, dataset='test', testLabel, testMeasure)
colnames(testData)[c(1,3)] <- c('subject', 'activity')

trainData <- cbind(trainSubjects, dataset='train', trainLabel, trainMeasure)
colnames(trainData)[c(1,3)] <- c('subject', 'activity')

mergeData <- rbind(trainData, testData)  #merged data set with train and test data


###
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
###
library(plyr)
# looking for variables that are named with 'mean' or 'std'
meanSdData <- mergeData[, grep(".*[Mm]ean.*|.*std.*", colnames(mergeData))]
meanSdData <- cbind(subject = mergeData$subject, dataset = mergeData$dataset, activity= mergeData$activity, meanSdData)


###
# 3. Uses descriptive activity names to name the activities in the data set
###
# loading file with activity labels
old.dir <- getwd()
wd <- paste(old.dir,'/', 'Dataset', sep='')
setwd(wd) 
activityLabels <- read.table('activity_labels.txt')
setwd(old.dir)
# replacing numbers with descriptive names for activity variable
head(activityLabels)
meanSdData$activity <- factor(meanSdData$activity, levels = levels(as.factor(meanSdData$activity)),
                             labels = activityLabels$V2)

###
# 4. Appropriately labels the data set with descriptive variable names.
###
names(meanSdData) <- gsub('Acc','Acceleration', names(meanSdData))
names(meanSdData) <- gsub('GyroJerk','AngularAcceleration', names(meanSdData))
names(meanSdData) <- gsub('iqr', 'InterquartileRange', names(meanSdData))
names(meanSdData) <- gsub('sma', 'SignalMagnitudeArea', names(meanSdData))
names(meanSdData) <- gsub('arCoeff', 'AutorregresionCoeff', names(meanSdData))                         
names(meanSdData) <- gsub('Mag', 'Magnitude', names(meanSdData))                         
names(meanSdData) <- gsub('\\()$', "", names(meanSdData))
names(meanSdData) <- gsub('[-()]', "_", names(meanSdData))
names(meanSdData) <- gsub('_$', "", names(meanSdData))
names(meanSdData) <- gsub('___', "_", names(meanSdData))

###
# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
###
newData <- aggregate(. ~ subject + activity, meanSdData, mean)
newData$dataset <- factor(newData$dataset, levels = levels(as.factor(newData$dataset)),
                             labels = levels(as.factor(mergeData$dataset)))
write.table(newData, file = "tidyDataset.txt", row.name=FALSE)
