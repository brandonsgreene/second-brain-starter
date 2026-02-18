# ──────────────────────────────────────────────────────
#  Second Brain — One-Command Setup (Windows)
# ──────────────────────────────────────────────────────
#  Run this with:
#    powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/brandonsgreene/second-brain-starter/main/setup.ps1 | iex"
#
#  What it does:
#    1. Installs Git
#    2. Installs Node.js
#    3. Installs VS Code
#    4. Clones the starter repo to ~/Code/second-brain
#    5. Installs npm dependencies
#    6. Sets up the database
#    7. Installs VS Code extensions
#    8. Opens the project in VS Code
#    9. Starts the dev server
# ──────────────────────────────────────────────────────

$ErrorActionPreference = "Stop"

$ProjectDir = Join-Path $HOME "Code\second-brain"
$RepoUrl = "https://github.com/brandonsgreene/second-brain-starter.git"

# ── Colors & formatting ──────────────────────────────
function Write-Header($text) {
    Write-Host ""
    Write-Host ("=" * 52) -ForegroundColor Magenta
    Write-Host "  $text" -ForegroundColor Magenta
    Write-Host ("=" * 52) -ForegroundColor Magenta
    Write-Host ""
}

function Write-Step($text) {
    Write-Host "-> " -ForegroundColor Cyan -NoNewline
    Write-Host $text
}

function Write-Ok($text) {
    Write-Host "[OK] " -ForegroundColor Green -NoNewline
    Write-Host $text
}

function Write-Skip {
    Write-Host "     (already installed -- skipping)" -ForegroundColor DarkGray
}

function Write-Warn($text) {
    Write-Host "[!] " -ForegroundColor Yellow -NoNewline
    Write-Host $text
}

function Write-Err($text) {
    Write-Host "[X] " -ForegroundColor Red -NoNewline
    Write-Host $text
}

function Refresh-Path {
    # Reload PATH from registry so newly installed tools are found
    $machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machinePath;$userPath"
}

function Test-Command($name) {
    return [bool](Get-Command $name -ErrorAction SilentlyContinue)
}

# ── Welcome ──────────────────────────────────────────
Clear-Host
Write-Host ""
Write-Host "    ____            _       " -ForegroundColor Magenta
Write-Host "   | __ ) _ __ __ _(_)_ __  " -ForegroundColor Magenta
Write-Host "   |  _ \| '__/ _`` | | '_ \ " -ForegroundColor Magenta
Write-Host "   | |_) | | | (_| | | | | |" -ForegroundColor Magenta
Write-Host "   |____/|_|  \__,_|_|_| |_|" -ForegroundColor Magenta
Write-Host ""
Write-Host "  My Second Brain -- Setup Script (Windows)" -ForegroundColor White
Write-Host "  This will install everything you need to start coding." -ForegroundColor DarkGray
Write-Host "  It's safe to run this multiple times." -ForegroundColor DarkGray
Write-Host ""
Write-Host ("─" * 52) -ForegroundColor DarkGray
Write-Host ""

$reply = Read-Host "  Ready to start? (y/n)"
if ($reply -ne "y" -and $reply -ne "Y") {
    Write-Host ""
    Write-Host "  No worries -- run this script again whenever you're ready!" -ForegroundColor DarkGray
    exit 0
}

# ── 1. Check for winget ─────────────────────────────
Write-Header "1/7  Checking winget (App Installer)"

if (Test-Command "winget") {
    Write-Ok "winget found"
    Write-Skip
} else {
    Write-Err "winget not found."
    Write-Host ""
    Write-Host "  winget comes with the 'App Installer' from the Microsoft Store." -ForegroundColor Yellow
    Write-Host "  Please install it from: https://aka.ms/getwinget" -ForegroundColor Yellow
    Write-Host "  Then run this script again." -ForegroundColor Yellow
    Write-Host ""
    Start-Process "https://aka.ms/getwinget"
    exit 1
}

# ── 2. Git ──────────────────────────────────────────
Write-Header "2/7  Git"
Write-Step "Checking for Git..."

if (Test-Command "git") {
    $gitVer = git --version
    Write-Ok "Git found ($gitVer)"
    Write-Skip
} else {
    Write-Step "Installing Git..."
    winget install --id Git.Git --accept-package-agreements --accept-source-agreements --silent
    Refresh-Path

    if (Test-Command "git") {
        Write-Ok "Git installed"
    } else {
        # winget installs may need a PATH refresh via a new shell
        Write-Warn "Git installed but not found in PATH yet."
        Write-Warn "If the script fails below, close this window, reopen PowerShell, and run the script again."
        # Try common Git install location
        $gitPath = "C:\Program Files\Git\cmd"
        if (Test-Path $gitPath) {
            $env:Path = "$gitPath;$env:Path"
            Write-Ok "Added Git to PATH for this session"
        }
    }
}

# ── 3. Node.js ──────────────────────────────────────
Write-Header "3/7  Node.js"
Write-Step "Checking for Node.js..."

