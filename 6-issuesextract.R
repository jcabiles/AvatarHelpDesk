library(dplyr)

tickets.iability$TicketCode <- gsub("[\\(\\)]", "",
                                    regmatches(tickets.iability$Problem,
                                               gregexpr("\\(.*?\\)", tickets.iability$Problem)))


library(stringr) # contains str_replace

# create columns containing ticket codes
tickets.iability <- tickets.iability %>%
  
  #remove 'c' that precedes multi-problem tickets
  mutate(TicketCode = str_replace(TicketCode, "c", " ")) %>%
  
  # remove parentheses around ticket codes
  mutate(TicketCode = str_replace_all(TicketCode, "[[:punct:]]", ""))




library(tidyr) # contains separate() and separate_rows()

# create data frame with different record for each ticket code
ticket.support <- tickets.iability %>%
  
  # remove PublicNote column
  select(-PublicNote) %>%
  
  # change codes to lowercase to make string-matching easier
  mutate(TicketCode = tolower(TicketCode)) %>%
  
  # give each TicketCode its own record
  separate_rows(TicketCode ,sep="\\s+")


# change blanks to NA
ticket.support$TicketCode[ticket.support$TicketCode == ""] <- NA


# remove records with no ticket code
ticket.support <- ticket.support %>%
  filter(!is.na(TicketCode))


# remove ticket codes that are not pre-defined
ticket.support <- ticket.support %>% 
  filter(TicketCode %in% c("a", "ac", "wb", "acrf", "ad", "ap",
                            "as", "b", "d", "dupli", "dx", "e",
                            "it", "o", "p", "pn", "r", "rf",
                            "s", "t", "tp", "tx", "wb", "v"))

# change "acrf" to "a"
ticket.support$TicketCode[which(ticket.support$TicketCode=="acrf")] <- "a"



# create function to get ticket codes
get.ticketcodes <- function(df,...){
  df %>%
    
    # list columns to break up into
    group_by(...) %>%
    
    # count instances
    summarize(TotalCount = n())
}


## get totals of all ticket codes
codes.totals <- get.ticketcodes(ticket.support, TicketCode)


# create function to display results in Zoriana's format
format.zoriana <- function(df,...){
  df %>%
    
    # convert df from long form to wide (each job title is a column)
    # enter key then value
    spread(...) %>%
    
    # organize columns
    select(TicketCode,
           staff,
           frontline,
           advanced,
           'avatar analyst',
           'avatar accounts team',
           'field services',
           'dph IT')
}




# consider writing the code below more elegantly...
# ideally, we can iterate over a vector containing "Title_FirstSupport" etc.)
# each.title <- c("Title_FirstSupport", "Title_SecondSupport", "Title_ThirdSupport", "Title_TicketClosedBy", "Title_TicketOpenedBy")
# codes.support <- lapply(ticket.support, )

## get totals of ticket codes by title of FIRST support
codes.firstsupport <- get.ticketcodes(ticket.support, Title_FirstSupport, TicketCode) %>%
  format.zoriana(Title_FirstSupport, TotalCount)
  

## get totals of ticket codes by title of SECOND support
codes.secondsupport <- get.ticketcodes(ticket.support, Title_SecondSupport, TicketCode) %>%
  format.zoriana(Title_SecondSupport, TotalCount)


## get totals of ticket codes by title of THIRD support
codes.thirdsupport <- get.ticketcodes(ticket.support, Title_ThirdSupport, TicketCode) %>%
  format.zoriana(Title_ThirdSupport, TotalCount)