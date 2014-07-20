##ReadMe
 
	Student: Ahmed Mustakim      
	Course: Getting and Cleaning Data               
	Date: July 19, 2014  
###Associatied Files:
         
**Main Program:** *run_analysis.R*  
**Code Book:** *CodeBook.md*    
**Main Output:** *TidyData.txt*  
**Secondary Output:** *MeanAndStdDevData.txt*
>**Purpose**:  The script,  merges the training & test data sets from the [Human Activity Recognition Using Smartphones Dataset](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones) and produces 2 resulting data sets (or files):  
>> 1) The *FIRST* data set is a an extraction of the mean & standard deviation related columns with additional descriptive activity and variable labels. It contains 66 columns (variables) and it's saved into the **"MeanAndStdDevData.txt"** file.
>
>> 2) The *SECOND* data set is an independent tidy data set with the average of each variable, for each activity, and for each subject. It's saved into the **"TidyData.txt"** file (i.e. the ***main purpose of this program***) and it's variables (or column names) are described in details in ***"CodeBook.md"***    

>>>**Assumptions**: The program will be run on a Windows 7 machine 
>             which has WinRAR installed and R Studio will have the following
>             packages installed:    

>>>- data.table
- reshape2
- plyr
 

