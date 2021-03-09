#!/bin/sh
killall keepalived
ip netns del router1
ip netns del router2
ip netns del client

ip netns add router1
ip netns add router2
ip netns add client

ip link add client-router1 type veth peer router1-client
ip link add client-router2 type veth peer router2-client
ip link set client-router1 netns client
ip link set client-router2 netns client
ip link set router1-client netns router1
ip link set router2-client netns router2

ip netns exec router1 ip link set router1-client up
ip netns exec router2 ip link set router2-client up
ip netns exec client ip link set client-router1 up
ip netns exec client ip link set client-router2 up

ip netns exec client ip link add name br-router type bridge
ip netns exec client ip link set br-router up
ip netns exec client ip link set client-router1 master br-router
ip netns exec client ip link set client-router2 master br-router

ip netns exec client ip addr add 192.168.0.100/24 dev br-router
ip netns exec router1 ip addr add 192.168.0.2/24 dev router1-client
ip netns exec router2 ip addr add 192.168.0.3/24 dev router2-client

keepalived -n -f router1-keepalived.conf -l &
keepalived -n -f router2-keepalived.conf -l &