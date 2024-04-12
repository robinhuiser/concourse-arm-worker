# Global build images
ARG golang_concourse_builder_image

#
# Build the UI artefacts
FROM ubuntu:20.04 AS yarn-builder

RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends tzdata
RUN apt-get update && apt-get install -y git curl libatomic1 xz-utils jq chromium-bsu chromium-browser

#
# NodeJS installation
ARG node_version
RUN curl -sL https://nodejs.org/dist/v${node_version}/node-v${node_version}-linux-arm64.tar.xz -o node-${node_version}-linux-arm64.tar.xz && \
      mkdir -p /usr/local/lib/nodejs && \
      tar -xJf node-${node_version}-linux-arm64.tar.xz -C /usr/local/lib/nodejs && \
      rm -Rf node-${node_version}-linux-arm64.tar.xz

ENV PATH="/usr/local/lib/nodejs/node-v${node_version}-linux-arm64/bin:${PATH}"

RUN npm install --global yarn

#
# Install elm (pre-compiled for arm64) since there is no public version available
ARG elm_version
ADD dist/elm-v${elm_version}-arm64.tar.gz /usr/local/bin

#
# Build concourse web
ARG concourse_version
RUN git clone --branch v${concourse_version} https://github.com/concourse/concourse /yarn/concourse
WORKDIR /yarn/concourse
RUN sed -i 's/\"ryannhg\/date\-format\"\:\ \"2\.3\.0\"/\"ryan\-haskell\/date\-format\"\:\ \"1\.0\.0\"/g' web/elm/elm.json

# Patch the package json since we have elm pre-installed
RUN cat package.json | jq 'del(.devDependencies ["elm","elm-analyse","elm-format","elm-test"])' > package.json.tmp && \
      mv package.json.tmp package.json
RUN yarn
RUN yarn build


#
# Build the go artefacts
FROM ${golang_concourse_builder_image} AS go-builder

ENV GO111MODULE=on

ARG concourse_version
ARG guardian_commit_id
ARG cni_plugins_version

RUN apk add gcc git g++

RUN git clone https://github.com/cloudfoundry/guardian.git /go/guardian
WORKDIR /go/guardian
RUN git checkout ${guardian_commit_id}
RUN go build -ldflags "-extldflags '-static'" -mod=vendor -o gdn ./cmd/gdn
WORKDIR /go/guardian/cmd/init
RUN gcc -static -o init init.c ignore_sigchild.c

RUN git clone --branch v${concourse_version} https://github.com/concourse/concourse /go/concourse
WORKDIR /go/concourse
RUN go build -v -ldflags "-extldflags '-static' -X github.com/concourse/concourse.Version=${concourse_version}" ./cmd/concourse

RUN git clone --branch v${cni_plugins_version} https://github.com/containernetworking/plugins.git /go/plugins
WORKDIR /go/plugins
RUN apk add bash
ENV CGO_ENABLED=0
RUN ./build_linux.sh


#
# Generate the final image
FROM ubuntu:bionic AS ubuntu

ARG concourse_version
ARG concourse_docker_entrypoint_commit_id

COPY --from=yarn-builder /yarn/concourse/web/public/ /public

COPY --from=go-builder /go/concourse/concourse /usr/local/concourse/bin/
COPY --from=go-builder /go/guardian/gdn /usr/local/concourse/bin/
COPY --from=go-builder /go/guardian/cmd/init/init /usr/local/concourse/bin/
COPY --from=go-builder /go/plugins/bin/* /usr/local/concourse/bin/


# Add resource-types
COPY resource-types /usr/local/concourse/resource-types

# Auto-wire work dir for 'worker' and 'quickstart'
ENV CONCOURSE_WORK_DIR                /worker-state
ENV CONCOURSE_WORKER_WORK_DIR         /worker-state
ENV CONCOURSE_WEB_PUBLIC_DIR          /public

# Volume for non-aufs/etc. mount for baggageclaim's driver
VOLUME /worker-state

RUN apt-get update && apt-get install -y \
    btrfs-tools \
    ca-certificates \
    containerd \
    iptables \
    dumb-init \
    iproute2 \
    file \
    curl

# Add fly CLI versions
RUN mkdir -p /usr/local/concourse/fly-assets && \
      curl -sL https://github.com/concourse/concourse/releases/download/v${concourse_version}/fly-${concourse_version}-darwin-amd64.tgz \
         -o /usr/local/concourse/fly-assets/fly-darwin-amd64.tgz && \
      curl -sL https://github.com/concourse/concourse/releases/download/v${concourse_version}/fly-${concourse_version}-linux-amd64.tgz \
         -o /usr/local/concourse/fly-assets/fly-linux-amd64.tgz && \
      curl -sL https://github.com/concourse/concourse/releases/download/v${concourse_version}/fly-${concourse_version}-windows-amd64.zip \
         -o /usr/local/concourse/fly-assets/fly-windows-amd64.zip

STOPSIGNAL SIGUSR2

ADD https://raw.githubusercontent.com/concourse/concourse-docker/${concourse_docker_entrypoint_commit_id}/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["dumb-init", "/usr/local/bin/entrypoint.sh"]
