FROM resin/raspberry-pi-alpine:3.6

RUN [ "cross-build-start" ]

VOLUME /etc/letsencrypt /var/lib/letsencrypt
WORKDIR /opt/certbot

RUN apk update \
    && apk add --no-cache --virtual .certbot-deps \
      binutils \
      ca-certificates \
      libffi \
      libssl1.0 \
      openssl \
      python3 \
      python3-dev \
    && apk add --no-cache --virtual .build-deps \
      gcc \
      git \
      libffi-dev \
      linux-headers \
      musl-dev \
      openssl-dev \
    && git clone https://github.com/certbot/certbot.git /opt/certbot \
    && git checkout tags/v0.25.1 \
    && cd /opt/certbot \
    && pip3 install --no-cache-dir --upgrade \
         pip \
        --editable /opt/certbot/acme \
        --editable /opt/certbot \
    && apk del .build-deps

RUN [ "cross-build-end" ]

ENTRYPOINT [ "certbot" ]
