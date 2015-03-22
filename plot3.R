
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

## Aggregate emissions over the four type of sources in all the four years
typeYearAggregate <- NEI %>%
        select(Emissions, year, type, fips) %>%
        filter(fips == "24510") %>% 
        group_by(type, year) %>%
        summarise(TotalEmissions = sum(Emissions)) %>%
        mutate(PollutionSource = type)

## Plotting the barplot and creating a png image file
png("plot3.png", width=600, height=600, units="px")

g <- ggplot(typeYearAggregate, aes(x = year, y = TotalEmissions, color = PollutionSource))
g <- g + geom_line() + labs(x = "Year") + labs(y = expression('Total PM'[2.5]*" Emissions"))
g <- g + ggtitle("Total Emissions in Baltimore City for the four Pollution Sources from 1999-2008")
g <- g + theme_bw()
print(g)

dev.off()