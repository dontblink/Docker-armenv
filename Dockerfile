FROM bitnami/minideb

ENV REFRESHED_AT 2020-07-12

# set up a tools dev directory
WORKDIR /home/dev

COPY gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 .

RUN apt-get update \
    && apt-get -y install \
    git \
    lib32z1 \
    libncurses5 \
    git \
    cmake \    
    clang \
    python-pip \
    && pip install invoke \
    && tar xvf gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 \
	&& rm gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 \
    && rm -rf /home/dev/gcc-arm-none-eabi-9-2020-q2-update/share/doc \
    && cd gcc-arm-none-eabi-9-2020-q2-update/bin \
    && cp arm-none-eabi-gdb /usr/bin/ \
    && cp arm-none-eabi-objcopy /usr/bin/    

ENV PATH $PATH:/home/dev/gcc-arm-none-eabi-9-2020-q2-update/bin

#git clone stm32f4 && cmake-stm32
#remove projects, save 1 gig of space
WORKDIR /usr/lib
RUN git clone https://github.com/ObKo/stm32-cmake.git ./stm32-cmake && \
git clone https://github.com/STMicroelectronics/STM32CubeF4.git ./STM32CUBEF4 && \
rm -rf /usr/lib/STM32CUBEF4/Projects

#fixes an issue with duplicate template files from STM32CUBEMX code generation
#also finds the asm startup file
COPY FindCMSIS.cmake ./stm32-cmake/cmake

#Set up the complier path
WORKDIR /usr/project
