##GCD_Final_Assignment

This is this final assignment for Getting and Cleaning Data course on Coursera.

* In order to use properly run_analysis.R, you would need to set yourself the directory with setdir().If you don't, it will take the environment of Rstudio you are currently working on.

* The data we are looking for is dispatched in two different files. The first one is **test** and the second is **train**. Both these files contains, **X file** (processed data from raw data, the rows are the observations = fixed-width sliding window of 2.56 sec, the column are the features.), **Y file** (processed data pointing out which activity the subject was doing during the observation), **subject file** (linking each observation to a subject by code 1:30) and a **"Inertial Signals" directory** (being the pre-processed raw data). We won't use Inertial Signals data since they aren't relevant for this Assignment and we will merge train files together, then test files, then the resulting test and train files together.

* How to use run_analysis ? Simply source and run_analysis(). You might want to affect run_analysis in a variable name since it returns a list containing the merged_data, the selected_data and the names of the columns of the selected_data.

##Analysis
* check if packages are installed and sourced

        packages<-c("data.table","dplyr")
            ipak(packages)

            ## set data path
            data_path<-paste(getwd(),"UCI HAR Dataset", sep="/")

* load data

        if(!dir.exists(data_path)){
                loadData()
        }

        loadData <-function(){
            url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
            temp<-tempfile()
            download.file(url,temp)
            unzip(temp)
            unlink(temp)
            ##the files are now available in the directory "UCI HAR Dataset"
        }

* merging test and train data

        ## getting train data
        train_path<-paste(data_path,"train",sep="/")

        subject_train<-read.table(paste(train_path,"subject_train.txt",sep="/"))
        activity_train<-read.table(paste(train_path,"y_train.txt",sep="/"))
        measures_train<-read.table(paste(train_path,"X_train.txt",sep="/"))
        train_data<-cbind(subject_train,activity_train,measures_train)

        ## getting test data
        test_path<-paste(data_path,"test",sep="/")

        subject_test<-read.table(paste(test_path,"subject_test.txt",sep="/"))
        activity_test<-read.table(paste(test_path,"y_test.txt",sep="/"))
        measures_test<-read.table(paste(test_path,"X_test.txt",sep="/"))
        test_data<-cbind(subject_test,activity_test,measures_test)

        ## merging both data set together
        merged_data<-rbind(train_data,test_data)

* Getting features.txt

        features_path<-paste(data_path,"features.txt",sep="/")
        features<-read.table(features_path)
        features[,2]<-as.character(features[,2]) ##to avoid further issues

* Label variables names of data

        features_names<-features[,2]
        colnames(merged_data)<- c("subject","activity",features_names)
        merged_data<-data.table(merged_data)

* Label activities thanks to the factor : levels-labels interaction
        
        merged_data$subject<-as.factor(merged_data$subject)

        labels_path<-paste(data_path,"activity_labels.txt",sep="/")
        activity_labels<-read.table(labels_path)
        activity_labels[,2]<-as.character(activity_labels[,2])
        merged_data$activity<-factor(merged_data$activity,levels=activity_labels[,1],labels=activity_labels[,2])
        setkey(merged_data,"subject","activity")

* Select mean and std features 
        
        selected_features<-features_names[grepl("*.mean.*|*.std.*",features_names)]
        col_to_select<-c("subject","activity",selected_features)
        selected_data<-subset(merged_data,select=col_to_select)

* write the tidy data set showing the mean of each variable per subject and activity
        
        selected_data_melted<-melt(selected_data,id=c("subject","activity"))
        selected_data_mean<-dcast(selected_data_melted,subject+activity~variable,mean)

        write.table(selected_data_mean,"tidy.txt",row.names = FALSE,quote = FALSE)


##Assignment Instructions
The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of yes/no questions related to the project. You will be required to submit: 1) a tidy data set as described below, 2) a link to a Github repository with your script for performing the analysis, and 3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the data called CodeBook.md. You should also include a README.md in the repo with your scripts. This repo explains how all of the scripts work and how they are connected.

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Here are the data for the project:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

You should create one R script called run_analysis.R that does the following.

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Good luck!