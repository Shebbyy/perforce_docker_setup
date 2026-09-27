FROM ubuntu:24.04

ARG P4_VERSION=25.2
ARG P4ARCH=amd64

ENV DEBIAN_FRONTEND=noninteractive
ENV P4USER=p4

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gosu \
        tini \
        gnupg2 \
    && rm -rf /var/lib/apt/lists/*

RUN adduser --disabled-password --gecos "" $P4USER

RUN curl -fsSL \
        "https://package.perforce.com/perforce.pubkey" \
        | gpg --dearmor -o /usr/share/keyrings/perforce.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/perforce.gpg] https://package.perforce.com/apt/ubuntu noble release" \
        > /etc/apt/sources.list.d/perforce.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        helix-p4d \
        helix-cli \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p \
        /perforce \
        /perforce/serverdata \
        /perforce/serverjournals \
        /perforce/servercheckpoints \
        /perforce/serverlibrary
RUN chown -R p4:p4 /perforce

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 1666

ENTRYPOINT ["/usr/bin/tini", "--"]
CMD ["/entrypoint.sh"]

