---
title: "Course Project"
author: "JCC"
---

## Project Description
Getting and cleaning data

##Study design and raw data
The original data is the result of a set of experiments that have been carried out with group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, we captured 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data. 

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). The sensor acceleration signal, which has gravitational and body motion components, was separated using a Butterworth low-pass filter into body acceleration and gravity. The gravitational force is assumed to have only low frequency components, therefore a filter with 0.3 Hz cutoff frequency was used. From each window, a vector of features was obtained by calculating variables from the time and frequency domain. See 'features_info.txt' for more details. 

For each record it is provided:
- Triaxial acceleration from the accelerometer (total acceleration) and the estimated body acceleration.
- Triaxial Angular velocity from the gyroscope. 
- A 561-feature vector with time and frequency domain variables. 
- Its activity label. 
- An identifier of the subject who carried out the experiment.

##Creating the tidy datafile

###Guide to create the tidy data file

The final tidy data set is creating by following the steps described bellow:

1- The files are saved in a local directory, and the adequate R working directory is set. 

2- The file containing the names of all the variables measured ("features.txt"), is stored as a vector in a variable called "labels".

3- The files containing information about the "test" measures are read and combined into a single data frame. Specificly, this files combined are: subject ID (subject_test.txt), labels of the activity performed (Y_test.txt), and the file containing the actual measures from 561 variables (X_test.txt).

4- A similar procedured was followed tho the one in step 3, but using the files regarding "taining" data: (subject_train.txt), (Y_train.txt) and (X_train.txt).

5- The two new files (from steps 3 and 4) containing the data from "test" and "training" measures are merged into a single data set (rbind).

6- In the combined data set (from step 5) the variables containing the words "mean" and "std" (standard desviation) are identified by using the function grpel().

7- Specificaly, A new data frame is created by combining the file "labels.txt" (containing 2 columns a numerical index 1:561 and the names of the 561 variables), with 3 more columns that represent logical vectors. The 3 logical columns indicate "TRUE" if the terms "mean", "Mean" (uppercase), and "std" (standard deviation) appear in the variable names respectively. 

8-The data frame from step 7, is filtered for all cases where at least one of the 3 logical columns was equal to TRUE. 

9- A new numerical vector called "index" is created based on the first column of the filtered data frame from step 8. It represents index(number) of the variable containing the words mean or std.

10- A new filtered data base (filtered_df) is created by selecting only the columns corresponding to the indices from step 
9. In other words, the columns containing variables including in their names the words mean or std were eliminated. From the initial 561 variables only 68 were kept. 

11- With the purpose of making the variables' names more readible the brackets "()" haven been eliminated and dashes "-" and semicolons"," have been substituted by dots "." bu using the function sub().

12- In addition, the column "task_labels" from the data frame filtered_df, which contains numeric values from 1 to 6 was redefined as a factor. In this regard the labesls of the factor were taken by reading the file "activity_labels.txt", which contains the names of the 6 different type of activities performed.

13- A new more tidy data set is created by "melting" the filtered_df data frame based on activities ("task_labels") and subject ID ("Subj_id").

14- The new data frame from step 13 is grouped based on task_labels, Subj_id and variable names by implementing the function group_by.

15- Finally, by implementing the function summarise_each based on "mean", a final tidy file is obtained and stored in the local directory.


##Description of the variables in the tidydef.txt file (tidy data set):

The final tidy data set (tidydef.txt) contains 4 columns and 15,480 rows. The format of the final dataset can be appriciated bellow:

----------------------------------------------------
   Activities Subj_id   Variable Name        Mean
1    WALKING       1 tBodyAcc.mean-X  0.27733076
2    WALKING       1 tBodyAcc.mean-Y -0.01738382
3    WALKING       1 tBodyAcc.mean-Z -0.11114810
4    WALKING       1  tBodyAcc.std-X -0.28374026
5    WALKING       1  tBodyAcc.std-Y  0.11446134
6    WALKING       1  tBodyAcc.std-Z -0.2600279
-----------------------------------------------------

The fist column, "Activities", indicates which of the 6 activities included in the file "activity.labels.txt" was the participant performing when the measure was took. 

Second column refers to the participant ID (30 in total). 

The third column show the variable names. The meaning of the abreviation of the names is following presented:
Acc = Acceleration, Gyro=Gyroscope, 
t=time, f=frequency
mean=mean, std= Standard Deviation.

The forth column is the average of each variable per type of activity and subject. All the measures are normalized and bounded within [-1,1].

