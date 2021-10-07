ARG ZIG_VERSION=0.9.0-dev.1324+598db831f
ARG ZIG_SUM=489c298cca541157b98ed2b9da79d21907262f12932816bdc4ea91bec915b2eb

# Targeting minimum supported version of MacOS.
# https://en.wikipedia.org/wiki/MacOS_version_history
ARG MAC_VERSION=10.14
ARG MAC_LATEST=11.3
ARG MAC_SUM=123dcd2e02051bed8e189581f6eea1b04eddd55a80f98960214421404aa64b72

FROM golang:latest AS base

FROM base AS dep-base
RUN apt update && apt install -y xz-utils

FROM dep-base AS zig
ARG ZIG_VERSION
ARG ZIG_SUM
ADD https://ziglang.org/builds/zig-linux-x86_64-${ZIG_VERSION}.tar.xz "/opt/zig.xz"
RUN echo "${ZIG_SUM}" "/opt/zig.xz" | sha256sum -c -
RUN tar -C /opt -xf "/opt/zig.xz"
RUN mv /opt/zig-linux-x86_64-${ZIG_VERSION} /opt/zig

FROM dep-base AS mac
ARG MAC_VERSION
ARG MAC_LATEST
ARG MAC_SUM
ADD https://github.com/phracker/MacOSX-SDKs/releases/download/${MAC_LATEST}/MacOSX${MAC_VERSION}.sdk.tar.xz "/opt/mac.sdk.xz"
RUN echo "${MAC_SUM}" "/opt/mac.sdk.xz" | sha256sum -c -
RUN tar -C /opt -xf "/opt/mac.sdk.xz"
RUN mv /opt/MacOSX${MAC_VERSION}.sdk /opt/mac.sdk

FROM base AS final
COPY --from=zig /opt/zig /opt/zig
COPY --from=mac /opt/mac.sdk /opt/mac.sdk
COPY ./bin /bin/
ENV ZIG_LOCAL_CACHE_DIR=/root/zig-cache
ENV CC=zcc
ENV CXX=zxx
ENV CGO_ENABLED=1
ENV PATH=/opt/zig:$PATH

ENTRYPOINT ["entrypoint"]
