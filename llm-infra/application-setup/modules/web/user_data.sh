#!/bin/bash
set -e

docker rm -f open-webui || true

docker run -d \
  --name open-webui \
  --restart unless-stopped \
  -p 8080:8080 \
  -e OLLAMA_BASE_URL="http://${llm_alb_dns}" \
  -v open-webui:/app/backend/data \
  ghcr.io/open-webui/open-webui:main-slim