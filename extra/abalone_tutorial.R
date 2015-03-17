Abalone Data Analysis
=========================

(c) 2013 Daniel J. Gerlanc  
Distributed under a Creative Commons 3.0 License

```{r}
library(ggplot2)
```

(c) 2013 Daniel J. Gerlanc  
Distributed under a Creative Commons 3.0 License

This document was generated programmatically using `R`, the `knitr` package,
and `RStudio`. The practice of combining code and prose in a document that can
be compiled is known as
[literate programming](http://en.wikipedia.org/wiki/Literate_programming).

### Loading the Data

First, we download the `abalone` dataset from University of California Irvine 
(UCI) machine learning repository.

```{r cache=TRUE}
# Metadata from http://archive.ics.uci.edu/ml/datasets/Abalone
# Sex / nominal / -- / M, F, and I (infant)
# Length / continuous / mm / Longest shell measurement
# Diameter / continuous / mm / perpendicular to length
# Height / continuous / mm / with meat in shell
# Whole weight / continuous / grams / whole abalone
# Shucked weight / continuous / grams / weight of meat
# Viscera weight / continuous / grams / gut weight (after bleeding)
# Shell weight / continuous / grams / after being dried
# Rings / integer / -- / +1.5 gives the age in years 

abalone.cols = c("sex", "length", "diameter", "height", "whole.wt",
                 "shucked.wt", "viscera.wt", "shell.wt", "rings")

url <- 'http://archive.ics.uci.edu/ml/machine-learning-databases/abalone/abalone.data'
abalone <- read.table(url, sep=",", row.names=NULL, col.names=abalone.cols,
                      nrows=4177)
```

Using the `str` function we can examine the ``structure'' of the dataset.

```{r}
str(abalone)
```

The dataset contains `r ncol(abalone)` variables and `r nrow(abalone)` 
observations.  Most of the variables are numeric. The only exception is the 
`sex` variable. The `rings` variable is slightly different from the other numeric
variables because it assumes discrete, integer values. Keep in mind that an integer
response variable is often indicative of count data. Modeling count data often 
requires the use of more complicated techniques than OLS regression, 
specifically, a Poisson model. If you are unsure about whether the data you are
modeling is count data, check with your local statistician!

In our model we are going to treat the number of rings as a continuous response
variable. We are going to do this because rings takes on a large number of values
over a fairly wide range: (`r min(abalone$rings)` - `r max(abalone$rings)`).
In addition, there are no values of 0 rings in the dataset. An abalone with 0
rings could not exist! Problems involving count data often have many observations
with counts of 0.

```{r echo=FALSE}
qplot(abalone$rings, binwidth=1)
```

I often find creating lists containing all the predictors and all the 
continuous predictors to be useful for model fitting and data visualization. 
Certain data visualizations only work with continuous or categorical variables. 
For example, you can only create a histogram with continuous data.

```{r}
predictors  <- c("sex", "volume", "whole.wt", "shucked.wt", "viscera.wt",
                 "shell.wt")
continuous.pred <- c("volume", "whole.wt", "shucked.wt", "viscera.wt",
                     "shell.wt")
outcome <- "rings"
```

Let's use the excellent `ggplot2` package to examine the relationship between 
some of the predictor variables and the outcome variable. 
We're going to use the `qplot` (quickplot) function to do this.

```{r}
qplot(shell.wt, rings, data=abalone)
```

It looks like there is a monotonic, somewhat non-linear relationship between
the number of rings and shell weight. One benefit of the `ggplot2` package is
that we can easily fit and plot an OLS regression line.

```{r}
qplot(shell.wt, rings, data=abalone, geom=c("point", "smooth"), method="lm")
```

Another variable we might want to incorporate into the visualization is the sex
of the abalone.

```{r}
qplot(shell.wt, rings, data=abalone, geom=c("point", "smooth"), method="lm",
      color=sex, se=F) 

```

A separate regression has been run for each sex. The relationship between
sex and shell weight appears similar for males and females but steeper for
infants. The overplotting makes the points hard to see so we're going to add
random jitter to get a better look at the distribution of data points

```{r}
ggplot(abalone, aes(shell.wt, rings, color=sex)) + 
  geom_jitter(alpha=0.5) + 
  geom_smooth(method=lm, se=FALSE) 
```

Alternatively, we could plot each sex separately.

```{r fig.width=9}
ggplot(abalone, aes(shell.wt, rings)) + 
  geom_jitter(alpha=0.25) + 
  geom_smooth(method=lm, se=FALSE) +
  facet_grid(. ~ sex)
```
