FROM ghcr.io/actions/actions-runner:2.304.0
# for latest release, see https://github.com/actions/runner/releases

USER root

# Suppress debconf warning
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies + Azure CLI manually (no apt-key)
RUN apt-get update && \
    apt-get install -y curl ca-certificates lsb-release gnupg jq apt-transport-https && \
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg && \
    install -o root -g root -m 644 microsoft.gpg /etc/apt/trusted.gpg.d/ && \
    sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/azure-cli.list' && \
    apt-get update && \
    apt-get install -y azure-cli && \
    rm microsoft.gpg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh

USER runner

ENTRYPOINT ["./entrypoint.sh"]