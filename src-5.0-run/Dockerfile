ARG REPO=mcr.microsoft.com/dotnet/runtime-deps
ARG DOTNET_VERSION=5.0.0

# Installer image
FROM amd64/buildpack-deps:focal-curl as installer
ARG DOTNET_VERSION

# Retrieve .NET
RUN curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Runtime/$DOTNET_VERSION/dotnet-runtime-$DOTNET_VERSION-linux-x64.tar.gz \
    && dotnet_sha512='d4d67df5ff5f6dde0d865a6e87559955bd57429df396cf7d05fe77f09e6220c67dc5e66439b1801ca4d301a62f81f666122bf4b623b31a46b861677dcafc62a4' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /dotnet \
    && tar -ozxf dotnet.tar.gz -C /dotnet \
    && rm dotnet.tar.gz


# .NET runtime image
FROM $REPO:5.0-focal-amd64
ARG DOTNET_VERSION

ENV DOTNET_VERSION $DOTNET_VERSION

COPY --from=installer ["/dotnet", "/usr/share/dotnet"]

RUN ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet

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

#RUN adduser --disabled-password --gecos "" www-data --force-badname
RUN usermod -l 1001 www-data \
    && usermod -u 1001 1001 \
    && groupadd -g 1001 1001 && usermod -a -G 1001 1001


# RUN addgroup www-xxx --force-badname
# RUN useradd -m -g 1001 --disabled-password --gecos "" 1001
# RUN addgroup 1001 --force-badname
# RUN adduser --disabled-password --gecos "" 1001 --force-badname -G 1001
# RUN usermod -l 1001 1001
# RUN usermod -u 1001 1001 
# RUN groupadd -g 1001 1001 && usermod -a -G 1001 1001
RUN id

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
