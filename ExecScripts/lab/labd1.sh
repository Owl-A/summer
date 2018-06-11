#!/bin/sh -e
set -e
L="docker container rm -f"
for i in $(seq 1 3) ; do
  $L cont$i || true
done
docker network prune --force
exit 0
