export WORKON_HOME=~/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
source /usr/local/bin/virtualenvwrapper.sh
source ~/.bash/functions
export TERM=xterm-256color-italic

alias ll='ls -lhF'
alias pi='ssh pi@192.168.0.208'
alias od='TERM=xterm-256color-italic ssh odroid@192.168.0.207'
#alias win='ssh 192.168.0.104'
alias win='ssh 10.211.55.3'
alias openelec='ssh root@192.168.0.39'
alias scn='screen -h 3000'
alias vis='vim --servername VIM '
#alias vir='vim --servername VIM --remote '
alias vir='vis --remote '
alias py='python '
alias open='reattach-to-user-namespace open'
#mount odroid의 약자 mod 를 사용합니다
alias mod='sshfs odroid@192.168.0.207:/home/odroid ~/mnt'

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


