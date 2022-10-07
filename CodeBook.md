## CodeBook.md - variables, data and transformations 

This file contains the primary variables, description of the data, and any transformations or work that you performed to clean up the data in this project

The input files are described in the readme.txt file that was provided with this assignment.
The output files from this assignment are as follows:
 1-  finaltidydataset.csv - The tidy data frame that contains the mean of all the feature variables
  ( a total from columns 3 to 88) that contain average/mean or standard deviation
   in their names summarized against each subject and further by activity
 2-  CodeBook.md - which is this file that contains a list of all the outputs
  and primary constructs used to reach to the output
 3-  README.txt - describes all the files that were provided to complete
  this assignment. It also describes the data set and how it was collected
  4- REAME.md - which provides explanations on how all of the scripts
   work and how they are connected
   
   Note that tibbles are used across the program. Whenever data frame is
   mentioned it means a tibble
   
   > X_train_Sep & X_test_Sep - these data frames hold the tidy feature variables
   (561 variables) of the train and test data sets
   
   > featuresNames - chr vector that holds the names of all the feature variables
   
   Note that the names of the feature variables have been corrected 
   where appropriate - removed the duplicate names - as shown below.
   Appending -X, -Y and -Z to the corresponding variable.
   
   > output_var_list - is a chr vector that holds the name of all the feature 
   variables whose name satisfies the regex "[Mm]ean|std" (has mean in 
   the name or std for standard deviation)
   
   > dataset, dataset1, dataset2 - 1 and 2 are the datasets of train and
    test respectively. dataset is the merge of 1 and 2
    
    > datasettidy - starts as a copy of dataset selecting only the variables
    in output_var_list and then grouped by subject and activity 
    and summarized by mean of all the variables
   
   
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

