library(readxl)   #easier way to import Excel spreadsheets
library(readr)    #easier way to import CSV files


# filepath for job titles
path_titles <- "stafftitles.csv"

# filepath for tickets
path_tickets <- "RAW DATA 2018.xlsx"



# import job title data into R
raw_titles <- read_csv(path_titles)



### import ticket data into R

library(data.table)   #use rbindlist function


# import all sheets within workbook
# set col_type to text to prevent conflict during rbindlist, which expects columns to have same datatype
all_sheets <- lapply(excel_sheets(path_tickets), read_excel, path = path_tickets, col_type = "text")



# bind all data frames into one data frame
raw_tickets <- rbindlist(all_sheets)