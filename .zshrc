# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
export EDITOR=/usr/local/bin/subl
source $ZSH_CUSTOM/plugins/zsh-autosuggestions
# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_DISABLE_COMPFIX=true
# ZSH_THEME="robbyrussell"
ZSH_THEME="gmaggess"
fpath=(/usr/local/share/zsh-completions $fpath)
rm -f "$HOME/.zcompdump" 
autoload -Uz promptinit; promptinit

export NVM_DIR="$HOME/.nvm"
. "$(brew --prefix nvm)/nvm.sh"

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins+=(git osx thefuck zsh-autosuggestions zsh-peco-history zsh-nvm zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh
source ~/.aliases.zsh
# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="subl ~/.zshrc"
# alias ohmyzsh="subl ~/.oh-my-zsh"

#java
export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

#android
# export ANDROID_HOME=$HOME/Library/Android/sdk
# path+=("$ANDROID_HOME/tools:$PATH")
# path+=("$ANDROID_HOME/platform-tools:$PATH")

#home
path+=("/usr/local/bin:/usr/local/sbin:$PATH")
path+=("$HOME/bin")
path+=("$(brew --prefix coreutils)/libexec/gnubin:$PATH")
export PATH

eval $(thefuck --alias)

export CFLAGS="-I$(brew --prefix openssl)/include -I$(xcrun --show-sdk-path)/usr/include"
export LDFLAGS="-L$(brew --prefix openssl)/lib"
export VIRTUAL_ENV_DISABLE_PROMPT=1

#tensorflow
# export TENSORFLOW_DIR=$HOME/dev/tensorflow
# export PYTHONPATH="${PYTHONPATH}:${TENSORFLOW_DIR}/models/research:${TENSORFLOW_DIR}/models/research/slim"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

#vagrant
# export VAGRANT_HOME=/Users/gmaggess/dev/vagrantexport PATH="/usr/local/opt/ruby/bin:$PATH"

#python
# path+=("/usr/local/anaconda3/bin")
eval "$(pyenv init -)"
export PATH="$(pyenv root)/shims:$PATH"
# eval "(pipenv --completion)"

#ruby
eval "$(rbenv init -)"
export PATH="$HOME/.rbenv/bin:$PATH"

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
