////////////////////////////////////////////////////////////
#Create Map Graph
  
library (ggmap)
library (osmar)
library(prettymapr)

#Import data on Greater London
src <- osmsource_api ()


bb <- center_bbox(-0.129390, 51.532401, 300, 300)
#bb <- osmar::corner_bbox(-0.1430397, 51.5265924, -0.1214227, 51.5400746)
ua <- osmar::get_osm(bb, source = src)

#The osmdata contains an osmar object, which has all the 'nodes' and 'ways' associated with the data.
#Two ways of visualizing
osmar::plot_nodes(ua)
osmar::plot_ways(ua)

#Subset the data such that we only have data associated with the roads
hways_data <- subset(ua, way_ids = find(ua, way(tags(k == "highway"))))
hways <- find(hways_data, way(tags(k == "name")))
hways <- find_down(ua, way(hways))
hways_data <- subset(ua, ids = hways)
plot(hways_data)

#visualization
par(bg = "black")
osmar::plot_ways(hways_data, col="blue", bg ='green')
osmar::plot_nodes(hways_data, pch=19, cex=0.1, add=T, col="red")

#convert to igraph
hways_graph = as_igraph(hways_data)
hways_graph = as.undirected(hways_graph)
plot(hways_graph, vertex.label=NA, vertex.size=4, edge.color="blue")




////////////////////////////////////////////////////////////
#Let's get the trace data
library(plotKML)
library(urltools)
library(rgdal)


url = "http://api.openstreetmap.org/api/0.6/trackpoints?bbox=12&page=pagenumber"
mat = matrix(bb)[,1]
val = capture.output(mat[])
url <- param_set(url, key = "bbox", value = "-0.1430397,51.5265924,-0.1214227,51.5400746")


for (i in 0:20){
url <- param_set(url, key = "page", value = i)
filename <- paste(i,"trace_data.gpx")
download.file(url, destfile=filename)
}

#Read in GPX files that are located in the working directory
files <- dir(pattern = "\\.gpx")
#route <- readOGR(files[2],"tracks")
#coordinates = coordinates(route)[[1]][[1]]

#Set up the three vectors to hold your coordinate and path data
index <- c()
latitude <- c()
longitude <- c()

for (i in 1:length(files)) {        
  route <- readOGR(files[i], "tracks")
  coordinates = coordinates(route)[[1]][[1]]
  index_el <- 0 : nrow(coordinates)
  index <- c(index, index_el)
  latitude <- c(latitude, coordinates[,2])
  longitude <- c(longitude, coordinates[,1])
}

routes <- data.frame(cbind(index, latitude, longitude))


#Get the map of Amsterdam from Google

london_map <- qmap('kings cross station', zoom =18, color = 'bw')

#Plot the map and the routes on top of that

london_map +
  geom_path(aes(x = longitude, y = latitude, group = factor(index)), 
            colour="#5F35D8", data = routes, alpha=0.3)








