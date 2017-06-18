#1.Merges the training and the test sets to create one data set.
test_set<- read.table('X_test.txt')
setwd('C:/Users/ylin/Desktop/Personal/data/Coursera/HAR Dataset/UCI HAR Dataset/train')
train_set <- read.table('X_train.txt')
combined_set<-rbind(test_set,train_set)
combined_set[1:4,1:5]

#2.Extracts only the measurements on the mean and standard deviation for each measurement.
setwd('C:/Users/ylin/Desktop/Personal/data/Coursera/HAR Dataset/UCI HAR Dataset')
feature_names1<- read.table('features.txt')
feature_names<-feature_names1[,2]
colnames(combined_set) <- feature_names
selected_measures <- grepl('-(mean|std)\\(',feature_names)
selected_set<- subset(combined_set,select=selected_measures)
selected_set[1:4,1:5]

#3.Uses descriptive activity names to name the activities in the data set
activities_train<- read.table('train/y_train.txt')
activities_test<- read.table('test/y_test.txt')
combined_activities1<- rbind(activities_train, activities_test)
combined_activities<- combined_activities1[,1]
label<- read.table('activity_labels.txt')
total_combined_activities<- merge(label,combined_activities1, by.x='V1',by.y = 'V1')
data_set<- cbind(total_combined_activities,selected_set)


#4.Appropriately labels the data set with descriptive variable names.
colnames(data_set) <- gsub("^f", "Frequency", colnames(data_set))
colnames(data_set) <- gsub('^t','Time',colnames(data_set))
colnames(data_set) <- gsub('BodyBody','Body',colnames(data_set))
colnames(data_set) <- gsub('\\(\\)','',colnames(data_set))
colnames(data_set) <- gsub('mean','Mean',colnames(data_set))
colnames(data_set) <- gsub('std','Std',colnames(data_set))
colnames(data_set) <- gsub('V2','Activity',colnames(data_set))
colnames(data_set) <- gsub('-','',colnames(data_set))
colnames(data_set) <- gsub("MeanOf", "", colnames(data_set))
data_set[1:4,1:5]


#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.setwd('C:/Users/ylin/Desktop/Personal/data/Coursera/HAR Dataset/UCI HAR Dataset/test')
subjects_train <- read.table("train/subject_train.txt")
subjects_test <- read.table('test/subject_test.txt')
subjects <- rbind(subjects_train,subjects_test)[,1]
data_set <- cbind(Subject = subjects,data_set)

library('dplyr')
mean_data <- data_set %>%
  group_by(Subject,Activity) %>%
  summarise_each(funs(mean))

write.table(mean_data,row.names=TRUE, file = 'tidy_data.txt')


tidy_data<- read.table('tidy_data.txt')  
