FROM bitnami/minideb:latest

ENV REFRESHED_AT 2022-01-12

# set up a tools dev directory
WORKDIR /home/dev

#COPY gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 .

#latest cmake binary here: https://cmake.org/download/
RUN apt-get update \
    && apt-get install -y build-essential libssl-dev \
    && apt-get install -y apt-transport-https ca-certificates gnupg software-properties-common wget \
    && wget https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1.tar.gz \
    && tar -zxvf cmake-3.22.1.tar.gz \
    && rm cmake-3.22.1.tar.gz \
    && cd cmake-3.22.1 \
    && ./bootstrap \
    && make \
    && make install

#latest arm toolchain here: https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-rm/downloads
RUN apt-get update \
    && apt-get -y install \
    git \
    lib32z1 \
    libncurses5 \
    git \
    clang \
    python-pip \
    && pip install invoke \
    && wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 \
    && tar xvf gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 \
	&& rm gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 \
    && mv gcc-arm-none-eabi-10.3-2021.10 gcc-arm-none-eabi \
    && rm -rf /home/dev/gcc-arm-none-eabi/share/doc \
    && cd gcc-arm-none-eabi/bin \
    && cp arm-none-eabi-gdb /usr/bin/ \
    && cp arm-none-eabi-objcopy /usr/bin/    

ENV PATH $PATH:/home/dev/gcc-arm-none-eabi/bin

#git clone stm32f4 && cmake-stm32
#remove projects, save 1 gig of space
WORKDIR /usr/lib
RUN git clone https://github.com/ObKo/stm32-cmake.git ./stm32-cmake && \
git clone https://github.com/STMicroelectronics/STM32CubeF4.git ./STM32CUBEF4 && \
rm -rf /usr/lib/STM32CUBEF4/Projects

#fixes an issue with duplicate template files from STM32CUBEMX code generation
#also finds the asm startup file
#COPY FindCMSIS.cmake ./stm32-cmake/cmake

#Set up the complier path
WORKDIR /usr/project

#docker build -t <user/name>:<version> .
