# Note:
# Don't forget to run
# ```
# starship preset bracketed-segments -o ~/.config/starship.toml
# ```
# and add `disabled = false` to `~/.config/starship.toml` `[time]` section
# and `format = "$all$time$line_break$character"` to `~/.config/starship.toml` first line
#
# Also, you need to install fzf, zoxide, eza:
# https://github.com/junegunn/fzf?tab=readme-ov-file#using-git
# https://github.com/ajeetdsouza/zoxide#installation
# https://github.com/eza-community/eza/blob/main/INSTALL.md
# this will show at start if not installed

# variables
CUR_USER=$(whoami)
DEFAULT_PROXY="192.168.119.1:7890"
LC_CTYPE=en_US.UTF-8
LC_ALL=en_US.UTF-8

# alias
## Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

## misc
alias bc='bc -l'
alias mkdir='mkdir -pv'
alias diff='colordiff'
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias svi='sudo vim'
alias df='df -H'
alias du='du -ch'
alias ports='sudo lsof -PiTCP -sTCP:LISTEN'
alias portsd='sudo netstat -apn'
alias ipdt='curl cip.cc'
alias sshproxy="ssh -o ProxyCommand='ncat --proxy-type socks5 --proxy ${DEFAULT_PROXY} %h %p'"
alias sshidrm='ssh-keygen -R'

