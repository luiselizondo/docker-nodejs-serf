#!/bin/bash

# Intended to be run like this:
# fig run --rm web /serf-members.sh

echo "Running serf agent first to join the cluster"

# Start serf and then join the cluster, we need to do this
# because if we don't, serf won't be able to communicate with
# the other members of the cluster to know how many members are
nohup serf agent -tag role=web &
nohup serf join $SERF_1_PORT_7946_TCP_ADDR:$SERF_1_PORT_7946_TCP_PORT &

sleep 5
echo "Members in Cluster:"
exec serf members
exit 0