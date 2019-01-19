library(ggplot2)


# bar graph tickets completed
ggplot(data = subset(tickets.iability,
                     !is.na(MonthofCloseDate)), aes(x=MonthofCloseDate)) +
  geom_bar(fill = "blue") + 
  ylab("Number of Tickets") + 
  xlab("Month") +
  ggtitle("Tickets Completed by i-Ability") +
  theme(plot.title = element_text(hjust=0.5, size=18))




# graph count i-A vs. DPH
ggplot(tickets, aes(x = factor(1), fill = factor(Organization))) +
  geom_bar() + 
  coord_polar(theta = "y") + 
  labs(fill = "Organization",
       y = "Proportion of iAbility tickets",
       x = "")




# graph of proportion of staff
ggplot(staff.org, aes(x = factor(1), fill=factor(Organization))) +
  geom_bar() + 
  theme(axis.text = element_blank(),
        panel.grid  = element_blank()) +
  coord_polar(theta = "y") + 
  labs(fill = "Organization",
       y = "Proportion of DPH Staff vs. iAbility Staff",
       x = "")
