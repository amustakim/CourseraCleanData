##Student: Ahmed Mustakim 
##Course: getdata-004
##Date: July 19, 2014
##Program: run_analysis.R
##Purpose: Produce 2 data sets using the 
##        Human Activity Recognition Using Smartphones Data Set:
##      1) FIRST set merges training & test data sets which
##         extracts mean & std dev, adds descriptive activity
##         tags & variable names
##      2) SECOND set is an independent tidy data set with
##         average of each variable, for each activity,
##         for each subject 
## Assumptions: Code will be run on a Windows 7 machine 
##             which has WinRAR installed and R Studio will have the following
##             packages installed:
##             - data.table
##             -reshape2
##             -plyr

## For more information please refer to the README.md and CodeBook.md files

run_analysis<- function() {
    #main working directory
    main <- "C:/Users/AhmedToshiba/Documents/GitHub/CourseraCleanData"
    setwd(main)

    #download data set
    fileurl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    file <- "getdata-projectfiles-UCI HAR Dataset.zip"
    #if the file already exists, overwrite it (i.e. remove previous version)
    if (file.exists(main)){
        file.remove(file)
        file.remove("UCI HAR Dataset")
    }    # if still prompted by windows, click "Yes" to overwrite files
    download.file(fileurl, file)
    
    #unzip file using windows winrar command
    WINRARexe <- file.path("C:", "Program Files (x86)", "WinRAR", "WinRAR.exe")
    command <- paste(paste0("\"", WINRARexe, "\""), 
                 "x", 
                 paste0("\"", file.path(main, file), "\"")
                 )
    system(command)
    
    #capture the unzipped files in a list variable
    UnzippedFiles <- file.path(main, "UCI HAR Dataset")
    
    #to display those files, the list.files comamnd I ran:
    #list.files(UnzippedFiles, recursive = TRUE)
    
    
    # Get all non-Inertial training data into data frames:
    ######################################################
    subjTrain <- read.table(file.path(UnzippedFiles, "train", "subject_train.txt")
                                      ,comment.char = ""
                                      ,colClasses="numeric")
    XtrainFile <- read.table(file.path(UnzippedFiles, "train", "X_train.txt")
                             ,comment.char = ""
                             ,colClasses="numeric")
    YtrainFile <- read.table(file.path(UnzippedFiles, "train", "y_train.txt")
                             ,comment.char = ""
                             ,colClasses="numeric")
    
    # Get all non-Inertial test data into data frames:
    ######################################################
    subjTest <- read.table(file.path(UnzippedFiles, "test", "subject_test.txt")
                                      ,comment.char = ""
                                      ,colClasses="numeric")
    XtestFile <- read.table(file.path(UnzippedFiles, "test", "X_test.txt") 
                             ,comment.char = ""
                             ,colClasses="numeric")
    YtestFile <- read.table(file.path(UnzippedFiles, "test", "y_test.txt")
                             ,comment.char = ""
                             ,colClasses="numeric")
    
    
    #Merge individual training and test data sets 
    #(Training on top of Test data)
    #####################################################
    SubjectData <- rbind(subjTrain, subjTest)
    MainData <- rbind(XtrainFile, XtestFile)
    ActivityData <- rbind(YtrainFile, YtestFile)
    
    #Set partial data Labels (part of Assignment 3 and 4)
    ######################################################
    names(SubjectData) <- c("SubjectID")
    names(ActivityData) <- c("ActivityID")

    #Now merge into 1 data set
    TempData <- cbind(SubjectData, ActivityData)
    MergedData <- cbind(TempData, MainData)
    #Assignement 1 Complete
    ####################################################
    
    
    #Extracts only the measurements on the 
    #mean and standard deviation for each measurement. 
    ####################################################
    #first convert to data table for what I am about to do next
    library(data.table)
    MergedData <- data.table(MergedData)
    # set 2 main keys, distinctive from the main data set
    setkey(MergedData,SubjectID, ActivityID) 
    
    #Capture names of the main data from features.txt
    ColLabels <- read.table(file.path(UnzippedFiles, "features.txt"), header=F)
    #Get the mean and std dev col names from the features list
    MeanStd <- ColLabels[grep("mean\\(\\)|std\\(\\)",ColLabels[,2]),]
    #Capture the V1, V2, V3 column names based on this smaller subset
    MeanStd$ColCode <- paste0("V",MeanStd[,1])
    #create column index names based on this look up
    MeanStdColIdx <- c(key(MergedData),MeanStd$ColCode)
    #then subset into those columns
    MeanStdData <- MergedData[, MeanStdColIdx , with=FALSE]
    #Assignement 2 Complete
    ####################################################
    
        
    #Use descriptive activity labels
    ####################################################
    #set all the 6 activities) labels
    ActivityLabels <- c("Walking", 
                        "Walking Upstairs", 
                        "Walking Downstairs",
                        "Sitting", 
                        "Standing", 
                        "Laying") 
    #convert the data type in Activity data frame to a factor
    MergedData$ActivityID <- as.factor(ActivityData$ActivityID )
    MeanStdData$ActivityID <- as.factor(ActivityData$ActivityID )
    levels(MergedData$ActivityID) <- ActivityLabels
    levels(MeanStdData$ActivityID) <- ActivityLabels
    #Assignement 3 Complete
    ####################################################
        
    #set main column labels:
    setnames(MergedData, 3:ncol(MergedData), as.vector(ColLabels [,2]) )
    setnames(MeanStdData, 3:ncol(MeanStdData), as.vector(MeanStd[,2]) )
    write.table(MeanStdData, file="MeanAndStdDevData.txt",sep="\t",col.names=TRUE, row.names=FALSE, quote=FALSE)
    #Assignement 4 Complete >>> names cross-referrenced with CodeBook
    ####################################################
    
    #Create a second, independent tidy data set 
    #with the average of each variable for each activity and each subject. 
    ####################################################
    #In order to do this, it will be efficient if we melted the data set
    #so that each variable for each activity and each subject 
    #lined up vertically
    library(reshape2)
    TempData <- melt(MergedData,c( "SubjectID" , "ActivityID"),variable.name="VariableName")
    #then take the mean 
    library(plyr)
    CleanData <- ddply(TempData, 
                       .(SubjectID, ActivityID, VariableName), 
                       colwise(mean) )
    setnames(CleanData,4,"Mean")
    write.table(CleanData, file="TidyData.txt", ,sep="\t",col.names=TRUE, row.names=FALSE, quote=FALSE)
    #Assignement 5 Complete >>> names cross-referrenced with CodeBook
    ####################################################
}