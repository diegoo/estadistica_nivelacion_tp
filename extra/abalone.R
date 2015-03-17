abalone <- read.csv("/var/folders/79/gjpjbsmj1d5c7b4j98_nf11w0000gn/T//RtmpVUP2MU/data13e521ff8d16f", 
                    header=F)
names(abalone) <- c("Sex","Length","Diameter","Height","Whole weight",
                    "Shucked weight","Viscera weight","Shell weight",
                    "Rings")
write.csv(abalone, "abalone.csv", row.names=FALSE)
abalone <- read.csv("abalone.csv")
table(abalone$Sex)
plot(Length ~ Sex, data=abalone)

