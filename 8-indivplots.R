library(ggplot2)
library(dplyr)

ia.name <- "Kennedy"

individual.tickets <- tickets %>%
  filter(FirstSupport %like% ia.name |
         SecondSupport %like%ia.name |
           ThirdSupport %like% ia.name |
           FourthSupport %like% ia.name,
         
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