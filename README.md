# Second Brain Starter

A beginner-friendly personal knowledge base built with **Next.js 16**, **React 19**, **Tailwind CSS v4**, and **Prisma + SQLite**. Capture ideas, organize them by category, and pin the ones that matter most — all running locally on your machine.

![Next.js](https://img.shields.io/badge/Next.js-16-black?logo=next.js)
![React](https://img.shields.io/badge/React-19-blue?logo=react)
![Tailwind CSS](https://img.shields.io/badge/Tailwind_CSS-4-38bdf8?logo=tailwindcss)
![Prisma](https://img.shields.io/badge/Prisma-SQLite-2d3748?logo=prisma)
![License](https://img.shields.io/badge/License-MIT-green)

## Features

- **Idea cards** with titles, descriptions, categories, and auto-assigned emojis
- **8 color-coded categories** — General, School, Creative, Music, Tech, Goals, Journal, Funny
- **Pin ideas** to keep important ones at the top
- **Responsive grid** layout that adapts to any screen size
- **Server-side rendering** — pages load fast with no loading spinners
- **Local SQLite database** — your data stays on your machine

## Quick Start (Windows)

Open **PowerShell** and paste this single command:

```powershell
powershell -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/brandonsgreene/second-brain-starter/main/setup.ps1 | iex"
```

This installs everything automatically (Git, Node.js, VS Code, dependencies, database) and opens the app. Takes about 5–10 minutes on a fresh machine.

Then open **http://localhost:3000** in your browser.

## Quick Start (macOS)

Open **Terminal** and paste:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/brandonsgreene/second-brain-starter/main/setup.sh)"
```

## Manual Setup

If you prefer to set things up yourself:

```bash
# Prerequisites: Node.js 20+ and Git

git clone https://github.com/brandonsgreene/second-brain-starter.git
cd second-brain-starter

npm install
npx prisma migrate dev --name init
npx prisma generate

npm run dev
```

Open **http://localhost:3000**.

## Project Structure

```
second-brain-starter/
+-- prisma/
|   +-- schema.prisma        # Database schema (Idea model)
+-- src/
|   +-- app/
|   |   +-- globals.css       # Theme colors (Tailwind v4 + CSS vars)
|   |   +-- layout.tsx        # Root layout with fonts
|   |   +-- page.tsx          # Home page (Server Component)
|   +-- actions/
|   |   +-- ideas.ts          # Server Actions (create, delete, pin)
|   +-- components/
|   |   +-- idea-card.tsx     # Idea card (Client Component)
|   |   +-- new-idea-form.tsx # Add idea form (Client Component)
|   +-- lib/
|       +-- prisma.ts         # Prisma singleton
|       +-- utils.ts          # cn() helper
+-- setup.ps1                 # Windows one-command setup
+-- setup.sh                  # macOS one-command setup
+-- package.json
+-- .env                      # DATABASE_URL (SQLite)
```

## Tech Stack

| Layer | Technology | Purpose |
|-------|-----------|---------|
| Framework | Next.js 16 (App Router) | Server & client rendering, routing |
| UI | React 19 | Component-based UI |
| Styling | Tailwind CSS v4 | Utility-first CSS |
| Database | SQLite via Prisma | Local, zero-config persistence |
| Language | TypeScript (strict) | Type safety |
| Icons | Lucide React | SVG icon library |

## Key Concepts

This project demonstrates several modern web development patterns:

- **Server Components** (`page.tsx`) — fetch data directly on the server, no API layer needed
- **Client Components** (`idea-card.tsx`, `new-idea-form.tsx`) — handle interactivity in the browser with `"use client"`
- **Server Actions** (`ideas.ts`) — mutate data from client components via `"use server"` functions
- **Prisma ORM** — type-safe database queries with auto-generated TypeScript types
- **CSS Variables** — theme colors defined once, used everywhere via Tailwind

## Commands

| Command | Description |
|---------|-------------|
| `npm run dev` | Start development server on localhost:3000 |
| `npm run build` | Production build (type-checks + compiles) |
| `npm run lint` | Run ESLint |
| `npx prisma studio` | Visual database browser |
| `npx prisma migrate dev --name <name>` | Create/run database migrations |
| `npx prisma generate` | Regenerate Prisma client after schema changes |

## Ideas for Extending

Once you're comfortable, try adding:

- **Search** — filter ideas with a search bar
- **Dark mode** — toggle between light and dark themes
- **Edit ideas** — update content after creation
- **Tags** — flexible many-to-many tagging instead of single categories
- **Folders** — organize ideas into notebooks
- **Markdown** — rich text formatting in idea content
- **AI features** — summarize ideas or find related ones with the Claude API
- **Deploy** — host on Vercel or Railway so you can access it from any device

## Using Claude Code

[Claude Code](https://docs.anthropic.com/en/docs/claude-code) is an AI coding assistant that runs in your terminal. It can read your project, understand the architecture, and make changes to your files.

```bash
npm install -g @anthropic-ai/claude-code
cd ~/Code/second-brain
claude
```

Then describe what you want in plain English — Claude handles the rest.

## License

MIT
