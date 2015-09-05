source ~/.bashrc
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

#export VIRTUAL_ENV_DISABLE_PROMPT=1
#export PS1="\u # \w\$(parse_git_branch) \\$ "
#export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]\$(parse_git_branch)\[\033[00m\]\$ "
#export PS1="\[\033[0;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]\$(parse_git_branch)\[\033[00m\]\$ "
export PS1="${LIGHT_GREEN}\u@\h${COLOR_NONE}:${BLUE}\w${RED}\$(parse_git_branch)${COLOR_NONE}\$ "
