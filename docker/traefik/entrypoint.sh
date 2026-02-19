#!/usr/bin/env sh
set -e

fqdn="${FQDN?'Missing FQDN'}"
org="${CERTIFICATE_ORG:-Traefik Dev Proxy}"
certs_dir="/opt/traefik/certs"

cd "$certs_dir"

# --- Root CA (created once, long-lived) ---
if [ ! -f ca.key ]; then
  echo "==> Generating root CA..."
  openssl genrsa -out ca.key 4096
  openssl req -x509 -new -nodes \
    -key ca.key \
    -sha256 \
    -days 3650 \
    -out ca.crt \
    -subj "/O=${org} CA/CN=${org} Root CA"
  chmod 600 ca.key
  chmod 644 ca.crt
  echo "==> Root CA generated."
fi

# --- Server cert (regenerate if missing or FQDN changed) ---
current_fqdn=""
[ -f server.fqdn ] && current_fqdn=$(cat server.fqdn)

if [ ! -f server.crt ] || [ "$current_fqdn" != "$fqdn" ]; then
  echo "==> Generating server certificate for *.${fqdn}..."
  openssl genrsa -out server.key 4096
  openssl req -new \
    -key server.key \
    -out server.csr \
    -subj "/O=${org}/CN=*.${fqdn}"
  openssl x509 -req \
    -in server.csr \
    -CA ca.crt \
    -CAkey ca.key \
    -CAcreateserial \
    -out server.crt \
    -days 730 \
    -sha256 \
    -extfile <(printf "subjectAltName=DNS:*.%s,DNS:%s" "$fqdn" "$fqdn")
  rm server.csr
  chmod 600 server.key
  chmod 644 server.crt
  echo "$fqdn" > server.fqdn
  echo "==> Server certificate generated."
fi

exec /entrypoint.original.sh "$@"
