#!/bin/sh
if [ "$#" -ne 4 ]; then 
  echo "Usage: $0 <lab-num> <debian-qcow2-img> <vm-name> <xml-specs-for-vm>"
  exit 1 
fi

# create a fresh image
echo "1: Creating a fresh image"
cp $2 ./$3.qcow2
cp ./lab/lab$1.sh ./lab.sh 
cp ./lab/labd$1 ./destroy.sh
echo "2: copying the lab scripts"
virt-copy-in -a ./$3.qcow2 ./lab.sh /etc/init.d/
virt-copy-in -a ./$3.qcow2 ./destroy.sh /etc/init.d/
mv $3.qcow2 /var/lib/libvirt/images/

# replace the ids and macs
echo "3: Editing the Config file now"
cp $4 ./$3-conf.xml
sed -e /\<uuid\>/d -i $3-conf.xml
sed -e /\<mac\ address/d -i $3-conf.xml
sed -e s/test/$3/ -i $3-conf.xml

# define and deploy
echo "4: Define and deploy"
virsh define $3-conf.xml
virsh start $3

# cleaning 
echo "5: removing the temporary file"
rm ./lab.sh
rm ./$3-conf.xml
