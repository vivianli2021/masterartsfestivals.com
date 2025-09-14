# AI Assistant Guide (vendor-agnostic)

Project
- Static website built with Astro for the Master Arts Festival rocket team
- Output is static files in dist/ served by nginx on a VPS

Setup & common commands
- Install: npm install
- Dev server: npm run dev (default: http://localhost:4321)
- Build: npm run build (outputs ./dist)
- Preview production: npm run preview
- Tests: npm test (none configured by default)
- Run single test (Jest): npm test -- -t "<regex>"
- Lint/format: npm run lint, npm run format (or eslint --fix, prettier --write)

Code conventions
- Use src/layouts/BaseLayout.astro for shared chrome; pages live in src/pages
- Styling in public/styles.css; keep design light, accessible, and responsive
- Imports: external, then internal, then relative; sort within groups
- Naming: camelCase (vars/functions), PascalCase (components/types), UPPER_SNAKE (constants)
- Types/JS: Prefer explicit props; avoid implicit any; prefer unknown to any
- Errors: Handle explicitly; wrap with context; never log or commit secrets
- Accessibility: Provide meaningful alt text; ensure keyboard access for interactions
- Tests: Small, deterministic; use fixtures/table-driven where helpful

Assets
- Put images in public/photos; prefer JPEG/WebP, ~1600px max width
- Do not import large binaries into the bundle; link from public/

Deployment
- Deploy via ./deploy/deploy.sh (reads deploy.toml at repo root)
- deploy.toml is gitignored; do not commit server credentials or targets
- Script builds, uploads dist/ to remote html dir, then reloads nginx

Cursor/Copilot rules
- No .cursor/rules or .cursorrules detected; no copilot-instructions.md detected
- If added later, summarize rules here for agents

Collaboration
- Small, focused commits with clear messages
- Avoid adding new dependencies unless necessary
- Do not modify CI/CD or server settings without approval
