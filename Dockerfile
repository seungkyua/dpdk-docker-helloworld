FROM centos:7.2.1511
MAINTAINER Seungkyu Ahn <seungkyua@gmail.com>
ENV REFRESHED_AT 2016-07-13

LABEL docker run --rm -it --privileged \
-v /sys/bus/pci/devices:/sys/bus/pci/devices \
-v /sys/kernel/mm/hugepages:/sys/kernel/mm/hugepages \
-v /sys/devices/system/node:/sys/devices/system/node \
-v /dev:/dev \
-v /mnt/huge:/mnt/huge \
--name dpdk-docker dpdk-docker-helloworld

ENV DPDK_VERSION=16.04
ENV RTE_SDK=/root/dpdk-${DPDK_VERSION}
ENV RTE_TARGET=build

USER root

# yum update
RUN yum -y update
RUN yum install -y deltarpm gcc make libhugetlbfs-utils libpcap-devel; yum clean all
RUN yum install -y kernel kernel-devel kernel-headers; yum clean all

# dpdk download
COPY modules /lib/modules
COPY kernels /usr/src/kernels
WORKDIR /root
RUN curl -OL http://dpdk.org/browse/dpdk/snapshot/dpdk-${DPDK_VERSION}.tar.gz
RUN tar xzf dpdk-${DPDK_VERSION}.tar.gz
WORKDIR /root/dpdk-${DPDK_VERSION}
RUN make config T=x86_64-native-linuxapp-gcc
RUN make

# rm modules and kernels directory
#RUN rm -rf /lib/modules/
#RUN rm -rf /usr/src/kernels/

# Loading Modules to Enable Userspace IO for DPDK
RUN modprobe uio_pci_generic
RUN modprobe vfio-pci

WORKDIR examples/helloworld
RUN make
WORKDIR build/app
ENTRYPOINT [ "./helloworld" ]
CMD [ "-c", " 3", "-n", "3" ]
