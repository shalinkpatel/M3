library(randomForest)
library(ggplot2)
setwd("/Users/shalinpatel/Documents/Drive\ Sync/BCA/12th\ Grade/M3/Part2/")
load("FinalData/data.RData")

x <- complete.cases(Pred1DataFin) & complete.cases(Pred1DataBeg)
Pred1DataBeg <- Pred1DataBeg[x, ]
Pred1DataFin <- Pred1DataFin[x, ]
Pred1DataBeg <- Pred1DataBeg[c(-1, -8)]
Pred1DataFin <- Pred1DataFin[c(-1, -4)]

set.seed(100)
train <- sample(nrow(Pred1DataFin), 0.7*nrow(Pred1DataFin), replace = FALSE)
TrainSetBeg <- Pred1DataBeg[train,]
TrainSetFin <- Pred1DataFin[train,]
ValidSetBeg <- Pred1DataBeg[-train,]
ValidSetFin <- Pred1DataFin[-train,]

IncomeModel <- randomForest(TrainSetBeg, y = TrainSetFin$Income, xtest = ValidSetBeg, ytest = ValidSetFin$Income, importance = TRUE, ntree = 500, mtry = 3)
WorkModel <- randomForest(TrainSetBeg, y = TrainSetFin$Work, xtest = ValidSetBeg, ytest = ValidSetFin$Work, importance = TRUE, ntree = 500, mtry = 3)
GeographyModel <- randomForest(TrainSetBeg, y = TrainSetFin$Geography, xtest = ValidSetBeg, ytest = ValidSetFin$Geography, importance = TRUE, ntree = 500, mtry = 2)

Pred2Data <- Pred2Data[-7]
w <- is.na(Pred2Data$`Friend Not Smoke`) | Pred2Data$`Friend Not Smoke` == levels(Pred2Data$`Friend Not Smoke`)[2]
x <- is.na(Pred2Data$`Percocet/percodan/tylox`) | Pred2Data$`Percocet/percodan/tylox` == levels(Pred2Data$`Friend Not Smoke`)[2]
y <- is.na(Pred2Data$`Vicodin/Lortab/Lorcet`) | Pred2Data$`Vicodin/Lortab/Lorcet` == levels(Pred2Data$`Friend Not Smoke`)[2]
z <- is.na(Pred2Data$`Pain Reliever`) | Pred2Data$`Pain Reliever` == levels(Pred2Data$`Friend Not Smoke`)[2]
opiod <- !x | !y | !z | Pred2Data$`Heroin Ever` == levels(Pred2Data$`Heroin Ever`)[1]
for(a in 1:length(opiod)){
  if(opiod[a]){
    opiod[a] <- levels(Pred2Data$`Friend Not Smoke`)[1]
  }
  else{
    opiod[a] <- levels(Pred2Data$`Friend Not Smoke`)[2]
  }
}



Pred2Data$`Friend Not Smoke` <- as.factor(w)
Pred2Data$`Percocet/percodan/tylox` <- as.factor(x)
Pred2Data$`Vicodin/Lortab/Lorcet` <- as.factor(y)
Pred2Data$`Pain Reliever` <- as.factor(z)
opiod <- as.factor(opiod)
Pred2Data <- cbind(Pred2Data, opiod)
Pred2Data$opiod <- opiod
Pred2Data <- Pred2Data[complete.cases(Pred2Data), ]


train <- sample(nrow(Pred2Data), 0.7*nrow(Pred2Data), replace = FALSE)
TrainSet2 <- Pred2Data[train,]
ValidSet2 <- Pred2Data[-train,]

FinalModelAlc <- randomForest(TrainSet2[1:11], y = TrainSet2$`Alcohol Ever`, xtest = ValidSet2[1:11], ytest = ValidSet2$`Alcohol Ever`, importance = TRUE, ntree = 250, mtry = 3)
FinalModelCig <- randomForest(TrainSet2[1:11], y = TrainSet2$`Cigarette Ever`, xtest = ValidSet2[1:11], ytest = ValidSet2$`Cigarette Ever`, importance = TRUE, ntree = 250, mtry = 3)
FinalModelMar <- randomForest(TrainSet2[1:11], y = TrainSet2$`Marijuana Ever`, xtest = ValidSet2[1:11], ytest = ValidSet2$`Marijuana Ever`, importance = TRUE, ntree = 250, mtry = 3)
FinalModelOpi <- randomForest(TrainSet2[1:11], y = TrainSet2$opiod, xtest = ValidSet2[1:11], ytest = ValidSet2$opiod, importance = TRUE, ntree = 250, mtry = 3)
