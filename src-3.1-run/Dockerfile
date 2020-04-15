ARG REPO=mcr.microsoft.com/dotnet/core/runtime-deps
FROM $REPO:3.1-alpine3.10


RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && apk update && apk add --no-cache libgdiplus

# Add dependencies for disabling invariant mode (set in base image)
RUN apk add --no-cache icu-libs

# Install .NET Core
RUN dotnet_version=3.1.3 \
    && wget -O dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$dotnet_version/dotnet-runtime-$dotnet_version-linux-musl-x64.tar.gz \
    && dotnet_sha512='ce8bef0f11c552d18727d39ae5c8751cba8de70b0bb1958afa6a7f2cf7c4c1bff94a7e216c48c3c3f72f756bfcf8d5c9e5d07f90cf91263a68c5914658ae6767' \
    && echo "$dotnet_sha512  dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -C /usr/share/dotnet -oxzf dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    && rm dotnet.tar.gz

RUN apk add --no-cache curl

# TODO: Put the maintainer name in the image metadata
LABEL maintainer="Nilber Vittorazzi <nilber@vittorazzi.com>"

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description=".Net Core 3.1.3 RUN" \
    io.k8s.display-name=".Net Core 3.1.3 RUN" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,dotnet-3.1.3-run." \
    io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
RUN mkdir -p /usr/libexec/
COPY ./s2i/bin/ /usr/libexec/s2i
RUN ls -l /usr/libexec/s2i


RUN mkdir /app && ls -la /

RUN addgroup -S 1001 && adduser -S 1001 -G 1001


WORKDIR /opt/app-root/

# TODO (optional): Copy the builder files into /opt/app-root
COPY ./* /opt/app-root/

# # TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /app
RUN chown -R 1001:1001 /opt/app-root  && ls -l /opt
# RUN mkdir /app
# RUN chown -R 1001:1001 /app
# # This default user is created in the openshift/base-centos7 image
# USER 1001

USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080

# TODO: Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]
