FROM quay.io/centos-bootc/centos-bootc:stream10 AS builder
RUN rm -rf /etc/yum.repos.d
COPY almalinux.repo /etc/yum.repos.d/
COPY almavirt.yaml /usr/share/doc/bootc-base-imagectl/manifests/
RUN /usr/libexec/bootc-base-imagectl build-rootfs --manifest=almavirt /target-rootfs
FROM scratch
COPY --from=builder /target-rootfs /
LABEL containers.bootc 1
LABEL ostree.bootable true
LABEL bootc.diskimage-builder quay.io/centos-bootc/bootc-image-builder
LABEL redhat.id almalinux
LABEL redhat.version-id 10
ENV container=oci
STOPSIGNAL SIGRTMIN+3
CMD ["/sbin/init"]