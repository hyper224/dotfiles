#!/usr/bin/env sh

make_zsh_default_shell(){
    # If this user's login shell is already "zsh", do not attempt to switch.
    if [ "$(basename -- "$SHELL")" = "zsh" ]; then
        return
    else
        chsh -s zsh "${USER}"
    fi
}


if command -v zsh >/dev/null; then
    make_zsh_default_shell
    
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        # ohmyzsh installation
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
fi

if [ -d "$HOME/.oh-my-zsh" ]; then
    # ohmyzsh - syntax-highlighting
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

    # ohmyzsh - auto-autosuggestions
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

    # zsh vi mode
    git clone https://github.com/jeffreytse/zsh-vi-mode ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-vi-mode

    # powerline10k
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi
