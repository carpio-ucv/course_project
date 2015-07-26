# course_project
Cleaning and getting data project

The run_analysis.R takes information from 7 diferent .txt files, and produced a single tidy data set which is saved in a local directory. The files required in the local directory in order to run the code are:

- 'features_info.txt': Shows information about the variables used on the feature vector
- 'features.txt': List of all features
- 'activity_labels.txt': Links the class labels with their activity name.
- 'train/X_train.txt': Training set
- 'train/y_train.txt': Training labels
- 'test/X_test.txt': Test set
- 'test/y_test.txt': Test labels.

The following packages need to be installed and the libraries called before running the file:

- library("data.table")
- library("dplyr")
- library("reshape2")
