FROM alpine:latest

MAINTAINER Karel Fiala <fiala.karel@gmail.com>

ENV PATH="/opt/bin:${PATH}" \
    EASYRSA_CRL_DAYS=3650 \
    EASYRSA_CA_EXPIRE=3650 \
    EASYRSA_CERT_EXPIRE=3650

COPY bin /opt/bin

RUN apk --no-cache add openvpn easy-rsa \
    && mkdir /opt/openvpn \
    && chmod -R +x /opt/bin

ENTRYPOINT ["/opt/bin/startup.sh"]