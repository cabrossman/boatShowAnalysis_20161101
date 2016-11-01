library(dplyr); library(ggplot2); library(broom)
tidy(lmfit)

mydata <- read.csv('ctr_analysis.csv')

mydata <- mydata %>% filter(CTR < .1, imps > 1000, PORTAL != 'DONOTUSE')


f <- CTR*100 ~ days_run + PORTAL + DEVICE_TYPE + PLACEMENT_GROUP + highly_targeted

m1 <- tidy(lm(f, data = mydata))

f <- log(CTR + 0.00000000000000000000000001) ~ days_run + PORTAL + DEVICE_TYPE + PLACEMENT_GROUP + highly_targeted

m2 <- tidy(lm(f, data = mydata))


f <- CTR*100 ~ days_run + PORTAL + DEVICE_TYPE + SITE_CONTENT + highly_targeted

m1 <- tidy(lm(f, data = mydata))

f <- log(CTR + 0.00000000000000000000000001) ~ days_run + PORTAL + DEVICE_TYPE + SITE_CONTENT + highly_targeted

m2 <- tidy(lm(f, data = mydata))

mydata_2 <- mydata %>% filter(PLACEMENT_GROUP %in% c('X21','X22'))

f <- CTR*100 ~ days_run + PORTAL + SITE_CONTENT + highly_targeted + PLACEMENT_GROUP
summary(lm(f, data = mydata_2))