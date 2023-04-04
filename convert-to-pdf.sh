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

END_NUMBER=1025

cd "$DIR"

echo "Convert all SVGs to PDF..."
out="1-200-400-600-800-1000"
cd "$DIR/svgs/$out"
find "." -name "*.svg" -print0 |
    xargs -0 -I {} sed -i -E "s@>1000@>$END_NUMBER@"
find "." -name "*.svg" -print0 |
    xargs -0 -I {} inkscape -T -C -o "$DIR/output/$out/{}.pdf" "$DIR/svgs/$out/{}"

cd "$DIR/output/$out"
echo "Merge all PDFs together"
pdfunite $(find "." -name "*.pdf" | sort | xargs -I {} echo {}) "$DIR/All-5-Ranges.pdf"

out="1-500-1000"
cd "$DIR/svgs/$out"
find "." -name "*.svg" -print0 |
    xargs -0 -I {} inkscape -T -C -o "$DIR/output/$out/{}.pdf" "$DIR/svgs/$out/{}"

cd "$DIR/output/$out"
echo "Merge all PDFs together"
pdfunite $(find "." -name "*.pdf" | sort | xargs -I {} echo {}) "$DIR/All-2-Ranges.pdf"

echo "Merge all PDFs together"
pdfunite "$DIR/All-5-Ranges.pdf" "$DIR/All-2-Ranges.pdf" "$DIR/All.pdf"