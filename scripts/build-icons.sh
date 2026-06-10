#!/usr/bin/env bash
#
# Regenerate the add-in PNG icons from the SVG sources.
#
#   icon-80.png, icon-32.png  <- assets/logo.svg        (detailed: staircase + guides)
#   icon-16.png               <- assets/logo-small.svg  (bold 3-row glyph, legible tiny)
#
# Uses macOS-native QuickLook (qlmanage) to rasterize SVG and sips to resize —
# no extra dependencies. Run from the repo root:  npm run icons
#
set -euo pipefail

cd "$(dirname "$0")/../assets"

# Rasterize an SVG to a square PNG at the given size. Renders at high resolution
# (320px) then downscales with sips for clean anti-aliasing at small sizes.
#   $1 = source .svg   $2 = output .png   $3 = size (px)
render() {
  local src="$1" out="$2" size="$3"
  local tmp="_build.svg"
  # QuickLook honors the SVG's width/height, so scale them up before rendering.
  sed 's/width="80" height="80"/width="320" height="320"/' "$src" > "$tmp"
  rm -f "${tmp}.png"
  qlmanage -t -s 320 -o . "$tmp" >/dev/null 2>&1
  mv "${tmp}.png" "$out"
  sips -z "$size" "$size" "$out" >/dev/null 2>&1
  rm -f "$tmp"
}

render logo.svg       icon-80.png 80
render logo.svg       icon-32.png 32
render logo-small.svg icon-16.png 16

echo "Rebuilt icon-16.png, icon-32.png, icon-80.png"
