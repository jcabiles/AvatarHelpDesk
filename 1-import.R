library(readxl)   #easier way to import Excel spreadsheets
library(readr)    #easier way to import CSV files


# filepath for job titles
path_titles <- "/Users/John/dataprojects/AvatarHelpDesk/stafftitles.csv"

# filepath for tickets
path_tickets <- "/Users/John/dataprojects/AvatarHelpDesk/RAW DATA 2018.xlsx"



# import job title data into R
raw_titles <- read_csv(path_titles)



### import ticket data into R

library(data.table)   #use rbindlist function


# import all sheets within workbook
# set col_type to text to prevent conflict during rbindlist, which expects columns to have same datatype
all_sheets <- lapply(excel_sheets(path_tickets), read_excel, path = path_tickets, col_type = "text")


# add column to March data frame to ensure that all data frames have 29 columns
library(tibble)  #contains add_column() function
all_sheets[[3]] <- add_column(all_sheets[[3]], 'Asset Number' = NA, .after = 9)


# bind all data frames into one data frame
raw_tickets <- rbindlist(all_sheets)