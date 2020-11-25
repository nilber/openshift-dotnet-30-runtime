FROM amd64/buildpack-deps:focal-scm

ENV \
    # Enable detection of running in a container
    DOTNET_RUNNING_IN_CONTAINER=true \
    # Enable correct mode for dotnet watch (only mode supported in a container)
    DOTNET_USE_POLLING_FILE_WATCHER=true \
    # Skip extraction of XML docs - generally not useful within an image/container - helps performance
    NUGET_XMLDOC_MODE=skip \
    # PowerShell telemetry for docker image usage
    POWERSHELL_DISTRIBUTION_CHANNEL=PSDocker-DotnetCoreSDK-Ubuntu-20.04

# Install .NET CLI dependencies
RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        libicu66 \
        libssl1.1 \
        libstdc++6 \
        zlib1g \
    && rm -rf /var/lib/apt/lists/*

# Install .NET Core SDK
RUN dotnet_sdk_version=3.1.401 \
    && curl -SL --output dotnet.tar.gz https://dotnetcli.azureedge.net/dotnet/Sdk/$dotnet_sdk_version/dotnet-sdk-$dotnet_sdk_version-linux-x64.tar.gz \
    && dotnet_sha512='5498add9ef83da44d8f7806ca1ce335ad4193c0d3181a5abda4b65e116c7331aac37a229817ff148e4487e9734ad2438f102a0eef0049e26773a185ceb78aac4' \
    && echo "$dotnet_sha512 dotnet.tar.gz" | sha512sum -c - \
    && mkdir -p /usr/share/dotnet \
    && tar -ozxf dotnet.tar.gz -C /usr/share/dotnet \
    && rm dotnet.tar.gz \
    && ln -s /usr/share/dotnet/dotnet /usr/bin/dotnet \
    # Trigger first run experience by running arbitrary cmd
    && dotnet help

# Install PowerShell global tool
RUN powershell_version=7.0.3 \
    && curl -SL --output PowerShell.Linux.x64.$powershell_version.nupkg https://pwshtool.blob.core.windows.net/tool/$powershell_version/PowerShell.Linux.x64.$powershell_version.nupkg \
    && powershell_sha512='580f405d26df40378f3abff3ec7e4ecaa46bb0e46bcb2b3c16eff2ead28fde5aaa55c19501f73315b454e68d98c9ef49f8887c36e7c733d7c8ea3dd70977da2f' \
    && echo "$powershell_sha512  PowerShell.Linux.x64.$powershell_version.nupkg" | sha512sum -c - \
    && mkdir -p /usr/share/powershell \
    && dotnet tool install --add-source / --tool-path /usr/share/powershell --version $powershell_version PowerShell.Linux.x64 \
    && dotnet nuget locals all --clear \
    && rm PowerShell.Linux.x64.$powershell_version.nupkg \
    && ln -s /usr/share/powershell/pwsh /usr/bin/pwsh \
    && chmod 755 /usr/share/powershell/pwsh \
    # To reduce image size, remove the copy nupkg that nuget keeps.
    && find /usr/share/powershell -print | grep -i '.*[.]nupkg$' | xargs rm

# Install ASP.NET Core
RUN aspnetcore_version=3.1.7 \
    && curl -SL --output aspnetcore.tar.gz https://dotnetcli.azureedge.net/dotnet/aspnetcore/Runtime/$aspnetcore_version/aspnetcore-runtime-$aspnetcore_version-linux-x64.tar.gz \
    && aspnetcore_sha512='c8c866faa5cae5511ee833b70d65a605ba91970f1ee59a2dad1fbcb84aa8743d07c47bd66fb1c37ef8b641f1b94b6f382f3f5cb69d7b1fbddef9043e4848c1cb' \
    && echo "$aspnetcore_sha512  aspnetcore.tar.gz" | sha512sum -c - \
    && tar -ozxf aspnetcore.tar.gz -C /usr/share/dotnet ./shared/Microsoft.AspNetCore.App \
    && rm aspnetcore.tar.gz    


# TODO: Put the maintainer name in the image metadata
LABEL maintainer="Nilber Vittorazzi <nilber@vittorazzi.com>"

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description=".Net Core 2.2 SDK" \
    io.k8s.display-name=".Net Core 2.2 SDK" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,dotnet-2.2-sdk." \
    io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"


RUN usermod -l 1001 www-data
RUN usermod -u 1001 1001 
RUN groupadd -g 1001 1001 && usermod -a -G 1001 1001


# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
RUN mkdir -p /usr/libexec/
COPY ./s2i/bin/ /usr/libexec/s2i
RUN ls -l /usr/libexec/s2i


RUN mkdir /app && ls -la /


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
