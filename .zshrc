alias vact="source venv/bin/activate"
alias ll="ls -la"
alias old_branch_delete='git fetch -p && git branch -vv | awk "/: gone]/{print \$1}" | xargs git branch -D'

