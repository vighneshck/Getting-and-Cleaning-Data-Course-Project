library(reshape2)

#Download and unzip the dataset
download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", destfile = "ucidataset.zip", method = "curl")
unzip("ucidataset.zip")

#Load the activity labels and features datasets
activitylabels <- read.table("UCI HAR Dataset/activity_labels.txt")
activitylabels[,2] <- as.character(activitylabels[,2]) #convert V2 to character 
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2]) #convert V2 to character

#Extracts only the measurements on the mean and standard deviation for each measurement.
featureswanted <- grep(".*mean.*|.*std.*", features[,2])
featureswanted.names <- features[featureswanted,2]
featureswanted.names = gsub('-mean', 'Mean', featureswanted.names)
featureswanted.names = gsub('-std', 'Std', featureswanted.names)
featureswanted.names <- gsub('[-()]', '', featureswanted.names)

#Load the test and train datasets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featureswanted]
trainactivities <- read.table("UCI HAR Dataset/train/Y_train.txt")
trainsubjects <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(trainsubjects, trainactivities, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featureswanted]
testactivities <- read.table("UCI HAR Dataset/test/Y_test.txt")
testsubjects <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(testsubjects, testactivities, test)

Data <- rbind(train, test)
colnames(Data) <- c("subject", "activity", featureswanted.names)

#Convert the data to factors
Data$activity <- factor(Data$activity, levels = activitylabels[,1], labels = activitylabels[,2])
Data$subject <- as.factor(Data$subject)

#Melt and Dcast the data
Datamelted <- melt(Data, id = c("subject", "activity"))
Datamean <- dcast(Datamelted, subject + activity ~ variable, mean)

#Obtain the tidy file in .txt form
write.table(Datamean, "tidy.txt", row.names = FALSE, quote = FALSE)




