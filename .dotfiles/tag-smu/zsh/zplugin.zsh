# zsh plugins managed via https://github.com/zdharma/zplugin

# Load a few plugins synchronously for a nice terminal experience

# https://github.com/zimfw/zimfw/blob/master/modules/environment/
zplugin ice lucid
zplugin snippet https://github.com/zimfw/zimfw/blob/master/modules/environment/init.zsh

# https://github.com/zimfw/zimfw/tree/master/modules/input/
zplugin ice lucid
zplugin snippet https://github.com/zimfw/zimfw/blob/master/modules/input/init.zsh

# https://github.com/sorin-ionescu/prezto/tree/master/modules/directory/
zplugin ice svn lucid
zplugin snippet PZT::modules/directory

# autoload everything from the .zsh dir that is suffixed .plugin.zsh
zplugin ice atload'local f; for f in *.plugin.zsh; do source "${f}"; done' blockf
zplugin load "${SMU_ZSH_DIR}"

# https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/fasd/
zplugin ice svn lucid
zplugin snippet OMZ::plugins/fasd

# https://github.com/zsh-users/zsh-autosuggestions
zplugin ice atload'_zsh_autosuggest_start'
zplugin load zsh-users/zsh-autosuggestions

# https://github.com/zsh-users/zsh-completions
zplugin ice wait'0' lucid blockf
zplugin load zsh-users/zsh-completions

# https://github.com/trapd00r/LS_COLORS
zplugin ice atclone"dircolors -b LS_COLORS > ls_colors.zsh" atpull'%atclone' pick"ls_colors.zsh"
zplugin load trapd00r/LS_COLORS

# https://github.com/MichaelAquilina/zsh-you-should-use
zplugin ice wait'0' lucid
zplugin load MichaelAquilina/zsh-you-should-use

# https://github.com/Cloudstek/zsh-plugin-appup
zplugin ice wait'0' lucid
zplugin load Cloudstek/zsh-plugin-appup

# https://github.com/hlissner/zsh-autopair
zplugin ice wait'0' lucid
zplugin load hlissner/zsh-autopair

# https://github.com/zsh-users/zsh-history-substring-search
zplugin ice wait'0' lucid
zplugin load zsh-users/zsh-history-substring-search

# https://github.com/omares/auto-ls
zplugin ice wait'0' lucid
zplugin load omares/auto-ls

# https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/extract/
zplugin ice svn wait'0' lucid blockf
zplugin snippet OMZ::plugins/extract

# https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/jira/
zplugin ice svn wait'0' lucid blockf
zplugin snippet OMZ::plugins/jira

# https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/httpie/
zplugin ice svn wait'0' lucid blockf
zplugin snippet OMZ::plugins/httpie

# https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/git/
zplugin ice svn wait'0' lucid blockf
zplugin snippet OMZ::plugins/git

# https://github.com/zimfw/zimfw/blob/master/modules/utility/
zplugin ice wait'0' lucid
zplugin snippet https://github.com/zimfw/zimfw/blob/master/modules/utility/init.zsh

# https://github.com/zimfw/zimfw/blob/master/modules/ssh/
zplugin ice wait'0' lucid
zplugin snippet https://github.com/zimfw/zimfw/blob/master/modules/ssh/init.zsh

# https://github.com/supercrabtree/k
zplugin ice wait'0' lucid
zplugin load supercrabtree/k

# https://github.com/junegunn/fzf
zplugin ice svn atclone'./install --bin --no-bash --no-fish' as'program' pick'bin/fzf' \
        atload'source shell/completion.zsh; source shell/key-bindings.zsh' \
        wait'0' blockf lucid
zplugin load junegunn/fzf

SMU_SPACESHIP_ENABLED=${SMU_SPACESHIP_ENABLED:-false}
zplugin ice pick'spaceship.zsh' blockf lucid if'[[ ${SMU_SPACESHIP_ENABLED} == true ]]'
zplugin load denysdovhan/spaceship-prompt

# fast-syntax-highlighting should be last to gain the best completion speed
# https://github.com/zdharma/fast-syntax-highlighting
zplugin ice wait'0' lucid atinit'zpcompinit; zpcdreplay'
zplugin load zdharma/fast-syntax-highlighting


