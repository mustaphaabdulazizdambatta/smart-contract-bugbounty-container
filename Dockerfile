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
    python3-venv \
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


# Install web application bug bounty tools
# Install OWASP ZAP
# Install Burp Suite Community Edition

# Set up a user for better file handling (optional)
RUN useradd -ms /bin/bash devuser
USER devuser
WORKDIR /home/devuser

# Expose necessary ports (e.g., Hardhat Node default port, OWASP ZAP)
EXPOSE 8545 8080

# Default command
CMD ["/bin/bash"]
