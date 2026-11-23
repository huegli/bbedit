#!/bin/zsh
# One-time (per manual version) build of searchable text from the PDF.
# usage: manual/build.sh [path-to-pdf]   (default: manual/pdf/BBEdit_16.0.3_User_Manual.pdf)
set -e
here=${0:A:h}
pdf=${1:-$here/pdf/BBEdit_16.0.3_User_Manual.pdf}
[[ -f $pdf ]] || { echo "PDF not found: $pdf" >&2; exit 1; }
swiftc -O -o $here/tools/extract $here/tools/extract.swift
$here/tools/extract "$pdf" $here/text
