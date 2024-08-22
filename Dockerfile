FROM docker:dind

# Set the user to root so we can install packages and copy files into the image. This must be changed 
# to a non root user before the build exits or the pipeline will fail.
#USER 0 

# Install Git
RUN apk add --no-cache git bash jq unzip wget

# renovate: datasource=github-releases depName=defenseunicorns/zarf versioning=semver registryUrl=https://github.com
ENV ZARF_VERSION="v0.36.1"
ENV ZARF_URL="https://github.com/defenseunicorns/zarf/releases/download/${ZARF_VERSION}/zarf_${ZARF_VERSION}_Linux_amd64"

RUN wget ${ZARF_URL} -q --tries=3 -O /usr/local/bin/zarf 

# renovate: datasource=github-releases depName=defenseunicorns/uds-cli versioning=semver registryUrl=https://github.com
ENV UDS_CLI_VERSION="v0.13.1"
ENV UDS_CLI_URL="https://github.com/defenseunicorns/uds-cli/releases/download/${UDS_CLI_VERSION}/uds-cli_${UDS_CLI_VERSION}_Linux_amd64"

RUN wget ${UDS_CLI_URL} -q --tries=3 -O /usr/local/bin/uds

# renovate: datasource=github-releases depName=mikefarah/yq versioning=semver registryUrl=https://github.com
ENV YQ_VERSION="v4.44.2"
ENV YQ_URL="https://github.com/mikefarah/yq/releases/download/${YQ_VERSION}/yq_linux_amd64"

RUN wget ${YQ_URL} -q --tries=3 -O /usr/local/bin/yq

# renovate: datasource=github-releases depName=k3d-io/k3d versioning=semver registryUrl=https://github.com
ENV K3D_VERSION="v5.7.3"
ENV K3D_URL="https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=${K3D_VERSION} bash"
ENV K3D_URL1="https://github.com/k3d-io/k3d/releases/download/${K3D_VERSION}/k3d-linux-amd64"
#RUN wget -q -O - https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash
#RUN wget -q --tries=3 -O - ${K3D_URL}
RUN wget ${K3D_URL1} -q --tries=3 -O /usr/local/bin/k3d


RUN chmod +x /usr/local/bin/zarf  && \
    chmod +x /usr/local/bin/uds && \
    chmod +x /usr/local/bin/yq && \
    chmod +x /usr/local/bin/k3d 

RUN zarf version && \
    echo "Zarf is installed" && \
    uds version && \
    echo "UDS CLI is installed" && \
    yq --version && \
    echo "YQ is installed" && \
    k3d --version && \
    echo "K3D is installed"

# # Default Command
# CMD [ "/bin/bash" ]
ENTRYPOINT ["dockerd-entrypoint.sh"]
CMD []