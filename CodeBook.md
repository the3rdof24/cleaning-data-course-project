This describes the tidy data set created by run_analysis(), and how the raw data was transformed.

##### About the Raw Data

The experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain.

##### run_analysis() creates a table with the following variables:

###### subjectId
- Identifier for the test subject. Its range is from 1 to 30.

###### activity
- The activity performed while wearing the smartphone.
1 = Walking
2 = Walking Upstairs
3 = Walking Downstairs
4 = Sitting
5 = Standing
6 = Laying

###### domain
- The signal domain, either 'time' or 'frequency'.

###### measurement
- The type of acceleration signal measured, body or gravity.

###### analysisFunction
- The summary function applied to the signal measurement, either 'mean' or 'std' (standard deviation)

###### axis
- The X,Y,Z axis of the measurement.

###### featureValue
- The calculated value of the analysisFunction on the signal measured.


##### Raw Data to Tidy Data Transformation

1. Read **train/X_train.txt**, and add a column with the subjects from **train/y_train.txt** using features.txt as the column names.
2. Read **test/X_test.txt**, and add a column with the subjects from **test/y_test.txt** using features.txt as the column names.
3. Associate the activity with the data from activity_labels.txt
3. Combine the data frames from 1 & 2.
4. At this stage we have the following columns:
..* subjectId
..* activity
..* All the column names from **features.txt** where parentheses **()** have been removed
5. Only the feature columns which contain '-mean()', or '-std()' are selected.
6. All the feature columns are melted so that we have
..* subjectId
..* activity
..* featureName
..* featureValue
7. Column *featureName* is then separated into
..* domain
..* measurement
..* analysisFunction
..* axis