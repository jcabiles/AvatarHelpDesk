library(dplyr)
library(stringr) # contains str_extract() function


#### extract CLOSING info about tickets #### 

# specify every possible time format (single digit vs double digit month/date/hour)
time.formats <- c("[0-9]{2}/[0-9]{2}/[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2}",
                  "[0-9]{1}/[0-9]{2}/[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2}",
                  "[0-9]{2}/[0-9]{1}/[0-9]{4} [0-9]{1}:[0-9]{2}:[0-9]{2}",
                  "[0-9]{2}/[0-9]{1}/[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2}",
                  "[0-9]{2}/[0-9]{2}/[0-9]{4} [0-9]{1}:[0-9]{2}:[0-9]{2}",
                  "[0-9]{1}/[0-9]{1}/[0-9]{4} [0-9]{2}:[0-9]{2}:[0-9]{2}",
                  "[0-9]{1}/[0-9]{1}/[0-9]{4} [0-9]{1}:[0-9]{2}:[0-9]{2}",
                  "[0-9]{1}/[0-9]{2}/[0-9]{4} [0-9]{1}:[0-9]{2}:[0-9]{2}")


# store closing information into respective column
tickets <- tickets %>%
  
  # create column for person who closed ticket (i.e., posted PublicNote)
  mutate(TicketClosedBy = sub(".*Posted by: *(.*?) *@.*", "\\1", PublicNote),
         
         # change to lowercase to make string-matching easier
         TicketClosedBy = tolower(TicketClosedBy),
         
         # extract timestamp for tickets with varying digits at each position
         CloseDate = str_extract(PublicNote, time.formats[1]),
         CloseDate = ifelse(!is.na(CloseDate), CloseDate, str_extract(PublicNote, time.formats[2])),
         CloseDate = ifelse(!is.na(CloseDate), CloseDate, str_extract(PublicNote, time.formats[3])),
         CloseDate = ifelse(!is.na(CloseDate), CloseDate, str_extract(PublicNote, time.formats[4])),
         CloseDate = ifelse(!is.na(CloseDate), CloseDate, str_extract(PublicNote, time.formats[5])),
         CloseDate = ifelse(!is.na(CloseDate), CloseDate, str_extract(PublicNote, time.formats[6])),
         CloseDate = ifelse(!is.na(CloseDate), CloseDate, str_extract(PublicNote, time.formats[7])),
         
         # convert to time datatype
         CloseDate= mdy_hms(CloseDate),
         CloseDate = as.POSIXct(CloseDate, format="%m/%d/%Y %H:%M:%S"))




#### extract OPENING info about tickets #### 

library(lubridate)

# store opening information into respective column
tickets <- tickets %>%
  
  # create column for person who closed ticket (i.e., posted PublicNote)
  mutate(TicketOpenedBy = sub(".*Posted by: *(.*?) *@.*", "\\1", InternalNote),
         
         # change to lowercase to make string-matching easier
         TicketOpenedBy = tolower(TicketOpenedBy),
         
         # extract timestamp for tickets with varying digits at each position
         OpenDate = str_extract(PublicNote, time.formats[1]),
         OpenDate = ifelse(!is.na(CloseDate), CloseDate, str_extract(InternalNote, time.formats[2])),
         OpenDate = ifelse(!is.na(CloseDate), CloseDate, str_extract(InternalNote, time.formats[3])),
         OpenDate = ifelse(!is.na(CloseDate), CloseDate, str_extract(InternalNote, time.formats[4])),
         OpenDate = ifelse(!is.na(CloseDate), CloseDate, str_extract(InternalNote, time.formats[5])),
         OpenDate = ifelse(!is.na(CloseDate), CloseDate, str_extract(InternalNote, time.formats[6])),
         OpenDate = ifelse(!is.na(CloseDate), CloseDate, str_extract(InternalNote, time.formats[7])),
         
         # convert to time datatype
         OpenDate = as.POSIXct(CloseDate, format="%m/%d/%Y %H:%M:%S"),
         
         
         ### add month and day-of-week information
         
         # month of ticket close
         MonthofCloseDate = lubridate::month(CloseDate, label=TRUE),
         
         # day of week
         DayofCloseDate = lubridate::wday(CloseDate, label = TRUE))