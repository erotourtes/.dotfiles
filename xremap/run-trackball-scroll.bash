#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

bin="${XDG_RUNTIME_DIR:-/tmp}/trackball-scroll-filter"

if [[ ! -x "$bin" || trackball-scroll-filter.c -nt "$bin" ]]; then
  gcc -Wall -Wextra -O2 -o "$bin" trackball-scroll-filter.c
fi

exec "$bin" xremap-scroll trackball-scroll
