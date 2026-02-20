#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
DIST="$ROOT/packages/opencode/dist"
PKG_DIR="$DIST/nellie-code"
INSTALLER_DIR="$ROOT/packaging/installers"

cd "$ROOT"

bun install
bun run --cwd packages/opencode script/build.ts -- --single

mkdir -p "$DIST/nellie-code-windows-x64" "$DIST/nellie-code-darwin-arm64" "$DIST/nellie-code-wsl-x64"
cat > "$DIST/nellie-code-windows-x64/package.json" <<'JSON'
{
  "name": "nellie-code-windows-x64",
  "version": "0.0.0-meta",
  "os": ["win32"],
  "cpu": ["x64"],
  "scripts": {
    "postinstall": "echo Install via packaging/installers/nellie-code-windows-native.zip or run npm i -g nellie-code on Windows host."
  }
}
JSON
cat > "$DIST/nellie-code-darwin-arm64/package.json" <<'JSON'
{
  "name": "nellie-code-darwin-arm64",
  "version": "0.0.0-meta",
  "os": ["darwin"],
  "cpu": ["arm64"],
  "scripts": {
    "postinstall": "echo Install via packaging/installers/nellie-code-macos-native.zip or run npm i -g nellie-code on macOS."
  }
}
JSON
cat > "$DIST/nellie-code-wsl-x64/package.json" <<'JSON'
{
  "name": "nellie-code-wsl-x64",
  "version": "0.0.0-meta",
  "os": ["linux"],
  "cpu": ["x64"],
  "scripts": {
    "postinstall": "echo Install via packaging/installers/nellie-code-wsl-native.tar.gz inside WSL."
  }
}
JSON

mkdir -p "$PKG_DIR"
cp -r "$ROOT/packages/opencode/bin" "$PKG_DIR/bin"
cp -r "$ROOT/packages/opencode/config" "$PKG_DIR/config"
cp "$ROOT/packages/opencode/script/postinstall.mjs" "$PKG_DIR/postinstall.mjs"
cp "$ROOT/LICENSE" "$PKG_DIR/LICENSE"

ROOT_ENV="$ROOT" node - <<'NODE'
const fs=require('fs');
const path=require('path');
const root=process.env.ROOT_ENV;
const dist=path.join(root,'packages/opencode/dist');
const pkg=JSON.parse(fs.readFileSync(path.join(root,'packages/opencode/package.json'),'utf8'));
const binaries={};
for (const name of fs.readdirSync(dist)) {
  const p=path.join(dist,name,'package.json');
  if (!fs.existsSync(p)) continue;
  const meta=JSON.parse(fs.readFileSync(p,'utf8'));
  binaries[meta.name]=meta.version;
}
const version=
  binaries['nellie-code-linux-x64'] ||
  binaries['nellie-code-linux-arm64'] ||
  binaries['nellie-code-linux-x64-musl'] ||
  pkg.version;
const meta={
  name:'nellie-code',
  version,
  license:pkg.license,
  bin:{'nellie-code':'./bin/nellie-code','opencode':'./bin/opencode'},
  scripts:{postinstall:'bun ./postinstall.mjs || node ./postinstall.mjs'},
  optionalDependencies:binaries,
};
fs.writeFileSync(path.join(dist,'nellie-code','package.json'),JSON.stringify(meta,null,2)+'\n');
NODE

for dir in "$DIST"/nellie-code-*; do
  [ -d "$dir" ] || continue
  (cd "$dir" && bun pm pack >/dev/null)
done
(cd "$PKG_DIR" && bun pm pack >/dev/null)

mkdir -p "$INSTALLER_DIR/windows" "$INSTALLER_DIR/linux" "$INSTALLER_DIR/wsl" "$INSTALLER_DIR/macos"

cp "$ROOT/install" "$INSTALLER_DIR/linux/install.sh"
cp "$ROOT/install" "$INSTALLER_DIR/wsl/install.sh"
chmod +x "$INSTALLER_DIR/linux/install.sh" "$INSTALLER_DIR/wsl/install.sh"

cat > "$INSTALLER_DIR/windows/install.ps1" <<'PS1'
$ErrorActionPreference = 'Stop'
$target = Join-Path $env:USERPROFILE '.nellie-code\\bin'
New-Item -ItemType Directory -Force -Path $target | Out-Null
Copy-Item -Force '.\\nellie-code.exe' (Join-Path $target 'nellie-code.exe')
Write-Host "Installed Nellie Code to $target"
PS1

cat > "$INSTALLER_DIR/wsl/install-wsl.sh" <<'WSL'
#!/usr/bin/env bash
set -euo pipefail
./install.sh --no-modify-path
echo "Installed for WSL at ~/.nellie-code/bin"
WSL
chmod +x "$INSTALLER_DIR/wsl/install-wsl.sh"

if [ -f "$DIST/nellie-code-linux-x64/bin/nellie-code" ]; then
  cp "$DIST/nellie-code-linux-x64/bin/nellie-code" "$INSTALLER_DIR/linux/nellie-code"
  cp "$DIST/nellie-code-linux-x64/bin/nellie-code" "$INSTALLER_DIR/wsl/nellie-code"
  chmod +x "$INSTALLER_DIR/linux/nellie-code" "$INSTALLER_DIR/wsl/nellie-code"
fi

if [ -f "$DIST/nellie-code-darwin-arm64/bin/nellie-code" ]; then
  cp "$DIST/nellie-code-darwin-arm64/bin/nellie-code" "$INSTALLER_DIR/macos/nellie-code"
fi
if [ -f "$DIST/nellie-code-windows-x64/bin/nellie-code.exe" ]; then
  cp "$DIST/nellie-code-windows-x64/bin/nellie-code.exe" "$INSTALLER_DIR/windows/nellie-code.exe"
fi

for d in "$INSTALLER_DIR/windows" "$INSTALLER_DIR/linux" "$INSTALLER_DIR/wsl" "$INSTALLER_DIR/macos"; do
  if [ -z "$(ls -A "$d")" ]; then
    echo "No native artifact produced for this platform in current environment." > "$d/README.txt"
  fi
done

(cd "$INSTALLER_DIR/linux" && tar -czf ../nellie-code-linux-native.tar.gz .)
(cd "$INSTALLER_DIR/wsl" && tar -czf ../nellie-code-wsl-native.tar.gz .)
(cd "$INSTALLER_DIR/macos" && zip -qr ../nellie-code-macos-native.zip .)
(cd "$INSTALLER_DIR/windows" && zip -qr ../nellie-code-windows-native.zip .)

echo "Packaging complete"
