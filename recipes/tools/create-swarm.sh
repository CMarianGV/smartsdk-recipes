#!/bin/sh
docker-machine create -d virtualbox node-1
docker-machine create -d virtualbox node-2
docker-machine create -d virtualbox node-3

eval $(docker-machine env node-1)
docker swarm init --advertise-addr $(docker-machine ip node-1) --listen-addr $(docker-machine ip node-1):2377

# TIP: there could be more than one leader in a production swarm cluster

TOKEN=$(docker swarm join-token -q worker)

eval $(docker-machine env node-2)
docker swarm join --token $TOKEN $(docker-machine ip node-1):2377

eval $(docker-machine env node-3)
docker swarm join --token $TOKEN $(docker-machine ip node-1):2377
