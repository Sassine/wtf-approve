#!/usr/bin/env bash
# Demo script for wtf-approve skill — creates real dirs and runs real commands
# Run: bash demo.sh

set -euo pipefail

DEMO_DIR="/tmp/wtf-approve-demo"

# Colors
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
CYAN='\033[36m'
WHITE='\033[37m'
BG_DARK='\033[48;5;236m'

# ── Setup: create realistic project structure ─────────────
rm -rf "$DEMO_DIR"
mkdir -p "$DEMO_DIR"/{node_modules/.cache,dist/assets,src,.git}
echo '{"name":"my-app","version":"1.0.0"}' > "$DEMO_DIR/package.json"
echo '{"port":3000}' > "$DEMO_DIR/config.json"
echo "// TODO: refactor this" > "$DEMO_DIR/src/index.js"
echo "APP_KEY=secret123" > "$DEMO_DIR/.env"
dd if=/dev/zero of="$DEMO_DIR/node_modules/.cache/babel.pack" bs=1024 count=50 2>/dev/null
dd if=/dev/zero of="$DEMO_DIR/dist/assets/bundle.js" bs=1024 count=30 2>/dev/null

clear

echo ""
echo -e "${BOLD}${CYAN}  wtf-approve${RESET}${DIM} — human-readable consent layer for agent execution${RESET}"
echo -e "${DIM}  ─────────────────────────────────────────────────────────${RESET}"
echo -e "${DIM}  Demo project: ${DEMO_DIR}${RESET}"
echo ""

# Show what exists
echo -e "  ${DIM}Project structure created:${RESET}"
echo -e "  ${DIM}$(du -sh "$DEMO_DIR/node_modules" 2>/dev/null | cut -f1)  node_modules/${RESET}"
echo -e "  ${DIM}$(du -sh "$DEMO_DIR/dist" 2>/dev/null | cut -f1)  dist/${RESET}"
echo -e "  ${DIM}$(du -sh "$DEMO_DIR/src" 2>/dev/null | cut -f1)  src/${RESET}"
echo -e "  ${DIM}     package.json  config.json  .env${RESET}"
echo ""
sleep 1

# ── STEP 1: LOW RISK — real ls + grep ────────────────────
echo -e "  ${DIM}━━━ Step 1: Low risk ━━━${RESET}"
echo ""
echo -e "  ${DIM}Claude wants to run:${RESET}"
echo -e "  ${WHITE}${BG_DARK} ls -la ${DEMO_DIR} && grep -R 'TODO' ${DEMO_DIR}/src/ ${RESET}"
echo ""
echo -e "  ${GREEN}2 read-only commands in the project directory. Nothing will be changed.${RESET}"
echo ""
echo -e "  ${DIM}Allow? ${BOLD}${WHITE}[Y]es${RESET} ${DIM}/${RESET} ${DIM}[N]o${RESET}  ${DIM}→ Y${RESET}"
echo ""
echo -e "  ${DIM}Running...${RESET}"
ls "$DEMO_DIR" 2>/dev/null | sed 's/^/    /'
echo -e "    ${GREEN}$(grep -R 'TODO' "$DEMO_DIR/src/" 2>/dev/null)${RESET}"
echo ""
sleep 2

# ── STEP 2: MEDIUM RISK — real sed + echo >> ─────────────
echo -e "  ${DIM}━━━ Step 2: Medium risk ━━━${RESET}"
echo ""
echo -e "  ${DIM}Claude wants to run:${RESET}"
echo -e "  ${WHITE}${BG_DARK} sed -i 's/3000/8080/g' ${DEMO_DIR}/config.json && echo \"DEBUG=true\" >> ${DEMO_DIR}/.env ${RESET}"
echo ""
echo -e "  ${YELLOW}Will edit config.json and append variable to .env.${RESET}"
echo -e "  ${YELLOW}Risk: medium — writes to local config files.${RESET}"
echo -e "  ${DIM}(details: /wtf:explain)${RESET}"
echo ""
echo -e "  ${DIM}Allow? ${BOLD}${WHITE}[Y]es${RESET} ${DIM}/${RESET} ${DIM}[N]o${RESET}  ${DIM}→ Y${RESET}"
echo ""
echo -e "  ${DIM}Running...${RESET}"
sed -i 's/3000/8080/g' "$DEMO_DIR/config.json"
echo "DEBUG=true" >> "$DEMO_DIR/.env"
echo -e "    ${YELLOW}config.json → $(cat "$DEMO_DIR/config.json")${RESET}"
echo -e "    ${YELLOW}.env → $(cat "$DEMO_DIR/.env")${RESET}"
echo ""
sleep 2

# ── STEP 3: HIGH RISK — real rm -rf ──────────────────────
echo -e "  ${DIM}━━━ Step 3: High risk ━━━${RESET}"
echo ""
echo -e "  ${DIM}Before: node_modules/ $(du -sh "$DEMO_DIR/node_modules" 2>/dev/null | cut -f1) | dist/ $(du -sh "$DEMO_DIR/dist" 2>/dev/null | cut -f1)${RESET}"
echo ""
echo -e "  ${DIM}Claude wants to run:${RESET}"
echo -e "  ${WHITE}${BG_DARK} rm -rf ${DEMO_DIR}/node_modules/ ${DEMO_DIR}/dist/ ${RESET}"
echo ""
echo -e "  ${RED}Vai remover diretorios de dependencias e build do projeto.${RESET}"
echo -e "  ${RED}Risco: ALTO — exclusao irreversivel de diretorios.${RESET}"
echo -e "  ${DIM}(mais detalhes: /wtf:explain)${RESET}"
echo ""
echo -e "  ${DIM}Allow? ${BOLD}${WHITE}[Y]es${RESET} ${DIM}/${RESET} ${DIM}[N]o${RESET}  ${DIM}→ Y${RESET}"
echo ""
echo -e "  ${DIM}Running...${RESET}"
rm -rf "$DEMO_DIR/node_modules/" "$DEMO_DIR/dist/"
echo -e "    ${RED}node_modules/ — deleted${RESET}"
echo -e "    ${RED}dist/ — deleted${RESET}"
echo ""
echo -e "  ${DIM}After:${RESET}"
ls "$DEMO_DIR" 2>/dev/null | sed 's/^/    /'
echo ""
sleep 1

# ── Cleanup ──────────────────────────────────────────────
echo -e "  ${DIM}─────────────────────────────────────────────────────────${RESET}"
echo -e "  ${DIM}Demo complete. Cleaning up ${DEMO_DIR}...${RESET}"
rm -rf "$DEMO_DIR"
echo -e "  ${GREEN}Done.${RESET}"
echo ""
