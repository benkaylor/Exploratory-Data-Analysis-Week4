library("dplyr")
library("ggplot2")

# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Question 5
# How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?

# Plot5.R

# Subset NEI for motor vehicles based on Mobile Sources and Onroad categories in SCC
SCCsubset <- SCC[grep("Mobile Sources", SCC$SCC.Level.One), ]
SCCsubset <- SCCsubset[grep("Onroad", SCCsubset$Data.Category), ]
v.subset <- as.vector(SCCsubset$SCC)
data <- subset(NEI, SCC %in% v.subset)
data$year <- as.factor(data$year)

# Use Dplyr to select just year and emissions, then group together
data.summary <- data %>% select(year, Emissions)
data.summary <- data.summary[complete.cases(data.summary), ]
grouped <- group_by(data.summary, year)

# Summarize into data frame for plotting
data.summary <- summarise(grouped, total=sum(Emissions))

# Plot the data
png("plot5.png")
df.plot <- ggplot(data.summary, aes(x=year, y=total, group = 1)) + 
  geom_point() + 
  geom_line()
df.plot + 
  ylab("Total Motor Vehicle Emissions") + 
  xlab("Year Collected") + 
  ggtitle("Total Motor Vehicle Emissions Change from 1999 to 2008")
dev.off()