### Loading the required libraries
library(tidyverse)
library(lubridate)
library(tidyr)

#loading the datasets
cab<-read_csv("Cab_Data.csv")
city<-read_csv("City.csv")
customerID<-read_csv("Customer_ID.csv")
transactionID<-read_csv("Transaction_ID.csv")

######## Checking the structure of the data sets and data types

# 1. Cab Data
glimpse(cab)
#Changing Date of travel from character to date data type
cab$`Date of Travel`<-dmy(cab$`Date of Travel`)

#saving the new dataset
write_csv(cab, "cab.csv")

#Loading the saved dataset
cab_data<-read_csv("cab.csv")
head(cab_data)

# 2. City data
glimpse(city)
head(city)

# 3. Customer ID data
glimpse(customerID)
head(customerID)

# 4.Transactions data
glimpse(transactionID)
head(transactionID)

##### Combining data sets 
# Combining Transaction ID data with cab data set
cab_trans<-left_join(transactionID, cab_data, by="Transaction_ID")
#checking the structure of the new data set
glimpse(cab_trans)
#taking a look at the first few rows of the data
head(cab_trans)

#saving the new data set to the working directory
write_csv(cab_trans, "cab_trans.csv")

#Joining customer ID dataset with TransactionId and Cab data
master_data<-left_join(cab_trans, customerID, by="Customer_ID")
glimpse(master_data)

## Dropping the rows with missing values
master_clean<-master_data %>% drop_na()
glimpse(master_clean)
#Writing the final data set to be used in the analysis

write_csv(master_clean, "g2m.csv")

###### Exploratory Data Analysis
final_data<-read_csv("g2m.csv")
