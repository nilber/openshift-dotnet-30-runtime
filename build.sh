#!/bin/bash

docker build src/ -t dotnet-30-runtime

s2i build src/ dotnet-30-runtime nbmaster/openshift-dotnet-30-runtime

docker push nbmaster/openshift-dotnet-30-runtime