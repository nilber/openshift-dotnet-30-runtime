#!/bin/bash

DOCKER_IMAGEM=dotnet-22-sdk-alpine
S2I_IMAGEM=nbmaster/openshift-dotnet-22-sdk-alpine
TAG=2.1.805-sdk

# docker system psdke
# docker rmi $DOCKER_IMAGEM:$TAG $S2I_IMAGEM:$TAG

docker build src-2.2-sdk/ -t $DOCKER_IMAGEM:$TAG

s2i build src-2.2-sdk/ $DOCKER_IMAGEM:$TAG $S2I_IMAGEM:$TAG

docker push $S2I_IMAGEM:$TAG