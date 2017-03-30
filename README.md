# Coursera - Getting and Cleaning Data Course Project

## run_analysis.R
This script contains two main functions. It is assumed that the working directory contains the following dataset:
<https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip>, so the directory 'UCI HAR Dataset' is the working directory.

### run_analysis()
- Merges the training and the test sets to create one data set.
- Extracts only the measurements on the mean and standard deviation for each measurement.
- Uses descriptive activity names to name the activities in the data set
- Appropriately labels the data set with descriptive variable names.
- Returns a tidy data set of the mean and standard deviation for each measurement

### getFeatureAverages(tidySignals)
Returns a tidy data set with the average of each variable for each activity and each subject.

## Usage

```R
tidyData <- run_analysis()

averages <- getFeatureAverages(tidyData)
```

## CodeBook.md
A code book that describes the variables, the data, and any transformations performed to clean up the raw data in the 'UCI HAR Dataset'.
