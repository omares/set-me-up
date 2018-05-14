SPACESHIP_TIME_SHOW=true
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_PROMPT_SEPARATE_LINE=false
SPACESHIP_CHAR_SUFFIX=" "
SPACESHIP_DIR_PREFIX=""
SPACESHIP_DIR_TRUNC_REPO=false
SPACESHIP_BATTERY_SHOW="always"
SPACESHIP_PROMPT_DEFAULT_PREFIX=""
SPACESHIP_KUBECONTEXT_SYMBOL="☸️  "
SPACESHIP_KUBECONTEXT_PREFIX="at "

SPACESHIP_PROMPT_ORDER=(
  time          # Time stampts section
  dir           # Current directory section
  user          # Username section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  hg            # Mercurial section (hg_branch  + hg_status)
  exec_time     # Execution time
  line_sep      # Line break
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

SPACESHIP_RPROMPT_ORDER=(
  package       # Package version
  node          # Node.js section
  ruby          # Ruby section
  elixir        # Elixir section
  xcode         # Xcode section
  swift         # Swift section
  golang        # Go section
  php           # PHP section
  rust          # Rust section
  haskell       # Haskell Stack section
  julia         # Julia section
  docker        # Docker section
  aws           # Amazon Web Services section
  venv          # virtualenv section
  conda         # conda virtualenv section
  pyenv         # Pyenv section
  dotnet        # .NET section
  ember         # Ember.js section
  #kubecontext   # Kubectl context section
  battery       # Battery level and status
)

# signal our zplugin configuration that spaceship is enabled
export SMU_SPACESHIP_ENABLED=true
