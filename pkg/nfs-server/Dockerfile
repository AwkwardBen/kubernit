FROM wombat/alpine:v0.1 AS mirror

RUN mkdir -p /out/etc/apk && cp -r /etc/apk/* /out/etc/apk/
RUN apk add --no-cache --initdb -p /out \
    nfs-utils \
    rpcbind \
    iptables \
    && true
RUN rm -rf /out/etc/apk /out/lib/apk /out/var/cache

ADD nfs-boot.sh /out/usr/bin/nfs-boot.sh

FROM scratch
ENTRYPOINT []
WORKDIR /
COPY --from=mirror /out/ /
COPY etc/ /etc/
EXPOSE 111/udp 2049/tcp
CMD ["/usr/bin/nfs-boot.sh"]
