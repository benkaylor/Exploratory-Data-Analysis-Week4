library("dplyr")

# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Question 2
# Have total emissions from PM2.5 decreased in the Baltimore City, 
# Maryland (fips == "24510") from 1999 to 2008? 
# Use the base plotting system to make a plot answering this question.

# Plot2.R

# Subset data for just Baltimore data fips code
NEI.baltimore <- subset(NEI, fips == "24510")

# Get total emissions in Baltimore by year
data.emissions.baltimore <- tapply(NEI.baltimore$Emissions, NEI.baltimore$year, sum)

# Scale data by Thousands for Plotting
for (i in 1:length(data.emissions.baltimore)) {
  data.emissions.baltimore[[i]] <- data.emissions.baltimore[[i]]/1000
}

# Plot the data
png("plot2.png")
barplot(data.emissions.baltimore, 
        main = "City of Baltimore PM 2.5 Emission Totals by Year", 
        ylab = "PM 2.5 Emissions in Thousands", 
        xlab = "Year collected")
dev.off()