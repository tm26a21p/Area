#!/bin/sh

containers=$(docker ps -a -q)
volumes=$(docker volume ls -q)
images=$(docker images -a -q)

docker-compose down
wait 
if [ -n "$containers" ]; then
    docker rm $containers
fi
wait
if [ -n "$volumes" ]; then
    docker volume rm $volumes
fi
wait

if [ $# -eq 1 ]
  then
    if [ $1 = "-b" ]
      then
        docker-compose up --build
    fi
    if [ $1 = "-rmi" ]
      then
        docker rmi $images
    fi
fi
