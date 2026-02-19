#!/usr/bin/env sh

traefik_version=3.6.8

TRAEFIK_VERSION=$traefik_version docker compose build \
    --pull \
    --no-cache \
    --push

echo
echo "**********************************************************************"
echo "Image 'tobygr/traefik-proxy:$traefik_version' built"
echo
echo "If you want to update the latest image run…"
echo
echo "$ docker tag tobygr/traefik-proxy:$traefik_version tobygr/traefik-proxy:latest"
echo
echo "You may also want to remove the build layers using…"
echo
echo "$ docker image prune --force"
echo "**********************************************************************"
