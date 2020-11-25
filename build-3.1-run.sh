#!/bin/bash

DOCKER_IMAGEM=dotnet-run-alpine
S2I_IMAGEM=nbmaster/openshift-dotnet-run-alpine
TAG=3.1.3-run

# docker system prune
# docker rmi $DOCKER_IMAGEM:$TAG $S2I_IMAGEM:$TAG

docker build src-3.1-run/ -t $DOCKER_IMAGEM:$TAG

s2i build src-3.1-run/ $DOCKER_IMAGEM:$TAG $S2I_IMAGEM:$TAG

docker push $S2I_IMAGEM:$TAG