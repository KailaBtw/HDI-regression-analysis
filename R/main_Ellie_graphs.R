#Stat 325 Final Project
#Ellie Lagrave

#library(dplyr)
#library(tidyverse)

#Import our CSV data into R studio

# Set working directory to the project root (repository root), then run.

dataFrame = read.csv("data/combdata.csv")


#Test our data was imported correctly
#head(dataFrame)
#head(hdi_data)

#Our data contains multiple columns of NA, or junk data, remove them
#(probably headers from excel format conversion)
dataFrame = subset(dataFrame, select = 
                     -c(X.1, X.3, X.5, X.7, X.9, X.11, X.13, X.15, X.17,
                        X.18, X.20, X.22, X.24, X.26, X.28, X.30, X.31, X.32))

#Data frame columns look clean, now clean the rows
#We want to remove na rows, ".." rows and "" rows
dataFrame <- dataFrame[!apply(is.na(dataFrame) 
                              | dataFrame$X == ".." 
                              | dataFrame$X == ""
                              | dataFrame$X.4 == "NA"
                              , 1, all),]

#Our rown names are now non sequential from our removal
rownames(dataFrame) <- 1:nrow(dataFrame)

#The end of the data has 15 rows of global/regional data
#subset them just incase we need later (then remove)
comb_global_data <- dataFrame[174:188, ]

#fix global data index
rownames(comb_global_data) <- 1:nrow(comb_global_data)

# Now we want to subset our rows remove global data (footer data)
dataFrame <- head(dataFrame, -15)

#Now we need to remove empty/unneeded header rows
dataFrame = dataFrame[-c(1:3),]

#Our rown names are now non sequential from our removal (again)
rownames(dataFrame) <- 1:nrow(dataFrame)

#Our data frame column names are generic, lets rename columns 
newGiiColumnNames <- c(
  "hdiRank", 
  "country", 
  "giiValue",
  "giiRank",
  "maternalMortality",
  "adolBirthRate",
  "fSeatsParlament",
  "fSecondaryEdu",
  "mSecondaryEdu",
  "fLaborForce",
  "mLaborForce",
  "hdiValue",
  "lifeExpec",
  "expecYearsSchool",
  "meanYearsSchool",
  "gniCapita",
  "gniMinusHdiRank"
)

for (i in 1:17) {
  names(dataFrame)[i] <- newGiiColumnNames[i]
}

# Data was visually inspected by scrolling through, both are clean
#   colnames(dataFrame)
# Now, looking at our data it is stored as characters, convert to numeric values
dataFrame[, c(1,3:15,17)] <- sapply(dataFrame[, c(1,3:15,17)], as.numeric)
# Data type check looks good
str(dataFrame)

# Lets reverse the value of gii ratio (closer to 0 is better)
#   to match HDI value (closer to 1 is better)
# I.e. (1 - gii value) = giiValueReversed
dataFrame$giiValue <- 1 - dataFrame$giiValue

# We will be comparing several predictors to hdiValues:

#Now lets test correlation between several variables and result (hdi) 
paste("correlation (adolBirthRate and MaternalMortality): ", 
      cor(dataFrame$adolBirthRate,dataFrame$maternalMortality))
paste("correlation (fParlament and adolBirthrate): ", 
      cor(dataFrame$fSeatsParlament,dataFrame$adolBirthRate))
paste("correlation (fParlament and fEdu): ", 
      cor(dataFrame$fSeatsParlament,dataFrame$fSecondaryEdu))
paste("correlation (fParlament and fLabor): ", 
      cor(dataFrame$fSeatsParlament,dataFrame$fLaborForce))

#this has been shown before, more edu less births when young
paste("correlation (fEdu and adolBirthRate): ", #some corr 
      cor(dataFrame$fSecondaryEdu,dataFrame$adolBirthRate))
paste("correlation (fEdu and fLabor): ", 
      cor(dataFrame$fSecondaryEdu,dataFrame$fLaborForce))

# Adol birth rate and maternal mortality correlation coefficient is 0.75
# Therefore we will only use one of those predictors
# predictors are: adolBirthrate, fSeatParlament, fSecondaryEdu, fLaborForce

