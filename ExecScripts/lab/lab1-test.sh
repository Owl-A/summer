
# creating the networks
#docker network create --subnet 172.18.0.0/16 net1
#docker network create --subnet 172.19.0.0/16 net2
docker network create --subnet 172.20.0.0/16 mitm

# run nodes on only one network
docker container run --privileged -p 8080:22 --network=mitm --ip 172.20.0.2 -itd --name=cont3 owla/debian-ssh:latest
docker container run --privileged -p 4040:22 --network=mitm --ip 172.20.0.3 -itd --name=cont1 owla/debian-ssh:latest
docker container run --privileged -p 6060:22 --network=mitm --ip 172.20.0.4 -itd --name=cont2 -e DISPLAY=$DISPLAY miraj50/debian-wshark:latest
