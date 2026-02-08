#!/bin/bash

# browser=$(xdg-settings get default-web-browser)
browser=google-chrome

exec setsid uwsm app -- $browser --app="$1" "${@:2}"
