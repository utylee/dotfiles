#export WORKON_HOME=~/.virtualenvs
##vim 에서 ctrlp \f 파일찾기 명령 오류로 찾아보니 homebrew doctor 명령에서도 지적했듯이 venvwrapper환경에서 
## python을 python3 로 가리키는 것이 문제라고 힌트를 줬는데 ctrlp 도 같은 문제인듯 싶다
##export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
#export VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
##export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
#source /usr/local/bin/virtualenvwrapper.sh
##source /usr/local/bin/pyenv-virtualenvwrapper
#source ~/.bash/functions



#vim 8.0 업데이트 이후 tic ...terminfo 실행했는데도 불구하고 tmux 상에서 적용이 잘안되어서 변경해봅니다
export TERM=xterm-256color-italic
export DISPLAY=:0
export GPG_TTY=$(tty)
# gpg 에서 ioctrl 오류를 해결하기 위함입니다

echo -ne   '\eP\e]12;#888888\a'  # Cursor       -> red


alias bye='echo sksmsqnwk11 | sudo -S ifconfig en0 mtu 500'
alias hi='echo sksmsqnwk11 | sudo -S ifconfig en0 mtu 1500'
# timemachine 백업속도 올려주는 쓰로틀 오프 명령어를 기록해놓는다
alias tm='sudo sysctl debug.lowpri_throttle_enabled=0'

#alias we='curl http://utylee.duckdns.org:9010;echo -e "\n"'
alias we='curl http://192.168.0.202:9010;echo -e "\n"'
#alias t='python ~/.virtualenvs/misc/src/translate_cmd.py ko '
#alias f='python ~/.virtualenvs/misc/src/translate_cmd.py en '
#alias j='python ~/.virtualenvs/misc/src/translate_cmd.py ja '                
alias ll='ls -lhF'
alias vi='vim'
alias lu='ssh utylee@192.168.0.201'
#alias od='tmux rename-window "od";TERM=xterm-256color-italic ssh -X -p 8022 odroid@192.168.0.207'
#alias odod='tmux rename-window "od";TERM=xterm-256color-italic ssh -p 8022 odroid@utylee.dlinkddns.com'
#alias hc='tmux rename-window "hc";TERM=xterm-256color-italic ssh -p 8026 odroid@192.168.0.212'
#alias hchc='tmux rename-window "hc";TERM=xterm-256color-italic ssh -X -p 8026 odroid@utylee.dlinkddns.com'
#alias hc2='tmux rename-window "hc2";TERM=xterm-256color-italic ssh -X -p 8030 odroid@192.168.0.213'
alias od='tmux rename-window "od";TERM=xterm-256color-italic ssh -X -p 8821 odroid@192.168.0.201'
alias odod='tmux rename-window "od";TERM=xterm-256color-italic ssh -p 8821 odroid@utylee.dlinkddns.com'
alias hc='tmux rename-window "hc";TERM=xterm-256color-italic ssh -p 8822 odroid@192.168.0.202'
alias hchc='tmux rename-window "hc";TERM=xterm-256color-italic ssh -X -p 8822 odroid@utylee.dlinkddns.com'
alias hc2='tmux rename-window "hc2";TERM=xterm-256color-italic ssh -X -p 8823 odroid@192.168.0.203'
#alias pi='TERM=xterm-256color-italic ssh -p 8023 pi@192.168.0.208'
#alias pi='tmux rename-window "pi";TERM=xterm-256color-italic ssh -p 8023 pi@utylee.dlinkddns.com'
#alias pi='tmux rename-window "pi";TERM=xterm-256color-italic ssh -p 8028 pi@utylee.dlinkddns.com'

#alias pi='tmux rename-window "pi";TERM=xterm-256color-italic ssh -p 8028 pi@192.168.0.211'
#alias pi5g='tmux rename-window "pi";TERM=xterm-256color-italic ssh -p 8028 pi@192.168.0.221'
alias pi='tmux rename-window "pi";TERM=xterm-256color-italic ssh -p 8028 pi@192.168.0.221'

