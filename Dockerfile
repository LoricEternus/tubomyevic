# CLI Usage 
# ----------------------------------------------------------------------------
# Deployment
# Configure custom git repo
# docker build --build-arg repo=https://github.com/Slikrick/tubomyevic.git .
#
# Set git branch as master
# docker build --build-arg branch=master .
# ----------------------------------------------------------------------------
# Usage
# docker run --rm -dti --name=evic -v {local_code_path}:/opt/tubomyevic {image_id}
# ----------------------------------------------------------------------------
# Build image and output to {local_code_path}/bin
# docker exec -it evic bash -c "./build.sh"
FROM debian
WORKDIR /opt

ARG repo
ARG branch
ENV repo=${repo:-https://github.com/Slikrick/tubomyevic.git}
ENV branch=${branch:-master}
ENV EVICSDK=/opt

# Install all required packages
RUN apt-get update
RUN apt-get install -y git gcc-arm-none-eabi libnewlib-arm-none-eabi gcc make python3 python3-pip python3-setuptools python3-dev libhidapi-dev python3-hidapi python3-hid wget bash-completion procps vim

# Set up the environment to be a bit more friendly
RUN echo '/etc/bash_completion' > /root/.bash_profile

# Clone and configure python-evic
RUN git clone https://github.com/Ban3/python-evic
RUN cd python-evic; python3 setup.py install

# Clone and link OpenNuvoton library repo
RUN git clone https://github.com/OpenNuvoton/M451BSP nuvoton-sdk

# Clone tubomyevic repo
RUN echo $repo
RUN git clone -b ${branch} ${repo}

# Create custom commands to ease docker exec calls
RUN echo 'cd ./tubomyevic; make' > ./build.sh
RUN chmod +x ./build.sh
RUN ./build.sh

RUN echo 'cd ./tubomyevic; make clean' > ./clean.sh
RUN chmod +x ./clean.sh
RUN ./clean.sh

# Install the evic-sdk for reference
RUN git clone https://github.com/ReservedField/evic-sdk.git

# Mounted volumes
VOLUME ["/opt/tubomyevic"]
