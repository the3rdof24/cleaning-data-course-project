library(readr)
library(dplyr)
library(reshape2)
library(tidyr)


# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement.
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names.
# Returns a tidy data set of the mean and standard deviation for each measurement
run_analysis <- function() {
    features <- getFeatures()
    # Create a vector of which contains the fixed width lengths of each column
    widths <- rep(16, nrow(features))
    activityLabels <- getActivityLabels()
    
    # Test data
    testSignals <- getDataSet("test", features, widths, activityLabels)
    
    # Train data
    trainSignals <- getDataSet("train", features, widths, activityLabels)
    
    # Add test rows to train rows
    allSignals <- bind_rows(testSignals, trainSignals)
    
    allSignals <- makeTidy(allSignals)
    
    allSignals
}

# Step 5: Returns a tidy data set with the average of each variable for each activity and each subject
getFeatureAverages <- function(tidySignals) {
    tidySignals %>%
    group_by(subjectId, activity, domain, measurement, analysisFunction, axis) %>%
    summarise(average = mean(featureValue))
}

# Melts all the feature columns in allSignals
# Separates the feature names into their parts in separate columns
# And converts the domain column into a factor
makeTidy <- function(allSignals) {
    # 1. Column headers are values, not variable names
    # Convert all the Feature columns into rows
    allSignals <-
        allSignals %>%
        melt(
            id.vars = c("subjectId", "activity"),
            variable.name = "featureName",
            value.name = "featureValue"
        ) %>%
        tbl_df()
    
    # 2. Multiple variables stored in one column
    # Extract the different components of the feature:
    # Domain: t or f (time or frequency)
    # Measurement: eg BodyAcc, GravityAcc
    # AnalysisFunction: eg mean, std
    # Axis: eg X, Y, Z
    
    allSignals <- 
        allSignals %>%
        separate(featureName, c("domain", "measurement"), sep = 1) %>%
        separate(measurement, c("measurement", "analysisFunction", "axis"), sep = "-", fill = "right")
    
    # Convert the domain into a factor so that it is more readable
    allSignals$domain <- factor(allSignals$domain, levels = c("f", "t"), labels = c("frequency", "time"))
    
    allSignals
}

# Returns a data frame with all the features. Parentheses are removed from feature names.
# A column 'extract' is added to indicate whether we want to retrieve data for that column or not.
getFeatures <- function() {
    # Read features, or column names
    features <- read.delim("features.txt", header = FALSE, sep = " ", col.names = c("index", "feature"))
    
    # Remove strange characters out of column names
    features$feature <- gsub("\\(\\)", "", features$feature)
    
    # Add a column to say whether we're interested in extracting each feature
    features$extract <- grepl("-(mean|std)-", features$feature)
    
    features
}

# Returns a data frame with the activity Id associated with each activity
getActivityLabels <- function() {
    activities <-
        read.csv(
            "activity_labels.txt",
            header = FALSE,
            sep = " ",
            stringsAsFactors = FALSE,
            col.names = c("activityId", "activity")
        )
    
    activities
}

#' Retrieves the specified data set by setName, and only includes the columns
#' where features$extract is true.
#'
#' @param setName - either "test" or "train"
#' @param features - data frame of all feature names
#' @param widths - numeric vector of column widths (they should all be 16)
#' @param activityLabels - Used to createa a factor for activity
#'
#' @return Data frame
getDataSet <- function(setName, features, widths, activityLabels) {
    # Read in the X_test file, but only the columns we want to extract
    featureData <- read_fwf(
        gsub("setName", setName, "setName\\X_setName.txt"),
        col_positions = fwf_widths(widths, features$feature)
    ) %>%
        select(features$index[features$extract == TRUE])
    
    
    subjects <- read.csv(gsub("setName", setName, "setName\\subject_setName.txt"), 
                             header = FALSE, col.names = c("subjectId"))
    
    activities <- read.csv(gsub("setName", setName, "setName\\y_setName.txt"), 
                              header = FALSE, col.names = c("activity"))
    
    # Set the activities' activity column to a factor
    activities$activity <- factor(activities$activity, activityLabels$activityId, labels = activityLabels$activity)
    
    # Add activity and subject to featureData
    featureData$activity <- activities$activity
    featureData$subjectId <- subjects$subjectId
    
    # put subject and activity at the beginning of the columns
    featureData <- select(featureData, subjectId, activity, everything())
    
    featureData
}
