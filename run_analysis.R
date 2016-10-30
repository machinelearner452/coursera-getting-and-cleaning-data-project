## Peer-graded Assignment: Getting and Cleaning Data Course Project
## Getting and Cleaning Data Course Project
##
## Review criterialess 
## The submitted data set is tidy.
## The Github repo contains the required scripts.
## GitHub contains a code book that modifies and updates the available codebooks with the data to indicate all the variables and summaries calculated, along with units, and any other relevant information.
## The README that explains the analysis files is clear and understandable.
## The work submitted for this project is the work of the student who submitted it.
##
## One of the most exciting areas in all of data science right now is wearable computing - 
## see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to 
## develop the most advanced algorithms to attract new users. The data linked to from the course 
## website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. 
## A full description is available at the site where the data was obtained:
##
##      http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
##
## Here are the data for the project:
##  
##      https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
##
## You should create one R script called run_analysis.R that does the following.
##
## Assignment
## 
## 1-Merges the training and the test sets to create one data set.
## 2-Extracts only the measurements on the mean and standard deviation for each measurement.
## 3-Uses descriptive activity names to name the activities in the data set
## 4-Appropriately labels the data set with descriptive variable names.
## 5-From the data set in step 4, creates a second, 
##   independent tidy data set with the average of each variable for each activity and each subject.
##
## A little reseach showed that this link offers some great packagesto get to know and learn
##   https://www.analyticsvidhya.com/blog/2015/12/faster-data-manipulation-7-packages/


library(dplyr)
library(data.table)
library(lubridate)

## set working directory
setwd("C:/Users/Joe/Documents/Coursera/Johns Hopkins University/Getting and Cleaning Data/")

datedownloadzip <- ymd("20161023")

## if data directory not create  - create it
if(!file.exists("./data/Dataset.zip"))
   {
##   dir.create("./data/Dataset")
   
   fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
   download.file(fileUrl,destfile="./data/Dataset.zip")

      # record the download date of the zip file
   datedownloadzip <- date()
}

## Unzip dataSet to /data/ directory
if (!file.exists("UCI HAR Dataset")) 
   { 
   unzip(zipfile="./data/Dataset.zip",exdir="./data")
   }

## list the directories
## cat("The directory list is:")
## cat("\n")
## print(list.dirs())
## cat("\n")
## setwd("C:/Users/Joe/Documents/Coursera/Johns Hopkins University/Getting and Cleaning Data/data/UCI HAR Dataset/")
## print(list.files())
## cat("\n")


## Merges the training and the test sets to create one data set.
## How?
## the activity_lable file shows there are 6 labels - 1 WALKING, 2 WALKING_UPSTAIRS, 3 WALKING_DOWNSTAIRS
##  4 SITTING, 5 STANDING, 6 LAYING, which when printed if a 2 by 6 vector, so use the second column
## the features file is a 2 by 561 vector of the measurement and calculations 
## Note "as.character" the default method calls as.vector, so dispatch is first on methods for 
##  as.character and then for methods for as.vector.

## Load activity labels + features
activitylabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
activitylabels[,2] <- as.character(activitylabels[,2])
features <- read.table("./data/UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

##  Extracts only the measurements on the mean and standard deviation for each measurement.
##  the "mean" and "std" names are through out the features file, assume all data is a measurement
##  the grep function is the best function to used for pattern matching,    so use "OR" within the grep

## Extract only the data on mean and standard deviation
## This line alings mean and std text with correct row numbers
## !!!!This line was adjusted post the reiew of other tidy report as it was clear 7 varables were missed, those with the "Mean" lable
featuressought <- grep(".*mean.*|.*std.*",ignore.case = TRUE, features[,2])

## this aligns the names with -mean or -std or Mean and converts or Mean / Std to capitals
featuressought.names <- features[featuressought,2]
featuressought.names = gsub('-mean', 'Mean' , featuressought.names)
featuressought.names = gsub('-std', 'Std' , featuressought.names)
## !!!!These line was adjusted post the reiew of other tidy report as it was clear 7 varables were missed, those with the "Mean" lable
featuressought.names = gsub('[()]', '', featuressought.names)
featuressought.names = gsub('[-]', '', featuressought.names)
featuressought.names = gsub(' ', '', featuressought.names)
featuressought.names = gsub(',', '', featuressought.names)


# The result is 86 rows of data with Mean or Std in the names
#cat("\n", "The feature set is:")
#print(featuressought.names)

# Load the datasets
# this section starts with the test data set, marries it with the 86 variables in header
test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")[featuressought]
# using note++ to view the Y_data & subject_test data can be seen that 1 of 30 subjects and 1 to 6 activies an be combined
testactivities <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
testsubjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
# Cbind is used to combine the 86 mean/std data set with activity and subject
test <- cbind(testsubjects, testactivities, test)
#cat("\n", "The test sample set is:")
#print(head(test))

# this section starts with the test data set, marries it with the 86 variables in header
train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")[featuressought]
# using note++ to view the Y_data & subject_test data can be seen that 1 of 30 subjects and 1 to 6 activies an be combined
trainactivities <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
trainsubjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
# cbind is used to combine the 86 mean/std data set with activity and subject
train <- cbind(trainsubjects, trainactivities, train)
#cat("\n", "The train sample set is:")
#print(head(train))


# merge datasets and add labels
# rbind is used to combine the test and train data sets at the row level
alldata <- rbind(train, test)
#This addes the first two coloumn names to new cloumns V1 and V2 data
colnames(alldata) <- c("subject", "activity", featuressought.names)

# turn activities & subjects into factors
alldata$activity <- factor(alldata$activity, levels = activitylabels[,1], labels = activitylabels[,2])
alldata$subject <- as.factor(alldata$subject)

alldata.melted <- melt(alldata, id = c("subject", "activity"))
# this the final step to get the mean and std measurment all align with the subject and activities
alldata.meanstd <- dcast(alldata.melted, subject + activity ~ variable, mean)


setwd("C:/Users/Joe/Documents/Coursera/Johns Hopkins University/Getting and Cleaning Data/data/")
#print(getwd())
write.table(alldata.meanstd, "tidy.txt", row.names = FALSE, quote = FALSE)
##print(names(alldata))
