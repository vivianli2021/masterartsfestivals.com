# Deployment Guide (Astro · masterartsfestivals.com)

Overview
- This is an Astro static site. We deploy the built dist/ to the same VPS and serve via nginx. No Node.js runtime/systemd needed.

Targets (same VPS, adapted)
- SSH: root@veu-gp-b001 -p 22
- Remote base: /opt/masterartsfestivals.com
- Remote html (nginx root): /opt/masterartsfestivals.com/html

Build
```bash
npm ci || npm install
npm run build   # creates ./dist
```

Deploy (rsync, preferred)
```bash
RSYNC_FLAGS="-avz --delete"
rsync $RSYNC_FLAGS -e "ssh -p 22" \
  dist/ root@veu-gp-b001:/opt/masterartsfestivals.com/html/
ssh -p 22 root@veu-gp-b001 "nginx -t && systemctl reload nginx"
```

Deploy (tar/scp alternative)
```bash
SITE=masterartsfestivals-$(date +%Y%m%d-%H%M%S).tar.gz
rm -f "$SITE" && tar -C dist -czf "$SITE" .
scp -P 22 "$SITE" root@veu-gp-b001:/tmp/
ssh -p 22 root@veu-gp-b001 <<'EOF'
set -e
BASE=/opt/masterartsfestivals.com
HTML=$BASE/html
mkdir -p "$HTML"
rm -rf "$HTML"/*
tar -C "$HTML" -xzf /tmp/$SITE
rm -f /tmp/$SITE
nginx -t && systemctl reload nginx
EOF
```

Nginx vhost
```nginx
server {
  listen 80;
  server_name masterartsfestivals.com www.masterartsfestivals.com;
  root /opt/masterartsfestivals.com/html;
  index index.html;
  location / { try_files $uri $uri/ /index.html; }
  location ~* \.(?:jpg|jpeg|png|gif|svg|webp|css|js|ico|json|txt|woff2?)$ {
    access_log off; expires 30d; add_header Cache-Control "public, max-age=2592000";
  }
}
```

Notes
- Previous Next.js/systemd flow in deploy.sh is not used for this project.
- Keep permissions so nginx can read /opt/masterartsfestivals.com/html.
- Optional zero-downtime: deploy to releases/<ts> and atomically switch a symlink, then reload nginx.
