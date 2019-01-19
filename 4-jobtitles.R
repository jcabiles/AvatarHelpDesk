# load package - allows joins to list job titles of each support member on tickets
library(sqldf)

# write functions to allow retrieval of titles based on date ranges
# arg1 = n
getTitle <- function(title_column, name_column){
  paste0("SELECT tickets.ReferenceNumber, titles.Title AS Title_",
         title_column,
         " FROM tickets LEFT JOIN titles ON tickets.",
         title_column,
         " = titles.",
         name_column,
         " AND tickets.CloseDate BETWEEN titles.StartDate AND titles.EndDate")
}


# generate SQL statement for each column that needs job title
col.titles <- c("FirstSupport", "SecondSupport", "ThirdSupport")
col.openclose <- c("TicketClosedBy", "TicketOpenedBy")


# SQL statement for support levels (first, second, third)
sql.statements <- getTitle(col.titles, "Name")

# add titles for staff who opened/closed ticket
sql.statements <- c(sql.statements,
                    getTitle(col.openclose, "FullName"))


# apply sqldf() over each statement and store in list
store <- lapply(sql.statements, sqldf)


library(dplyr)

# join all columns
ticket.titles <- left_join(store[[1]], store[[2]], by="ReferenceNumber") %>%
  left_join(store[[3]], by="ReferenceNumber") %>%
  left_join(store[[4]], by="ReferenceNumber") %>%
  left_join(store[[5]], by="ReferenceNumber") 


# add columns to tickets
tickets <- left_join(tickets, ticket.titles, by="ReferenceNumber")




# create vector of i-Ability staff titles
ia.vector <- unique(titles$Title)
ia.vector <- ia.vector[1:4]


# add organization
tickets <- tickets %>%  
  
  # add organization
  mutate(Organization = case_when(Title_FirstSupport %in% ia.vector ~ 'iAbility',
                                  Title_SecondSupport %in% ia.vector ~ 'iAbility',
                                  Title_ThirdSupport %in% ia.vector ~ 'iAbility',
                                  Title_TicketClosedBy %in% ia.vector ~ 'iAbility',
                                  Title_TicketOpenedBy %in% ia.vector ~ 'iAbility',
                                  TRUE ~ 'DPH'))

