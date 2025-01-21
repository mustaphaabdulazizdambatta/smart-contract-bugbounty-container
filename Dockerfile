# Use the latest Ubuntu as the base image
FROM ubuntu:latest

# Set a non-interactive frontend to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Update and install essential dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    curl \
    wget \
    git \
    python3 \
    python3-pip \
    npm \
    nodejs \
    jq \
    vim \
    unzip \
    libssl-dev \
    nmap \
    && apt-get clean

# Install Foundry for smart contract development
RUN curl -L https://foundry.paradigm.xyz | bash && \
    /root/.foundry/bin/foundryup

# Install Hardhat for Ethereum development
RUN npm install -g hardhat

# Install smart contract security tools
RUN pip3 install slither-analyzer mythril eth-brownie && \
    git clone https://github.com/crytic/echidna.git && \
    cd echidna && \
    cabal update && \
    cabal install exe:echidna --install-method=copy \
    --installdir=/usr/local/bin

# Install web application bug bounty tools
# Subfinder for subdomain enumeration
RUN GO_VERSION=$(curl -sL https://golang.org/VERSION?m=text) && \
    curl -OL https://golang.org/dl/${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf ${GO_VERSION}.linux-amd64.tar.gz && \
    rm -f ${GO_VERSION}.linux-amd64.tar.gz && \
    ln -s /usr/local/go/bin/go /usr/local/bin/go && \
    go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Install OWASP ZAP
RUN wget -O zap.zip https://github.com/zaproxy/zaproxy/releases/download/v2.13.0/ZAP_2.13.0_Linux.zip && \
    unzip zap.zip -d /usr/local/zap && \
    rm zap.zip && \
    ln -s /usr/local/zap/zap.sh /usr/local/bin/zap

# Install Burp Suite Community Edition
RUN wget -O burp.jar https://portswigger.net/burp/releases/download?product=community&version=2023.9.2&type=Jar && \
    mv burp.jar /usr/local/bin/

# Set up a user for better file handling (optional)
RUN useradd -ms /bin/bash devuser
USER devuser
WORKDIR /home/devuser

# Expose necessary ports (e.g., Hardhat Node default port, OWASP ZAP)
EXPOSE 8545 8080

# Default command
CMD ["/bin/bash"]