alias pipi='tmux rename-window "pi";TERM=xterm-256color-italic ssh -p 8028 pi@utylee.dlinkddns.com'
#alias pi2='TERM=xterm-256color-italic ssh -p 8024 pi@192.168.0.209'
alias octo='tmux rename-window "octo";ssh -p 8027 pi@octopi.local'
alias pi2='tmux rename-window "pi2";TERM=xterm-256color-italic ssh -p 8024 pi@192.168.0.209'
alias pi2pi2='tmux rename-window "pi2";TERM=xterm-256color-italic ssh -p 8024 pi@utylee.dlinkddns.com'
#alias pi2='ssh -p 8024 pi@utylee.dlinkddns.com'
#alias pi3='TERM=xterm-256color-italic ssh -p 8025 pi@192.168.0.209'
alias pi3='tmux rename-window "pi3";TERM=xterm-256color-italic ssh -p 8025 pi@192.168.0.210'
alias pi3pi3='tmux rename-window "pi3";TERM=xterm-256color-italic ssh -p 8025 pi@utylee.dlinkddns.com'
#alias win='ssh 192.168.0.104'
#alias wsl='tmux rename-window "wsl";TERM=xterm-256color-italic ssh  -p 2222 utylee@192.168.0.102'
#alias wslwsl='tmux rename-window "wsl";TERM=xterm-256color-italic ssh -p 2222 utylee@utylee.dlinkddns.com'
alias wsl='tmux rename-window "wsl";TERM=xterm-256color-italic ssh  -p 8812 utylee@192.168.0.102'
alias wslwsl='tmux rename-window "wsl";TERM=xterm-256color-italic ssh -p 8812 utylee@utylee.dlinkddns.com'

#두번째 윈도우7 운영체제용으로 아이피를 변경합니다
#alias win='ssh 10.211.55.3'
alias win='ssh 10.211.55.10'
alias openelec='ssh root@192.168.0.39'
alias scn='screen -h 3000'
alias dt='tmux detach -a'
alias td='tmux detach -a'

# vim server-client 를 위해 env 별 사용할 단축 명령어를 만들어 놓습니다.
alias vi3='vim --servername WIN --remote '
alias vi2='vim --servername VIM --remote '
#alias vi1='vim --servername MISC --remote '
#alias vi0='vim --servername BLOG --remote '
alias vi36='vim --servername v36 --remote '
alias vif='vim --servername FF --remote '
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

# utylee copy
uc() {
    b="${1//\?/_u_qa_}"         # /이 한개면 한번만 //면 전체에서 교체입니다
    #b="${b//\%/_u_pe_}"        #%는 잘 받아지는 것 같습니다
    b="${b//\&/_u_im_}"
    b="${b//\ /_u_sp_}"
    curl http://192.168.0.212:9202/c/"$b"
    #curl http://192.168.0.212:9212/c/"$1"
    #curl http://utylee.duckdns.org:9212/c/"$1"
}
alias ua=uc

ur() {
    curl http://192.168.0.212:9202/r
}

uv() {
    curl http://192.168.0.212:9202/vt
}


m() {
    #echo $2 | mutt -s "$1" utylee@gmail.com -a "$3"
    echo $2 | mutt -s "$1" utylee@gmail.com
}

ma() {
    #echo $2 | mutt -s "$1" utylee@gmail.com -a "$3"
    echo $2 | mutt -s "$1" utylee@gmail.com -a "$3"
}
# simplify3d execute crack`
s() {
    #echo $2 | mutt -s "$1" utylee@gmail.com -a "$3"
    echo sksmsqnwk11 | sudo -S DYLD_INSERT_LIBRARIES=/Applications/Simplify3D-4.0.1/Interface.dylib DYLD_FORCE_FLAT_NAMESPACE=1 /Applications/Simplify3D-4.0.1/Simplify3D.app/Contents/MacOS/Simplify3D
}

#t0() {
    #open /Applications/Utilities/Xquartz.app
    #sh ~/.tmuxset-blog 
#}

