### README

#### Step 1: Prepare the qcow2 image
  - Use *guestmount* (`guestmount -a name.qcow2 -i --rw /mnt`) to mount the .qcow2 to a folder in  /mnt (if nothing is mounted there)
  - copy "./vm daemon/dockghost" to /mnt/etc/init.d/ and *chmod* to 755
  - create *softlinks* using `ln -s /mnt/etc/init.d/dockghost /mnt/etc/rc*.d/K01dockghost` in *={0,1,2,6,S}
  - create *softlinks* using `ln -s /mnt/etc/init.d/dockghost /mnt/etc/rc*.d/S02dockghost` in *={3,4,5}
  - compile `ghost.c` using `g++ -Wall ghost.c -o ghost` and copy `ghost` to `/mnt/usr/sbin/`
  - chmod `ghost` to 755
  - create folder `docker` in `/mnt`
  - create files `/mnt/docker/tally` and `/mnt/docker/log` (log files)
  - `umount /mnt`
  - the qcow2 is ready

#### Step 2: Use exec.sh in /Execscripts/ to launch a vm 
  - to check usage run ./exec.sh

#### Step 3: Check diagnostic files `/docker/log` and `/docker/tally` for any potential faults
