# Neural Style for Docker
__Satellite imagery edition!__

![Stylized Eixample](doc/barca1-0-1_by_picabia_ecclesiastical_1080px_2016_11_22_400.png)
_Barcelona's Eixample district in the style of Francis Picabia's "Ecclesiastical"_

A dockerized (by [Álvaro Barbero Jiménez](https://github.com/albarji/neural-style-docker)) version of the [neural style algorithm by jcjohnson](https://github.com/jcjohnson/neural-style). [nvidia-docker](https://github.com/NVIDIA/nvidia-docker) is optimized for GPU hardware.

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

### Usage

This docker container operates by receiving images through a volume to be mounted at the **/images** directory.
For instance, to apply a **style** image *somestyle.png* onto a **content** image *somecontent.png* located at the 
current directory, run: 

    nvidia-docker run --rm -v $(pwd):/images albarji/neural-style --content somecontent.png --style somestyle.png

All paths referenced in the arguments are regarded as relative to the /images folder within the container. So in case
of having a local structure such as

    contents/
        docker.png
        whatever.jpg
    styles/
        picasso.png
        vangogh.png
        
applying the *vangogh.png* style to the *docker.png* image amounts to

    nvidia-docker run --rm -v $(pwd):/images albarji/neural-style --content contents/docker.png --style styles/vangogh.png
    
You can provide several content and style images, in which case all cross-combinations will be generated.

    nvidia-docker run --rm -v $(pwd):/images albarji/neural-style --content contents/docker.png contents/whatever.jpg --style styles/vangogh.png styles/picasso.png
		
Example: to draw the downtown Sydney in the style of Picabia's "Ecclesiastical", run

		`bash scripts/fake-it.sh digitalglobe/_0003_AUS_Sydney_Jan06_2015_WV3_30cm.jpg picabia_ecclesiastical.jpg`


### Fine tuning the results

Better results can be attained by modifying some of the transfer parameters.

#### Algorithm

The --alg parameter allows changing the neural style transfer algorithm to use.

* **gatys**: highly detailed transfer, slow processing times (default)
* **chen-schmidt**: fast patch-based style transfer
* **chen-schmidt-inverse**: even faster aproximation to chen-schmidt through the use of an inverse network

The following example illustrates kind of results to be expected by these different algorithms

| Content image | Algorithm | Style image |
| ------------- | --------- | ----------- |
| ![Content](./doc/avila-walls.jpg) | Gatys ![Gatys](./doc/avila-walls_broca_gatys_ss1.0_sw10.0.jpg) | ![Style](./doc/broca.jpg) | 
| ![Content](./doc/avila-walls.jpg) | Chen-Schmidt ![Chen-Schmidt](./doc/avila-walls_broca_chen-schmidt_ss1.0.jpg) | ![Style](./doc/broca.jpg) | 
| ![Content](./doc/avila-walls.jpg) | Chen-Schmidt Inverse ![Chen-Schmidt Inverse](./doc/avila-walls_broca_chen-schmidt-inverse_ss1.0.jpg) | ![Style](./doc/broca.jpg) | 

#### Output image size

By default the output image will have the same size as the input content image, but a different target size can be
specified through the --size parameter. For example, to produce a 512 image

    nvidia-docker run --rm -v $(pwd):/images albarji/neural-style --content contents/docker.png --style styles/vangogh.png --size 512
    
Note the proportions of the image are maintained, therefore the value of the size parameter is understood as the width 
of the target image, the height being scaled accordingly to keep proportion.

If the image to be generated is large, a tiling strategy will be used, applying the neural style transfer method
to small tiles of the image and stitching them together. Tiles overlap to provide some guarantees on overall
consistency.

![Tiling](./doc/tiling.png)

You can control the size of these tiles through the --tilesize parameter.
Higher values will generally produce better quality results and faster rendering times, but they will also incur in
larger memory consumption.
Note also that since the full style image is applied to each tile, as a result the style features will appear
as smaller in the rendered image.

#### Style weight

Gatys algorithm allows to adjust the amount of style imposed over the content image, by means of the --sw parameter.
By default a value of **10** is used, meaning the importance of the style is 10 times the importance of the content.
Smaller weight values result in the transfer of colors, while higher values transfer textures and details of the style

If several weight values can be provided, all combinations will be generated. For instance, to generate the same
style transfer with three different weights, use

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
