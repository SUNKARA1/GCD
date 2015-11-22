# You should create one R script called run_analysis.R that does the following. 
# 1.Merges the training and the test sets to create one data set.
# 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3.Uses descriptive activity names to name the activities in the data set
# 4.Appropriately labels the data set with descriptive variable names. 
# 5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# setwd(~/UCI HAR Dataset/) to the where data is present (../UCI HAR Dataset/)

#Loading Test data
test = read.csv("test/X_test.txt", sep = "", header = FALSE)
test[, ncol(test) + 1] = read.csv("test/y_test.txt", sep = "", header = FALSE)
test[, ncol(test) + 1] = read.csv("test/subject_test.txt", sep = "", header = FALSE)

#Loading Train data
train = read.csv("train/X_train.txt", sep = "", header = FALSE)
train[, ncol(train) + 1] = read.csv("train/y_train.txt", sep = "", header = FALSE)
train[, ncol(train) + 1] = read.csv("train/subject_train.txt", sep = "", header = FALSE)

#Merge Train and Test data
data = rbind(train, test)

#Loading Feature data
features = read.csv("features.txt", sep="", header=FALSE)
features[,2] = gsub('-mean', 'Mean', features[,2]) 
features[,2] = gsub('-std', 'Std', features[,2]) 
features[,2] = gsub('[-()]', '', features[,2]) 

#Loading Activitie data
activities = read.csv("activity_labels.txt", sep="", header=FALSE)

#Expiremental columns
KeepCol = grep(".*Mean.*|.*Std.*", features[,2])
features <- features[KeepCol,]

#Columns to Drop
KeepCol <- c(KeepCol, 562, 563)
data <- data[, KeepCol]
colnames(data) <- c(features$V2, "activity", "subject")
colnames(data) <- tolower(colnames(data))

# 
currentActivity <- 1
for(currentActivityLabel in activities$V2)
{
        data$activity <- gsub(currentActivity, currentActivityLabel, data$activity)
        currentActivity <- currentActivity + 1
}

data$activity <- as.factor(data$activity) 
data$subject <- as.factor(data$subject) 

# Apply mean
tidydata = aggregate(data, by=list(activity = data$activity, subject=data$subject), mean)

#pass null to unwanted
tidydata[,90] = NULL 
tidydata[,89] = NULL 

write.table(tidydata, "tidydataSet.txt", sep="\t") 

