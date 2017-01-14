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
    
}

extractFeat<-function(dir_path){
    
}

describeActivites<-function(dir_path){
    
}

labelDataSet<-function(dir_path){
    
}

writeData<-function(dir_path){
    
}
