FROM kaixhin/cuda-torch
MAINTAINER "Bill Morris, https://github.com/wboykinm"

# Install system dependencies
RUN set -ex && \
	apt-get update && apt-get install --no-install-recommends --no-install-suggests -y \
	libprotobuf-dev \
	protobuf-compiler \
	wget \
	git \
	build-essential \
	checkinstall \
	libssl-dev \
	imagemagick \	
	&& rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/wboykinm/neural-style-docker

WORKDIR "/home/ubuntu/neural-style-docker/scripts"
RUN bash install-nvidia.sh
	
# Install geo/tile dependencies
RUN sudo apt-get install python-pip
RUN pip install mercantile
RUN	curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
RUN nvm install 6
RUN nvm use 6
RUN nvm alias default node
WORKDIR "/home/ubuntu/neural-style-docker/scripts/tiles"
RUN npm install

# Install loadcaffe and other torch dependencies
RUN luarocks install loadcaffe

# Clone neural-style app
WORKDIR /
RUN set -ex && \
	wget --no-check-certificate https://github.com/jcjohnson/neural-style/archive/master.tar.gz && \
	tar -xvzf master.tar.gz && \
    mv neural-style-master neural-style && \
	rm master.tar.gz

# Download precomputed network weights
WORKDIR neural-style
RUN bash models/download_models.sh
RUN mkdir /models

# Declare volume for storing network weights
VOLUME ["/neural-style/models"]

# Copy wrapper scripts
COPY ["/scripts/variants.sh", "/scripts/neural-style.sh", "/neural-style/"]

# Add neural-style to path
ENV PATH /neural-style:$PATH

# Prepare folder for mounting images and workplaces
WORKDIR /images
VOLUME ["/images"]

ENTRYPOINT ["neural-style.sh"]
CMD ["-backend", "cudnn", "-cudnn_autotune"]

