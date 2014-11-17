#Getting and Cleaning Data

##Course Project using data from a Wearable Device

###The R script run_analysis.R does the following
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
6. Write the data from Step 5 to a text file 

###Comments
1. Download the Data from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
2. Unzip the data, folder "UCI HAR Dataset" is created
3. Use the correct working directory: place file "run_analysis.R" and folder "UCI HAR Dataset" directly in the working directory
4. Libraries used: plyr, data.table
5. Run source("run_analysis.R")


