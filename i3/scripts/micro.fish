#!/usr/bin/fish

function setMicro
  pactl load-module module-echo-cancel source_name=noechosource sink_name=noechosin
end


if not test (pactl list sinks | rg "echo-cancel" | count) -gt 1
  echo "starting..."
  setMicro
end

