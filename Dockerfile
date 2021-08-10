FROM debian AS tubomyevi
RUN apt-get update
# Install all required packages
RUN apt-get install -y git gcc-arm-none-eabi libnewlib-arm-none-eabi gcc make python3 python3-setuptools python3-dev libhidapi-dev python3-hidapi python3-hid wget bash-completion

# Set up the environment to be a bit more friendly
RUN echo '/etc/bash_completion' > /root/.bash_profile

# Configure python-evic
RUN git clone https://github.com/Ban3/python-evic
RUN cd python-evic; python3 setup.py install

# Install OpenNuvoton libraries
RUN git clone https://github.com/OpenNuvoton/M451BSP

# This should be a mounted volume
RUN echo 'export EVICSDK=/tubomyevic' >> /root/.bash_profile
RUN git clone -b linkerfix https://github.com/LoricEternus/tubomyevic.git
RUN mkdir /tubomyevic/nuvoton-sdk
RUN ln -s /M451BSP/Library /tubomyevic/nuvoton-sdk/
RUN cd /tubomyevic; make

# RUN git clone https://github.com/ReservedField/evic-sdk.git
# RUN ln -s /M451BSP/Library /evic-sdk
# RUN cd /evic-sdk/; EVICSDK=. make
