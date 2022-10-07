## start by ingesting the train and test datasets with their related datasets
## into tibbles
rm(list =ls())
library(tidyverse)
setwd("/home/kal/RProgramming/cleanData/motionAnalytics")
trainPath <- file.path(getwd(),"train")
testPath <- file.path(getwd(),"test")

# table of activity labels with their description
activity_labels <- as_tibble(read.csv(file.path(getwd(),"activity_labels.txt"), header = FALSE))
# split data in activity labels into two columns: activity_id and activity
activity_labels <- activity_labels %>% separate(col = V1, into = c("activity_id", "activity"), sep = " ")
# change activity data type to factor and activity_id to integer
activity_labels$activity <- as.factor(activity_labels$activity)
activity_labels$activity_id <- as.integer(activity_labels$activity_id)
# read the features files and separate the data into two columns to get the names vector
features <- as_tibble(read.csv(file.path(getwd(),"features.txt"), header = FALSE, sep = "\n"))
features <- separate(features,col = "V1", into = c("f_id","name"), sep = " ")
featuresNames <- features$name
##### -----------------------------------------------------------------------
# fixing duplicate feature names
#fBodyAcc
fba_x <- featuresNames[303:316]
fba_y <- featuresNames[317:330]
fba_z <- featuresNames[331:344]
# fBobyAccJerk
fbj_x <-  featuresNames[382:395]
fbj_y <- featuresNames[396:409]
fbj_z <- featuresNames[410:423]
# fBobyGyro
fbg_x <- featuresNames[461:474]
fbg_y <- featuresNames[475:488]
fbg_z <- featuresNames[489:502]

# fixing the X axis set, Note that there are 14 measurement for each axis 
# and there are 3 sets of measurements = 126 measurement variables need to be fixed
featuresNames[303:316] <- paste0(fba_x,"-X")
featuresNames[382:395]<- paste0(fbj_x,"-X")
featuresNames[461:474] <- paste0(fbg_x,"-X")

featuresNames[317:330] <- paste0(fba_y,"-Y")
featuresNames[396:409]<- paste0(fbj_y,"-Y")
featuresNames[475:488] <- paste0(fbg_y,"-Y")

featuresNames[331:344] <- paste0(fba_z,"-Z")
featuresNames[410:423]<- paste0(fbj_z,"-Z")
featuresNames[489:502] <- paste0(fbg_z,"-Z")
## test for no duplicates
# table(duplicated(featuresNames))
## ---------------------------------------------------------------------------
# read train data into tibbles
##----------------------------------------------------------------------------
subject_train <- as_tibble(read.csv(file.path(trainPath,"subject_train.txt"), header = FALSE))
X_train <-       as_tibble(read.csv(file.path(trainPath,"X_train.txt"), header = FALSE))
y_train <-       as_tibble(read.csv(file.path(trainPath,"y_train.txt"), header = FALSE))
# rename columns
subject_train <- rename(subject_train, subject = "V1")
y_train       <- rename(y_train, activity_id = "V1")
# separate the train data into 561 features and assign col names to train data set
#testing with one record
X_train <- as_tibble(X_train)

X_train_Sep <- separate(X_train,col = "V1", into = featuresNames, sep = "[^ ] +" )
X_train_Sep <- as_tibble(sapply(X_train_Sep, as.numeric))

## ---------------------------------------------------------------------------
# read test data into tibbles
##----------------------------------------------------------------------------

subject_test <- as_tibble(read.csv(file.path(testPath,"subject_test.txt"), header = FALSE))
X_test <-       as_tibble(read.csv(file.path(testPath,"X_test.txt"), header = FALSE))
y_test <-      as_tibble(read.csv(file.path(testPath,"y_test.txt"), header = FALSE))
# rename columns
subject_test <- rename(subject_test, subject = "V1")
y_test       <- rename(y_test, activity_id = "V1")
# separate the test data into 561 features and assign col names to test data set
#testing with one record
X_test <- as_tibble(X_test)
X_test_Sep <- separate(X_test,col = "V1", into = featuresNames, sep = "[^ ] +" )
X_test_Sep <- as_tibble(sapply(X_test_Sep, as.numeric))

## ----------------------------------------------------------------
##
## Now join the subject and activity id and the train data set
# and apply the same from test and then add the two datasets into one
dataset1 <- as_tibble(cbind(subject_train, y_train, X_train_Sep))
dataset2 <- as_tibble(cbind(subject_test, y_test, X_test_Sep))

dataset <- rbind(dataset1, dataset2)
#then add the activity description using the activity_labels table
dataset <- as_tibble(merge(activity_labels,dataset))


## now identify the vectors that are either mean or std ( 
#"mean()"
#"std()"
#"meanFreq()"
#gravityMean
#tBodyAccMean
#tBodyAccJerkMean
#tBodyGyroMean
#tBodyGyroJerkMean

variablesvec <- colnames(dataset)
rexp_output <- "[Mm]ean|std"
output_var_list <- variablesvec[grep(rexp_output,variablesvec)]
dataset <- dataset %>% select(subject, activity,all_of(output_var_list), -activity_id)


datasettidy <- dataset
datasettidy <- datasettidy %>% group_by(subject, activity) %>% summarize_all(., mean)
write.csv(datasettidy, "finaltidydataset.csv", col.names = TRUE)
