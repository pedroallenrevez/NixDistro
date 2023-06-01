[![Hive](https://img.shields.io/badge/Nix-Hive-yellow?style=for-the-badge&logo=NixOS)](https://github.com/nix-community/hive)
[![Haumea](https://img.shields.io/badge/Nix-Haumea-blue?style=for-the-badge&logo=NixOS)](https://github.com/nix-community/haumea)
[![Colmena](https://img.shields.io/badge/Nix-Colmena-yellow?style=for-the-badge&logo=NixOS)](https://github.com/zhaofengli/colmena)
[![Nix GL](https://img.shields.io/badge/Nix-GL-orange?style=for-the-badge&logo=NixOS)](https://github.com/guibou/nixGL)

[![NixOS Generators](https://img.shields.io/badge/NixOS-generators-yellowgreen?style=for-the-badge&logo=NixOS)](https://github.com/nix-community/nixos-generators)
[![NixOS Disko](https://img.shields.io/badge/NixOS-disko-blue?style=for-the-badge&logo=NixOS)](https://github.com/nix-community/disko)
[![NixOS Hardware](https://img.shields.io/badge/NixOS-hardware-lightgrey?style=for-the-badge&logo=NixOS)](https://github.com/nixos/nixos-hardware)

Forked from: https://gitlab.com/dar/home-nix

This is an intent to create a development environment experimenting with Hive, a principled approach
to Nix deployment. The objective is the following:
1. Be able to develop a NixOs distribution within a VM;
2. Learn the `divnix` stack:
    1. `colmena` - deploy builds into target machines, in this case a VM;
    2. `disko` - define your disks from a specification;
    3. `nixos-generators` - build an ISO of your distribution that is installable offline;
    4. `nixos-hardware` - define hardware specifications for your machines;
    5. `haumea` - file-system based Nix declarations. Will allow a modular implementation of components you want to add to your OS.
    6. `hive` - principled approach to modular deployment, eliminating a lot of boilerplate, but introducing a lot of prerequisite knowledge; Just look at [Hive](https://github.com/divnix/hive)

# Prerequisites

In order to understand how to use this complex stack of Nix-related software you should have an understanding of:
1. `nix` language and it's specification, and progamming capabilities, so you won't get lost on code details;
2. `NixOs` and how a regular distribution is provisioned. You should have personal experience with deploying your own OS for your own personal use;
3. `nix-flakes` an "experimental" feature that everyone uses. It is the fundamental on how to create modular Nix software, and how to compose complex architectures.
4. An intuitive understanding of the purposes of each tool, that are documented but seldomly used, and only understood by a select group of people. The 

Thus, the intended purpose of this project is to bring it to the attention of people, by creating a sane template that people can develop from, without needing to understand every intrincancy of the projects.
The objective is to be able to provide the means to test your OS implementation on a VM, simulating a remote deployment, but being able to deploy it locally (in case you are already in a NixOs environment), and finally generate your own installable NixDistro!

# Development Environment

The repo defines two main hosts:
1. `repo-larva` - the builder node, and Nix development environment. This is a host which function is to deploy other NixOS builds, and not your main OS.
2. `vm-vagrant` - the development target of your OS, a template to go from.

To start a development environment for this flake:
```
$ nix develop
🔨 Welcome to Apis Mellifera

[general commands]

  menu           - prints this menu
  treefmt        - one CLI to format the code tree

[hexagon]

  build-larva    - the hive x86_64-linux iso-bootstrapper
  colmena        - A simple, stateless NixOS deployment tool
  disko          - Format disks with nix-config
  home-manager   - A user environment configurator
  nixos-generate - Collection of image builders
  writedisk      - Small utility for writing a disk image to a USB drive
```

The development environment offers CLI utilities:
1. `build-larva` - build an ISO of the builder-node, using `nixos-generators` to construct an install-iso;
2. `colmena`, `disko`, `home-manager`, `nixos-generate` - wrappers around the nix utilities;
3. `writedisk` - write your ISOs to an USB stick.


# Vagrant VMs
pamac build cockpit cockpit-machines vagrant
vagrant plugin install vagrant-libvirt
systemctl start libvirtd.service
systemctl start cockpit.socket

# Use virsh (libvirt) to create a local network
virsh net-list --all
# Create a net.xml with specifications, routing through mullvad
```
<network>
  <name>mynetwork</name>
  <forward mode="route" dev="wg-mullvad"/>
  <bridge name="virbr0" stp="off" delay="0"/>
  <ip address="192.168.123.1" netmask="255.255.255.0">
    <dhcp>
      <range start="192.168.123.100" end="192.168.123.200"/>
    </dhcp>
  </ip>
</network>
```
virsh net-define /path/to/mynetwork.xml
virsh net-start <network-name>
virsh net-info <network-name>

# follow instructions on vagrantfile for
# 1. Architecture, memory, disks and firmware 
# 2. Networking
# 3. Display of graphical interface
# install virt-viewer to connect to graphical vms
