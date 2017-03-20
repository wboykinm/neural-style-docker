// return a bounding box array given a geojson file input

var turf = require('turf')
var fs = require('fs')

var tractPolys = JSON.parse(fs.readFileSync(process.argv[2]));

var bbox = turf.extent(tractPolys);

console.log(bbox);