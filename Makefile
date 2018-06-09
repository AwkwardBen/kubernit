.PHONY: all build vhd pkg
all: pkg build iso

pkg:
	@make -C tools/alpine build
	linuxkit pkg build -org=wombat -disable-content-trust -dev pkg/init
	linuxkit pkg build -org=wombat -disable-content-trust -dev pkg/containerd
	linuxkit pkg build -org=wombat -disable-content-trust -dev pkg/cni
	linuxkit pkg build -org=wombat -disable-content-trust -dev pkg/runc
	linuxkit pkg build -org=wombat -disable-content-trust -dev pkg/ca-certificates
	linuxkit pkg build -org=wombat -disable-content-trust -dev pkg/getty

	linuxkit pkg build -org=wombat -disable-content-trust -dev pkg/sysctl
	linuxkit pkg build -org=wombat -disable-content-trust -dev pkg/sysfs
	linuxkit pkg build -org=wombat -disable-content-trust -dev pkg/metadata
	linuxkit pkg build -org=wombat -disable-content-trust -dev pkg/format
	linuxkit pkg build -org=wombat -disable-content-trust -dev pkg/mount
	linuxkit pkg build -org=wombat -disable-content-trust -dev pkg/dhcpcd

	linuxkit pkg build -org=wombat -disable-content-trust -dev pkg/rngd
	linuxkit pkg build -org=wombat -disable-content-trust -dev pkg/openntpd
	linuxkit pkg build -org=wombat -disable-content-trust -dev pkg/sshd
	linuxkit pkg build -org=wombat -disable-content-trust -dev pkg/kubelet

build:
	linuxkit build -format kernel+initrd -dir ${PWD}/config/assets kubernit.yaml

iso:
	linuxkit build -format iso-bios kubernit.yaml

vhd:
	linuxkit build -format vhd kubernit.yaml
