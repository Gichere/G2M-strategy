### Loading the required libraries
library(tidyverse)
library(lubridate)
library(tidyr)
library(dlookr)
library(stringr)
library(ggpubr)
library(knitr)
library(pastecs)
library(reshape2)
library(ggcorrplot)

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

#Adding a calculated column for profit margin
master_clean$Profit_margin<-(master_clean$`Price Charged` - master_clean$`Cost of Trip`)
glimpse(master_clean)
#Writing the final data set to be used in the analysis

write_csv(master_clean, "g2m.csv")

###### Exploratory Data Analysis
final_data<-read_csv("g2m.csv")
head(final_data)

summary(final_data)
glimpse(final_data)

###Defining Gender and Company as factors
final_data$Company<-as.factor(final_data$Company)
final_data$Gender<-as.factor(final_data$Gender)
final_data$Payment_Mode<-as.factor(final_data$Payment_Mode)
### Creating age groups
final_data$Age_Group<-cut(final_data$Age, c(17,25,32,39,46,53,60,65),
                          labels = c("18-25",
                                     "26-32",
                                     "33-39",
                                     "40-46",
                                     "47-53", 
                                     "54-60",
                                     "61+"))

## Checking if the grouping has been done correctly
table_1<-table(final_data$Age, final_data$Age_Group)
view(table_1)

################# Plots ######################
## Distributions

# Kilometer traveled 
ggplot(final_data, mapping = aes(x=`KM Travelled`))+
  geom_histogram(mapping = aes(color=Company), bins = 30)
## Plotting Price charged per company
ggplot(data = final_data, mapping = aes(y=`Price Charged`, x=Company))+
  geom_boxplot(mapping = aes(color=Company))+
  theme_pubclean()+
  ggtitle("Plot of Price Charged per Company")+
  theme(legend.position = "none")

## Plot of cost of trip per company
ggplot(data = final_data, mapping = aes(y=`Cost of Trip`, x=Company))+
  geom_boxplot(mapping = aes(color=Company))+
  theme_pubclean()+
  ggtitle("Plot of Cost of Trip per Company")+
  theme(legend.position = "none")

## Plot of Profit margin per company
ggplot(data = final_data, mapping = aes(y=Profit_margin, x=Company))+
  geom_boxplot(mapping = aes(color=Company))+
  theme_pubclean()+
  ggtitle("Plot of Profit per Company")+
  theme(legend.position = "none")

ggplot(data = final_data, mapping = aes(y=Profit_margin, x=Gender))+
  geom_boxplot()+
  theme_pubclean()+
  ggtitle("Plot of Profit per Company")+
  theme(legend.position = "none")
