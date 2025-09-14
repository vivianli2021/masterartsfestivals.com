# Master Arts Festival — Website

Welcome! This repo contains a simple Astro website. These steps assume you are new to programming.

1) One‑time setup
- Install Node.js LTS from nodejs.org
- Open a terminal and clone the repo: git clone <repo-url>
- Enter the folder: cd masterartsfestivals.com
- Install dependencies: npm install

2) Run the site locally
- Start the dev server (auto reloads): npm run dev
- Open the URL shown (usually http://localhost:4321)
- Edit files in src/pages and public; changes show immediately

3) Build a production version
- Create optimized static files: npm run build
- Preview the production build: npm run preview (then visit the printed URL)

4) Deploy updates (push to the remote server)
- Make sure you can SSH into your team’s server (ask mentor to set this up for you)
- Ask for a deploy.toml template and fill in:
  - server.host, server.user, server.ssh_port
  - paths.remote_html (the folder on the server where files go)
- Save deploy.toml at the project root (it is ignored by git so your server info stays private)
- Run the deploy script: ./deploy/deploy.sh deploy
- The script will build and upload the new files, then reload the web server

Tips
- Photos: put images in public/photos and they’ll appear on the front page
- Styling: edit public/styles.css
- Pages: add .astro files in src/pages (about.astro => /about)
- If something breaks, run: npm install, then try again
