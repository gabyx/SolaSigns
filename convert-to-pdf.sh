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

# Change this end number.
REPLACE_NUMBER=1025
WITH_NEW_NUMBER=1050

cd "$DIR"

function convert() {
    local out="$1"
    local f="$2"

    cd "$DIR/svgs/$out"
    find "." -name "*.svg" -print0 |
        xargs -0 -I {} sed -i -E "s@>$REPLACE_NUMBER<@>$WITH_NEW_NUMBER<@g" {}
    find "." -name "*.svg" -print0 |
        xargs -0 -I {} inkscape -T -C -o "$DIR/output/$out/{}.pdf" "$DIR/svgs/$out/{}"

    cd "$DIR/output/$out"
    echo "Merge all PDFs together"
    pdfunite $(find "." -name "*.pdf" | sort | xargs -I {} echo {}) "$DIR/$f"
}

echo "Convert all SVGs to PDF..."
convert "1-200-400-600-800-1000" "All-5-Ranges.pdf"

cp "$DIR/svgs/1-200-400-600-800-1000/Sola-1000.svg" "$DIR/svgs/1-500-1000/Sola-1000.svg"
cp "$DIR/svgs/1-200-400-600-800-1000/Sola-1000R.svg" "$DIR/svgs/1-500-1000/Sola-1000R.svg"
convert "1-500-1000" "All-2-Ranges.pdf"


rm -f "$DIR/svgs/1-500-1000/Sola-1000.svg"
rm -f "$DIR/svgs/1-500-1000/Sola-1000R.svg"

echo "Merge all PDFs together"
pdfunite "$DIR/All-5-Ranges.pdf" "$DIR/All-2-Ranges.pdf" "$DIR/All.pdf"
