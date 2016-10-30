# CodeBook
Joe Larson
October 30, 2016


##Synopsis
The purpose of this project is to demonstrate ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. Required to submit: tidy data set, script for performing the analysis, and a code book.
Data
Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones
Here are the data for the project:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
Data Overview
•	Human Activity Recognition database built from the recordings of 30 subjects performing activities of daily living (ADL) while carrying a waist-mounted smartphone with embedded inertial sensors.
•	Data Set Characteristics: Multivariate, Time-Series
•	Number of Instances: 10299
•	Number of Attributes: 561
Libraries Used
The libraries used in this operation are:  library(dplyr), library(data.table), library(lubridate) 
Assignment
The assignment is to create one R script called run_analysis.R that does the following:
### 1-Merges the training and the test sets to create one data set.
### 2-Extracts only the measurements on the mean and standard deviation for each measurement.
### 3-Uses descriptive activity names to name the activities in the data set
### 4-Appropriately labels the data set with descriptive variable names.
### 5-From the data set in step 4, creates a second, 
###   independent tidy data set with the average of each variable for each activity and each subject. 
Data processing
#1. Downloading and unzipping dataset
datedownloadzip <- ymd("20161023") original date set to
## if data directory not create  - create it
if(!file.exists("./data/Dataset.zip"))
   {
##   dir.create("./data/Dataset")
   fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
   download.file(fileUrl,destfile="./data/Dataset.zip")
      # record the download date of the zip file, 
   datedownloadzip <- date()
}
## Unzip dataSet to /data/ directory
if (!file.exists("UCI HAR Dataset")) 
   { 
   unzip(zipfile="./data/Dataset.zip",exdir="./data")
   }

PART 1: Data Extraction
•	PART 1 of the R Script run_analysis -
•	Downloads the zip file and saves it as Dataset.zip in the working directory
•	Unzips Dataset.zip to the working directory
•	Directory “UCI HAR Dataset” contains all files need for running the R Script
print(list.dirs()) 
[1] "."                                             "./data"                                       
[3] "./data/UCI HAR Dataset"                        "./data/UCI HAR Dataset/test"                  
[5] "./data/UCI HAR Dataset/test/Inertial Signals"  "./data/UCI HAR Dataset/train"                 
[7] "./data/UCI HAR Dataset/train/Inertial Signals"
setwd("C:/Users/Joe/Documents/Coursera/Johns Hopkins University/Getting and Cleaning Data/data/UCI HAR Dataset/")
list.files("./UCI HAR Dataset")
[1] "activity_labels.txt" "features.txt"        "features_info.txt"   "README.txt"         
[5] "test"                "train"  
Data Sets
•	features_info.txt: Shows information about the variables used on the feature vector
•	features.txt : List of all features - contains the list of 561 features that needs to be mapped to the test and training datasets
features.txt: Is a list of the measurement labels, 561 of them.  The mean and std term will be pulled 
out and yields 86 term of interest.
str (read.table("./UCI HAR Dataset/features.txt"))
## data.frame':	561 obs. of  2 variables:
## $ V1: int  1 2 3 4 5 6 7 8 9 10 ...
## $ V2: Factor w/ 477 levels "angle(tBodyAccJerkMean),gravityMean)",..: 243 
## 244 245 250 251 252 237 238 239 240 ...

activity_labels.txt: Links the class labels with their activity name (6 activities)
> str (read.table("./UCI HAR Dataset/activity_labels.txt"))
## 'data.frame':	6 obs. of  2 variables:
## $ V1: int  1 2 3 4 5 6
## $ V2: Factor w/ 6 levels "LAYING","SITTING",..: 4 6 5 2 3 1 

