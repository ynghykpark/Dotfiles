export PATH=$HOME/.local/bin:$PATH
export SHELL=$(which zsh)
export TERM=xterm-256color # Use gui 256 color

# ohmyzsh
export ZSH="$HOME/.oh-my-zsh"
plugins=(
    git
    python
    zsh-autosuggestions
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

if [ -x "$(command -v nvim )" ]; then
  export EDITOR=nvim
  alias vim="nvim"
fi


if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  export OS_ICON=""
  export LOCAL_IP=$(hostname -I | grep -o "^[0-9.]*")
  alias ls="ls --color"
  alias ll="ls -alh --color"

elif [[ "$OSTYPE" == "darwin"* ]]; then
  export OS_ICON=""
  export LOCAL_IP=$(ipconfig getifaddr en0)
  alias ls="ls -G"
  alias ll="ls -alh -G"
fi

if [[ -f ~/.ssh_address ]]; then
  source ~/.ssh_address
fi

alias tmux='tmux -u'

dexec() {
  docker exec $1 bash -c "xauth add $(xauth list | grep unix:$(echo $DISPLAY | cut -d. -f1 | cut -d: -f2))" && docker exec -it $1 bash
}

get_cpu_temperature() {
  CEL=$'\xc2\xb0C'
  temp=$( cat /sys/devices/virtual/thermal/thermal_zone0/temp )
  temp=`expr $temp / 1000`
  echo $temp$CEL
}

docker_template() {
  echo "
ARG USER_NAME
ARG USER_ID
RUN useradd --create-home --shell /bin/bash --uid \${USER_ID} \${USER_NAME} \\
 && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \\
 && usermod -aG sudo \${USER_NAME}
USER \${USER_NAME}
WORKDIR /home/\${USER_NAME}
RUN touch /home/\${USER_NAME}/.Xauthority # For GUI connection over ssh"
}

eval "$(starship init zsh)"
