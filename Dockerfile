FROM jenkins/jnlp-slave

LABEL maintainer="Thomas Brown <tabsoftwareconsulting@gmail.com>"

# set user for modifying image
USER root

RUN apt-get -q -y update && apt-get -q -y install \
    clang \
    g++ \
    \
    libboost-dev \
    cmake \
    make \
    \
    doxygen \
    graphviz \
    \
    libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*

# restore user
USER jenkins

# set up Boost.Build
RUN echo > "${HOME}/user-config.jam"
RUN echo "using doxygen ;" >> "${HOME}/user-config.jam"
RUN echo "using gcc ;" >> "${HOME}/user-config.jam"
RUN echo "using clang ;" >> "${HOME}/user-config.jam"
RUN echo "using boost : \"\" : <include>/usr/include <library>/usr/lib <layout>system ;" >> "${HOME}/user-config.jam"

# @todo the contrib/boost.jam file is missing from the installation on
# the underlying Docker (Debian Stretch), so add it
COPY boost.jam "${HOME}"
