## -----------------------------------------------------------------------------
birthday <- function(k) {
    logdenom <- k * log(365) + lfactorial(365 - k) # log denominator
    lognumer <- lfactorial(365) # log numerator
    ## P(at least two have the same bday) = 1 - P(nobody has the same bday)
    pr <- 1 - exp(lognumer - logdenom) # transform back
    return(pr)
}

k <- 1:50
bday <- birthday(k)  # call the function
names(bday) <- k  # add labels
plot(k, bday, xlab = "Number of people", xlim = c(0, 50), ylim = c(0, 1),
     ylab = "Probability that at least two\n people have the same birthday")
abline(h = 0.5) # horizontal 0.5 line
bday[20:25]


## -----------------------------------------------------------------------------
k <- 23 # number of people
sims <- 1000 # number of simulations
event <- 0 # counter

for (i in 1:sims) {
    days <- sample(1:365, k, replace = TRUE)
    days.unique <- unique(days) # unique birthdays
    ## if there are duplicates, the number of unique birthdays
    ## will be less than the number of birthdays, which is `k'
    if (length(days.unique) < k) {
        event <- event + 1
    }
}

## fraction of trials where at least two bdays are the same
answer <- event / sims
answer


## -----------------------------------------------------------------------------
choose(84, 6)


## -----------------------------------------------------------------------------
FLVoters <- read.csv("FLVoters.csv")
dim(FLVoters) # before removal of missing data

FLVoters <- na.omit(FLVoters)
dim(FLVoters) # after removal

margin.race <- prop.table(table(FLVoters$race))
margin.race

margin.gender <- prop.table(table(FLVoters$gender))
margin.gender

prop.table(table(FLVoters$race[FLVoters$gender == "f"]))

joint.p <- prop.table(table(race = FLVoters$race, gender = FLVoters$gender))
joint.p

rowSums(joint.p)
colSums(joint.p)

FLVoters$age.group <- NA # initialize a variable
FLVoters$age.group[FLVoters$age <= 20] <- 1
FLVoters$age.group[FLVoters$age > 20 & FLVoters$age <= 40] <- 2
FLVoters$age.group[FLVoters$age > 40 & FLVoters$age <= 60] <- 3
FLVoters$age.group[FLVoters$age > 60] <- 4

joint3 <-
    prop.table(table(race = FLVoters$race, age.group = FLVoters$age.group,
                     gender = FLVoters$gender))
joint3

## marginal probabilities for age groups
margin.age <- prop.table(table(FLVoters$age.group))
margin.age

## P(black and female | above 60)
joint3["black", 4, "f"] / margin.age[4]

## two-way joint probability table for age group and gender
joint2 <- prop.table(table(age.group = FLVoters$age.group,
                           gender = FLVoters$gender))
joint2
joint2[4, "f"] # P(above 60 and female)

## P(black | female and above 60)
joint3["black", 4, "f"] / joint2[4, "f"]


## -----------------------------------------------------------------------------
plot(c(margin.race * margin.gender["f"]), # product of marginal probs.
     c(joint.p[, "f"]), # joint probabilities
     xlim = c(0, 0.4), ylim = c(0, 0.4),
     xlab = "P(race) * P(female)", ylab = "P(race and female)")
abline(0, 1) # 45 degree line

## joint independence
plot(c(joint3[, 4, "f"]), # joint probability
     margin.race * margin.age[4] * margin.gender["f"], # product of marginals
     xlim = c(0, 0.3), ylim = c(0, 0.3), main = "Joint independence",
     xlab = "P(race and above 60 and female)",
     ylab = "P(race) * P(above 60) * P(female)")
abline(0, 1)

## conditional independence given female
plot(c(joint3[, 4, "f"]) / margin.gender["f"], # joint prob. given female
     ## product of marginals
     (joint.p[, "f"] / margin.gender["f"]) *
         (joint2[4, "f"] / margin.gender["f"]),
     xlim = c(0, 0.3), ylim = c(0, 0.3), main = "Marginal independence",
     xlab = "P(race and above 60 | female)",
     ylab = "P(race | female) * P(above 60 | female)")
abline(0, 1)

sims <- 1000
doors <- c("goat", "goat", "car")
result.switch <- result.noswitch <- rep(NA, sims)

