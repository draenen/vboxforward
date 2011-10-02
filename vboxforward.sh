#! /bin/bash
# vboxforward.sh
# Setup or remove port forwarding for a VirtualBox VM
# Written by: Caleb Thorne Aug, 2011

action=$1
vbname=$2
service=$3
hostport=$4
guestport=$5

# The device type. Customize this for your machine.
DEVICE="e1000"

help () {
   echo "Proper Usage:"
   echo "./vboxforward.sh add <virtual machine name> <service> <host port> <guest port>"
   echo "./vboxforward.sh remove <virtual machine name> <service>"
}

if [[ -z "$1" || "$1" == "help" ]]; then
   echo "vboxforward.sh"
   echo "Written by Caleb Thorne Aug, 2011"
   echo ""
   help
   exit
fi

# Make sure the vitual machine name is provided
if [ -z "$vbname" ]; then
   echo "ERROR: Missing virtual machine name."
   help
   exit
fi

# Make sure the service name is provided
if [ -z "$service" ]; then
   echo "ERROR: Missing service name."
   help
   exit
fi

# Add a service forward
if [[ "$action" == "add" ]]; then

   # Make sure host port is provided
   if [ -z "$hostport" ]; then
      echo "ERROR: Missing host port."
      help
      exit
   fi

   if [ -z "$guestport" ]; then
      echo "ERROR: Missing guest port."
      help
      exit
   fi

   echo "Forwarding $service from host:$hostport to guest:$guestport for $vbname."
   VBoxManage setextradata "$vbname" "VBoxInternal/Devices/$DEVICE/0/LUN#0/Config/$service/Protocol" TCP
   VBoxManage setextradata "$vbname" "VBoxInternal/Devices/$DEVICE/0/LUN#0/Config/$service/GuestPort" $guestport
   VBoxManage setextradata "$vbname" "VBoxInternal/Devices/$DEVICE/0/LUN#0/Config/$service/HostPort" $hostport

elif [[ "$action" == "remove" ]]; then

   echo "Removing forwarding for $service from $vbname."
   VBoxManage setextradata "$vbname" "VBoxInternal/Devices/pcnet/0/LUN#0/Config/$service/Protocol"
   VBoxManage setextradata "$vbname" "VBoxInternal/Devices/pcnet/0/LUN#0/Config/$service/GuestPort"
   VBoxManage setextradata "$vbname" "VBoxInternal/Devices/pcnet/0/LUN#0/Config/$service/HostPort"

else
   echo "ERROR: Invalid option."
   help
   exit
fi

echo "Done."
exit