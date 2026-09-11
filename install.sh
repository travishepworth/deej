#!/usr/bin/env bash
set -euo pipefail

# Directory this script lives in (should be the deej project dir).
DEEJ_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SERVICE_SRC="$DEEJ_DIR/deej.service"
SERVICE_DEST_DIR="$HOME/.config/systemd/user"
SERVICE_DEST="$SERVICE_DEST_DIR/deej.service"

if [[ ! -f "$DEEJ_DIR/deej-release" ]]; then
  echo "Error: deej-release not found in $DEEJ_DIR" >&2
  exit 1
fi
chmod +x "$DEEJ_DIR/deej-release"

if [[ ! -f "$DEEJ_DIR/config.yaml" ]]; then
  echo "Warning: config.yaml not found in $DEEJ_DIR" >&2
fi

mkdir -p "$DEEJ_DIR/logs"
mkdir -p "$SERVICE_DEST_DIR"

# Substitute the actual path into the service file and install it.
sed "s|__DEEJ_DIR__|$DEEJ_DIR|g" "$SERVICE_SRC" > "$SERVICE_DEST"

systemctl --user daemon-reload
systemctl --user enable --now deej.service

echo "deej installed as a user service and started."
echo "  Status: systemctl --user status deej.service"
echo "  Logs:   journalctl --user -u deej.service -f"
echo "  Stop:   systemctl --user stop deej.service"
echo "  Disable:systemctl --user disable deej.service"
