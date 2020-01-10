library(ggplot2)
library(stringr)
library(forcats)
setwd("/Users/shalinpatel/Documents/Drive\ Sync/BCA/12th\ Grade/M3/Part2/")
load("/Users/shalinpatel/Documents/Drive\ Sync/BCA/12th\ Grade/M3/Part2/ICPSR_36361/DS0001/36361-0001-Data.rda")
load("/Users/shalinpatel/Documents/Drive\ Sync/BCA/12th\ Grade/M3/Part2/ICPSR_21600/DS0001/21600-0001-Data.rda")
load("/Users/shalinpatel/Documents/Drive\ Sync/BCA/12th\ Grade/M3/Part2/ICPSR_21600/DS0022/21600-0022-Data.rda")
Pred1DataBeg <- da21600.0001
Pred1DataFin <- da21600.0022

factorlist <- c("IRFAMIN3", "NEWRACE2", "IRSEX", "SNRLGIMP", "AGE2", "WRKBZCA2", "YUTPFMLY", "IMOTHER", "IFATHER", "NRCH17_2", "CIGFNSMK", "COUTYP2", "ALCEVER", "CIGEVER", "MJEVER", "HEREVER", "PERCTYLX", "VICOLOR", "ANLCARD")
colnames1 <- c("Income", "Race", "Gender", "Religious Beliefs", "Age", "Work", "Family Problems", "Mother", "Father", "Num Children", "Friend Not Smoke", "Geography", "Alcohol Ever", "Cigarette Ever", "Marijuana Ever", "Heroin Ever", "Percocet/percodan/tylox", "Vicodin/Lortab/Lorcet", "Pain Reliever")
Pred2Data <- da36361.0001[factorlist]

factorlist <- c("AID", "PA55", "H1GI6A", "H1GI6B", "H1GI6C", "H1GI6D", "H1GI6E", "H1GI1Y", "H1EE3", "H1RM1", "H1RF1", "H1IR12")
colnames2 <- c("ID", "Income", "White", "Black/AA", "American Indian", "Asian", "Other", "Birth date", "Work", "Mother", "Father", "Geography", "Gender")
Pred1DataBeg <- da21600.0001[factorlist]                    

factorlist <- c("AID", "H4EC1", "BIO_SEX4", "H4OD1Y", "H4LM1", "H4WP13", "H4WP27", "H4EO6")
colnames3 <- c("ID", "Income", "Gender", "Birth date", "Work", "Mother", "Father", "Geography", "White", "Black/AA", "American Indian", "Asian", "Other")
Pred1DataFin <- da21600.0022[factorlist]

Pred1DataBeg <- Pred1DataBeg[match(Pred1DataFin$AID, Pred1DataBeg$AID),]
Pred1DataBeg <- cbind(Pred1DataBeg, BIO_SEX4 = Pred1DataFin$BIO_SEX4)
Pred1DataFin <- cbind(Pred1DataFin, Pred1DataBeg[,3:7])

colnames(Pred1DataBeg) <- colnames2
colnames(Pred1DataFin) <- colnames3

x <- cut(Pred1DataBeg$Income, breaks = c(0, 4.9, 9.9, 14.9, 19.9, 24.9, 29.9, 39.9, 49.9, 74.9, 99.9, 149.9, Inf), labels = levels(Pred1DataFin$Income))
Pred1DataBeg$Income <- x

x <- as.character(Pred1DataBeg$`Birth date`)
x <- str_sub(x, -4,-1)
Pred1DataBeg$`Birth date`<-Pred1DataFin

x <- is.na(Pred1DataBeg$Mother)
x[x] <- 1
Pred1DataBeg$Mother <- x
Pred1DataFin$Mother <- x

x <- is.na(Pred1DataBeg$Father)
x[x] <- 1
Pred1DataBeg$Father <- x
Pred1DataFin$Father <- x

levels(Pred1DataFin$Geography) <- c(levels(Pred1DataBeg$Geography)[1], levels(Pred1DataBeg$Geography))
colnames(Pred2Data) <- colnames1

save(Pred1DataBeg, Pred1DataFin, Pred2Data, file = "/Users/shalinpatel/Documents/Drive\ Sync/BCA/12th\ Grade/M3/Part2/FinalData/data.RData")
