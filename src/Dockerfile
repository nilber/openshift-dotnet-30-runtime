# dotnet-30-runtime
FROM openshift/base-centos7

# TODO: Put the maintainer name in the image metadata
LABEL maintainer="Nilber Vittorazzi <nilber@vittorazzi.com>"

# TODO: Rename the builder environment variable to inform users about application you provide them
ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
LABEL io.k8s.description=".Net Core 3.0" \
    io.k8s.display-name=".Net Core 3.0" \
    io.openshift.expose-services="8080:http" \
    io.openshift.tags="builder,dotnet-30,net-30." \
    io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y
RUN rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm
RUN yum install -y dotnet-sdk-3.0 && yum clean all -y
#RUN gem install asdf

# TODO (optional): Copy the builder files into /opt/app-root
COPY ./* /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
RUN chown -R 1001:1001 /opt/app-root
RUN mkdir /app
RUN chown -R 1001:1001 /app
# This default user is created in the openshift/base-centos7 image
USER 1001


# TODO: Set the default port for applications built using this image
EXPOSE 8080

# TODO: Set the default CMD for the image
CMD ["/usr/libexec/s2i/usage"]