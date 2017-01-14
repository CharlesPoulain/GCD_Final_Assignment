main <- function(){
    # ipak function: install and load multiple R packages.
    # check to see if packages are installed. Install them if they are not, then load them into the R session.
    
    ## credit to stevenworthington for the ipak function
    ipak <- function(pkg){
        new.pkg <- pkg[!(pkg %in% installed.packages()[, "Package"])]
        if (length(new.pkg)) 
            install.packages(new.pkg, dependencies = TRUE)
        sapply(pkg, require, character.only = TRUE)
    }
    
    packages<-c("data.table")
    ipak(packages)
    
    ## set data path
    data_path<-paste(getwd(),"UCI HAR Dataset", sep="/")
    
    ## the following line will help to test other functions without having to load the data at every test
    if(!dir.exists(data_path)){
        loadData()
    }
    dt<-mergeData(data_path)
}

loadData <-function(){
    url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    temp<-tempfile()
    download.file(url,temp)
    unzip(temp)
    unlink(temp)
    ##the files are now available in the directory "UCI HAR Dataset"
}

mergeData <-function(dir_path){
    train_path<-paste(dir_path,"train",sep="/")
    
    subject_train<-read.table(paste(train_path,"subject_train.txt",sep="/"))
    activity_train<-read.table(paste(train_path,"y_train.txt",sep="/"))
    measures_train<-read.table(paste(train_path,"X_train.txt",sep="/"))
    train_data<-cbind(measures_train,subject_train,activity_train)
    
    test_path<-paste(dir_path,"test",sep="/")
    
    subject_test<-read.table(paste(test_path,"subject_test.txt",sep="/"))
    activity_test<-read.table(paste(test_path,"y_test.txt",sep="/"))
    measures_test<-read.table(paste(test_path,"X_test.txt",sep="/"))
    test_data<-cbind(measures_test,subject_test,activity_test)
    
    merged_data<-rbind(train_data,test_data)
    features_path<-paste(dir_path,"features.txt",sep="/")
    names(merged_data)<-c(as.character(read.table(features_path)[,2]),"subject","activity")
    return(merged_data)
}

extractFeat<-function(dir_path){
    
}

describeActivites<-function(dir_path){
    
}

labelDataSet<-function(dir_path){
    
}

writeData<-function(dir_path){
    
}

