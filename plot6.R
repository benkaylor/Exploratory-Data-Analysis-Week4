library("dplyr")
library("ggplot2")

# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Question 6
# Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?

# Plot6.R

# Subset NEI for motor vehicles based on Mobile Sources and Onroad categories in SCC
SCCsubset <- SCC[grep("Mobile Sources", SCC$SCC.Level.One), ]
SCCsubset <- SCCsubset[grep("Onroad", SCCsubset$Data.Category), ]
v.subset <- as.vector(SCCsubset$SCC)
data <- subset(NEI, SCC %in% v.subset)
data$year <- as.factor(data$year)

# Use Dplyr to select just year, emissions and FIPs codes, then group together
data.summary <- data %>% select(year, Emissions, fips)
data.summary <- data.summary[complete.cases(data.summary), ]
grouped <- group_by(data.summary, year, fips)

# Summarize into data frame for plotting
data.summary <- summarise(grouped, total=sum(Emissions))

# Subset just Baltimore and Los Angeles data for comparison
data.baltimore <- subset(data.summary, fips == "24510")
data.baltimore$metro <- "Baltimore"
data.la <- subset(data.summary, fips == "06037")
data.la$metro <- "Los Angeles"
data <- rbind(data.baltimore, data.la)

# Plot the data
png("plot6.png")
df.plot <- ggplot(data, aes(x=year, y=total, group=2)) + 
  geom_point() + 
  geom_line()
df.plot + 
  facet_wrap( ~ metro, ncol=2) + 
  ylab("Total Motor Vehicle Emissions") + 
  xlab("Year Collected") + 
  ggtitle("Total Motor Vehicle Emissions Change from 1999 to 2008")
dev.off()