### Getting and Cleaning Data Course Project

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

mergeData <- rbind(trainData, testData)


###
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
###
library(plyr)
# looking for variables that are named with 'mean' or 'std'
meanSd <- mergeData[, grep(".*[Mm]ean.*|.*std.*", colnames(mergeData))]


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
mergeData$activity <- factor(mergeData$activity, levels = levels(as.factor(mergeData$activity)),
                             labels = activityLabels$V2)

###
# 4. Appropriately labels the data set with descriptive variable names.
###
names(mergeData) <- gsub('Acc','Acceleration', names(mergeData))
names(mergeData) <- gsub('GyroJerk','AngularAcceleration', names(mergeData))
names(mergeData) <- gsub('iqr', 'InterquartileRange', names(mergeData))
names(mergeData) <- gsub('sma', 'SignalMagnitudeArea', names(mergeData))
names(mergeData) <- gsub('arCoeff', 'AutorregresionCoeff', names(mergeData))                         
names(mergeData) <- gsub('Mag', 'Magnitude', names(mergeData))                         
names(mergeData) <- gsub('\\()$', "", names(mergeData))
names(mergeData) <- gsub('[-()]', "_", names(mergeData))
names(mergeData) <- gsub('_$', "", names(mergeData))
names(mergeData) <- gsub('___', "_", names(mergeData))

###
# 5. From the data set in step 4, creates a second, independent tidy data set 
# with the average of each variable for each activity and each subject.
###
newData <- aggregate(. ~ subject + activity, mergeData, mean)
newData$dataset <- factor(newData$dataset, levels = levels(as.factor(newData$dataset)),
                             labels = levels(as.factor(mergeData$dataset)))
write.table(newData, file = "tidyDataset.txt", row.name=FALSE)
