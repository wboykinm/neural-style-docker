// return a bounding box array given a geojson file input

var turf = require('turf-extent')
var fs = require('fs')

var tractPolys = JSON.parse(fs.readFileSync(process.argv[2]));

var bbox = turf(tractPolys);

console.log(bbox);