#t1() {
    #open /Applications/Utilities/Xquartz.app
    #sh ~/.tmuxset-misc 
#}

vi0() {
    filename=$PWD/$1
    tmux send-keys -t vBLOG.0 ":e $filename" C-m
    tmux select-window -t vBLOG
    tmux select-pane -t vBLOG.0
}
vi1() {
    filename=$PWD/$1
    tmux send-keys -t vMISC.0 ":e $filename" C-m
    tmux select-window -t vMISC
    tmux select-pane -t vMISC.0
}
vir() {
    filename=$PWD/$1
    tmux send-keys -t vRust.0 ":e $filename" C-m
    tmux select-window -t vRust
    tmux select-pane -t vRust.0
}

fx() {
        /Users/utylee/.virtualenvs/misc/bin/python /Users/utylee/.virtualenvs/misc/src/forex-test.py 0 $1
    }
xf() {
        /Users/utylee/.virtualenvs/misc/bin/python /Users/utylee/.virtualenvs/misc/src/forex-test.py 1 $1
    }
#translate-shell
t() {
    trans -b $1
}
tt() {
    trans $1
}
f() {
    trans -b $1 :en
}


#tmux workspace shortcut
alias t0='~/.tmuxset-blog'
alias t1='~/.tmuxset-misc'
alias t2='~/.tmuxset-trader'
alias t3='~/.tmuxset-win'
alias tf='~/.tmuxset-fontforge'

alias t3.4='~/.tmuxset-3.4'
alias t3.5='~/.tmuxset-3.5'
alias t3.6='~/.tmuxset-3.6'

alias mygrep="grep -rn . --exclude={*.o,*.a,tags} -e "


#if [ -f $(brew --prefix)/etc/bash_completion ]; then
    #. $(brew --prefix)/etc/bash_completion
#fi

#export NACL_SDK_ROOT=/Users/utylee/temp/nacl_sdk/pepper_49


export CLANGHOME="/usr/local/Cellar/llvm/12.0.0"
export PATH="$CLANGHOME/bin:$HOME/.cargo/bin:$PYENV_ROOT/bin:$PATH"
#export LD_LIBRARY_PATH="/usr/local/clang_7.0.1/lib:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$CLANGHOME/lib:$LD_LIBRARY_PATH"


export PATH="/Applications/Arduino.app/Contents/MacOS:$PATH"
#export PATH="/usr/local/opt/python@2/libexec/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"

# pyenv를 macOS에 설치 중 3.6.8 버전 설치중 zlib 못찾는 문제 해결법

# For compilers to find zlib you may need to set:
export LDFLAGS="${LDFLAGS} -L/usr/local/opt/zlib/lib"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/zlib/include"
export PATH="/usr/local/opt/openssl@1.1/bin:$PATH"

# For brew installed readline
export LDFLAGS="${LDFLAGS} -L/usr/local/opt/readline/lib"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/readline/include"

# For pkg-config to find zlib you may need to set:
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig"

#export LDFLAGS="-L/usr/local/opt/avr-gcc@8/lib"


#export PYENV_VIRTUALENVWRAPPER_PREFER_PYVENV="true"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
pyenv virtualenvwrapper_lazy

[ -f ~/.fzf.bash ] && source ~/.fzf.bash
#export FZF_DEFAULT_COMMAND='ag --hidden -g ""'

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore'
export FZF_CTRL_T_COMMAND='rg --files --hidden --follow --no-ignore'
#export FZF_DEFAULT_COMMAND='ag --hidden -g ""'
#export FZF_DEFAULT_COMMAND='ag --hidden --path-to-ignore ~/.ignore -g ""'
#export FZF_DEFAULT_COMMAND='ag -g ""'
#alias ag='ag --hidden --path-to-ignore ~/.ignore '
#export FZF_DEFAULT_COMMAND='ag --hidden --ignore "*tags" --ignore={"*css","*min.css","*min.js"} -g ""'  #export FZF_DEFAULT_COMMAND='ag --hidden -g ""'
#export FZF_DEFAULT_COMMAND='ag'