[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# zinit
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# theme
# Load starship theme
# line 1: `starship` binary as command, from github release
# line 2: starship setup at clone(create init.zsh, completion)
# line 3: pull behavior same as clone, source init.zsh
zinit ice as"command" from"gh-r" \
		  atclone"./starship init zsh > init.zsh; ./starship completions zsh > _starship" \
		  atpull"%atclone" src"init.zsh"
zinit light starship/starship

# plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light zsh-users/zsh-history-substring-search
zinit light Aloxaf/fzf-tab

zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Keybindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^[^[[A' up-line-or-history
bindkey '^[^[[B' down-line-or-history
bindkey "^[^[[C" forward-word
bindkey "^[^[[D" backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^[[1;3C" forward-word
bindkey "^[[1;3D" backward-word

# Load completions
autoload -Uz compinit && compinit -u

zinit cdreplay -q

# Zsh configure
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
HISTDUP=erase
setopt autocd autopushd cdablevars correct correctall histignoredups hist_find_no_dups histignorespace interactivecomments APPEND_HISTORY PUSHD_IGNORE_DUPS AUTO_MENU AUTO_LIST AUTO_PARAM_KEYS AUTO_PARAM_SLASH AUTO_REMOVE_SLASH LIST_PACKED LIST_TYPES CSH_NULL_GLOB EXTENDED_HISTORY HIST_EXPIRE_DUPS_FIRST HIST_FCNTL_LOCK HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _ignored _match _correct _approximate _prefix
# zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# set list-colors to enable filename colorizing
if command -v dircolors >/dev/null 2>&1; then
	eval "$(dircolors -b)"
	zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
else
	export CLICOLOR=1
	zstyle ':completion:*' list-colors ''
fi
# zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# zstyle ':completion:*' list-colors ''

# force zsh not to show completion menu, which allows fzf-tab to capture the unambiguous prefix
zstyle ':completion:*' menu no
# zstyle ':completion:*' menu select=long


# Proxy
if [[ -n "$HTTP_PROXY" ]]; then
	echo "Proxy Enabled as $HTTP_PROXY"
fi

function proxy() {
	local proxy_url="${1:-http://${DEFAULT_PROXY}}"
	export http_proxy="$proxy_url"
	export https_proxy="$proxy_url"
	export HTTP_PROXY="$proxy_url"
	export HTTPS_PROXY="$proxy_url"
	export all_proxy="$proxy_url"
	export ALL_PROXY="$proxy_url"
	echo "Proxy set to $proxy_url"
}

function unproxy() {
	unset http_proxy
	unset https_proxy
	unset HTTP_PROXY
	unset HTTPS_PROXY
	unset all_proxy
	unset ALL_PROXY
	echo "Proxy has been unset"
}


if [[ "$OSTYPE" == "darwin"* ]]; then
	# macOS-specific configuration
	alias ls='ls -G'
	alias ll='ls -lG'
	alias la='ls -aG'
	alias lla='ls -laG'
	alias l.='ls -dG .?*'
	alias ll.='ls -ldG .?*'

	alias md5sum='openssl md5'
	alias sha1sum='openssl sha1'
	alias sha256sum='openssl sha256'
	alias sha512sum='openssl sha512'

	export PATH="/usr/local/sbin:$PATH"
	export PATH="/opt/homebrew/opt/rustup/bin:$PATH"
	export PATH="/Applications/gtkwave.app/Contents/Resources/bin/:$PATH"
	export PATH="$PATH:/Applications/010 Editor.app/Contents/CmdLine" #ADDED BY 010 EDITOR

	if [[ -f "/opt/homebrew/bin/brew" ]] then
		# If you're using macOS, you'll want this enabled
		eval "$(/opt/homebrew/bin/brew shellenv)"
	fi

	# iTerm2 shell integration
	test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

	# The following lines have been added by Docker Desktop to enable Docker CLI completions.
	fpath=($HOME/.docker/completions $fpath)
	autoload -Uz compinit
	compinit
	# End of Docker CLI completions
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	# Linux-specific configuration
	alias ls="ls --color"
	alias ll="ls -l --color"
	alias la="ls -a --color"
	alias lla="ls -la --color"
	alias l.="ls -d .?* --color"
	alias ll.="ls -ld .?* --color"

	bindkey "$terminfo[kcuu1]" history-substring-search-up
	bindkey "$terminfo[kcud1]" history-substring-search-down
	bindkey "$terminfo[kUP3]" up-line-or-history
	bindkey "$terminfo[kDN3]" down-line-or-history
fi


# plugin zstyle
## fzf-tab
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
# NOTE: don't use escape sequences (like '%F{red}%d%f') here, fzf-tab will ignore them
zstyle ':completion:*:descriptions' format '[%d]'
# custom fzf flags
if command -v eza >/dev/null 2>&1; then
	zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
	zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'eza -1 --color $realpath'
else
	echo "eza not installed, using ls instead"
	zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
	zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
fi
# zstyle ':fzf-tab:*' fzf-flags --color=fg:1,fg+:2 --bind=tab:accept
zstyle ':fzf-tab:*' fzf-flags --color fg:240,bg:230,hl:33,fg+:241,bg+:221,hl+:33,info:33,prompt:33,pointer:166,marker:166,spinner:33 --height ~90% --layout=reverse --info=inline --margin=1 --padding=1 --ansi --preview-window=right:90% --bind=tab:accept --pointer '❯'
# switch group using `<` and `>`
zstyle ':fzf-tab:*' switch-group '<' '>'
# use alt+/ or ctrl+] to select multiple files
zstyle ':fzf-tab:*' fzf-bindings 'alt-/:toggle,ctrl-]:toggle'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup

# fzf
if command -v fzf >/dev/null 2>&1; then
	eval "$(fzf --zsh)"
elif [ -f ~/.fzf.zsh ]; then
	source ~/.fzf.zsh
else
	echo "fzf not installed"
fi

# zoxide
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

if command -v zoxide >/dev/null 2>&1; then
	eval "$(zoxide init --cmd cd zsh)"
else
	echo "zoxide not installed"
fi

# pyenv
if [ -d "$HOME/.pyenv" ]; then
	export PYENV_ROOT="$HOME/.pyenv"
	[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
	eval "$(pyenv init -)"
fi

# jenv
if [ -d "$HOME/.jenv" ]; then
	export PATH="$HOME/.jenv/bin:$PATH"
	eval "$(jenv init -)"
fi

# nvm
# install: https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating
if [ -d "$HOME/.nvm" ]; then
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
fi

# go apps
[ -d "$HOME/go/bin" ] && export PATH="$HOME/go/bin:$PATH"

command -v nvim >/dev/null 2>&1 && alias vi='nvim' || alias vi='vim'

rename_title() {
	local cmd=$1
	if [ -z "$cmd" ]; then
		cmd="zsh"
	fi
	print -Pn "\e]0;$cmd-${CUR_USER}@${HOST}:${PWD/#$HOME/~}\a"
}

case "$TERM" in
xterm*|rxvt*)
	preexec() {
		rename_title $1
	}
	precmd() {
		rename_title $1
	}
	;;
*)
	;;
esac

if [ `pwd` = "${HOME}" ] && [ -d "${HOME}/Downloads" ]; then
	cd Downloads
fi

