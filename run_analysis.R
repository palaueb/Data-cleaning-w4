library(dplyr)

## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names.
## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

	# create our variable base folder that points to the datasets
	base_folder <- file.path(getwd(),'UCI_HAR_Dataset')

	# create the paths to the test and train data files
	test_data <- read.table(file.path(base_folder,'test','X_test.txt'))
	train_data <- read.table(file.path(base_folder,'train','X_train.txt'))

	# then the same with the activities for test and train
	activity_test_data <- read.table(file.path(base_folder,'test','y_test.txt'))
	activity_train_data <- read.table(file.path(base_folder,'train','y_train.txt'))
	
	# then the same with the subjects for test and train
	subject_test_data <- read.table(file.path(base_folder,'test','subject_test.txt'))
	subject_train_data <- read.table(file.path(base_folder,'train','subject_train.txt'))

	#last: the name of the variables
	activity_labels <- read.table(file.path(base_folder,"activity_labels.txt"))
	features <- read.table(file.path(base_folder,'features.txt'))
	
	## then merge the datasets and we got 2 new datasets (the one with the training data and the one with the activity results data)
	data <- bind_rows(test_data, train_data)
	activity_data <- bind_rows(activity_test_data, activity_train_data)
	subject_data <- bind_rows(subject_test_data, subject_train_data)

	# set the name of each column
	colnames(data) <- features[,2]
	# just take the data variables we want from data
	mean_std_data <- data[, grep("-mean\\(|-std\\(", names(data), value=T)]

	# set activity columns names to make it clear
	colnames(activity_labels) <- c("activity_id","activity_label")
	colnames(activity_data) <- c("activity_id")
	colnames(subject_data) <- c("subject")
	
	#join the names with the IDs of activity_data
	activity_data <- full_join(activity_data,activity_labels,by="activity_id")

	## Uses descriptive activity names to name the activities in the data set
	# we just bind the columns of our observations and our activities
	new_data <- cbind(mean_std_data, activity_data, subject_data)
	# then delete the activity_id that we don't need anymore
	new_data$activity_id <- NULL
	
	## mean the subjects and activity levels
	data_means <- new_data %>% group_by(subject, activity_label) %>% summarise_all(mean)

	# export the table for the evaluation process
	write.table(x = data_means, file = "data_means.txt",row.names = FALSE)
