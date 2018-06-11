#!/bin/bash
set +e
docker rm -f proxy
docker rm -f client
docker system prune --force