Reading the activity_labels.txt: show the 6 activities
> (read.table("./UCI HAR Dataset/activity_labels.txt"))[,2]
[1] WALKING WALKING_UPSTAIRS   WALKING_DOWNSTAIRS SITTING   STANDING          
[6] LAYING            
Levels: LAYING SITTING STANDING WALKING WALKING_DOWNSTAIRS WALKING_UPSTAIRSS
•	Test and training datasets can be found under the respective sub directories named “test” and “train”
•	Unit of Measurement: The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix ‘t’ to denote time) were captured at a constant rate of 50 Hz.
•	train/X_train.txt: Training set - A 561-feature vector with time(t) and frequency(f) domain variables ++ match column names to features.txt for descriptive labels
•	train/y_train.txt: Training labels - Its activity label ++ match with activity_labels.txt for descriptive labels
•	train/subject_train.txt: subject who performed the test
•	test/X_test.txt’: Test set- A 561-feature vector with time and frequency domain variables ++ match column names to features.txt for descriptive labels
•	test/y_test.txt’: Test labels - Its activity label ++ match with activity_labels.txt for descriptive labels
•	test/subject_test.txt: subject who performed the test
dim (read.table("./UCI HAR Dataset/test/X_test.txt"))
## [1] 2947  561
dim (read.table("./UCI HAR Dataset/test/y_test.txt"))
## [1] 2947    1
dim(read.table("./UCI HAR Dataset/test/subject_test.txt"))
## [1] 2947    1
dim (read.table("./UCI HAR Dataset/train/X_train.txt"))
## [1] 7352  561
dim (read.table("./UCI HAR Dataset/train/y_train.txt"))
## [1] 7352    1
dim(read.table("./UCI HAR Dataset/train/subject_train.txt"))
## [1] 7352    1
# PART 2: Joining tables to create a master dataset
•	PART 2 of the R script run_analysis joins the test and training datsets, adds column names, activity labels and subject list
•	2.1 Covert the activies and feature to charter vs as.character
## Load activity labels + features
activitylabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
activitylabels[,2] <- as.character(activitylabels[,2])
features <- read.table("./data/UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2]) 
•	2.2 to save memory space  only the feature that have a mean or std term in their label will be carried forward in a “data.table” featuressought
## Extract only the data on mean and standard deviation
## This line alings mean and std text with correct row numbers
featuressought <- grep(".*mean.*|.*std.*|.*Mean.*", features[,2])
•	2.3 convert mean, std and Mean to capitals
## this aligns the names with -mean or -std and converts  Mean or Std to capitals
featuressought.names <- features[featuressought,2]
featuressought.names = gsub('-mean', 'Mean' , featuressought.names)
featuressought.names = gsub('Mean', 'Mean' , featuressought.names)
featuressought.names = gsub('-std', 'Std' , featuressought.names)
## The result is 86 rows of data with Mean or Std in the names 

# PART 3: Extracts only the measurements on the mean and standard deviation for each measurement and adds descriptive activity names to name the activities in the data set
•	Part 3 of the R Script run_analysis (Please Note: This portion of the script utilizes the dplyr package) -
•	X-test is 561 columns of data that has test data.
•	Y-test is 1 column of data that has test activities type data.
•	X-train is 561 columns of data that has train data.
•	Y-train is 1 column of data that has train activities type data
•	Featuresought contains 561 rows of the measurement type
•	Using read.table in combination with one of the dataset(test/train) and featuressought yields a table of test/train with the correct labeling. This feature is not documented but saw an example and had to try it out, it seems to work.
•	In the end we have two data sets; test and train, that have 81 columns of information
library(dplyr)
### Load the datasets
# this section starts with the test data set, marries it with the 561 variables with mean/std in header
test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")[featuressought]
# using note++ to view the Y_data & subject_test data can be seen that 1 of 30 subjects and 1 to 6 activies an be combined
testactivities <- read.table("./data/UCI HAR Dataset/test/Y_test.txt")
testsubjects <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
# Cbind is used to combine the 86 mean/std data set with activity and subject
test <- cbind(testsubjects, testactivities, test)
#cat("\n", "The test sample set is:")
#print(head(test))

train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")[featuressought]
# using note++ to view the Y_data & subject_test data can be seen that 1 of 30 subjects and 1 f 6 activies an be combined
trainactivities <- read.table("./data/UCI HAR Dataset/train/Y_train.txt")
trainsubjects <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")
# cbind is used to combine the 86 mean/std data set with activity and subject
train <- cbind(trainsubjects, trainactivities, train)
#cat("\n", "The train sample set is:")
#print(head(train))

# PART 3: Extracts only the measurements on the mean and standard deviation for each measurement and adds descriptive activity names to name the activities in the data set
•	Part 3.1 
•	Takes test and train and adds in the correct labels of subject and activity
•	alldata.melted table is the combination of all the test and train data for the 6 actives and 30 subjects that have either mean or std in the measure lable. 
•	At the end of this code is a data set called “alldata.meanstd “ which is 180 observations (30 subject * 6 activities) and the mean of all the measure recorded as part of the test or train data set.   

## merge datasets and add labels
## rbind is used to combine the test and train data sets at the row level
alldata <- rbind(train, test)
#This addes the first two coloumn names to new cloumns V1 and V2 data
colnames(alldata) <- c("subject", "activity", featuressought.names)

# turn activities & subjects into factors
alldata$activity <- factor(alldata$activity, levels = activitylabels[,1], labels = activitylabels[,2])
alldata$subject <- as.factor(alldata$subject)

alldata.melted <- melt(alldata, id = c("subject", "activity"))
## this the final step to get the mean and std measurment all align with the subject and activities
alldata.meanstd <- dcast(alldata.melted, subject + activity ~ variable, mean)


# PART 4: Labels the data set with descriptive variable names wherever approrpiate
•	Part 4 of the R Script run_analysis -
•	Subsititutes specific character strings in the column names of the dataset meansd_act with more descriptive labels
•	This si a repeat of the above section
alldata.melted <- melt(alldata, id = c("subject", "activity"))
# this the final step to get the mean and std measurment all align with the subject and activities
alldata.meanstd <- dcast(alldata.melted, subject + activity ~ variable, mean)

# PART 5: Creates a second, independent tidy data set with the average of each variable for each activity and each subject
•	Part 5 of the R script run_analysis produces the file called tidy.txt and saving in the working directory – 86 data means
## setwd("C:/Users/Joe/Documents/Coursera/Johns Hopkins University/Getting and Cleaning Data/data/")
print(getwd())
write.table(alldata.meanstd, "tidy.txt", row.names = FALSE, quote = FALSE)
print(names(alldata))
 [1] "subject"                              "activity"                            
 [3] "tBodyAccMean()-X"                     "tBodyAccMean()-Y"                    
 [5] "tBodyAccMean()-Z"                     "tBodyAccStd()-X"                     
 [7] "tBodyAccStd()-Y"                      "tBodyAccStd()-Z"                     
 [9] "tGravityAccMean()-X"                  "tGravityAccMean()-Y"                 
[11] "tGravityAccMean()-Z"                  "tGravityAccStd()-X"                  
[13] "tGravityAccStd()-Y"                   "tGravityAccStd()-Z"                  
[15] "tBodyAccJerkMean()-X"                 "tBodyAccJerkMean()-Y"                
[17] "tBodyAccJerkMean()-Z"                 "tBodyAccJerkStd()-X"                 
[19] "tBodyAccJerkStd()-Y"                  "tBodyAccJerkStd()-Z"                 
[21] "tBodyGyroMean()-X"                    "tBodyGyroMean()-Y"                   
[23] "tBodyGyroMean()-Z"                    "tBodyGyroStd()-X"                    
[25] "tBodyGyroStd()-Y"                     "tBodyGyroStd()-Z"                    
[27] "tBodyGyroJerkMean()-X"                "tBodyGyroJerkMean()-Y"               
[29] "tBodyGyroJerkMean()-Z"                "tBodyGyroJerkStd()-X"                
[31] "tBodyGyroJerkStd()-Y"                 "tBodyGyroJerkStd()-Z"                
[33] "tBodyAccMagMean()"                    "tBodyAccMagStd()"                    
[35] "tGravityAccMagMean()"                 "tGravityAccMagStd()"                 
[37] "tBodyAccJerkMagMean()"                "tBodyAccJerkMagStd()"                
[39] "tBodyGyroMagMean()"                   "tBodyGyroMagStd()"                   
[41] "tBodyGyroJerkMagMean()"               "tBodyGyroJerkMagStd()"               
[43] "fBodyAccMean()-X"                     "fBodyAccMean()-Y"                    
[45] "fBodyAccMean()-Z"                     "fBodyAccStd()-X"                     
[47] "fBodyAccStd()-Y"                      "fBodyAccStd()-Z"                     
[49] "fBodyAccMeanFreq()-X"                 "fBodyAccMeanFreq()-Y"                
[51] "fBodyAccMeanFreq()-Z"                 "fBodyAccJerkMean()-X"                
[53] "fBodyAccJerkMean()-Y"                 "fBodyAccJerkMean()-Z"                
[55] "fBodyAccJerkStd()-X"                  "fBodyAccJerkStd()-Y"                 
[57] "fBodyAccJerkStd()-Z"                  "fBodyAccJerkMeanFreq()-X"            
[59] "fBodyAccJerkMeanFreq()-Y"             "fBodyAccJerkMeanFreq()-Z"            
[61] "fBodyGyroMean()-X"                    "fBodyGyroMean()-Y"                   
[63] "fBodyGyroMean()-Z"                    "fBodyGyroStd()-X"                    
[65] "fBodyGyroStd()-Y"                     "fBodyGyroStd()-Z"                    
[67] "fBodyGyroMeanFreq()-X"                "fBodyGyroMeanFreq()-Y"               
[69] "fBodyGyroMeanFreq()-Z"                "fBodyAccMagMean()"                   
[71] "fBodyAccMagStd()"                     "fBodyAccMagMeanFreq()"               
[73] "fBodyBodyAccJerkMagMean()"            "fBodyBodyAccJerkMagStd()"            
[75] "fBodyBodyAccJerkMagMeanFreq()"        "fBodyBodyGyroMagMean()"              
[77] "fBodyBodyGyroMagStd()"                "fBodyBodyGyroMagMeanFreq()"          
[79] "fBodyBodyGyroJerkMagMean()"           "fBodyBodyGyroJerkMagStd()"           
[81] "fBodyBodyGyroJerkMagMeanFreq()"       "angle(tBodyAccMean,gravity)"         
[83] "angle(tBodyAccJerkMean),gravityMean)" "angle(tBodyGyroMean,gravityMean)"    
[85] "angle(tBodyGyroJerkMean,gravityMean)" "angle(X,gravityMean)"                
[87] "angle(Y,gravityMean)"                 "angle(Z,gravityMean)"

