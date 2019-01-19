# load ticket data
tickets <- raw_tickets
# load job titles data
titles <- raw_titles


# make syntactically valid names out of character vectors
names(tickets) <- make.names(names(tickets), unique=TRUE)

# remove periods . in column names (easier for functions like sqldf to work with)
names(tickets) <- gsub("\\.", "", names(tickets))



# load dplyr to work with pipes
library(dplyr) 

# clean up data frame
tickets <- tickets %>%
  
  # delete row if reference number is NA
  filter(!is.na(ReferenceNumber),
         
         # remove rows whose ReferenceNumber is negative
         !(ReferenceNumber < 0),
         
         # delete row if values are column names
         !(ReferenceNumber=='Reference Number'),
         
         #remove duplicate tickets
         !duplicated(ReferenceNumber)) %>%
  
  
  # remove unnecessary columns
  select(ReferenceNumber,   # will keep this column to make joins easier later
         Problem,
         FirstSupport,
         SecondSupport,
         ThirdSupport,
         FourthSupport,
         InternalNote,
         PublicNote,
         ActiveSupport)


### consider changing all support names to lowercase


# easier to work with dates
 library(lubridate)


# change to date
titles <- titles %>%
  mutate(StartDate = mdy(StartDate),
         EndDate = mdy(EndDate),
         
         # convert to include timestamp
         StartDate = as.POSIXct(StartDate),
         EndDate = as.POSIXct(EndDate))

