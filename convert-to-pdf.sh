#!/usr/bin/env bash
# shellcheck disable=SC1090,SC2015,SC1091
# =============================================================================
# Convert all SVG to PDFs.
#
# @date Sun Mar 06 2022
# @author Gabriel Nützi, gnuetzi@gmail.com
# =============================================================================
set -u
set -e
set -o pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

cd "$DIR"

echo "Convert all SVGs to PDF..."
cd svgs
find "." -name "*.svg" -print0 |
    xargs -0 -n 1 -I {} inkscape -T -C -o "$DIR/output/{}.pdf" {}

cd "$DIR/output"
echo "Merge all PDFs together"
pdfunite $(find "." -name "*.pdf" | sort | xargs -I {} echo {}) "$DIR/All.pdf"