source ~/.bashrc
# openvpn 설치해도 실행파일 링크가 안돼서 해결책
export PATH=$(brew --prefix openvpn)/sbin:$PATH
# The various escape codes that we can use to color our prompt.
        RED="\[\033[0;31m\]"
     YELLOW="\[\033[1;33m\]"
      GREEN="\[\033[1;32m\]"
       BLUE="\[\033[1;34m\]"
  LIGHT_RED="\[\033[1;31m\]"
LIGHT_GREEN="\[\033[1;32m\]"
      WHITE="\[\033[0;37m\]"
 LIGHT_GRAY="\[\033[1;37m\]"
 COLOR_NONE="\[\e[0m\]"

parse_git_branch() {
   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}
#set_virtualenv

# pyenv의 autocompletion 을 사용하라면 추가하라고 합니다
# 또한 pyenv를 사용하기 위한 PATH설정도 추가합니다
#if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
#export PYENV_ROOT=~/.pyenv
#export PATH=$PYENV_ROOT/shims:$PATH

# pyenv-virtualenv 를 사용하기 위한 초기화구문
#eval "$(pyenv init -)"
#eval "$(pyenv virtualenv-init -)"

#source "$(brew --prefix)/etc/bash_completion"

source /usr/local/opt/autoenv/activate.sh

export TRINITY=/Users/utylee/Trinity
export PATH=$TRINITY/bin:/usr/local/mysql/bin:$PATH
export DYLD_LIBRARY_PATH=$TRINITY/lib:/usr/local/mysql/lib:$DYLD_LIBRARY_PATH

#export VIRTUAL_ENV_DISABLE_PROMPT=1
#export PS1="\u # \w\$(parse_git_branch) \\$ "
#export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]\$(parse_git_branch)\[\033[00m\]\$ "
#export PS1="\[\033[0;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]\$(parse_git_branch)\[\033[00m\]\$ "
export PS1="${LIGHT_GREEN}\u@\h${COLOR_NONE}:${BLUE}\w${RED}\$(parse_git_branch)${COLOR_NONE}\$ "
