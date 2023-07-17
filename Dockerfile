ARG TRAEFIKVERSION=2.10

FROM traefik:$TRAEFIKVERSION

# provide the servername as a configurable option
# note that this is self signed so you should still add it to your
# trusted certificates every time you rebuild this images.
# For Chrome: click on the lock icon and export it
# then browse to chrome://settings/certificates and add it. Then restart

# add a self signed certificate
# note: it might be a good thing to remove the openssl package again to
# reduce the attack surface.

RUN apk add --no-cache openssl

WORKDIR /opt/traefik/certs

COPY docker/traefik/etc/traefik /etc/traefik

RUN mv /entrypoint.sh /entrypoint.original.sh

COPY docker/traefik/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh
