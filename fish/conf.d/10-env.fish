
set TERM "alacritty"
set -gx EDITOR nvim
set -gx VISUAL nvim
# set -gx PAGER "nvim -R"
set -gx MANPAGER "nvim +Man!"

if test -n "$SWAYSOCK"
  set -gx SDL_VIDEODRIVER             wayland
  set -gx _JAVA_AWT_WM_NONREPARENTING 1
  set -gx QT_QPA_PLATFORM             wayland
  set -gx XDG_CURRENT_DESKTOP         sway
  set -gx XDG_SESSION_DESKTOP         sway

  # QT_WAYLAND_FORCE_DPI=physical

  set -gx QT_WAYLAND_DISABLE_WINDOWDECORATION 1
  set -gx SDL_VIDEODRIVER wayland

  set -gx MOZ_ENABLE_WAYLAND 1
  set -gx MOZ_WEBRENDER 1
end

set --export BUN_INSTALL "$HOME/.bun"
