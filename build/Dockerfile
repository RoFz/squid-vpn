# alpine 3.21 gives us squid-6.12-r0
FROM alpine:3.21

RUN apk add --no-cache \
    bash \
    shadow \
    openssl \
    squid

COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

RUN mkdir /cache \
    mkdir /config

RUN mkdir -p /etc/squid/ssl_cert \
    mkdir -p /var/lib/squid \
    && chown -R squid:users /etc/squid/ssl_cert \
    && chmod 770 /etc/squid/ssl_cert \
    && openssl req -new -newkey rsa:2048 -sha256 -days 365 -nodes -x509 -extensions v3_ca -keyout /etc/squid/ssl_cert/myCA.pem  -out /etc/squid/ssl_cert/myCA.pem -subj "/C=PT/ST=Lisbon/L=Lisbon/O=RoFz/OU=NAS/CN=proxy-ca.homenet" \
    && echo "This root CA certificate needs to be imported into the http clients." \
    && openssl x509 -in /etc/squid/ssl_cert/myCA.pem -outform PEM -out /etc/squid/ssl_cert/myCA-nokey.pem \
    && openssl x509 -in /etc/squid/ssl_cert/myCA.pem -outform DER -out /etc/squid/ssl_cert/myCA.der

RUN usermod -u 1000 -g users -G squid squid \
    && chown -R squid:users /run/squid \
    && chown -R squid:users /var/run/squid \
    && chown -R squid:users /var/cache/squid \
    && chown -R squid:users /var/log/squid \
    && chown -R squid:users /cache \
    && chown -R squid:users /config \
    && chown -R squid:users /etc/squid/ssl_cert \
    && chown -R squid:users /var/lib/squid

USER squid:users

EXPOSE 3128/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
