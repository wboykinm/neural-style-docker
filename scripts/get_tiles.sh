# get expanded bbox from tracts_$COUNTY_FIPS.geojson
COMMUNITY_BBOX=$(node bbox.js ../../data/tmp_$STATE_ABBRV"_"$COUNTY_NAME/tracts_$COUNTY_FIPS.geojson)
# pipe it through a tile cruncher
echo $COMMUNITY_BBOX | mercantile tiles $TILE_ZOOM > ../../data/tmp_$STATE_ABBRV"_"$COUNTY_NAME/tiles.txt
# . . . and then the mapbox api in 6x parallel to get geojson
cat ../../data/tmp_$STATE_ABBRV"_"$COUNTY_NAME/tiles.txt | parallel -j6 node get.js {} ../../data/tmp_$STATE_ABBRV"_"$COUNTY_NAME/ $TILES_MB_TOKEN