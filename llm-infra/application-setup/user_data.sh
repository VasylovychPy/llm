#!/bin/bash
set -euxo pipefail

dnf update -y
dnf install -y nginx
systemctl enable nginx
systemctl start nginx

curl -fsSL https://ollama.com/install.sh | sh

systemctl enable ollama
systemctl start ollama

sleep 10
export HOME=/root
ollama pull tinyllama