# CLI Usage 
# ----------------------------------------------------------------------------
# docker build --build-arg='repo=https://github.com/Slickrick/tubomyevic.git' .
# docker run --rm -ti --name=evic -v {local_code_path}:/tubomyevic {image_id}
# ----------------------------------------------------------------------------
FROM debian

ARG repo

# Install all required packages
RUN apt-get update
RUN apt-get install -y git gcc-arm-none-eabi libnewlib-arm-none-eabi gcc make python3 python3-setuptools python3-dev libhidapi-dev python3-hidapi python3-hid wget bash-completion procps vim

# Set up the environment to be a bit more friendly
RUN echo '/etc/bash_completion' > /root/.bash_profile

# Clone and configure python-evic
RUN git clone https://github.com/Ban3/python-evic
RUN cd python-evic; python3 setup.py install

# Clone and link OpenNuvoton library repo
RUN git clone https://github.com/OpenNuvoton/M451BSP
RUN mkdir nuvoton-sdk
RUN ln -s /M451BSP/Library /nuvoton-sdk

# Clone tubomyevic repo
RUN echo $repo
RUN git clone ${repo}
RUN cd /tubomyevic; make

# Install the evic-sdk for reference
RUN git clone https://github.com/ReservedField/evic-sdk.git

# Mounted volumes
VOLUME /tubomyevic
