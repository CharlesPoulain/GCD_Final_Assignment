run_analysis <- function(){
    packages<-c("data.table","dplyr")
    ipak(packages)
    
    ## set data path
    data_path<-paste(getwd(),"UCI HAR Dataset", sep="/")
    
    ## the following line will help to test other functions without having to load the data at every test
    if(!dir.exists(data_path)){
        loadData()
    }
    
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
    
    ## getting features data
    features_path<-paste(data_path,"features.txt",sep="/")
    features<-read.table(features_path)
    features[,2]<-as.character(features[,2]) ##to avoid further issues
    
    ## label variables of merged data
    features_names<-features[,2]
    colnames(merged_data)<- c("subject","activity",features_names)
    merged_data<-data.table(merged_data)
    
    ## turn activities $ subjects into factor : label activities
    merged_data$subject<-as.factor(merged_data$subject)
    
    labels_path<-paste(data_path,"activity_labels.txt",sep="/")
    activity_labels<-read.table(labels_path)
    activity_labels[,2]<-as.character(activity_labels[,2])
    merged_data$activity<-factor(merged_data$activity,levels=activity_labels[,1],labels=activity_labels[,2])
    setkey(merged_data,"subject","activity")
    
    ## select features with mean and std
    selected_features<-features_names[grepl("mean\\(\\)|std\\(\\)",features_names)]
    col_to_select<-c("subject","activity",selected_features)
    selected_data<-subset(merged_data,select=col_to_select)
    
    ## write tidy data set with mean for each features for each subject and activity
    selected_data_melted<-melt(selected_data,id=c("subject","activity"))
    selected_data_mean<-dcast(selected_data_melted,subject+activity~variable,mean)
    
    write.table(selected_data_mean,"tidy.txt",row.names = FALSE,quote = FALSE)
    return(list(merged_data,selected_data,col_to_select))
}

loadData <-function(){
    url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    temp<-tempfile()
    download.file(url,temp)
    unzip(temp)
    unlink(temp)
    ##the files are now available in the directory "UCI HAR Dataset"
}

## credit to stevenworthington for the ipak function
ipak <- function(pkg){
    # ipak function: install and load multiple R packages.
    # check to see if packages are installed. Install them if they are not, then load them into the R session.
    
    new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
    if (length(new.pkg)) 
        install.packages(new.pkg, dependencies = TRUE)
    sapply(pkg, require, character.only = TRUE)
}



