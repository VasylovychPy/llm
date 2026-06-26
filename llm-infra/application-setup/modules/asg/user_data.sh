#!/bin/bash
set -e

cat > /etc/alloy/config.alloy <<EOF
prometheus.exporter.unix "node" {}

prometheus.relabel "node" {
  forward_to = [prometheus.remote_write.prom.receiver]

  rule {
    action       = "replace"
    target_label = "instance"
    replacement  = "llm-ollama"
  }

  rule {
    action       = "replace"
    target_label = "job"
    replacement  = "integrations/unix"
  }
}

prometheus.scrape "node" {
  targets    = prometheus.exporter.unix.node.targets
  forward_to = [prometheus.relabel.node.receiver]
}

prometheus.remote_write "prom" {
  endpoint {
    url = "${prometheus_remote_write_url}"
  }
}
EOF

systemctl daemon-reload
systemctl enable alloy
systemctl restart alloy