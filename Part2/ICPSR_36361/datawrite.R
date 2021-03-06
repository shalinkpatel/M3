library(ggplot2)
setwd("/Users/shalinpatel/Documents/Drive\ Sync/BCA/12th\ Grade/M3/Part2/ICPSR_36361/")
load("DS0001/36361-0001-Data.rda")
write.table(da36361.0001, "data.tsv", quote = FALSE, sep = '\t')
x <- as.numeric(da36361.0001$RKFQDBLT)
y <- as.numeric(da36361.0001$ALCTRY)
ggplot(data = da36361.0001, mapping = aes(x = RKFQDBLT, y = ALCTRY)) + geom_violin(fill = "violet", alpha = 0.5) + geom_boxplot(fill = "green", alpha = 0.7, width = 0.1)
