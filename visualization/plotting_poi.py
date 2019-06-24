from gmplot import gmplot
import os, json
# Place map

API_KEY = 'AIzaSyCcFSRX4kExONVVB9cqQynjh7EXgZwcyaI'

gmap = gmplot.GoogleMapPlotter(43.739829, -79.514102, 13, API_KEY)


path_to_json = 'C:\\Users\\saim\\Documents\\POI_Clustering\\POI_datasets\\downtown_toronto'
json_files = [pos_json for pos_json in os.listdir(path_to_json) if pos_json.endswith('.json')]

for i in range(len(json_files)):
	with open(path_to_json + '/' + str(json_files[i])) as file:
 		data = json.load(file)

 		gmap.marker(data["geometry"]["location"]["lat"], data["geometry"]["location"]["lng"], 'cornflowerblue')

# for i in range(len(json_files)):
# 	#print(json_files[i])
# 	with open(path_to_json + '/' + str(json_files[i])) as file:
# 		data = json.load(file)
# 	gmap.marker(data["geometry"]["location"]["lat"], data["geometry"]["location"]["lng"], 'green')


gmap.draw("my_map.html")
print("process completed")