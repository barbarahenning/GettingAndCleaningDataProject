# Code book
Author: Barbara Henning  
2016, October 03rd

This code book contains the information about the variables on the `tidyDataset.csv` file.

## Description
This code book contains the information about the variables, data and transformations performed for the final project for the Getting and Cleaning Data course.  The R script associated to this project is called `run_analysis.R` and can be found within the https://github.com/barbarahenning/GettingAndCleaningDataProject repo.   
This script updates the data set found at http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones and returns `tidyDataset.csv` file also found within the https://github.com/barbarahenning/GettingAndCleaningDataProject repo.

## Project overview
### Original data is available here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The data represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description of original data is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### A tidy data set was created with the following updates on the original data:

The R script called run_analysis.R does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Tidy data set new variables:

* **subject**: identifies the subject who performed the activity. There are 30 subjects in total.
* **activity**: identifies the activity performed. There are six activities: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING.
* **dataset**: identifies if the subject was randomly selected for generating either the test or the training data set.

* **following measurements**: the detailed description of each of the following measurements found in the tidy data set is available at the site where the original data was obtained.  Here, each of the measurements were averaged for each activity and each subject.
