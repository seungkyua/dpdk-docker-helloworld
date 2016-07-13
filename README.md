# dpdk-docker-helloworld

precondition
================================
## In a host

1. setting hugepage

  `#echo 256 > /sys/kernel/mm/hugepages/hugepages-2048kB/nr_hugepages`

2. Using Hugepages with the DPDK

  `#mkdir -p /mnt/huge`

  `#mount -t hugetlbfs nodev /mnt/huge`

  `#vi /etc/fstab`

   nodev /mnt/huge hugetlbfs defaults 0 0

source download
=================================

$ mkdir -p github

$ cd github

$ git clone https://github.com/seungkyua/dpdk-docker-helloworld.git

$ cd dpdk-docker-helloworld

$ cp -R /lib/modules .

$ cp -R /usr/src/kernels/ .


build and run
======================================

$ docker build -t dpdk-docker-helloworld .

$ docker run --rm -it --privileged -v /sys/bus/pci/devices:/sys/bus/pci/devices -v /sys/kernel/mm/hugepages:/sys/kernel/mm/hugepages -v /sys/devices/system/node:/sys/devices/system/node -v /dev:/dev -v /mnt/huge:/mnt/huge --name dpdk-docker dpdk-docker-helloworld
