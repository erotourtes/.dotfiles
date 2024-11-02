#run to set fish as default shell
#chsh -s $(which fish)

set TERM "alacritty"
set -gx EDITOR nvim
set -gx VISUAL nvim
# set -gx PAGER "nvim -R"
set -gx MANPAGER "nvim +Man!"

fish_add_path ~/.local/share/JetBrains/Toolbox/scripts/
fish_add_path /usr/local/go/bin
fish_add_path ~/.local/bin
# /home/sirmax/.local/share/JetBrains/Toolbox/scripts /home/linuxbrew/.linuxbrew/bin/ /home/linuxbrew/.linuxbrew/bin/brew /home/sirmax/.cargo/bin /usr/local/bin /usr/local/sbin /usr/bin /usr/sbin

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

alias t="tmux"
alias ta="tmux-attach"
alias tk="tmux-kill-session"
alias ts="tmux-sessionizer"

alias pn="pnpm"

alias vim="nvim"
alias ls="ls --hyperlink=auto --group-directories-first -h --color=auto"
alias l="ls -1"
alias ll="ls -l"
alias gs="git status --short"
alias rg="rg --hyperlink-format kitty"

alias ch="~/.config/fish/cht.sh"
alias gps="gh copilot suggest"

alias ne="~/Documents/Apps/neovide.AppImage"

function fish_user_key_bindings
  bind -M insert \cl "accept-autosuggestion"
  bind -M insert \cp "clear -x && commandline -f repaint"
  bind -M insert \cr "_fzf_search_history"
  bind -M insert \cf "_fzf_search_directory"
  bind -M insert \e\cl "_fzf_search_git_log"
end

if status is-interactive
    # Commands to run in interactive sessions can go here
    fish_vi_key_bindings
    # fish_hybrid_key_bindings

    set fish_cursor_default     block
    set fish_cursor_insert      line
    set fish_cursor_replace_one underscore
    set fish_cursor_replace     underscore
    set fish_cursor_visual      block
end

zoxide init fish | source