if (Test-Command "node") {
    $nodeVer = node --version
    Write-Ok "Node.js found ($nodeVer)"
    Write-Skip
} else {
    Write-Step "Installing Node.js LTS..."
    winget install --id OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements --silent
    Refresh-Path

    if (Test-Command "node") {
        Write-Ok "Node.js installed ($(node --version))"
    } else {
        Write-Warn "Node.js installed but not found in PATH yet."
        # Try common Node install locations
        $nodePath = "C:\Program Files\nodejs"
        if (Test-Path $nodePath) {
            $env:Path = "$nodePath;$env:Path"
            Write-Ok "Added Node.js to PATH for this session"
        } else {
            Write-Err "Could not find Node.js. Close this window, reopen PowerShell, and run the script again."
            exit 1
        }
    }
}

# Verify npm
if (Test-Command "npm") {
    Write-Ok "npm found ($(npm --version))"
} else {
    Write-Err "npm not found. Close this window, reopen PowerShell, and run the script again."
    exit 1
}

# ── 4. VS Code ──────────────────────────────────────
Write-Header "4/7  Visual Studio Code"
Write-Step "Checking for VS Code..."

if (Test-Command "code") {
    Write-Ok "VS Code found"
    Write-Skip
} else {
    Write-Step "Installing VS Code..."
    winget install --id Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements --silent
    Refresh-Path

    if (-not (Test-Command "code")) {
        # Try common VS Code location
        $codePath = Join-Path $env:LOCALAPPDATA "Programs\Microsoft VS Code\bin"
        if (Test-Path $codePath) {
            $env:Path = "$codePath;$env:Path"
        }
    }

    if (Test-Command "code") {
        Write-Ok "VS Code installed"
    } else {
        Write-Warn "VS Code installed but 'code' command not found in PATH yet."
        Write-Warn "You may need to restart your computer for VS Code CLI to work."
    }
}

# ── 5. Clone the repo ──────────────────────────────
Write-Header "5/7  Clone the Project"

$codeDir = Join-Path $HOME "Code"
if (-not (Test-Path $codeDir)) {
    New-Item -ItemType Directory -Path $codeDir -Force | Out-Null
    Write-Step "Created $codeDir"
}

if (Test-Path $ProjectDir) {
    Write-Ok "Project folder already exists at $ProjectDir"
    Write-Skip
    Set-Location $ProjectDir
} else {
    Write-Step "Cloning from GitHub..."
    git clone $RepoUrl $ProjectDir
    Set-Location $ProjectDir
    Write-Ok "Project cloned to $ProjectDir"
}

# ── 6. Install dependencies & database ─────────────
Write-Header "6/7  Install Dependencies & Database"
Set-Location $ProjectDir

if (Test-Path "node_modules") {
    Write-Ok "node_modules found"
    Write-Skip
} else {
    Write-Step "Running npm install (this may take a minute or two)..."
    npm install
    Write-Ok "Dependencies installed"
}

Write-Step "Setting up database..."
if (Test-Path "prisma\dev.db") {
    Write-Ok "Database already exists"
    Write-Skip
    npx prisma generate --no-hints 2>$null
} else {
    npx prisma migrate dev --name init --skip-generate 2>$null
    npx prisma generate --no-hints 2>$null
    Write-Ok "Database created and ready"
}

# ── 7. VS Code extensions ──────────────────────────
Write-Header "7/7  VS Code Extensions"

if (Test-Command "code") {
    $extensions = @(
        "bradlc.vscode-tailwindcss",
        "Prisma.prisma",
        "dbaeumer.vscode-eslint",
        "YoavBls.pretty-ts-errors"
    )

    foreach ($ext in $extensions) {
        $extName = $ext.Split(".")[-1]
        Write-Step "Installing $extName..."
        code --install-extension $ext --force 2>$null
        Write-Ok "$extName installed"
    }
} else {
    Write-Warn "VS Code 'code' command not available -- install extensions manually later."
}

# ── Done! ────────────────────────────────────────────
Write-Host ""
Write-Host ("=" * 52) -ForegroundColor Magenta
Write-Host ""
Write-Host "  Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "  Your project is at: $ProjectDir" -ForegroundColor White
Write-Host ""
Write-Host "  What's next:" -ForegroundColor White
Write-Host "  1. Opening your project in VS Code..." -ForegroundColor Cyan
Write-Host "  2. Starting the dev server..." -ForegroundColor Cyan
Write-Host "  3. Open http://localhost:3000 in your browser" -ForegroundColor Cyan
Write-Host ""
Write-Host ("=" * 52) -ForegroundColor Magenta
Write-Host ""

# Open VS Code
if (Test-Command "code") {
    code $ProjectDir
}

# Start the dev server
Set-Location $ProjectDir
Write-Host "  Starting your Second Brain..." -ForegroundColor Green
Write-Host "  (Press Ctrl+C to stop the server)" -ForegroundColor DarkGray
Write-Host ""
npm run dev
