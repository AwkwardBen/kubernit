.PHONY: all build vhd pkg

PKG = init containerd runc ca-certificates sysctl sysfs metadata format mount dhcpcd rngd openntpd sshd kubelet getty helm

all: base $(PKG) iso

packages: $(PKG) iso

base:
	@make -C tools/alpine build

$(PKG):
	@linuxkit pkg build -org=wombat -disable-content-trust -dev pkg/$@

iso-masters:
	linuxkit build -format iso-bios kubernit_master0.yaml

iso-nodes:
	linuxkit build -format iso-bios kubernit_node0.yaml
	linuxkit build -format iso-bios kubernit_node1.yaml

iso: iso-masters iso-nodes
