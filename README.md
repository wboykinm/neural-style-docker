<<<<<<< HEAD
# Neural Style for Docker
__Satellite imagery edition!__

![Stylized Eixample](doc/barca1-0-1_by_picabia_ecclesiastical_1080px_2016_11_22_400.png)
_Barcelona's Eixample district in the style of Francis Picabia's "Ecclesiastical"_

A dockerized (by [Álvaro Barbero Jiménez](https://github.com/albarji/neural-style-docker)) version of the [neural style algorithm by jcjohnson](https://github.com/jcjohnson/neural-style). [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) is optimized for GPU hardware.
=======
# neural-style-docker

![Stylized Docker](./doc/docker_afremov_sw5000_ss1.png)
![Stylized Docker](./doc/docker_broca_sw5000_ss1.png)
![Stylized Docker](./doc/docker_brownrays_sw375_ss1.png)
![Stylized Docker](./doc/docker_ediaonise_sw1500_ss1.png)
![Stylized Docker](./doc/docker_edimburgGraffit_sw20000.0_ss1.png)
![Stylized Docker](./doc/docker_himesama_sw10000_ss1.png)
![Stylized Docker](./doc/docker_paisaje_urbano-hundertwasser_sw2000_ss1.png)
![Stylized Docker](./doc/docker_potatoes_sw375_ss1.png)
![Stylized Docker](./doc/docker_RenoirDogesPalaceVenice_sw1500_ss1.png)
![Stylized Docker](./doc/docker_revellerAndCourtesan_sw2000_ss1.png)
![Stylized Docker](./doc/docker_seated-nude_sw375_ss1.png)
![Stylized Docker](./doc/docker_starryNight_sw1500_ss1.png)

A dockerized version of neural style transfer algorithms.
[nvidia-docker](https://github.com/NVIDIA/nvidia-docker) is used to make use of GPU hardware.
>>>>>>> b0f870ffbc21673cd4e2b03001a2cb82434ec57c

## Install

### Prerequisites

* [docker](https://www.docker.com/)
* [nvidia-docker](https://github.com/NVIDIA/nvidia-docker)
* Appropriate nvidia drivers for your GPU

### Installation

You can either pull the Docker image from Docker Hub with

`docker pull albarji/neural-style`

or build the image locally with

`make`
	
or spin up an EC2 (warning; these GPU instances can get expensive)

<<<<<<< HEAD
```
# create:
docker-machine create \
	--driver amazonec2 \
	--amazonec2-instance-type p2.xlarge \
	--amazonec2-access-key $AWS_ACCESS_KEY \
	--amazonec2-secret-key $AWS_SECRET_KEY \
	--amazonec2-subnet-id $AWS_SUBNET_ID \
	--amazonec2-vpc-id $AWS_VPC_ID \
	nvidia-mapper # name your machine

# build the environment from the local container config:
eval $(docker-machine env nvidia-docker)
docker build -t albarji/neural-style .

# . . . and connect:
docker-machine ssh nvidia-mapper

# don't forget to spin it down when finished
docker-machine rm nvidia-docker
```

## Simple use

`bash scripts/fake-it.sh <params>`
=======
### Usage

This docker container operates by receiving images through a volume to be mounted at the **/images** directory.
For instance, to apply a **style** image *somestyle.png* onto a **content** image *somecontent.png* located at the 
current directory, run: 

    nvidia-docker run --rm -v $(pwd):/images albarji/neural-style --content somecontent.png --style somestyle.png
>>>>>>> b0f870ffbc21673cd4e2b03001a2cb82434ec57c

All paths referenced in the arguments are regarded as relative to the /images folder within the container. So in case
of having a local structure such as

<<<<<<< HEAD
Example: to draw the downtown Sydney in the style of Picabia's "Ecclesiastical", run

`bash scripts/fake-it.sh digitalglobe/_0003_AUS_Sydney_Jan06_2015_WV3_30cm.jpg picabia_ecclesiastical.jpg`
=======
    contents/
        docker.png
        whatever.jpg
    styles/
        picasso.png
        vangogh.png
        
applying the *vangogh.png* style to the *docker.png* image amounts to

    nvidia-docker run --rm -v $(pwd):/images albarji/neural-style --content contents/docker.png --style styles/vangogh.png
    
You can provide several content and style images, in which case all cross-combinations will be generated.
>>>>>>> b0f870ffbc21673cd4e2b03001a2cb82434ec57c

    nvidia-docker run --rm -v $(pwd):/images albarji/neural-style --content contents/docker.png contents/whatever.jpg --style styles/vangogh.png styles/picasso.png

<<<<<<< HEAD
### Processing tiled maps

Pull satellite imagery tiles from the Mapbox API for a given bbox and zoom level:
`bash get_tiles.sh <bbox geojson> <z>`

e.g.
`bash get_tiles.sh vergennes.geojson 11`

Then loop through the results:
```
for i in $(ls scripts/tiles/tmptiles/); do
  bash scripts/style-tiles.sh $i picabia_ecclesiastical.jpg 512
done
```

### Generating variants
=======
### Fine tuning the results
>>>>>>> b0f870ffbc21673cd4e2b03001a2cb82434ec57c

Better results can be attained by modifying some of the transfer parameters.

<<<<<<< HEAD
`bash scripts/variants.sh`
=======
#### Algorithm
>>>>>>> b0f870ffbc21673cd4e2b03001a2cb82434ec57c

The --alg parameter allows changing the neural style transfer algorithm to use.

* **gatys**: highly detailed transfer, slow processing times (default)
* **chen-schmidt**: fast patch-based style transfer
* **chen-schmidt-inverse**: even faster aproximation to chen-schmidt through the use of an inverse network

<<<<<<< HEAD
`bash scripts/variants.sh --contents contents/docker.png --styles styles/vangogh.jpg`
=======
The following example illustrates kind of results to be expected by these different algorithms
>>>>>>> b0f870ffbc21673cd4e2b03001a2cb82434ec57c

| Content image | Algorithm | Style image |
| ------------- | --------- | ----------- |
| ![Content](./doc/avila-walls.jpg) | Gatys ![Gatys](./doc/avila-walls_broca_gatys_ss1.0_sw10.0.jpg) | ![Style](./doc/broca.jpg) | 
| ![Content](./doc/avila-walls.jpg) | Chen-Schmidt ![Chen-Schmidt](./doc/avila-walls_broca_chen-schmidt_ss1.0.jpg) | ![Style](./doc/broca.jpg) | 
| ![Content](./doc/avila-walls.jpg) | Chen-Schmidt Inverse ![Chen-Schmidt Inverse](./doc/avila-walls_broca_chen-schmidt-inverse_ss1.0.jpg) | ![Style](./doc/broca.jpg) | 

#### Output image size

<<<<<<< HEAD
`nvidia-docker run --rm albarji/neural-style -h`
=======
By default the output image will have the same size as the input content image, but a different target size can be
specified through the --size parameter. For example, to produce a 512 image
>>>>>>> b0f870ffbc21673cd4e2b03001a2cb82434ec57c

    nvidia-docker run --rm -v $(pwd):/images albarji/neural-style --content contents/docker.png --style styles/vangogh.png --size 512
    
Note the proportions of the image are maintained, therefore the value of the size parameter is understood as the width 
of the target image, the height being scaled accordingly to keep proportion.

If the image to be generated is large, a tiling strategy will be used, applying the neural style transfer method
to small tiles of the image and stitching them together. Tiles overlap to provide some guarantees on overall
consistency.

<<<<<<< HEAD
`nvidia-docker run --rm -v $(pwd):/images albarji/neural-style -backend cudnn -cudnn_autotune -content_image content.png -style_image style.png`
=======
![Tiling](./doc/tiling.png)
>>>>>>> b0f870ffbc21673cd4e2b03001a2cb82434ec57c

You can control the size of these tiles through the --tilesize parameter.
Higher values will generally produce better quality results and faster rendering times, but they will also incur in
larger memory consumption.
Note also that since the full style image is applied to each tile, as a result the style features will appear
as smaller in the rendered image.

#### Style weight

Gatys algorithm allows to adjust the amount of style imposed over the content image, by means of the --sw parameter.
By default a value of **10** is used, meaning the importance of the style is 10 times the importance of the content.
Smaller weight values result in the transfer of colors, while higher values transfer textures and details of the style

<<<<<<< HEAD
`nvidia-docker run --rm -v $(pwd):/images albarji/neural-style -backend cudnn -cudnn_autotune -content_image contents/docker.png -style_image styles/vangogh.jpg`
=======
If several weight values can be provided, all combinations will be generated. For instance, to generate the same
style transfer with three different weights, use
>>>>>>> b0f870ffbc21673cd4e2b03001a2cb82434ec57c

    nvidia-docker run --rm -v $(pwd):/images albarji/neural-style --content contents/docker.png --style styles/vangogh.png --sw 5 10 20
 
#### Style scale

If the transferred style results in too large or too small features, the scaling can be modified through the --ss 
parameter. A value of **1** keeps the style at its original scale. Smaller values reduce the scale of the style,
resulting in smaller style features in the output image. Conversely, larger values produce larger features. 
Similarly to the style weight, several values can be provided

    nvidia-docker run --rm -v $(pwd):/images albarji/neural-style --content contents/docker.png --style styles/vangogh.png --ss 0.75 1 1.25
    
Warning: using a value larger than **1** will increasy the memory consumption. 

### Transparency

Transparency values (alpha channels) are preserved by the neural style transfer. Note for instance how in the Wikipedia
logo example above the transparent background is not transformed.

## References

* [Gatys et al method](https://arxiv.org/abs/1508.06576), [implementation by jcjohnson](https://github.com/jcjohnson/neural-style)
* [Chen-Schmidt method](https://arxiv.org/pdf/1612.04337.pdf), [implementation](https://github.com/rtqichen/style-swap)
* [A review on style transfer methods](https://arxiv.org/pdf/1705.04058.pdf)
* [Neural-tiling method](https://github.com/ProGamerGov/Neural-Tile)
* [The Wikipedia logo](https://en.wikipedia.org/wiki/Wikipedia_logo)
