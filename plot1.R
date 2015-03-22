

## Unzip the zip file
unzip("exdata-data-NEI_data.zip")

## Reading the dataframes
if(!exists("NEI")){
        NEI <- readRDS("summarySCC_PM25.rds")
}

if(!exists("SCC")){
        SCC <- readRDS("Source_Classification_Code.rds")
}

## Applying summarisation for PM2.5 emissions over years
yearWiseEmissions <- with(NEI, tapply(Emissions, year, sum))

## Plotting the barplot and creating a png image file
png("plot1.png", width=480, height=480, units="px")

barplot(yearWiseEmissions/10^6, 
        names.arg = names(yearWiseEmissions),
        xlab = "Year", 
        ylab = expression('Total PM'[2.5]*' Emission (10^6 Tons)'),
        main = expression('Total PM'[2.5]*' Emissions From all Sources')
)

dev.off()