#
# Contains custom configuration, aliases and more to not clutter the .zshrc file
#

export LANG=de_DE.UTF-8
export SMU_ZSH_DIR=${ZDOTDIR:-${HOME}}/.zsh
export ZSH_CACHE_DIR=${SMU_ZSH_DIR}/cache

# english please
alias git='LANG=en_GB git'

# use nvim

alias vi="nvim"
alias vim="nvim"

# disabled for now as this puts zsh into vi mode
#export VISUAL="nvim"
export EDITOR="nvim"

# zsh-autosuggestions
export ZSH_AUTOSUGGEST_USE_ASYNC=true

# auto-ls
auto-ls-pwd() {
    pwd
    [[ $AUTO_LS_NEWLINE != false ]] && echo ""
}

auto-ls-better-ls() {
    ls --group-directories-first --color=auto -F
    [[ $AUTO_LS_NEWLINE != false ]] && echo ""
}

auto-ls-git-st () {
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == true ]]; then
        git st
    fi
    [[ $AUTO_LS_NEWLINE != false ]] && echo ""
}

export AUTO_LS_CHPWD=false
export AUTO_LS_COMMANDS=(pwd better-ls git-st)

# coreutils without g prefix
PATH="/usr/local/opt/findutils/libexec/gnubin:/usr/local/opt/coreutils/libexec/gnubin:$PATH"
MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# taken from https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/functions.zsh#L18-L41
# required for https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/jira
function open_command() {
  emulate -L zsh
  setopt shwordsplit

  local open_cmd

  # define the open command
  case "$OSTYPE" in
    darwin*)  open_cmd='open' ;;
    cygwin*)  open_cmd='cygstart' ;;
    linux*)   open_cmd='xdg-open' ;;
    msys*)    open_cmd='start ""' ;;
    *)        echo "Platform $OSTYPE not supported"
              return 1
              ;;
  esac

  # don't use nohup on OSX
  if [[ "$OSTYPE" == darwin* ]]; then
    $open_cmd "$@" &>/dev/null
  else
    nohup $open_cmd "$@" &>/dev/null
  fi
}

# sublime on console
readonly sublime_bin="/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
if [[ -a "${sublime_bin}" ]]; then
    subl () { "${sublime_bin}" $* }
    export EDITOR='subl -w'
fi

# fzf, apply a thousand overrides to use fd everywhere
_fzf_compgen_path() {
    echo "${1}"
    fd --color=always --hidden --follow --exclude ".git" . "$1"
}

_fzf_compgen_dir() {
    echo "${1}"
    fd --color=always --type d --hidden --follow --exclude ".git" . "$1"
}

export FZF_DEFAULT_COMMAND='fd --color=always --follow --hidden --exclude .git'
export FZF_CTRL_T_COMMAND="${FZF_DEFAULT_COMMAND}"
export FZF_ALT_C_COMMAND="${FZF_DEFAULT_COMMAND} --type d"
export FZF_DEFAULT_OPTS="--ansi --border --select-1 --exit-0"

# history-substring-search
# bind UP and DOWN keys
bindkey "${terminfo[kcuu1]}" history-substring-search-up
bindkey "${terminfo[kcud1]}" history-substring-search-down

# bind UP and DOWN arrow keys (compatibility fallback)
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# init rbenv
if [[ ! $(command -v rbenv) == "" ]]; then
    eval "$(rbenv init --no-rehash - zsh)"
fi

# init pyenv
if [[ ! $(command -v pyenv) == "" ]]; then
    # set PYENV_ROOT for pipenv
    export PYENV_ROOT="$(pyenv root)"
    eval "$(pyenv init --no-rehash - zsh)"
fi

# init goenv
if [[ ! $(command -v goenv) == "" ]]; then
    eval "$(goenv init --no-rehash - zsh)"
fi

# init sdkman
if [[ -s "${HOME}/.sdkman/bin/sdkman-init.sh" ]]; then
    export SDKMAN_DIR="${HOME}/.sdkman"
    source "${SDKMAN_DIR}/bin/sdkman-init.sh"
fi

# add android platform tools to path
if [[ -d "${HOME}/Library/Android/sdk/platform-tools" ]]; then
    export PATH="${HOME}/Library/Android/sdk/platform-tools:${PATH}"
fi

# init nodenv
if [[ ! $(command -v nodenv) == "" ]]; then
    eval "$(nodenv init --no-rehash - zsh)"
fi

if [[ -s "${HOME}/.base16-manager/chriskempson/base16-shell/base16-shell.plugin.zsh" ]]; then
    source "${HOME}/.base16-manager/chriskempson/base16-shell/base16-shell.plugin.zsh"
fi
