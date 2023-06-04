FROM node:18

ENV LIBPOSTAL_DIR="/libpostal"

# Install libpostal dependencies
RUN apt-get update && apt-get install -y \
    curl autoconf automake libtool pkg-config build-essential

RUN mkdir -p $LIBPOSTAL_DIR
RUN git clone https://github.com/openvenues/libpostal $LIBPOSTAL_DIR

# Compile and install libpostal
WORKDIR $LIBPOSTAL_DIR
RUN ./bootstrap.sh && ./configure
RUN make -j4 && make install && ldconfig

# Install node-gyp so node-postal works
RUN npm install -g node-gyp

# Clean up
RUN rm -rf /libpostal && \
    apt-get remove -y build-essential autoconf automake libtool curl && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
