#!/bin/bash

DOCKER_IMAGEM=dotnet-22-run-alpine
S2I_IMAGEM=nbmaster/openshift-dotnet-22-run-alpine
TAG=2.2-run

docker system prune
docker rmi $DOCKER_IMAGEM:$TAG $S2I_IMAGEM:$TAG

docker build src-2.2-run/ -t $DOCKER_IMAGEM:$TAG

s2i build src-2.2-run/ $DOCKER_IMAGEM:$TAG $S2I_IMAGEM:$TAG

docker push $S2I_IMAGEM:$TAG