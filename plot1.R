library("dplyr")

## This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Question 1
# Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 
# emission from all sources for each of the years 1999, 2002, 2005, and 2008.

# Plot1.R

# Get total emissions by year
data.emissions <- tapply(NEI$Emissions, NEI$year, sum)

# Scale data by Millions for Plotting
for (i in 1:length(data.emissions)) {
  data.emissions[[i]] <- data.emissions[[i]]/1000000
}

# Plot the data
png("plot1.png")
barplot(data.emissions, main = "United States PM 2.5 Emission Totals by Year", ylab = "PM 2.5 Emissions in Millions", xlab = "Year collected")
dev.off()