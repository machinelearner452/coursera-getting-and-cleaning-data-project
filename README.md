# Coursera-Getting-and-Cleaning-Data-Project
Coursera-Peer-graded-Assignment-Getting-and-Cleaning-Data

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The assignment is documented in the code book. The method is simple starts with downloading the zip fie, the un zipping to merging the data. Data tables were used over data frames, to have the information read and manipulated to the requirements listed above.

The final tidy file had 88 output columns with 180 rows of information, 6 activities and 30 subjects

There are some key points in the obtain the mean and std value needs to have the files searched to ensure the lower and upper case value are sought. There is also key in having the not standard charters address; dash, space, commas, brackets (different types), otherwise the column counts can be different than the data set.
