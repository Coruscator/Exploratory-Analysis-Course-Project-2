
## Reading libraries
library(dplyr)
library(ggplot2)

## Unzip the file
unzip("exdata-data-NEI_data.zip")

## Reading the dataframes
if(!exists("NEI")){
        NEI <- readRDS("summarySCC_PM25.rds")
}

if(!exists("SCC")){
        SCC <- readRDS("Source_Classification_Code.rds")
}


## Subset the NEI data frame for emissions from motor vehicle sources in Baltimore City
motorEmissionsAggregateBC <- NEI %>%
        select(fips, Emissions, type, year) %>%
        filter(fips == "24510", type == "ON-ROAD") %>%
        group_by(year) %>%
        summarise(TotalEmissions = sum(Emissions))


## Plotting the barplot and creating a png image file
png("plot5.png", width=640, height=480, units="px")

g <- ggplot(motorEmissionsAggregateBC, aes(x = factor(year), y = TotalEmissions))
g <- g + geom_bar(stat = "identity") 
g <- g + labs(x = "Year") 
g <- g + labs(y = expression('Total PM'[2.5]*' Emissions (Tons)'))
g <- g + labs(title = expression('Total PM'[2.5]*' Emissions from Motor sources from 1999 to 2008 for Baltimore City'))
g <- g + theme_bw()
print(g)

dev.off()