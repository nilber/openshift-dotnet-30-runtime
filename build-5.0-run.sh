#!/bin/bash

DOCKER_IMAGEM=dotnet-5.0-run-ubuntu
S2I_IMAGEM=nbmaster/openshift-dotnet-5.0-run-ubuntu
TAG=5.0.0-run

# docker system prune
# docker rmi $DOCKER_IMAGEM:$TAG $S2I_IMAGEM:$TAG

docker build src-5.0-run/ -t $DOCKER_IMAGEM:$TAG

# s2i build src-5.0-run/ $DOCKER_IMAGEM:$TAG $S2I_IMAGEM:$TAG

# docker push $S2I_IMAGEM:$TAG