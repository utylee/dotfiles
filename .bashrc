export WORKON_HOME=~/.virtualenvs
#vim 에서 ctrlp \f 파일찾기 명령 오류로 찾아보니 homebrew doctor 명령에서도 지적했듯이 venvwrapper환경에서 
# python을 python3 로 가리키는 것이 문제라고 힌트를 줬는데 ctrlp 도 같은 문제인듯 싶다
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
#export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
source /usr/local/bin/virtualenvwrapper.sh
source ~/.bash/functions
export TERM=xterm-256color-italic

alias ll='ls -lhF'
alias pi='ssh pi@192.168.0.208'
alias piw='ssh pi@192.168.0.209'
alias lu='ssh utylee@192.168.0.201'
alias od='TERM=xterm-256color-italic ssh odroid@192.168.0.207'
#alias win='ssh 192.168.0.104'
alias win='ssh 10.211.55.3'
alias openelec='ssh root@192.168.0.39'
alias scn='screen -h 3000'

# vim server-client 를 위해 env 별 사용할 단축 명령어를 만들어 놓습니다.
alias vi2='vim --servername VIM --remote '
alias vi1='vim --servername MISC --remote '
#alias vir='vim --servername VIM --remote '
#alias vis='vim --servername VIM '
#alias vir='vis --remote '
alias py='python '
alias open='reattach-to-user-namespace open'
#mount odroid의 약자 mod 를 사용합니다
alias mod='sshfs odroid@192.168.0.207:/home/odroid ~/mnt'
alias canon='cd /Volumes/NO\ NAME/DCIM/100CANON'

#osx에서의 한글grep
alias hgrep='iconv -c -f UTF-8-MAC -t UTF-8 | grep'
#alias mvim='open -a MacVim'
#alias vim="open \"mvim://open?url=file://$1\""
#alias vi="mvim -v --servername VIM --remote "

export CLICOLOR=1
#export LSCOLORS=GxFxCxDxBxegedabagaced

parse_git_branch() {
   git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
}

#tmux workspace shortcut
alias t1='~/.tmuxset-misc'
alias t2='~/.tmuxset-trader'
alias t3='~/.tmuxset-win'


