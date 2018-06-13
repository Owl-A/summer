#!/bin/bash

subnet=172.18.0.0/16
proxyip=172.18.0.2
clientip=172.18.0.3
homedir=/root/.mitmproxy

docker network create --subnet $subnet proxynet 

docker run --rm -itd --network proxynet --ip $proxyip --name proxy sgrio/mitmproxy

TMP=$RANDOM
if [ -d /tmp/$TMP ]; then
  TMP=$RANDOM
fi

mkdir /tmp/$TMP

docker exec proxy sh -c "mkdir $homedir" 
docker exec proxy sh -c "openssl genrsa -out $homedir/cert.key 2048"
docker exec proxy sh -c "openssl req -new -x509 -key $homedir/cert.key -out $homedir/mitmproxy-ca.crt -subj \"/CN=mitmproxy\""
docker exec proxy sh -c "cat $homedir/cert.key $homedir/mitmproxy-ca.crt > $homedir/mitmproxy-ca.pem"
docker exec proxy sh -c "rm $homedir/cert.key"

docker cp proxy:$homedir/mitmproxy-ca.crt /tmp/$TMP/

docker run --rm -itd --network proxynet --ip $clientip --name client --env PROXY=$proxyip:8080 --env CERT="$(cat /tmp/$TMP/mitmproxy-ca.crt)" owla/debian-proxy-client

rm -r /tmp/$TMP
