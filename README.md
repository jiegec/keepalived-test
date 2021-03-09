# keeplived-test

Small experiment to use keepalived:

1. Create three netns: client, router1, router2
2. Connect three netns by veth and bridge
3. Start keepalived on router1 and router2
4. Observe ip fallback when router1 is down

Run `setup.sh` and use `ip netns` to inspect netns.
