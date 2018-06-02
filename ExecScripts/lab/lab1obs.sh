T=0
while [ $T -eq 0 ]
do 
  docker pull busybox && T=1 || T=0
done

# creating the networks
docker network create --subnet 172.18.0.0/16 net1
docker network create --subnet 172.19.0.0/16 net2

# run nodes on only one network
docker container run --privileged --network=net2 --ip 172.19.0.2 -itd --name=cont3 busybox 
docker container run --privileged --network=net1 --ip 172.18.0.2 -itd --name=cont1 busybox 

# make a bridging node between two networks
docker container run --network=net2 --ip 172.19.0.3 -itd --name=cont2 busybox 
docker network connect --ip 172.18.0.3 net1 cont2 

# add static routes to cont1 and cont2 to make the private networks visible to each other
docker exec cont3 route add -net 172.18.0.0 netmask 255.255.0.0 gw 172.19.0.3
docker exec cont1 route add -net 172.19.0.0 netmask 255.255.0.0 gw 172.18.0.3

# docker run -itd --privileged --net=net1 --name chinjune -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY manell/wireshark
