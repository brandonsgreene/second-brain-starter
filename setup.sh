#!/bin/bash
# ──────────────────────────────────────────────────────
#  Second Brain — One-Command Setup
# ──────────────────────────────────────────────────────
#  Run this with:
#    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/brandonsgreene/second-brain-starter/main/setup.sh)"
#
#  What it does:
#    1. Installs Xcode CLI tools (git)
#    2. Installs Homebrew (Mac package manager)
#    3. Installs Node.js
#    4. Installs VS Code
#    5. Clones the starter repo to ~/Code/second-brain
#    6. Installs npm dependencies
#    7. Sets up the database
#    8. Installs VS Code extensions
#    9. Opens the project in VS Code
#   10. Starts the dev server
# ──────────────────────────────────────────────────────

set -e

# ── Colors & formatting ──────────────────────────────
PURPLE='\033[0;35m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

PROJECT_DIR="$HOME/Code/second-brain"
REPO_URL="https://github.com/brandonsgreene/second-brain-starter.git"

print_header() {
  echo ""
  echo -e "${PURPLE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo -e "${PURPLE}${BOLD}  $1${RESET}"
  echo -e "${PURPLE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
  echo ""
}

print_step() {
  echo -e "${BLUE}${BOLD}→${RESET} $1"
}

print_success() {
  echo -e "${GREEN}${BOLD}✓${RESET} $1"
}

print_skip() {
  echo -e "${DIM}  (already installed — skipping)${RESET}"
}

print_warning() {
  echo -e "${YELLOW}${BOLD}!${RESET} $1"
}

print_error() {
  echo -e "${RED}${BOLD}✗${RESET} $1"
}

# ── Welcome ──────────────────────────────────────────
clear
echo ""
echo -e "${PURPLE}${BOLD}"
echo "    ____            _       "
echo "   | __ ) _ __ __ _(_)_ __  "
echo "   |  _ \| '__/ _\` | | '_ \ "
echo "   | |_) | | | (_| | | | | |"
echo "   |____/|_|  \__,_|_|_| |_|"
echo ""
echo -e "${RESET}"
echo -e "${BOLD}  My Second Brain — Setup Script${RESET}"
echo -e "${DIM}  This will install everything you need to start coding.${RESET}"
echo -e "${DIM}  It's safe to run this multiple times.${RESET}"
echo ""
echo -e "${DIM}──────────────────────────────────────────────────────${RESET}"
echo ""
read -p "  Ready to start? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo ""
  echo -e "${DIM}  No worries — run this script again whenever you're ready!${RESET}"
  exit 0
fi

# ── 1. Xcode Command Line Tools ─────────────────────
print_header "1/8  Xcode Command Line Tools"
print_step "Checking for git (comes with Xcode CLI tools)..."

if xcode-select -p &>/dev/null; then
  print_success "Xcode CLI tools found"
  print_skip
else
  print_step "Installing Xcode Command Line Tools..."
  print_warning "A popup may appear — click 'Install' and wait for it to finish."
  xcode-select --install 2>/dev/null || true

  # Wait for the user to complete the GUI install
  echo ""
  echo -e "${YELLOW}  Waiting for Xcode CLI tools to install...${RESET}"
  echo -e "${DIM}  (Click 'Install' in the popup if you see one)${RESET}"
  echo ""
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
  print_success "Xcode CLI tools installed"
fi

# ── 2. Homebrew ──────────────────────────────────────
print_header "2/8  Homebrew (Mac Package Manager)"
print_step "Checking for Homebrew..."

if command -v brew &>/dev/null; then
  print_success "Homebrew found"
  print_skip
else
  print_step "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # Add Homebrew to PATH for Apple Silicon Macs
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
    # Also add to .zprofile so it persists
    if ! grep -q 'brew shellenv' "$HOME/.zprofile" 2>/dev/null; then
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> "$HOME/.zprofile"
    fi
  fi

  print_success "Homebrew installed"
fi

# ── 3. Node.js ───────────────────────────────────────
print_header "3/8  Node.js"
print_step "Checking for Node.js..."

if command -v node &>/dev/null; then
  NODE_VERSION=$(node --version)
  print_success "Node.js found (${NODE_VERSION})"
  print_skip
else
  print_step "Installing Node.js via Homebrew..."
  brew install node
  print_success "Node.js installed ($(node --version))"
fi

