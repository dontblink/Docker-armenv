FROM bitnami/minideb

ENV REFRESHED_AT 2020-06-20

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
    extra-cmake-modules \
    clang \
    && tar xvf gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 \
	&& rm gcc-arm-none-eabi-9-2020-q2-update-x86_64-linux.tar.bz2 \
    && rm -rf /home/dev/gcc-arm-none-eabi-9-2020-q2-update/share/doc \
    && cd gcc-arm-none-eabi-9-2020-q2-update/bin \
    && cp arm-none-eabi-gdb /usr/bin/ \
    && cp arm-none-eabi-objcopy /usr/bin/

#Set up the complier path
ENV PATH $PATH:/home/dev/gcc-arm-none-eabi-9-2020-q2-update/bin
WORKDIR /usr/project
