library("dplyr")
library("ggplot2")

# This first line will likely take a few seconds. Be patient!
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# Question 4
# Across the United States, 
# How have emissions from coal combustion-related sources changed from 1999–2008?

# Plot4.R

# Grep for Coal and Combustion in SCC data
SCCsubset <- SCC[grep("Coal", SCC$Short.Name), ]
SCCsubset <- SCCsubset[grep("Combustion", SCCsubset$SCC.Level.One), ]
v.subset <- as.vector(SCCsubset$SCC)

# Subset NEI based on coal and combustion SCC
data <- subset(NEI, SCC %in% v.subset)
data$year <- as.factor(data$year)

# Use Dplyr to select just year and emissions, then group together
data.summary <- data %>% select(year, Emissions)
data.summary <- data.summary[complete.cases(data.summary), ]
grouped <- group_by(data.summary, year)

# Summarize into data frame for plotting
data.summary <- summarise(grouped, total=sum(Emissions))

# Plot the data
png("plot4.png")
df.plot <- ggplot(data.summary, aes(x=year, y=total, group = 1)) + 
  geom_point() + 
  geom_line()
df.plot + 
  ylab("Total Coal Emissions") + 
  xlab("Year Collected") + 
  ggtitle("Total Coal Emissions Change from 1999 to 2008")
dev.off()