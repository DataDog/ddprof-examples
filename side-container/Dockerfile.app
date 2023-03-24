FROM ubuntu:20.04 AS base
ENV CLANG_VERSION=11
ENV CC=clang-${CLANG_VERSION}
ENV CXX=clang++-${CLANG_VERSION}

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    clang-${CLANG_VERSION} \
    lld-${CLANG_VERSION} \
    cmake \
    git \
    && rm -rf /var/lib/apt/lists/*

# Retrieve a program to run
RUN git clone --depth 1 --branch ddprof_ci_v3 https://github.com/DataDog/bad-boggle-solver.git

# Build and install toy project
RUN cd bad-boggle-solver \
    && mkdir build \
    && cd build \
    && cmake -DCMAKE_BUILD_TYPE=Release ../ \
    && make -j 4 \
    && make install

CMD ["BadBoggleSolver_run", "1000000000" ]
