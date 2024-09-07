#run to set fish as default shell
#chsh -s $(which fish)

set TERM "alacritty"
set -gx EDITOR nvim
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
alias l="ls -1 --group-directories-first -h"
alias ll="ls -l --group-directories-first -h"
alias gs="git status --short"

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

# lf

bind \co 'set old_tty (stty -g); stty sane; lfcd; stty $old_tty; commandline -f repaint'
alias gd="lfcd"
set -Ux LF_ICONS "\
*.7z=:\
*.aac=:\
*.ace=:\
*.alz=:\
*.arc=:\
*.arj=:\
*.asf=:\
*.atom=:\
*.au=:\
*.avi=:\
*.bash=:\
*.bash_history=:\
*.bashprofile=:\
*.bashrc=:\
*.bmp=:\
*.bz2=:\
*.bz=:\
*.c=:\
*.cab=:\
*.cc=:\
*.cfg=:\
*.cgm=:\
*.clang-format=:\
*.clj=:\
*.cmd=:\
*.coffee=:\
*.cpio=:\
*.cpp=:\
*.css=:\
*.d=:\
*.dart=:\
*.deb=:\
*.dl=:\
*.DS_Store=:\
*.dwm=:\
*.dz=:\
*.ear=:\
*.emf=:\
*.env=:\
*.erl=:\
*.esd=:\
*.exs=:\
*.fish=:\
*.flac=:\
*.flc=:\
*.fli=:\
*.flv=:\
*.fs=:\
*.gif=:\
*.git=:\
*.gitattributes=:\
*.gitconfig=:\
*.github=:\
*.gitignore=:\
*.gitignore_global=:\
*.gitkeep=:\
*.gitmodules=:\
*.gl=:\
*.go=:\
*.gz=:\
*.h=:\
*.hh=:\
*.hidden=:\
*.hpp=:\
*.hs=:\
*.html=:\
*.hyper.js=:\
*.jar=:\
*.java=:\
*.jl=:\
*.jpeg=:\
*.jpg=:\
*.js=:\
*.json=:\
*.jsx=:\
*.lha=:\
*.lrz=:\
*.lua=:\
*.lz4=:\
*.lz=:\
*.lzh=:\
*.lzma=:\
*.lzo=:\
*.m2v=:\
*.m4a=:\
*.m4v=:\
*.map=:\
*.md=:\
*.mdx=:\
*.mid=:\
*.midi=:\
*.mjpeg=:\
*.mjpg=:\
*.mka=:\
*.mkv=:\
*.mng=:\
*.mov=:\
*.mp3=:\
*.mp4=:\
*.mp4v=:\
*.mpc=:\
*.mpeg=:\
*.mpg=:\
*.nix=:\
*.npmignore=:\
*.npmrc=:\
*.nuv=:\
*.nvmrc=:\
*.oga=:\
*.ogg=:\
*.ogm=:\
*.ogv=:\
*.ogx=:\
*.opus=:\
*.pbm=:\
*.pcx=:\
*.pdf=:\
*.pgm=:\
*.php=:\
*.pl=:\
*.png=:\
*.ppm=:\
*.pro=:\
*.ps1=:\
*.py=:\
*.qt=:\
*.ra=:\
*.rar=:\
*.rb=:\
*.rm=:\
*.rmvb=:\
*.rpm=:\
*.rs=:\
*.rvm=:\
*.rz=:\
*.sar=:\
*.scala=:\
*.sh=:\
*.skhdrc=:\
*.sol=ﲹ:\
*.spx=:\
*.svg=:\
*.svgz=:\
*.swm=:\
*.t7z=:\
*.tar=:\
*.taz=:\
*.tbz2=:\
*.tbz=:\
*.tga=:\
*.tgz=:\
*.tif=:\
*.tiff=:\
*.tlz=:\
*.tmux.conf=:\
*.trash=:\
*.ts=:\
*.tsx=:\
*.txz=:\
*.tz=:\
*.tzo=:\
*.tzst=:\
*.vim=:\
*.vimrc=:\
*.vob=:\
*.vscode=:\
*.war=:\
*.wav=:\
*.webm=:\
*.wim=:\
*.xbm=:\
*.xcf=:\
*.xpm=:\
*.xspf=:\
*.xwd=:\
*.xz=:\
*.yabairc=:\
*.yaml=פּ:\
*.yarn-integrity=:\
*.yarnrc=:\
*.yml=פּ:\
*.yuv=:\
*.z=:\
*.zip=:\
*.zoo=:\
*.zprofile=:\
*.zprofile=:\
*.zsh=:\
*.zsh_history=:\
*.zshrc=:\
*.zst=:\
*bin=:\
*config=:\
*docker-compose.yml=:\
*dockerfile=:\
*gradle=:\
*gruntfile.coffee=:\
*gruntfile.js=:\
*gruntfile.ls=:\
*gulpfile.coffee=:\
*gulpfile.js=:\
*gulpfile.ls=:\
*include=:\
*lib=:\
*localized=:\
*node_modules=:\
*package.json=:\
*rubydoc=:\
*tsconfig.json=:\
*yarn.lock=:\
di=:\
dt=:\
ex=:\
fi=:\
ln=:\
or=:\
ow=:\
st=:\
tw=:\
"