for (i in 1:sims) {
    ## randomly choose the initial door
    first <- sample(1:3, size = 1)
    result.noswitch[i] <- doors[first]
    remain <- doors[-first] # remaining two doors
    ## Monty chooses one door with a goat
    if (doors[first] == "car") # two goats left
        monty <- sample(1:2, size=1)
    else # one goat and one car left
        monty <- (1:2)[remain == "goat"]
    result.switch[i] <- remain[-monty]
}

mean(result.noswitch == "car")
mean(result.switch == "car")


## -----------------------------------------------------------------------------
cnames <- read.csv("names.csv")
dim(cnames)

x <- c("blue", "red", "yellow")
y <- c("orange", "blue")

## match x with y
match(x, y) # `blue' appears in the 2nd element of y

## match y with x
match(y, x) # `blue' appears in the 1st element of x

FLVoters <- FLVoters[!is.na(match(FLVoters$surname, cnames$surname)), ]
dim(FLVoters)

whites <- subset(FLVoters, subset = (race == "white"))
w.indx <- match(whites$surname, cnames$surname)
head(w.indx)

## relevant variables
vars <- c("pctwhite", "pctblack", "pctapi", "pcthispanic", "pctothers")
mean(apply(cnames[w.indx, vars], 1, max) == cnames$pctwhite[w.indx])

## blacks
blacks <- subset(FLVoters, subset = (race == "black"))
b.indx <- match(blacks$surname, cnames$surname)

mean(apply(cnames[b.indx, vars], 1, max) == cnames$pctblack[b.indx])

## Hispanics
hispanics <- subset(FLVoters, subset = (race == "hispanic"))
h.indx <- match(hispanics$surname, cnames$surname)

mean(apply(cnames[h.indx, vars], 1, max) == cnames$pcthispanic[h.indx])

## Asians
asians <- subset(FLVoters, subset = (race == "asian"))
a.indx <- match(asians$surname, cnames$surname)

mean(apply(cnames[a.indx, vars], 1, max) == cnames$pctapi[a.indx])

indx <- match(FLVoters$surname, cnames$surname)

## whites false discovery rate
1 - mean(FLVoters$race[apply(cnames[indx, vars], 1, max) ==
                           cnames$pctwhite[indx]] == "white")

## black false discovery rate
1 - mean(FLVoters$race[apply(cnames[indx, vars], 1, max) ==
                           cnames$pctblack[indx]] == "black")

## Hispanic false discovery rate
1 - mean(FLVoters$race[apply(cnames[indx, vars], 1, max) ==
                           cnames$pcthispanic[indx]] == "hispanic")

## Asian false discovery rate
1 - mean(FLVoters$race[apply(cnames[indx, vars], 1, max) ==
                           cnames$pctapi[indx]] == "asian")

FLCensus <- read.csv("FLCensusVTD.csv")

## compute proportions by applying weighted.mean() to each column
race.prop <-
    apply(FLCensus[, c("white", "black", "api", "hispanic", "others")],
          2, weighted.mean, w = FLCensus$total.pop)

race.prop # race proportions in Florida

total.count <- sum(cnames$count)

## P(surname | race) = P(race | surname) * P(surname) / P(race)
cnames$name.white <- (cnames$pctwhite / 100) *
    (cnames$count / total.count) / race.prop["white"]

cnames$name.black <- (cnames$pctblack / 100) *
    (cnames$count / total.count) / race.prop["black"]

cnames$name.hispanic <- (cnames$pcthispanic / 100) *
    (cnames$count / total.count) / race.prop["hispanic"]

cnames$name.asian <- (cnames$pctapi / 100) *
    (cnames$count / total.count) / race.prop["api"]

cnames$name.others <- (cnames$pctothers / 100) *
    (cnames$count / total.count) / race.prop["others"]

FLVoters <- merge(x = FLVoters, y = FLCensus, by = c("county", "VTD"),
                  all = FALSE)

## P(surname | residence) = sum_race P(surname | race) P(race | residence)
indx <- match(FLVoters$surname, cnames$surname)

FLVoters$name.residence <- cnames$name.white[indx] * FLVoters$white +
    cnames$name.black[indx] * FLVoters$black +
    cnames$name.hispanic[indx] * FLVoters$hispanic +
    cnames$name.asian[indx] * FLVoters$api +
    cnames$name.others[indx] * FLVoters$others

## P(race | surname, residence) = P(surname | race) * P(race | residence)
##                                / P(surname | residence)
FLVoters$pre.white <- cnames$name.white[indx] * FLVoters$white /
    FLVoters$name.residence

FLVoters$pre.black <- cnames$name.black[indx] * FLVoters$black /
    FLVoters$name.residence

FLVoters$pre.hispanic <- cnames$name.hispanic[indx] * FLVoters$hispanic /
    FLVoters$name.residence

FLVoters$pre.asian <- cnames$name.asian[indx] * FLVoters$api /
    FLVoters$name.residence

FLVoters$pre.others <- 1 - FLVoters$pre.white - FLVoters$pre.black -
    FLVoters$pre.hispanic - FLVoters$pre.asian

## relevant variables
vars1 <- c("pre.white", "pre.black", "pre.hispanic", "pre.asian",
           "pre.others")
## whites
whites <- subset(FLVoters, subset = (race == "white"))
mean(apply(whites[, vars1], 1, max) == whites$pre.white)

## blacks
blacks <- subset(FLVoters, subset = (race == "black"))
mean(apply(blacks[, vars1], 1, max) == blacks$pre.black)

## Hispanics
hispanics <- subset(FLVoters, subset = (race == "hispanic"))
mean(apply(hispanics[, vars1], 1, max) == hispanics$pre.hispanic)

## Asians
asians <- subset(FLVoters, subset = (race == "asian"))
mean(apply(asians[, vars1], 1, max) == asians$pre.asian)

## proportion of blacks among those with surname "White"
cnames$pctblack[cnames$surname == "WHITE"]

## predicted probability of being black given residence location
summary(FLVoters$pre.black[FLVoters$surname == "WHITE"])

## whites
1 - mean(FLVoters$race[apply(FLVoters[, vars1], 1, max) ==
                           FLVoters$pre.white] == "white")

## blacks
1 - mean(FLVoters$race[apply(FLVoters[, vars1], 1, max) ==
                           FLVoters$pre.black] == "black")

## Hispanics
1 - mean(FLVoters$race[apply(FLVoters[, vars1], 1, max) ==
                           FLVoters$pre.hispanic] == "hispanic")

## Asians
1 - mean(FLVoters$race[apply(FLVoters[, vars1], 1, max) ==
                           FLVoters$pre.asian] == "asian")


## -----------------------------------------------------------------------------
## uniform PDF: x = 0.5, interval = [0, 1]
dunif(0.5, min = 0, max = 1)

## uniform CDF: x = 1, interval = [-2, 2]
punif(1, min = -2, max = 2)

sims <- 1000
p <- 0.5 # success probabilities
x <- runif(sims, min = 0, max = 1) # uniform [0, 1]
head(x)

y <- as.integer(x <= p) # Bernoulli; turn TRUE/FALSE to 1/0
head(y)
mean(y) # close to success probability p, proportion of 1's vs. 0's


## -----------------------------------------------------------------------------
## PMF when x = 2, n = 3, p = 0.5
dbinom(2, size = 3, prob = 0.5)

## CDF when x = 1, n = 3, p = 0.5
pbinom(1, size = 3, prob = 0.5)

## number of voters who turn out
voters <- c(1000, 10000, 100000)
dbinom(voters / 2, size = voters, prob = 0.5)


## -----------------------------------------------------------------------------
## plus minus one standard deviation from the mean
pnorm(1) - pnorm(-1)

## plus minus two standard deviations from the mean
pnorm(2) - pnorm(-2)

mu <- 5
sigma <- 2

## plus minus one standard deviation from the mean
pnorm(mu + sigma, mean = 5, sd = 2) - pnorm(mu - sigma, mean = 5, sd = 2)

## plus minus two standard deviations from the mean
pnorm(mu + 2*sigma, mean = 5, sd = 2) - pnorm(mu - 2*sigma, mean = 5, sd = 2)


