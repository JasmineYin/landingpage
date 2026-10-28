# snap.ps1 - render a local HTML file to PNG screenshots with headless Chrome
# Usage:
#   .\scripts\snap.ps1                      # index.html at 1440 and 390
#   .\scripts\snap.ps1 -Path index.html -Widths 1440,1024,768,390
#   .\scripts\snap.ps1 -Height 2200         # taller capture
param(
  [string]$Path = 'index.html',
  [int[]]$Widths = @(1440, 390),
  [int]$Height = 900,
  [string]$OutDir = 'snaps'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
if (-not [System.IO.Path]::IsPathRooted($Path)) { $Path = Join-Path $root $Path }
if (-not (Test-Path -LiteralPath $Path)) { throw "HTML not found: $Path" }

$chrome = @(
  "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
  "${env:ProgramFiles(x86)}\Microsoft\Edge\Application\msedge.exe",
  "$env:ProgramFiles\Microsoft\Edge\Application\msedge.exe"
) | Where-Object { Test-Path -LiteralPath $_ } | Select-Object -First 1
if (-not $chrome) { throw 'Chrome/Edge not found. Install a browser or pass a path.' }

$outDir = if ([System.IO.Path]::IsPathRooted($OutDir)) { $OutDir } else { Join-Path $root $OutDir }
New-Item -ItemType Directory -Path $outDir -Force | Out-Null
$profileDir = Join-Path $root '.cache\chrome-profile'
New-Item -ItemType Directory -Path $profileDir -Force | Out-Null

$url = ([System.Uri]$Path).AbsoluteUri
$results = @()

foreach ($w in $Widths) {
  $png = Join-Path $outDir ("snap-{0}.png" -f $w)
  # Chrome writes noise to stderr; never let it abort the loop.
  $ErrorActionPreference = 'SilentlyContinue'
  & $chrome --headless=new --disable-gpu --hide-scrollbars --force-device-scale-factor=1 `
    "--user-data-dir=$profileDir" --no-first-run --no-default-browser-check `
    "--virtual-time-budget=4000" "--window-size=$w,$Height" `
    "--screenshot=$png" $url 2>$null | Out-Null
  $ErrorActionPreference = 'Stop'
  if (Test-Path -LiteralPath $png) {
    $kb = [math]::Round((Get-Item -LiteralPath $png).Length / 1KB)
    $results += "{0}x{1} -> {2} ({3} KB)" -f $w, $Height, $png, $kb
  } else {
    $results += "{0}x{1} -> FAILED" -f $w, $Height
  }
}

$results | ForEach-Object { Write-Host $_ }
