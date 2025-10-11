alias python="python3"
alias pip="pip3"
export PATH="/Applications/PyCharm.app/Contents/MacOS:$PATH"

export PATH="/opt/homebrew/opt/ruby/bin:/opt/homebrew/lib/ruby/gems/3.4.0/bin:$PATH"
export STAGE=dev
export AWS_REGION=ap-southeast-2
export AWS_ACCOUNT_ID=630633962298
export UAT_BASIC_AUTH_PASSWORD=elite2025
export ACTOR=madeline
alias dfe="cd /Users/madiabio/repos/vptech-elitemx && npx --yes cdk deploy develitemx-SharedApiFrontendStack --require-approval never"
alias nrd="npm run dev"

cdf() {
  local dir
  dir=$(find . -type d | fzf) || return
  cd "$dir" || return
}


# Git commit shortcut
gc() {
    git commit -m "$*"
}

# Git push shortcut
gp() {
    git push
}
