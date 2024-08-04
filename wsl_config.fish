if status is-interactive
    # Commands to run in interactive sessions can go here
end

# set rust PATH
fish_add_path -a ~/.cargo/bin

# set nvim PATH
fish_add_path -a ~/download/nvim/
alias nvim="nvim.appimage"

# set go PATH
set --export GOROOT /usr/local/go
set --export GOPATH $HOME/go
fish_add_path -a $GOROOT/bin 
fish_add_path -a $GOPATH/bin 

# set some paths
set -x PKG_CONFIG_PATH '/usr/local/lib/pkgconfig' '/lib/x86_64-linux-gnu/pkgconfig/fontconfig.pc'
set -x DISPLAY ':0'

# Display a shortened directory path
set -g theme_short_path yes

# Deno
set -x DENO_INSTALL "/home/tanat/.deno"
fish_add_path -a $DENO_INSTALL/bin:$PATH

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# pyenv
pyenv init - | source

# CUDA
fish_add_path -a /usr/local/cuda-12.3/bin
fish_add_path LD_LIBRARY_PATH /usr/local/cuda-12.3/lib64

# opam configuration
source /home/tanat/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# zoxide better cd
zoxide init fish | source

# protoc
fish_add_path -a $HOME/.local/bin
