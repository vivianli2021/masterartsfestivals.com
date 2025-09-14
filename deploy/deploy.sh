#!/bin/bash
set -e
BLUE='\033[0;34m'; GREEN='\033[0;32m'; RED='\033[0;31m'; NC='\033[0m'
log(){ echo -e "${BLUE}[INFO]${NC} $1"; }
ok(){ echo -e "${GREEN}[OK]${NC} $1"; }
err(){ echo -e "${RED}[ERR]${NC} $1"; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
CONFIG_FILE="$PROJECT_DIR/deploy.toml"

HOST=""; USER=""; PORT=""; REMOTE_HTML=""

dump_config(){
  log "CONFIG_FILE=$CONFIG_FILE"
  if [[ -f "$CONFIG_FILE" ]]; then
    log "deploy.toml contents:"; nl -ba "$CONFIG_FILE" | sed 's/^/  /'
  else
    err "deploy.toml not found"
  fi
}

require_config(){
  [[ -f "$CONFIG_FILE" ]] || { dump_config; err "deploy.toml not found at project root"; exit 1; }
}

parse_config(){
  require_config
  dump_config
  log "Parsing [server] section"
  HOST=$(awk 'BEGIN{FS="="} /^\[server\]/{s=1;next} /^\[/{s=0} s && $1 ~ /^[ \t]*host[ \t]*/ {v=$2; gsub(/^[ \t]+|[ \t]+$/, "", v); gsub(/^"|"$/, "", v); print v}' "$CONFIG_FILE" | tail -n1)
  USER=$(awk 'BEGIN{FS="="} /^\[server\]/{s=1;next} /^\[/{s=0} s && $1 ~ /^[ \t]*user[ \t]*/ {v=$2; gsub(/^[ \t]+|[ \t]+$/, "", v); gsub(/^"|"$/, "", v); print v}' "$CONFIG_FILE" | tail -n1)
  PORT=$(awk 'BEGIN{FS="="} /^\[server\]/{s=1;next} /^\[/{s=0} s && $1 ~ /^[ \t]*ssh_port[ \t]*/ {v=$2; gsub(/^[ \t]+|[ \t]+$/, "", v); gsub(/^"|"$/, "", v); print v}' "$CONFIG_FILE" | tail -n1)
  log "Extracted: HOST='${HOST}', USER='${USER}', PORT='${PORT}'"
  log "Parsing [paths] section"
  REMOTE_HTML=$(awk 'BEGIN{FS="="} /^\[paths\]/{s=1;next} /^\[/{s=0} s && $1 ~ /^[ \t]*remote_html[ \t]*/ {v=$2; gsub(/^[ \t]+|[ \t]+$/, "", v); gsub(/^"|"$/, "", v); print v}' "$CONFIG_FILE" | tail -n1)
  log "Extracted: REMOTE_HTML='${REMOTE_HTML}'"
  if [[ -z "$HOST" || -z "$USER" || -z "$PORT" || -z "$REMOTE_HTML" ]]; then
    err "Missing required keys in deploy.toml (server.host,user,ssh_port; paths.remote_html)"
    exit 1
  fi
  ok "Config OK: $USER@$HOST:$PORT -> $REMOTE_HTML"
}

build(){
  cd "$PROJECT_DIR"
  if [[ ! -d node_modules ]]; then log "Installing deps"; npm ci || npm install; fi
  log "Building site"; npm run build
  [[ -d dist ]] || { err "dist not found"; exit 1; }
  ok "Build complete"
}

deploy_files(){
  parse_config
  log "Creating remote dir"
  ssh -p "$PORT" "$USER@$HOST" "mkdir -p '$REMOTE_HTML'"
  log "Uploading artifacts"
  COPYFILE_DISABLE=1 tar -C "$PROJECT_DIR/dist" -czf - . | ssh -p "$PORT" "$USER@$HOST" "tar -C '$REMOTE_HTML' -xzf -"
  ok "Files uploaded to $REMOTE_HTML"
}

reload_nginx(){
  log "Reloading nginx"
  ssh -p "$PORT" "$USER@$HOST" "nginx -t && systemctl reload nginx" || err "nginx reload failed"
}

case "${1:-deploy}" in
  deploy) build; deploy_files; reload_nginx;;
  build) build;;
  upload) deploy_files; reload_nginx;;
  *) echo "Usage: $0 [deploy|build|upload]"; exit 1;;
esac
