# Kick-off virtual network named default
network-init:
    virsh net-define net.xml

network-bridge-create:
    brctl addbr virbr0
    brctl stp virbr0 off

network-bridge-delete:
    ip link delete virbr0

# Start a network using virsh
network-start:
    virsh net-start vpn

network-destroy:
    virsh net-destroy vpn
    virsh net-undefine vpn