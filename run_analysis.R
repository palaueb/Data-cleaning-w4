## 1. Merges the training and the test sets to create one data set.

## Load both datasets
	# create our variable base folder that points to the datasets
	base_folder <- file.path(getwd(),'UCI_HAR_Dataset')

	# create the paths to the test and train data files
	test_file <- file.path(base_folder,'test','X_test.txt')
	train_file <- file.path(base_folder,'train','X_train.txt')

	# read the data into R
	test_data <- read.table(test_file)
	train_data <- read.table(train_file)

	# then the same with the activities for test and train
	activity_test_file <- file.path(base_folder,'test','y_test.txt')
	activity_train_file <- file.path(base_folder,'train','y_train.txt')

	# and loads the data of the activities
	activity_test_data <- read.table(activity_test_file)
	activity_train_data <- read.table(activity_train_file)

	## then merge the datasets and we got 2 new datasets (the one with the training data and the one with the activity results data)
	data <- bind_rows(test_data, train_data)
	activity_data <- bind_rows(activity_test_data, activity_train_data)

## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
	
	# just take the data variables we want from data
	mean_std_data <- data[,1:6]

## 3. Uses descriptive activity names to name the activities in the data set

	# start reading the activities and storing into a variable
	activity_labels = read.table(file.path(base_folder,"activity_labels.txt"))
	# set it names to make it clear
	colnames(activity_labels) <- c("activity_id","activity_label")	
	
	## Uses descriptive activity names to name the activities in the data set
	# we just bind the columns of our observations and our activities
	new_data <- cbind(mean_std_data,activity_data)
	#set the label of the new column to activity_id
	names(new_data)[7] <- "activity_id" 
	# join the labels into our datatable to give the descriptive activity names
	new_data <- full_join(new_data,activity_labels,by="activity_id")
	# then delete the activity_id that we don't need anymore
	new_data$activity_id <- NULL
	
## 4. Appropriately labels the data set with descriptive variable names.
	
	## Create the labels for ALL the columns
	nomCols <- c("tBodyAcc_mean_X","tBodyAcc_mean_Y","tBodyAcc_mean_Z","tBodyAcc_std_X","tBodyAcc_std_Y","tBodyAcc_std_Z","activity_label")
	colnames(new_data) <- nomCols


## 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

	# I found two ways to do this
	data_means <- aggregate(new_data[,1:6],list(Activity=new_data$activity_label),mean)
	# data_means <- new_data %>% group_by(activity_label) %>% summarise_all(funs(mean))
 	
	# export the table for the evaluation process
	write.table(x = data_means, file = "data_means.txt",row.names = FALSE)
