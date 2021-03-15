#!/usr/bin/env bash

NONE="\033[0m"
RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[0;33m"
WHITE="\033[1;37m"
ROOT=`dirname "$(realpath $0)"`


symlink() {
    mkdir -p $(dirname $2)
    ln -sf $(readlink -f $1) $2
}


install_package_for_ubuntu() {
    declare -a packages; packages=( \
        sudo curl git neovim zsh vifm tzdata curl neovim tree highlight \
    )
    sudo sed -i "s/archive.ubuntu/mirror.kakao/g" /etc/apt/sources.list
    sudo apt update && sudo apt -y upgrade
    sudo apt install -y software-properties-common
    sudo add-apt-repository -y ppa:neovim-ppa/stable
    sudo apt-get update
    sudo apt-get install -y --no-install-recommends ${packages[@]}
}


install_ohmyzsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    git clone --depth=1 \
        https://github.com/zsh-users/zsh-autosuggestions.git \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone --depth=1 \
        https://github.com/zsh-users/zsh-syntax-highlighting.git \
        ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
}


symlink_for_ubuntu() {
    declare -A symlink_table; symlink_table=( \
        ["$ROOT/config/.zshrc"]="$HOME/.zshrc"
        ["$ROOT/config/.tmux.conf"]="$HOME/.tmux.conf"
        ["$ROOT/config/init.vim"]="$HOME/.config/nvim/init.vim"
        ["$ROOT/config/vifmrc"]="$HOME/.config/vifm/vifmrc"
        ["$ROOT/config/.gitconfig"]="$HOME/.gitconfig"
    )
    for i in "${!symlink_table[@]}"
    do
        symlink $i ${symlink_table[$i]}
    done
}


setup_neovim() {
    if [[ ! -f ~/.local/share/nvim/site/autoload/plug.vim ]]; then
        curl -fLo \
            ~/.local/share/nvim/site/autoload/plug.vim \
            --create-dirs \
            https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        nvim +PlugInstall +qall!
    fi
}

setup_tmux() {
    VERSION=2.4
    sudo apt-get -y remove tmux
    sudo apt-get -y install wget tar libevent-dev libncurses-dev
    wget https://github.com/tmux/tmux/releases/download/${VERSION}/tmux-${VERSION}.tar.gz
    tar xf tmux-${VERSION}.tar.gz
    rm -f tmux-${VERSION}.tar.gz
    cd tmux-${VERSION}
    ./configure
    make
    sudo make install
    cd -
    sudo rm -rf /usr/local/src/tmux-*
    sudo mv tmux-${VERSION} /usr/local/src
}

setup_git() {
    if [[ ! -f ~/.gitconfig.secret ]]; then
        cat > ~/.gitconfig.secret <<EOL
EOL
    fi
    if ! git config --file ~/.gitconfig.secret user.name 2>&1 > /dev/null || \
       ! git config --file ~/.gitconfig.secret user.email 2>&1 > /dev/null; then echo -ne '
\033[1;33mPlease configure git user name and email:
    git config --file ~/.gitconfig.secret user.name "(YOUR NAME)"
    git config --file ~/.gitconfig.secret user.email "(YOUR EMAIL)"
\033[0m'
        echo -en '\n'
        echo -en "(git config user.name) \033[0;33m Please input your name  : \033[0m"; read git_username
        echo -en "(git config user.email)\033[0;33m Please input your email : \033[0m"; read git_useremail
        if [[ -n "$git_username" ]] && [[ -n "$git_useremail" ]]; then
            git config --file ~/.gitconfig.secret user.name "$git_username"
            git config --file ~/.gitconfig.secret user.email "$git_useremail"
        else
            exit 1;   # error
        fi
    fi
}


change_default_shell() {
    if [[ ! "$SHELL" = *zsh ]]; then
        echo -e '\033[0;33mPlease type your password if you wish to change the default shell to ZSH\e[m'
        chsh -s /bin/zsh && echo -e 'Successfully changed the default shell, please re-login'
    else
        echo -e "\033[0;32m\$SHELL is already zsh.\033[0m $(zsh --version)"
    fi
}


install_python_package() {
    python3 -m pip install pynvim python-language-server
}


install_ubuntu() {
    install_package_for_ubuntu
    setup_tmux
    install_python_package
    install_ohmyzsh
    symlink_for_ubuntu
    setup_neovim
    setup_git
    change_default_shell
}


if [[ `uname` == "Linux" ]]; then
    install_ubuntu
fi
