library(dplyr)

# create dataframe of only iability staff
tickets.iability <- tickets %>%
  filter(Organization == 'iAbility')



titles.ia <- titles %>%
  filter(Organization == 'iability')


staff.org <- as.data.frame(unique(tickets$FirstSupport)) %>%
  rename(Name = 1) %>%
  mutate(Organization = ifelse(Name %in% titles.ia$Name,
                               "iAbility",
                               "DPH"))