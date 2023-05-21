
# Steps for my dev experience

- Install `fish` shell, and config it
- Use `Fira Code` font
- Install `oh-my-fish` and `bobthefish` theme
- wsl command `wsl -d Ubuntu-20.04 fish`


.tmux.conf

```
set -g default-command /usr/bin/fish
set -g default-shell /usr/bin/fish

set-option -ga terminal-overrides ",xterm-256color:Tc"

set-window-option -g mode-keys vi

set -g mouse on

```
