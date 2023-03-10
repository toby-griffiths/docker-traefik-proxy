#!/usr/bin/env sh

fqdn="${FQDN?'Missing FQDN'}"
org="${CERTIFICATE_ORG:-Traefik Dev Proxy}"

if [[ ! -f "/opt/traefik/certs/server.crt" ]] ; then
    echo "${fqdn}"
    openssl req -x509 -nodes -days 365 \
        -newkey rsa:4096 \
        -keyout /opt/traefik/certs/server.key \
        -out /opt/traefik/certs/server.crt \
        -subj "/O=${org}" \
        -addext "subjectAltName = DNS:*.${fqdn}"

    chmod 644 /opt/traefik/certs/server.crt
    chmod 600 /opt/traefik/certs/server.key
fi

exec /entrypoint.original.sh "$@"