## ---- eval = FALSE------------------------------------------------------------
## ## see the page reference above
## ## `Obama2012.z' is Obama's 2012 standardized vote share
## ## `Obama2008.z' is Obama's 2008 standardized vote share
## fit1
## 
## e <- resid(fit1)
## 
## ## z-score of residuals
## e.zscore <- scale(e)
## 
## ## alternatively we can divide residuals by their standard deviation
## e.zscore <- e / sd(e)
## 
## hist(e.zscore, freq = FALSE, ylim = c(0, 0.4),
##      xlab = "Standardized residuals",
##      main = "Distribution of standardized residuals")
## 
## x <- seq(from = -3, to = 3, by = 0.01)
## lines(x, dnorm(x)) # overlay the Normal density
## qqnorm(e.zscore, xlim = c(-3, 3), ylim = c(-3, 3)) # quantile-quantile plot
## 
## abline(0, 1) # 45 degree line
## 
## e.sd <- sd(e)
## e.sd
## 
## CA.2008 <- pres$Obama2008.z[pres$state == "CA"]
## CA.2008
## 
## CA.mean2012 <- coef(fit1) * CA.2008
## CA.mean2012
## 
## ## area to the right; greater than CA.2008
## pnorm(CA.2008, mean = CA.mean2012, sd = e.sd, lower.tail = FALSE)
## 
## TX.2008 <- pres$Obama2008.z[pres$state == "TX"]
## TX.mean2012 <- coef(fit1) * TX.2008
## TX.mean2012
## 
## pnorm(TX.2008, mean = TX.mean2012, sd = e.sd, lower.tail = FALSE)


## -----------------------------------------------------------------------------
## theoretical variance: p was set to 0.5 earlier
p * (1-p)

## sample variance using `y' generated earlier
var(y)


## -----------------------------------------------------------------------------
pres08 <- read.csv("pres08.csv")

## two-party vote share
pres08$p <- pres08$Obama / (pres08$Obama + pres08$McCain)

n.states <- nrow(pres08) # number of states
n <- 1000 # number of respondents
sims <- 10000 # number of simulations

## Obama's electoral votes
Obama.ev <- rep(NA, sims)

for (i in 1:sims) {
    ## samples number of votes for Obama in each state
    draws <- rbinom(n.states, size = n, prob = pres08$p)
    ## sums state's electoral college votes if Obama wins the majority
    Obama.ev[i] <- sum(pres08$EV[draws > n / 2])
}

hist(Obama.ev, freq = FALSE, main = "Prediction of election outcome",
     xlab = "Obama's electoral college votes")
abline(v = 364, col = "red") # actual result

summary(Obama.ev)
mean(Obama.ev)

## probability of binomial random variable taking greater than n/2 votes
sum(pres08$EV * pbinom(n / 2, size = n, prob = pres08$p, lower.tail = FALSE))

## approximate variance using Monte Carlo draws
var(Obama.ev)

## theoretical variance
pres08$pb <- pbinom(n / 2, size = n, prob = pres08$p, lower.tail = FALSE)
V <- sum(pres08$pb * (1 - pres08$pb) * pres08$EV^2)
V

## approximate standard deviation using Monte Carlo draws
sd(Obama.ev)

## theoretical standard deviation
sqrt(V)


## -----------------------------------------------------------------------------
sims <- 1000

## 3 separate simulations for each
x.binom <- rbinom(sims, p = 0.2, size = 10)

## computing sample mean with varying sample size
mean.binom <- cumsum(x.binom) / 1:sims

## default runif() is uniform(0, 1)
x.unif <- runif(sims)
mean.unif <- cumsum(x.unif) / 1:sims

## plot for binomial
plot(1:sims, mean.binom, type = "l", ylim = c(1, 3),
     xlab = "Sample size", ylab = "Sample mean", main = "Binomial(10, 0.2)")
abline(h = 2, lty = "dashed") # expectation

## plot for uniform
plot(1:sims, mean.unif, type = "l", ylim = c(0, 1),
     xlab = "Sample size", ylab = "Sample mean", main = "Uniform(0, 1)")
abline(h = 0.5, lty = "dashed") # expectation


## -----------------------------------------------------------------------------
## sims = number of simulations
n.samp <- 1000
z.binom <- z.unif <- rep(NA, sims)

for (i in 1:sims) {
    x <- rbinom(n.samp, p = 0.2, size = 10)
    z.binom[i] <- (mean(x) - 2) / sqrt(1.6 / n.samp)
    x <- runif(n.samp, min = 0, max = 1)
    z.unif[i] <- (mean(x) - 0.5) / sqrt(1 / (12 * n.samp))
}

## histograms; nclass specifies the number of bins
hist(z.binom, freq = FALSE, nclass = 40, xlim = c(-4, 4), ylim = c(0, 0.6),
     xlab = "z-score", main = "Binomial(0.2, 10)")

x <- seq(from = -3, to = 3, by = 0.01)
lines(x, dnorm(x)) # overlay the standard Normal PDF
hist(z.unif, freq = FALSE, nclass = 40, xlim = c(-4, 4), ylim = c(0, 0.6),
     xlab = "z-score", main = "Uniform(0, 1)")
lines(x, dnorm(x))

