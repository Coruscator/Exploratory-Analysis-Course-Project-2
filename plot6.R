
## Reading libraries
library(dplyr)
library(ggplot2)
library(tidyr)

## Unzip the file
unzip("exdata-data-NEI_data.zip")

## Reading the dataframes
if(!exists("NEI")){
        NEI <- readRDS("summarySCC_PM25.rds")
}

if(!exists("SCC")){
        SCC <- readRDS("Source_Classification_Code.rds")
}


## Subset the NEI data frame for emissions from motor vehicle sources in Baltimore City and
## Los Angeles County
motorEmissionsAggregate <- NEI %>%
        select(fips, Emissions, type, year) %>%
        filter((fips == "24510"| fips == "06037") & type == "ON-ROAD") %>%
        mutate(City = ifelse(fips == "24510", "Baltimore City", "Los Angeles County")) %>%
        group_by(year, City) %>%
        summarise(TotalEmissions = sum(Emissions)) 

## Normalize the emissions to 1999 levels
baltimore1999Emission <- filter(motorEmissionsAggregate, City == "Baltimore City", 
                                year == 1999)[1,3] %>% as.numeric
losAngeles1999Emission <- filter(motorEmissionsAggregate, City == "Los Angeles County", 
                                year == 1999)[1,3] %>% as.numeric

motorEmissionsAggregate <- motorEmissionsAggregate %>%
        mutate(NormalizedEmissions = ifelse(City == "Los Angeles County", 
                                            TotalEmissions/losAngeles1999Emission, 
                                            TotalEmissions/baltimore1999Emission))
gatherMotorAggregate <- gather(motorEmissionsAggregate, TotalOrNormalized, Emissions, -c(year, City))

## Plotting the barplot and creating a png image file
png("plot6.png", width=640, height=640, units="px")

g <- ggplot(gatherMotorAggregate, aes(x = year, y = Emissions, color = City))
g <- g + geom_line() + facet_grid(TotalOrNormalized~., scales="free_y")
g <- g + labs(x = "Year") 
g <- g + labs(y = expression('Total PM'[2.5]*' Emissions (Tons)'))
g <- g + labs(title = expression('Total PM'[2.5]*' Emissions from Motor sources from 1999 to 2008 for Baltimore and LA'))
g <- g + theme_bw()
print(g)

dev.off()