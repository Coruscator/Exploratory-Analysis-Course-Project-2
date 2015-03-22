

## Reading libraries
library(dplyr)

## Unzip the file
unzip("exdata-data-NEI_data.zip")

## Reading the dataframes
if(!exists("NEI")){
        NEI <- readRDS("summarySCC_PM25.rds")
}

if(!exists("SCC")){
        SCC <- readRDS("Source_Classification_Code.rds")
}

## Baltimore city (fips == "24510")
baltimoreAggregate <- NEI %>% 
        select(fips, Emissions, year) %>% 
        filter(fips == "24510") %>% 
        group_by(year) %>%
        summarise(Total = sum(Emissions))

## Plotting the barplot and creating a png image file
png("plot2.png", width=480, height=480, units="px")

with(baltimoreAggregate, barplot(Total, 
        names.arg = year,
        xlab = "Year", 
        ylab = expression('Total PM'[2.5]*' Emission (Tons)'),
        main = expression('Total PM'[2.5]*' Emissions From all sources for Baltimore City')
))

dev.off()