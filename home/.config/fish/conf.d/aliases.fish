# File system
alias ls 'eza -lh --group-directories-first --icons=auto'
alias lsa 'ls -a'
alias lt 'eza --tree --level=2 --long --icons --git'
alias lta 'lt -a'
alias cd 'zd'

# System
alias ... 'cd ../..'
alias .... 'cd ../../..'
alias nproc 'sysctl -n hw.ncpu'
alias q 'exit'
alias tailf 'tail -f'
alias top 'btop'
alias df 'df -h'
alias du 'du -h'
alias cp 'cp -iv'
alias mv 'mv -iv'
alias grep 'grep --color=auto --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox}'

## Rails
alias r 'rails'
alias rc 'rails console'
alias rr 'rails routes'

## Bundler
alias b 'bundle'
alias ba 'bundle add'
alias bi 'bundle install'
alias bu 'bundle update'
alias be 'bundle exec'

# Tools
alias g 'git'
alias gs 'git st'
alias lg 'lazygit'
alias oc 'opencode'
alias ccx 'claude --dangerously-skip-permissions'
alias reload 'exec fish'
alias p 'clear && pi'

# Disable automatic completion generation for oc to avoid errors
complete -c oc -e
