.PHONY: all build vhd pkg

PKG = init containerd runc ca-certificates sysctl sysfs metadata format mount dhcpcd rngd openntpd sshd kubelet

all: base $(PKG) build iso

packages: $(PKG) build iso

base:
	@make -C tools/alpine build

$(PKG):
	@linuxkit pkg build -org=wombat -disable-content-trust -dev pkg/$@

build:
	linuxkit build -format kernel+initrd -dir ${PWD}/config/assets kubernit.yaml

iso:
	linuxkit build -format iso-bios kubernit.yaml
