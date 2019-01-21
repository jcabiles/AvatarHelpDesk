library(ggplot2)
library(dplyr)
library(DescTools)  #contains %like%



## define function to look up trainee's tickets
person.tickets <- function(name){
  name <- deparse(substitute(name))  # converts name object into a string of the person's name
  
  # gather all records containing that person's name
  individual.tickets <- tickets %>%
    filter(FirstSupport %like% name |
             SecondSupport %like% name |
             ThirdSupport %like% name |
             FourthSupport %like% name,
           
           # remove duplicates
           !duplicated(ReferenceNumber))
  
  
  # individual ticket per month
  # bar graph tickets completed
  ggplot(data = subset(individual.tickets,
                       !is.na(MonthofCloseDate)), aes(x=MonthofCloseDate)) +
    geom_bar(fill = "blue") + 
    ylab("Number of Tickets") + 
    xlab("Month") +
    ggtitle("Number of Tickets Completed") +
    theme(plot.title = element_text(hjust=0.5, size=18))
}




