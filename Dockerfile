#FROM alpine:3.18 as builder
FROM alpine:3.18
RUN apk add --no-cache wget terraform gcompat jq

RUN wget https://mirror.openshift.com/pub/openshift-v4/x86_64/clients/rosa/1.2.25/rosa-linux.tar.gz \
  && tar xvf rosa-linux.tar.gz -C /usr/local/bin/ rosa && chmod +x /usr/local/bin/rosa

RUN wget https://mirror.openshift.com/pub/openshift-v4/`arch`/clients/ocp/latest-4.10/openshift-client-linux-4.10.66.tar.gz \
 && tar xvf openshift-client-linux-4.10*tar.gz -C /usr/local/bin/ oc && chmod +x /usr/local/bin/oc

VOLUME /u
WORKDIR /u
ENTRYPOINT ["terraform"]
