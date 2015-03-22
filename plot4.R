
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

### Avoided merging of NEI and SCC as it is a very costly operation for data
### sets of these sizes. Its cheaper to just query the two datasets individually.

## Source IDs for Coal pollution source
coalSource <- SCC %>%
        select(SCC, Short.Name, EI.Sector) %>%
        filter(grepl("[Cc]oal", Short.Name) | grepl("[Cc]oal", EI.Sector)) 

## Subset the NEI data frame for emissions from coal sources
coalEmissionsAggregate <- NEI %>%
        select(SCC, Emissions, year) %>%
        filter(SCC %in% as.character(coalSource$SCC)) %>%
        group_by(year) %>%
        summarise(TotalEmissions = sum(Emissions))
        

## Plotting the barplot and creating a png image file
png("plot4.png", width=640, height=480, units="px")

g <- ggplot(coalEmissionsAggregate, aes(x = factor(year), y = TotalEmissions/10^5))
g <- g + geom_bar(stat = "identity") 
g <- g + labs(x = "Year") 
g <- g + labs(y = expression('Total PM'[2.5]*' Emissions (10^5 Tons)'))
g <- g + labs(title = expression('Total PM'[2.5]*' Emissions from Coal based sources from 1999 to 2008'))
g <- g + theme_bw()
print(g)

dev.off()