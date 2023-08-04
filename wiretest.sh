#!/usr/bin/env bash
set -e

ns_name=wiretest
ns_ip=10.0.0.2/24
host_ip=10.0.0.1/24

case "$1" in
	"addip")
		[ "$2" != '' ] && interface=$2 || { echo "Missing argument: interface"; exit 1; }
		ip addr add $host_ip dev $interface
		ip addr show $interface
		exit 0
		;;
	"delip")
		[ "$2" != '' ] && interface=$2 || { echo "Missing argument: interface"; exit 1; }
		ip addr del $host_ip dev $interface
		ip addr show $interface
		exit 0
		;;
	"addns")
		[ "$2" != '' ] && interface=$2 || { echo "Missing argument: interface"; exit 1; }
		ip netns add $ns_name
		ip link set $interface netns $ns_name
		ip netns exec $ns_name ip addr add $ns_ip dev $interface
		ip netns exec $ns_name ip link set $interface up
		ip netns show
		ip netns exec $ns_name ip addr show $interface
		exit 0
		;;
	"delns")
		ip netns del $ns_name || true
		ip netns show
		exit 0
		;;
	"exec")
		shift
		[ "$1" != '' ] && command=$@ || { echo "Missing argument: command"; exit 1; }
		ip netns exec $ns_name $command
		exit 0
		;;
	"dev")
		ip link show
		exit 0
		;;
	"ip")
		ip addr show
		exit 0
		;;
	*)
		echo "Usage: $0 <addip|delip|addns|delns|exec|dev|ip> [interface|command]"
		exit 1
		;;
esac

