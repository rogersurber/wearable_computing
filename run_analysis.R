### use set working directory and libraries once
###setwd("../GitHub/Wearable_Computing_Aux/")
###library(data.table)
###library(plyr)


##  1. Merges the training and the test sets to create one data set.

### read test data
test_data <- read.table("UCI HAR Dataset/test/X_test.txt", header=FALSE, sep = "")
### add subject and y-label first
test_data[, 562] <- read.table("UCI HAR Dataset/test/subject_test.txt", header=FALSE, sep = "")
test_data[, 563] <- read.table("UCI HAR Dataset/test/y_test.txt", header=FALSE, sep = "")

### read training data
training_data <- read.table("UCI HAR Dataset/train/X_train.txt", header=FALSE, sep = "")
### add subject and y-label first
training_data[, 562] <- read.table("UCI HAR Dataset/train/subject_train.txt", header=FALSE, sep = "")
training_data[, 563] <- read.table("UCI HAR Dataset/train/y_train.txt", header=FALSE, sep = "")

### union test and training data sets
all_data <- rbind(test_data, training_data)

### complete union by adding names to all + to the 2 added columns
### read features, name features on all_data
features <- read.table("UCI HAR Dataset/features.txt", header=FALSE, sep = "")
names(all_data) <- features[,2]
### name the two added columns
names(all_data)[562] <- "Subject"
names(all_data)[563] <- "Activity_Number"


## 2. Extracts only the measurements on the mean and standard deviation for each measurement. 

### names_feat1 contains vector with indices where matching is TRUE
names_feat1 <- grep("(mean\\(\\)|std\\(\\)|Subject|Activity)", names(all_data), ignore.case = TRUE, value = FALSE) 
### create dataset feat1_data with the mean and standard measurements (and still including the subject and y-label)
feat1_data <- all_data[, names_feat1]


## 3. Uses descriptive activity names to name the activities in the data set

### reads the activity names from the failes and stores it in activity_labels
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", header=FALSE, sep = "")
activities_numbers <- activity_labels$V2[feat1_data$Activity_Number]
### add column to the dataset
feat1_data <- cbind(Activity = activities_numbers, feat1_data)

### convert to data.table
feat1_table <- data.table(feat1_data)

### delete Activity from feat1_data
tidy_table <- feat1_table[, Activity_Number:=NULL]

### set new order of columns
tidy_table <- setcolorder(tidy_table, 
                          c(names(tidy_table)[(length(tidy_table))], 
                            names(tidy_table)[1:(length(tidy_table)-1)]))


## 4. Appropriately labels the data set with descriptive variable names. 

setnames(tidy_table, names(tidy_table), gsub("^t", "Time-", names(tidy_table)))
setnames(tidy_table, names(tidy_table), gsub("^f", "Frequency-", names(tidy_table)))
setnames(tidy_table, names(tidy_table), gsub("mean\\(\\)", "Mean", names(tidy_table)))
setnames(tidy_table, names(tidy_table), gsub("std\\(\\)", "StandardDeviation", names(tidy_table)))
setnames(tidy_table, names(tidy_table), gsub("Mag", "Magnitude", names(tidy_table)))
setnames(tidy_table, names(tidy_table), gsub("Acc", "Acceleration", names(tidy_table)))


## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

tidy_mean <- ddply(tidy_table, .(Subject, Activity), colwise(mean))
setnames(tidy_mean, names(tidy_mean), gsub("^Time", "AVG-Time", names(tidy_mean)))
setnames(tidy_mean, names(tidy_mean), gsub("^Frequency", "AVG-Frequency", names(tidy_mean)))


## write tidy_mean into txt-file
write.table(tidy_mean, file = "./tidy_mean.txt", row.name=FALSE)

