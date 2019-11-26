#!/bin/bash

DOCKER_IMAGEM=dotnet-30-runtime-alpine
S2I_IMAGEM=nbmaster/openshift-dotnet-30-runtime-alpine
TAG=v1.0

docker system prune
docker rmi $DOCKER_IMAGEM:$TAG $S2I_IMAGEM:$TAG

docker build src/ -t $DOCKER_IMAGEM:$TAG

s2i build src/ $DOCKER_IMAGEM:$TAG $S2I_IMAGEM:$TAG

docker push $S2I_IMAGEM:$TAG