# Verify npm
if command -v npm &>/dev/null; then
  print_success "npm found ($(npm --version))"
else
  print_error "npm not found — something went wrong with the Node.js installation"
  exit 1
fi

# ── 4. VS Code ──────────────────────────────────────
print_header "4/8  Visual Studio Code"
print_step "Checking for VS Code..."

if command -v code &>/dev/null; then
  print_success "VS Code found"
  print_skip
elif [[ -d "/Applications/Visual Studio Code.app" ]]; then
  print_success "VS Code app found — installing 'code' command..."
  # Add the code command to PATH
  VSCODE_BIN="/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  if [[ -d "$VSCODE_BIN" ]]; then
    export PATH="$VSCODE_BIN:$PATH"
    print_success "'code' command available"
  fi
else
  print_step "Installing VS Code via Homebrew..."
  brew install --cask visual-studio-code
  print_success "VS Code installed"

  # Make sure the 'code' command is available
  if [[ -d "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" ]]; then
    export PATH="/Applications/Visual Studio Code.app/Contents/Resources/app/bin:$PATH"
  fi
fi

# ── 5. Clone the repo ───────────────────────────────
print_header "5/8  Clone the Project"
print_step "Setting up project at ${PROJECT_DIR}..."

mkdir -p "$HOME/Code"

if [[ -d "$PROJECT_DIR" ]]; then
  print_success "Project folder already exists at ${PROJECT_DIR}"
  print_skip
  cd "$PROJECT_DIR"
else
  print_step "Cloning from GitHub..."
  git clone "$REPO_URL" "$PROJECT_DIR"
  cd "$PROJECT_DIR"
  print_success "Project cloned to ${PROJECT_DIR}"
fi

# ── 6. Install dependencies ─────────────────────────
print_header "6/8  Install Dependencies"
cd "$PROJECT_DIR"

if [[ -d "node_modules" ]]; then
  print_success "node_modules found"
  print_skip
else
  print_step "Running npm install (this may take a minute)..."
  npm install
  print_success "Dependencies installed"
fi

# ── 7. Set up the database ──────────────────────────
print_header "7/8  Set Up Database"
print_step "Running Prisma migrations..."

if [[ -f "prisma/dev.db" ]]; then
  print_success "Database already exists"
  print_skip
  npx prisma generate --no-hints 2>/dev/null
else
  npx prisma migrate dev --name init --skip-generate 2>/dev/null
  npx prisma generate --no-hints 2>/dev/null
  print_success "Database created and ready"
fi

# ── 8. VS Code extensions ───────────────────────────
print_header "8/8  VS Code Extensions"

if command -v code &>/dev/null; then
  EXTENSIONS=(
    "bradlc.vscode-tailwindcss"
    "Prisma.prisma"
    "dbaeumer.vscode-eslint"
    "YoavBls.pretty-ts-errors"
  )

  for ext in "${EXTENSIONS[@]}"; do
    EXT_NAME=$(echo "$ext" | cut -d. -f2-)
    if code --list-extensions 2>/dev/null | grep -qi "$ext"; then
      print_success "${EXT_NAME} — already installed"
    else
      print_step "Installing ${EXT_NAME}..."
      code --install-extension "$ext" --force 2>/dev/null
      print_success "${EXT_NAME} installed"
    fi
  done
else
  print_warning "VS Code 'code' command not found — install extensions manually later"
fi

# ── Done! ────────────────────────────────────────────
echo ""
echo -e "${PURPLE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""
echo -e "${GREEN}${BOLD}  Setup complete!${RESET}"
echo ""
echo -e "  Your project is at: ${BOLD}${PROJECT_DIR}${RESET}"
echo ""
echo -e "  ${BOLD}What's next:${RESET}"
echo -e "  ${BLUE}1.${RESET} Opening your project in VS Code..."
echo -e "  ${BLUE}2.${RESET} Starting the dev server..."
echo -e "  ${BLUE}3.${RESET} Open ${BOLD}http://localhost:3000${RESET} in your browser"
echo ""
echo -e "${PURPLE}${BOLD}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

# Open VS Code
if command -v code &>/dev/null; then
  code "$PROJECT_DIR"
fi

# Start the dev server
cd "$PROJECT_DIR"
echo -e "${GREEN}${BOLD}  Starting your Second Brain...${RESET}"
echo -e "${DIM}  (Press Ctrl+C to stop the server)${RESET}"
echo ""
npm run dev
