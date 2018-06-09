FROM linuxkit/alpine:v0.1 as alpine
# containerd v1.1.x requires go1.10 which is currently a separate package in Alpine 3.7
# Use the same version of go for consistency.

ENV cni_version v0.7.1

RUN \
  apk add \
  bash \
  gcc \
  git \
  go1.10 \
  libc-dev \
  libseccomp-dev \
  linux-headers \
  make \
  && true
ENV GOPATH=/go PATH=$PATH:/go/bin

#ENV CNI_BRANCH pull/NNN/head
ENV CNI_COMMIT ${cni_version}
RUN mkdir -p $GOPATH/github.com/containernetworking/ && \
    cd $GOPATH/github.com/containernetworking/ && \
    git clone https://github.com/containernetworking/plugins plugins
WORKDIR $GOPATH/github.com/containernetworking/plugins
RUN set -e;  \
    if [ -n "$CNI_BRANCH" ] ; then \
        git fetch origin "CNI_BRANCH"; \
    fi; \
    git checkout -q $CNI_COMMIT
RUN ./build.sh
RUN cp bin/* /usr/bin/

RUN mkdir -p /etc/init.d && ln -s /usr/bin/service /etc/init.d/030-cni

FROM scratch
WORKDIR /
ENTRYPOINT []
COPY --from=alpine /usr/bin/bridge /opt/cni/bin/
COPY --from=alpine /usr/bin/dhcp /opt/cni/bin/
COPY --from=alpine /usr/bin/flannel /opt/cni/bin/
COPY --from=alpine /usr/bin/host-device /opt/cni/bin/
COPY --from=alpine /usr/bin/host-local /opt/cni/bin/
COPY --from=alpine /usr/bin/ipvlan /opt/cni/bin/
COPY --from=alpine /usr/bin/loopback /opt/cni/bin/
COPY --from=alpine /usr/bin/macvlan /opt/cni/bin/
COPY --from=alpine /usr/bin/portmap /opt/cni/bin/
COPY --from=alpine /usr/bin/ptp /opt/cni/bin/
COPY --from=alpine /usr/bin/sample /opt/cni/bin/
COPY --from=alpine /usr/bin/tuning /opt/cni/bin/
COPY --from=alpine /usr/bin/vlan /opt/cni/bin/
COPY --from=alpine /etc/init.d/ /etc/init.d/
