library("dplyr")
library("ggplot2")

# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Question 3
# Of the four types of sources indicated by the type (point, nonpoint, onroad, nonroad) variable, 
# which of these four sources have seen decreases in emissions 
# from 1999–2008 for Baltimore City? Which have seen increases in emissions from 1999–2008? 
# Use the ggplot2 plotting system to make a plot answer this question.

# Plot3.R

# Not needed, but Subsets based on Data Category 
data.category <- c("Point", "Nonpoint", "Onroad", "Nonroad")
pnon <- subset(SCC, Data.Category %in% data.category)

# Subset based on Baltimore Fips code
data <- subset(NEI, fips == "24510" & SCC %in% pnon$SCC)

# Create Factors for Grouping in Plot and Facet Wrap
data$year <- as.factor(data$year)
data$type <- as.factor(data$type)

# Plot the data
png("plot3.png")
df.plot <- ggplot(data, aes(x=year, y=Emissions)) + 
  geom_boxplot(notch=TRUE) + 
  scale_y_log10()
df.plot + 
  facet_wrap( ~ type, ncol=4) + 
  geom_smooth(aes(group = type), method="glm", size = 1.5, se = TRUE) + 
  ylab("PM 2.5 Emissions Median") + xlab("Year Collected") + 
  ggtitle("City of Baltimore PM 2.5 Emission Medians by Year and Type")
dev.off()