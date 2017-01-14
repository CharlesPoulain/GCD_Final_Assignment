main <- function(){
    data_path<-paste(getwd(),"UCI HAR Dataset", sep="/")
    if(!dir.exists(data_path)){
        loadData()
    }
    
}

loadData <-function(){
    url="https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
    temp<-tempfile()
    download.file(url,temp)
    unzip(temp)
    unlink(temp)
}