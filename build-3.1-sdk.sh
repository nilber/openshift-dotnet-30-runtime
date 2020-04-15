#!/bin/bash

DOCKER_IMAGEM=dotnet-31-sdk-alpine
S2I_IMAGEM=nbmaster/openshift-dotnet-31-sdk-alpine
TAG=3.13.1.201-sdk

# docker system prune
# docker rmi $DOCKER_IMAGEM:$TAG $S2I_IMAGEM:$TAG

docker build src-3.1-sdk/ -t $DOCKER_IMAGEM:$TAG

s2i build src-3.1-sdk/ $DOCKER_IMAGEM:$TAG $S2I_IMAGEM:$TAG

docker push $S2I_IMAGEM:$TAG