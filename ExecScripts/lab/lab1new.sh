T=0
while [ $T -eq 0 ]
do 
  docker pull owla/debian-ssh:latest && T=1 || T=0
done
T=0
while [ $T -eq 0 ]
do 
  docker pull miraj50/debian-wshark:latest && T=1 || T=0
done
T=0
while [ $T -eq 0 ]
do 
  docker pull busybox && T=1 || T=0
done

# creating the networks
docker network create --internal --subnet 172.18.0.0/16 net1
docker network create --internal --subnet 172.19.0.0/16 net2
docker network create --subnet 172.20.0.0/16 mitm

# run nodes on only one network
docker container run --privileged -p 8080:22 --network=mitm --ip 172.20.0.2 -itd --name=cont3 busybox
docker container run --privileged -p 4040:22 --network=mitm --ip 172.20.0.3 -itd --name=cont1 busybox
docker container run --privileged -p 6060:22 --network=mitm --ip 172.20.0.4 -itd --name=cont2 -e DISPLAY=$DISPLAY miraj50/debian-wshark:latest

# make a bridging node between two networks
docker network connect --ip 172.18.0.2 net1 cont1 
docker network connect --ip 172.19.0.2 net2 cont3 
docker network connect --ip 172.18.0.3 net1 cont2 
docker network connect --ip 172.19.0.3 net2 cont2 

# add static routes to cont1 and cont2 to make the private networks visible to each other
#docker exec cont3 ip route add 172.18.0.0/16 via 172.19.0.3
#docker exec cont1 ip route add 172.19.0.0/16 via 172.18.0.3
docker exec cont3 route add -net 172.18.0.0 netmask 255.255.0.0 gw 172.19.0.3
docker exec cont1 route add -net 172.19.0.0 netmask 255.255.0.0 gw 172.18.0.3


# docker run -itd --privileged --net=net1 --name chinjune -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY manell/wireshark
