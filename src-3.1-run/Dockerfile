ARG REPO=mcr.microsoft.com/dotnet/core/runtime
FROM $REPO:3.1-bionic

RUN apt-get update -y \    
    && apt install libc6-dev -y \
    && apt install libgdiplus -y \
    && apt-get install -y --no-install-recommends \
        curl wget \
    && rm -rf /var/lib/apt/lists/*

# Install ASP.NET Core
RUN aspnetcore_version=3.1.3 \
    && curl -SL --output aspnetcore.tar.gz https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-$aspnetcore_version-linux-x64.tar.gz \
    && aspnetcore_sha512='ced0b7c9faaf250fbee2c850e8941d47a17da06fa8e576d57063fa4bbc6c8435de6ab488b683d4a692cd622e24d9592f11608a1b358074167cf0b76024815611' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -ozxf aspnetcore.tar.gz -C /usr/share/dotnet ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz

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
RUN mkdir /app/temp && chmod 777 /app/temp
# RUN mkdir /app
# RUN chown -R 1001:1001 /app
# # This default user is created in the openshift/base-centos7 image
# USER 1001

USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 8080

# TODO: Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]
