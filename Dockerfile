# jekyll-asciidoc-s2i
FROM centos/nodejs-8-centos7

LABEL maintainer="Takayuki Konishi <seannos.takayuki@gmail.com>"

ENV JEKYLL_ASCIIDOC_S2I_VERSION 0.0.4

LABEL io.k8s.description="Platform for building static web site via Antora then publish it" \
      io.k8s.display-name="jekyll-asciidoc-s2i 0.0.4" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="jekyll-asciidoc-s2i,0.0.4"

USER root

RUN export PATH=$PATH:/opt/rh/rh-nodejs8/root/usr/bin/; npm i --prefix=/opt/rh/rh-nodejs8/root/usr/local -g superstatic
# Reference:
#RUN yum install -y ruby ruby-devel rubygems && yum clean all -y
RUN yum install -y rh-ruby24 rh-ruby24-ruby-devel && yum clean all -y
RUN scl enable rh-ruby24 -- gem install bundler

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i

RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

EXPOSE 8080

# TODO: Set the default CMD for the image
# CMD ["/usr/libexec/s2i/usage"]
