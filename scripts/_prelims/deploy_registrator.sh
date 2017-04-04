#!/bin/sh

# Installs Registrator

set -e

vms=( "manager1" "manager2" "manager3"
      "worker1" "worker2" "worker3" )

# only deploy to swarm worker nodes / consul clients
for vm in ${vms[@]:3:3}
do
  docker-machine env ${vm}
  eval $(docker-machine env ${vm})

  HOST_IP=$(docker-machine ip ${vm})
  # echo ${HOST_IP}

  docker service create \
    --name=registrator \
    --net=host \
    --volume=/var/run/docker.sock:/tmp/docker.sock \
    gliderlabs/registrator:latest \
      -internal consul://${HOST_IP:localhost}:8500 \
  || echo "Already installed?"
done

echo "Script completed..."