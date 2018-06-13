docker run -d \
  --restart=always \
  --name registry \
  -v "$PWD/config.yml:/etc/docker/registry/config.yml" \
  -p 5000:5000 \
  registry:2
