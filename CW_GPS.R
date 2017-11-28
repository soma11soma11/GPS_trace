////////////////////////////////////////////////////////////
#Create Map Graph
  
library (ggmap)
library (osmar)

#Import data on Greater London
src <- osmsource_api ()
place <- geocode("Kings Cross")
bb <- center_bbox(place$lon , place$lat , 1500 , 1500)
ua <- get_osm(bb, source = src)

#The osmdata contains an osmar object, which has all the 'nodes' and 'ways' associated with the data.


#Two ways of visualizing
plot_nodes(ua)
plot_ways(ua)

#Subset the data such that we only have data associated with the roads
hways_data <- subset(ua, way_ids = find(ua, way(tags(k == "highway"))))
hways <- find(hways_data, way(tags(k == "name")))
hways <- find_down(ua, way(hways))
hways_data <- subset(ua, ids = hways)

par(bg = "black")
plot_ways(hways_data, col="blue", bg ='green')
plot_nodes(hways_data, pch=19, cex=0.1, add=T, col="red")


////////////////////////////////////////////////////////////
#Let's get the trace data
library(data.table)
library(plotKML)
library(maps)

trace_data <- readGPX('http://api.openstreetmap.org/api/0.6/trackpoints?bbox=0,51.5,0.25,51.75&page=0.gpx')


