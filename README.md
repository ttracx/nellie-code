<p align="center">
  <a href="https://vibecaas.com">
    <picture>
      <source srcset="packages/console/app/src/asset/logo-ornate-dark.svg" media="(prefers-color-scheme: dark)">
      <source srcset="packages/console/app/src/asset/logo-ornate-light.svg" media="(prefers-color-scheme: light)">
      <img src="packages/console/app/src/asset/logo-ornate-light.svg" alt="Nellie Code logo">
    </picture>
  </a>
</p>
<p align="center">Nellie Code by VibeCaaS: local-first AI coding with cloud fallback.</p>
<p align="center">
  <a href="https://vibecaas.com/discord"><img alt="Discord" src="https://img.shields.io/badge/discord-vibecaas-5865F2?style=flat-square" /></a>
  <a href="https://www.npmjs.com/package/nellie-code"><img alt="npm" src="https://img.shields.io/npm/v/nellie-code?style=flat-square" /></a>
  <a href="https://github.com/vibecaas/nellie-code/actions/workflows/publish.yml"><img alt="Build status" src="https://img.shields.io/github/actions/workflow/status/vibecaas/nellie-code/publish.yml?style=flat-square&branch=main" /></a>
</p>

<p align="center">
  <a href="README.md">English</a> |
  <a href="README.zh.md">简体中文</a> |
  <a href="README.zht.md">繁體中文</a> |
  <a href="README.ko.md">한국어</a> |
  <a href="README.de.md">Deutsch</a> |
  <a href="README.es.md">Español</a> |
  <a href="README.fr.md">Français</a> |
  <a href="README.it.md">Italiano</a> |
  <a href="README.da.md">Dansk</a> |
  <a href="README.ja.md">日本語</a> |
  <a href="README.pl.md">Polski</a> |
  <a href="README.ru.md">Русский</a> |
  <a href="README.bs.md">Bosanski</a> |
  <a href="README.ar.md">العربية</a> |
  <a href="README.no.md">Norsk</a> |
  <a href="README.br.md">Português (Brasil)</a> |
  <a href="README.th.md">ไทย</a> |
  <a href="README.tr.md">Türkçe</a> |
  <a href="README.uk.md">Українська</a>
</p>

[![Nellie Code Terminal UI](packages/web/src/assets/lander/screenshot.png)](https://nelliecode.vibecaas.com)

---

### Installation

```bash
# YOLO
curl -fsSL https://raw.githubusercontent.com/vibecaas/nellie-code/main/install | bash

# Package managers
npm i -g nellie-code@latest        # or bun/pnpm/yarn
scoop install nellie-code          # Windows
choco install nellie-code          # Windows
brew install vibecaas/tap/nellie-code # macOS and Linux
paru -S nellie-code-bin            # Arch Linux (AUR)
```

> [!TIP]
> Remove versions older than 0.1.x before installing.

### Desktop App (BETA)

Nellie Code is also available as a desktop application. Download directly from the [releases page](https://github.com/vibecaas/nellie-code/releases).

| Platform              | Download                              |
| --------------------- | ------------------------------------- |
| macOS (Apple Silicon) | `opencode-desktop-darwin-aarch64.dmg` |
| macOS (Intel)         | `opencode-desktop-darwin-x64.dmg`     |
| Windows               | `opencode-desktop-windows-x64.exe`    |
| Linux                 | `.deb`, `.rpm`, or AppImage           |

```bash
# macOS (Homebrew)
brew install --cask opencode-desktop
# Windows (Scoop)
scoop bucket add extras; scoop install extras/opencode-desktop
```

#### Installation Directory

The install script respects the following priority order for the installation path:

1. `$OPENCODE_INSTALL_DIR` - Custom installation directory
2. `$XDG_BIN_DIR` - XDG Base Directory Specification compliant path
3. `$HOME/bin` - Standard user binary directory (if it exists or can be created)
4. `$HOME/.opencode/bin` - Default fallback

```bash
# Examples
OPENCODE_INSTALL_DIR=/usr/local/bin curl -fsSL https://raw.githubusercontent.com/vibecaas/nellie-code/main/install | bash
XDG_BIN_DIR=$HOME/.local/bin curl -fsSL https://raw.githubusercontent.com/vibecaas/nellie-code/main/install | bash
```

### Agents

Nellie Code includes two built-in agents you can switch between with the `Tab` key.

- **build** - Default, full-access agent for development work
- **plan** - Read-only agent for analysis and code exploration
  - Denies file edits by default
  - Asks permission before running bash commands
  - Ideal for exploring unfamiliar codebases or planning changes

Also included is a **general** subagent for complex searches and multistep tasks.
This is used internally and can be invoked using `@general` in messages.

### Nellie Stack Routing

Nellie Code ships with prebuilt stack profiles in `packages/opencode/config`:

- `nellie-stack.local.jsonc`: local vLLM first, then Ollama/cloud and Anthropic/OpenAI backup.
- `nellie-stack.cloud.jsonc`: Ollama/cloud first, then Anthropic/OpenAI.
- `nellie-stack.safe.jsonc`: cloud-only safety fallback.

Set `NELLIE_CODE_STACK=local|cloud|safe|auto` (default `auto`) before launching.

Learn more about [agents](https://nelliecode.vibecaas.com/docs/agents).

### Documentation

For more info on how to configure Nellie Code, [**head over to our docs**](https://nelliecode.vibecaas.com/docs).

### Contributing

If you're interested in contributing to Nellie Code, please read our [contributing docs](./CONTRIBUTING.md) before submitting a pull request.

### Building on OpenCode

If you are working on a project that's related to OpenCode and is using "opencode" as part of its name, for example "opencode-dashboard" or "opencode-mobile", please add a note to your README to clarify that it is not built by the OpenCode team and is not affiliated with us in any way.

### FAQ

#### How is this different from Claude Code?

It's very similar to Claude Code in terms of capability. Here are the key differences:

- 100% open source
- Not coupled to any provider. Although we recommend the models we provide through [OpenCode Zen](https://opencode.ai/zen), OpenCode can be used with Claude, OpenAI, Google, or even local models. As models evolve, the gaps between them will close and pricing will drop, so being provider-agnostic is important.
- Out-of-the-box LSP support
- A focus on TUI. OpenCode is built by neovim users and the creators of [terminal.shop](https://terminal.shop); we are going to push the limits of what's possible in the terminal.
- A client/server architecture. This, for example, can allow OpenCode to run on your computer while you drive it remotely from a mobile app, meaning that the TUI frontend is just one of the possible clients.

---

**Join our community** [Discord](https://discord.gg/opencode) | [X.com](https://x.com/opencode)
