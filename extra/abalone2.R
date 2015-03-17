abalone<- read.csv("abalone.csv")
table(abalone$Sex)

   F    I    M 
1307 1342 1528 
plot(Length ~ Sex, data=abalone)
