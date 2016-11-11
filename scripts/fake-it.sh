#!/bin/bash
#
# Easy to use script to run neural-style
# USAGE: ./fake-it.sh <content image filename> <style image filename> <output image width> <content image folder>

DATE=`date +%Y_%m_%d`

if [ $# -lt 2 ]
  then
    echo "USAGE: fake-it.sh content-image style-image image-width"
    echo "Current available contents: "
    for i in `ls contents`; do echo -e "\t${i}"; done
    echo "Current available styles: "
    for i in `ls styles`; do echo -e "\t${i}"; done
	echo "Example: fake-it.sh demo/goldengate.jpg vangogh.jpg 512"
	echo "To add more contents or styles, simply add them to the folders above"
    exit 1
fi

# Check docker permissions
if groups $USER | grep &>/dev/null '\bdocker\b'; then SU=""
else SU="sudo"; fi

output_name="output/${1%.*}_by_${2%.*}_${3}px_$DATE.png"
time $SU nvidia-docker run --rm -v $(pwd):/images albarji/neural-style -backend cudnn -cudnn_autotune -normalize_gradients -init image -num_iterations 500 -content_weight 200 -style_weight 400 -content_image contents/$4/$1 -style_image styles/$2 -output_image $output_name -image_size $3



