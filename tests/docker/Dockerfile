FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

ARG HTTP_PROXY=
ARG HTTPS_PROXY=
ARG NO_PROXY=
ARG http_proxy=
ARG https_proxy=
ARG no_proxy=

RUN apt-get update \
 && apt-get install -y --no-install-recommends fail2ban \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /test

COPY run-tests.sh /usr/local/bin/run-tests.sh
RUN chmod +x /usr/local/bin/run-tests.sh

ENTRYPOINT ["/usr/local/bin/run-tests.sh"]
