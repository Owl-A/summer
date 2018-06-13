docker run -d \
  --restart=always \
  --name registry \
  -v "$PWD/certs:/certs" \
  -v "$PWD/config.yml:/etc/docker/registry/config.yml" \
  -v "/mnt/docker/registry:/var/lib/registry" \
  -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/registry.crt \
  -e REGISTRY_HTTP_TLS_KEY=/certs/registry.key \
  -p 443:443 registry