giiHdiCor <- cor(dataFrame$giiValue,dataFrame$hdiValue);
paste("correlation (hdi and gii): ", giiHdiCor)

fLaborCor <- cor(dataFrame$hdiValue,dataFrame$fLaborForce)
paste("correlation (hdi and fLabor): ", fLaborCor)
fSeatCor <- cor(dataFrame$hdiValue,dataFrame$fSeatsParlament)
paste("correlation (hdi and fParlament): ", fSeatCor)
fSecCor <- cor(dataFrame$hdiValue,dataFrame$fSecondaryEdu)
paste("correlation (hdi and fEdu): ",fSecCor)
adolCor <- cor(dataFrame$hdiValue,dataFrame$adolBirthRate)
paste("correlation (hdi and adol): ",adolCor)
fsecAdolCor <- cor(dataFrame$fSecondaryEdu,dataFrame$adolBirthRate)
paste("correlation (fSec and adolBirthRate): ", fsecAdolCor)
maternalCor <- cor(dataFrame$hdiValue,dataFrame$maternalMortality)
paste("correlation (hdi and maternal mortality): ", maternalCor)

#largest correlation between hdi and predictors we see is fEdu and adolBirthrate
library(ggplot2)


#as suggested from our CC calculations, on a scatter plot there is very little 
#relationship between hdi and fSeatsParlament or fLaborForce
ggplot(dataFrame, aes(x=fSeatsParlament, y=hdiValue)) +
  geom_point(aes(color=hdiValue)) +
  labs(x = "female % share of parlament",
       y = "HDI values (Higher is better)") +
  theme(plot.title = element_text(
    hjust = 0.5, face="bold", 
    color="black", 
    size=14),
    axis.title.x = element_text(
      size=12, 
      face="bold"),
    axis.title.y = element_text(
      size=12, 
      face="bold"),
    axis.text.x = element_text(
      face="bold", 
      color="black", 
      size=14),
    axis.text.y = element_text(
      face="bold", 
      color= "black", 
      size=14),
    axis.line = element_line(
      colour = "darkblue", 
      size = 1, 
      linetype = "solid"), 
    legend.position="none"
  ) +
  scale_y_continuous(limits=c(0.4, 1)) +
  ggtitle("Connecting parlamentary gender equality and Quality of Life",
          subtitle = paste("R-Squared: ", fSeatCor**2)) +     
  scale_color_gradient(low = "#710193", high = "#cb21ff") +
geom_smooth(method = "lm", 
            formula = y ~ x, 
            color = "darkblue", 
            size=0.8) 



ggplot(dataFrame, aes(x=fLaborForce, y=hdiValue)) +
  geom_point(aes(color=hdiValue)) +
  labs(x = "female % share of labor force",
       y = "HDI values (Higher is better)") +
  theme(plot.title = element_text(
    hjust = 0.5, face="bold", 
    color="black", 
    size=14),
    axis.title.x = element_text(
      size=12, 
      face="bold"),
    axis.title.y = element_text(
      size=12, 
      face="bold"),
    axis.text.x = element_text(
      face="bold", 
      color="black", 
      size=14),
    axis.text.y = element_text(
      face="bold", 
      color= "black", 
      size=14),
    axis.line = element_line(
      colour = "darkblue", 
      size = 1, 
      linetype = "solid"), 
    legend.position="none"
  ) +
  scale_y_continuous(limits=c(0.4, 1)) +
  ggtitle("Connecting labor force gender equality and Quality of Life",
          subtitle = paste("R-Squared: ", fLaborCor**2)) +     
  scale_color_gradient(low = "#710193", high = "#cb21ff") +
 # geom_vline(xintercept = 52.2) #canada is median (52.2)
geom_smooth(method = "lm", 
            formula = y ~ x, 
            color = "darkblue", 
            size=0.8) 


