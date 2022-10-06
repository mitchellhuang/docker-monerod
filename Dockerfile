FROM ubuntu:22.04 as build

ARG VERSION=v0.18.1.2
ARG OS=linux
ARG ARCH=x64
ARG FILE=monero-${OS}-${ARCH}-${VERSION}.tar.bz2
ARG HASH=7d51e7072351f65d0c7909e745827cfd3b00abe5e7c4cc4c104a3c9b526da07e

WORKDIR /monero

RUN apt-get update && apt-get install -y curl bzip2
RUN curl -LO https://downloads.getmonero.org/cli/${FILE}
RUN echo "${HASH} ${FILE}" | sha256sum -c
RUN tar xvf ${FILE} --strip-components=1

FROM gcr.io/distroless/base-debian11

COPY --from=build /monero/monerod /
ENTRYPOINT ["/monerod"]
CMD ["--non-interactive", "--restricted-rpc", "--rpc-bind-ip=0.0.0.0", "--confirm-external-bind"]
