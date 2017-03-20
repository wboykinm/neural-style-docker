# Get a whole batch of image tiles:
# USAGE bash get_tiles.sh <geojson filename>
GEO_FILE=$1
TILE_ZOOM=11
TILE_URL_BASE='https://a.tiles.mapbox.com/v4/landplanner.l26ddlb9/'
TILE_URL_SUFFIX='@2x.png?access_token='
MB_TOKEN='pk.eyJ1IjoibGFuZHBsYW5uZXIiLCJhIjoicUtlZGgwYyJ9.UFYz8MD4lI4kIzk9bjGFvg'
# get expanded bbox from tracts_$COUNTY_FIPS.geojson
BBOX=$(node bbox.js tmp.geojson)
# pipe it through a tile cruncher
echo $BBOX | mercantile tiles $TILE_ZOOM > tiles.txt
rm -rf tmptiles
mkdir tmptiles
cd tmptiles
set -f
while read i; do
  X=$(node -e "console.log($i[0])")
  Y=$(node -e "console.log($i[1])")
  Z=$(node -e "console.log($i[2])")
  wget -c $TILE_URL_BASE$Z"/"$X"/"$Y$TILE_URL_SUFFIX$MB_TOKEN -O tile_$Z"_"$X"_"$Y.png
done < ../tiles.txt
cd ../