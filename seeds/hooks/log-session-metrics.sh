#!/bin/bash
# Appends session metrics to CSV
METRICS_DIR=".claude/metrics"
mkdir -p "$METRICS_DIR"
echo "$(date -u +%Y-%m-%dT%H:%M:%SZ),${SESSION_ID:-unknown}" >> "$METRICS_DIR/sessions.csv"