#Also, as suggested with our cc calculations, on a scatter plot there is a noticable
#trend between hdi and predictors
ggplot(dataFrame, aes(x=fSecondaryEdu, y=hdiValue)) +
  geom_point(aes(color=hdiValue)) +
  labs(x = "% of women completing secondary education",
       y = "HDI values (Higher is better)") +
  theme(plot.title = element_text(
    hjust = 0.5, face="bold", 
    color="black", 
    size=14),
    axis.title.x = element_text(
      size=12, 
      face="bold"),
    axis.title.y = element_text(
      size=12, 
      face="bold"),
    axis.text.x = element_text(
      face="bold", 
      color="black", 
      size=14),
    axis.text.y = element_text(
      face="bold", 
      color= "black", 
      size=14),
    axis.line = element_line(
      colour = "darkblue", 
      size = 1, 
      linetype = "solid"), 
    legend.position="none"
  ) +
  scale_y_continuous(limits=c(0.4, 1)) +
  ggtitle("Increasing secondary education gender equality and Quality of Life",
          subtitle = paste("R-Squared: ", fSecCor**2)) +     
  scale_color_gradient(low = "#710193", high = "#cb21ff") +
  geom_smooth(method = "lm", 
              formula = y ~ x, 
              color = "darkblue", 
              size=0.8) 

#Now lets show increasing education lowers adol birth rate
#This shows our need to fund more female secondary edu
#Greatest effect on HDI and also lowers AdolBirthRate 
#which causes secondary effect o n raising HDI

ggplot(dataFrame, aes(y=adolBirthRate, x=fSecondaryEdu)) +
  geom_point(aes(color=-adolBirthRate)) +
  labs(x = "% of women completing secondary education",
       #"Adolescent births per 1,000 women ages 15–19"
       y = "Adolescent births") +
  theme(plot.title = element_text(
    hjust = 0.5, face="bold", 
    color="black", 
    size=14),
    axis.title.x = element_text(
      size=12, 
      face="bold"),
    axis.title.y = element_text(
      size=12, 
      face="bold"),
    axis.text.x = element_text(
      face="bold", 
      color="black", 
      size=14),
    axis.text.y = element_text(
      face="bold", 
      color= "black", 
      size=14),
    axis.line = element_line(
      colour = "darkblue", 
      size = 1, 
      linetype = "solid"), 
    legend.position="none"
  ) +
  ggtitle("Increasing secondary education gender equality effect on Adolescent births",
          subtitle = paste("Correlation Coefficient (negative): ", 
                           fsecAdolCor)) +     
  scale_color_gradient(low = "#710193", high = "#cb21ff") +
  geom_smooth(method = "lm", 
              formula = y ~ x, 
              color = "darkblue", 
              size=0.8) 


ggplot(dataFrame, aes(x=maternalMortality, y=hdiValue)) +
  geom_point(aes(color=hdiValue)) +
  scale_x_reverse() + #reverse to get on same x,y xoord system
  #Maternal deaths per 100,000 live births
  labs(x = "Maternal Mortality",
       y = "HDI values (Higher is better)") +
  theme(plot.title = element_text(
    hjust = 0.5, face="bold", 
    color="black", 
    size=14),
    axis.title.x = element_text(
      size=12, 
      face="bold"),
    axis.title.y = element_text(
      size=12, 
      face="bold"),
    axis.text.x = element_text(
      face="bold", 
      color="black", 
      size=14),
    axis.text.y = element_text(
      face="bold", 
      color= "black", 
      size=14),
    axis.line = element_line(
      colour = "darkblue", 
      size = 1, 
      linetype = "solid"), 
    legend.position="none"
  ) +
  scale_y_continuous(limits=c(0.4, 1)) +
  ggtitle("Lowering Maternal Mortality rate and Quality of Life",
          subtitle = paste("R-Squared: ", 
                           maternalCor**2)) +     
  scale_color_gradient(low = "#710193", high = "#cb21ff") +
  geom_smooth(method = "lm", 
              formula = y ~ x, 
              color = "darkblue", 
              size=0.8) 





