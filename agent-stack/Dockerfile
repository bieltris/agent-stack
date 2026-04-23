FROM python:3.13-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends bash ca-certificates curl git procps \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get update \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g opencode-ai \
    && python -m pip install --no-cache-dir --upgrade pip \
    && python -m pip install --no-cache-dir aider-chat

WORKDIR /workspace

COPY scripts/docker-entrypoint.sh /usr/local/bin/agent-stack-entrypoint
RUN chmod +x /usr/local/bin/agent-stack-entrypoint

ENTRYPOINT ["agent-stack-entrypoint"]
CMD ["bash"]
