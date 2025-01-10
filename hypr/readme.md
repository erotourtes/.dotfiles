## Enabling wayland support for apps

Path for default `.desktop` files `~/.local/share/applications/`

#### Obsidian (flatpack)
```fish
flatpack list --app # list applications, should show `md.obsidian.Obsidian`
flatpak override --user --env=OBSIDIAN_USE_WAYLAND=1 md.obsidian.Obsidian
flatpak override --user --socket=wayland md.obsidian.Obsidian
```

#### Google chrome
In the $XDG_DATA_DIRS [Google chrome apps](https://www.reddit.com/r/hyprland/comments/1ccwkml/how_to_remove_chrome_context_menu_blur_in_hyprland/)  
Or [Google chrome from settings](https://www.reddit.com/r/Fedora/comments/rkzp78/make_chrome_run_on_wayland_permanently/)

#### Jetbrains
[Jetbrains](https://blog.jetbrains.com/platform/2024/07/wayland-support-preview-in-2024-2/)