ggplot(dataFrame, aes(x=adolBirthRate, y=hdiValue)) +
  geom_point(aes(color=hdiValue)) +
  scale_x_reverse() + #reverse to get on same x,y xoord system
  #Adolescent births per 1,000 women ages 15–19
  labs(x = "Adolescent births",
       y = "HDI values (Higher is better)") +
  theme(plot.title = element_text(
    hjust = 0.5, face="bold", 
    color="black", 
    size=14),
    axis.title.x = element_text(
      size=12, 
      face="bold"),
    axis.title.y = element_text(
      size=12, 
      face="bold"),
    axis.text.x = element_text(
      face="bold", 
      color="black", 
      size=14),
    axis.text.y = element_text(
      face="bold", 
      color= "black", 
      size=14),
    axis.line = element_line(
      colour = "darkblue", 
      size = 1, 
      linetype = "solid"), 
    legend.position="none"
  ) +
  guides(fill="none") +
  scale_y_continuous(limits=c(0.4, 1)) +
  ggtitle("Lowering Adolecent birth rate and Quality of Life",
          subtitle = paste("R-Squared: ", adolCor**2)) +     
  scale_color_gradient(low = "#710193", high = "#cb21ff") +
  geom_smooth(method = "lm", 
              formula = y ~ x, 
              color = "darkblue", 
              size=0.8) 



giiNonReversed <- -dataFrame$giiValue + 1
ggplot(dataFrame, aes(x=giiNonReversed, y=hdiValue)) +
  geom_point(aes(color=hdiValue)) +
  scale_x_reverse() + #reverse to get on same x,y xoord system
  #Adolescent births per 1,000 women ages 15–19
  labs(x = "GII Values (Lower is Better)",
       y = "HDI values (Higher is better)") +
  theme(plot.title = element_text(
    hjust = 0.5, face="bold", 
    color="black", 
    size=14),
    axis.title.x = element_text(
      size=12, 
      face="bold"),
    axis.title.y = element_text(
      size=12, 
      face="bold"),
    axis.text.x = element_text(
      face="bold", 
      color="black", 
      size=14),
    axis.text.y = element_text(
      face="bold", 
      color= "black", 
      size=14),
    axis.line = element_line(
      colour = "darkblue", 
      size = 1, 
      linetype = "solid"), 
    legend.position="none"
  ) +
  #guides(fill="none") +
  scale_y_continuous(limits=c(0.4, 1)) +
  ggtitle("Connecting Gender Equality and Quality of Life",
          subtitle = paste("R-Squared: ", giiHdiCor**2)) +     
  scale_color_gradient(low = "#710193", high = "#cb21ff") +
  geom_smooth(method = "lm", 
              formula = y ~ x, 
              color = "darkblue", 
              size=0.8) 

# This will create a box plot of the sales column from a data frame named advertising
plot <- advertising %>%
  ggplot(aes(sales, sales)) +
  geom_boxplot()


#adolBirthRate maternalMortality 
#fSecondaryEdu fLaborForce fSeatsParlament

#Use box plots to look for outliers
ggplot(dataFrame) +
  aes(x = maternalMortality, y = hdiValue) +
  geom_boxplot(fill = "#0c4c8a", outlier.colour="red", 
               outlier.shape=8, outlier.size=4)
ggplot(dataFrame) +
  aes(x = adolBirthRate, y = hdiValue) +
  geom_boxplot(fill = "#0c4c8a", outlier.colour="red", 
               outlier.shape=8,outlier.size=4) +
  theme_minimal()
ggplot(dataFrame) +
  aes(x = fSecondaryEdu, y = hdiValue) +
  geom_boxplot(fill = "#0c4c8a", outlier.colour="red", 
               outlier.shape=8, outlier.size=4) +
  theme_minimal()
ggplot(dataFrame) +
  aes(x = fLaborForce, y = hdiValue) +
  geom_boxplot(fill = "#0c4c8a", outlier.colour="red",
               outlier.shape=8, outlier.size=4) +
  theme_minimal()
ggplot(dataFrame) +
  aes(x = fSeatsParlament, y = hdiValue) +
  geom_boxplot(fill = "#0c4c8a", outlier.colour="red", 
               outlier.shape=8, outlier.size=4) +
  theme_minimal()




