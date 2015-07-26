##########################
## PROJECT INSTRUCTIONS ##
##########################
#  You should create one R script called run_analysis.R that does the following. 

# Merges the training and the test sets to create one data set.
# Extracts only the measurements on the mean and standard deviation for each measurement. 
# Uses descriptive activity names to name the activities in the data set
# Appropriately labels the data set with descriptive variable names. 
# From the data set in step 4, creates a second, independent tidy data set with the
# average of each variable for each activity and each subject.

## Setting working directory where the files are located
setwd("C:/Users/K56CA/Dropbox/Big Data/COURSERA/Data/UCI HAR Dataset")

## Read variable names
labels_file<-as.vector(read.table("features.txt"))
labels<-as.vector(labels_file[,2])# make a vector with names in second column
                                  # of the file

### GETTING "TEST" DATA

# open labraries
library("data.table")
library("dplyr")
library("reshape2")

sub_test<-fread("test/subject_test.txt")# subjects ID
setnames(sub_test, "V1", "Subj_id")# define column header

ytest<-fread("test/Y_test.txt") # activity labels
setnames(ytest, "V1", "task_labels") # define column header

xtest<-read.table("test/X_test.txt") # data set "TEST"

data_test<-cbind(sub_test,ytest, xtest) # combine previous columns into 1 df

### GETTING "TRAINING" DATA

sub_train<-fread("train/subject_train.txt") # subject ID
setnames(sub_train, "V1", "Subj_id") # define column header

ytrain<-fread("train/Y_train.txt") # activity labels
setnames(ytrain, "V1", "task_labels") # define column header

xtrain<-read.table("train/X_train.txt") # data set "TRAIN"

data_train<-cbind(sub_train,ytrain, xtrain) # combine previous columns into 1 df

## Marging TEST and TRAINING data

dataset<-(rbind(data_test, data_train))
colnames(dataset)[3:ncol(dataset)]<-labels # adding variables names


##########################
## DEFINING DATA FILTER ##
##########################

## Searching for variables measuring mean and SD
meanFilter<-grepl("mean", labels)# Finding true values of the word "mean" 
                                 # among variable names
MeanFilter<-grepl("Mean", labels) # Finding true values of the word "Mean" 
                                  # among variable names
sdFilter<-grepl("std", labels) # Finding true values of the word "std" 
                               # among variable names

## Define df with index, labels, and true/false of each filtered word

data_filter<-as.data.frame((cbind(1:length(labels),labels, meanFilter, 
                                  MeanFilter, sdFilter))) 

final_filter<-(filter(data_filter, meanFilter==TRUE | MeanFilter==TRUE |
                        sdFilter==TRUE)) 
                               
## index indicating the variables to be kept in the analysis                                        
index<-as.matrix(final_filter$V1)%>%as.numeric

## Df selecting the relevant variables
filtered_df<-tbl_df(select(dataset, Subj_id, task_labels, index+2))


###################################
# CHANGING VARIABLE LABELS/NAMES ##
###################################

# eliminate brackets ")"  from variables' names
colnames(filtered_df)<-sub("[)]","",names(filtered_df))

# eliminate brackets "("  from variables' names
colnames(filtered_df)<-sub("[(]","",names(filtered_df))

# substitute "- " by "." in variables' names
colnames(filtered_df)<-sub("-", ".",names(filtered_df))

# substitute " ," by "." in variables' names
colnames(filtered_df)<-sub(",",".",names(filtered_df))

                       
############################
# DEFINING ACTIVITY NAMES ##
############################

# obtaining names from existing file
activ<-read.table("activity_labels.txt") 

# define a factor with labels from the previous file
filtered_df$task_labels<-factor(filtered_df$task_labels, 
                        levels=c(1:6), labels= activ$V2)

###########################################
# SUMMARISING AND OPTAINING TIDY DATASET ##
###########################################

# melting and grouping file based on activities and subject ID
tidySet<-melt(filtered_df, id=c("task_labels", "Subj_id"))
tidySet3<-group_by(tidySet, task_labels, Subj_id, variable)

tidydef<-summarise_each(tidySet3,funs(mean))

# define table header
setnames(tidydef, c("task_labels","variable","value"), 
                c("Activities", "Variable Name","Mean"))

# save file in disk
write.table(tidydef, file="tidyset.txt", row.name=FALSE)
