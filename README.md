#README
Code consists of 5 parts:

1)Downloading and reading the data. Raw data is downloaded to the temporary file. That could be handy for you not to download it yourself and set working directory, but download and read it in R. If you do not have internet limitations of course :)
  Then data is being read from the temporary file. For both test and train datasets, files X_test.txt containing values, y_test.txt containing labels, subject_test.txt containing subject ids are being read to files test_values, test_labels, test_subject, train_values, train_labels, train_subject respectively are being created. Code uses readr package in order to fasten reading process.
 Then these files are bind to create dataframe called ‘data’ that contains both test and train data.
 
2) Adding features names. features.txt file being read to the features data frame. After that data names are set to be names from from features dataset and names for first two columns(‘Subject’,’Activity’). 

3) Decoding activity labels. File activity_labels.txt contains activity labels, so R code reads this file and then merges two dataframes: data and activity(dataframe that contains activity labels). When activity labels are decoded, temporary variable is being deleted from dataframe.

4) Removing features that are not mean or std. Firstly, code created a logical vector, that gives TRUE output when variable is mean or std. That is being made using stringr package. Then first and second values of this vector are assigned as TRUE as long as we need these variables, because they are ‘Subject’ and ‘Activity’. After that we leave only ‘Subject’, ‘Activity’ and mean/std features variables in the original dataframe (data). Also, angle variables are being removed. At this point we won’t rename variables, so all column names should be converted to lower case characters (tolower function)

5) Creating tidy data set with averages of all features for all subjects for all activities. That is being made using dplyr package by consequent functions group_by and summarize_each. 
Final dataframe ‘tidy_data’ is now ready.
