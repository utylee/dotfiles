if status is-interactive
    # Commands to run in interactive sessions can go here
	# CURSOR
	echo -ne '\eP\e]12;#7fa31c\a'	# mac
	set fish_greeting ''
	fish_vi_key_bindings
	starship init fish | source
end
if status is-login
    # Commands to run in interactive sessions can go here
	eval (gdircolors -c ~/.dircolors)
end

set -Ux fish_term24bit 1

set -gx EDITOR /usr/local/bin/vi
set -gx GHQ_ROOT /Users/utylee/.ghq

# PATH
# mac은 xcode-select 자체 생태계가 있으므로 굳이 설정하지 않습니다
fish_add_path /usr/local/bin /Users/utylee/.go/bin

#set CLANGHOME /usr/local/clang+llvm-12.0.1-x86_64-linux-gnu-ubuntu-16.04
#set -x PATH $CLANGHOME/bin $PATH
#set -x PATH /usr/local/go1.17.2/bin /usr/local/node-v14.18.1-linux-x64/bin /mnt/c/Windows/System32/WindowsPowrShell/v1.0/ /mnt/c/Python310/ /mnt/c/Python310/Scripts $PATH
#set -gx CC $CLANGHOME/bin/clang
#set -gx CXX $CLANGHOME/bin/clang++
#set -gx LD_LIBRARY_PATH $LD_LIBRARY_PATH $CLANGHOME/lib 

# FZF
# fzf을 직접입력해 파일명 탐색 명내용 
set -gx FZF_DEFAULT_COMMAND 'fd --type file --color=always --follow --hidden --exclude .git'
set -gx FZF_DEFAULT_OPTS "--ansi"
#
#set -gx FZF_CTRL_T_COMMAND "fd --type d --hidden --color=always"
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_CTRL_F_COMMAND "fd --type d --hidden --color=always . $HOME"
set -gx FZF_ALT_C_COMMAND "fd --type d --hidden --color=always"
set -gx FZF_CTRL_R_OPTS "--reverse --height 50%"
#set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"

#set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --follow --no-ignore"
#set -gx FZF_CTRL_T_COMMAND "rg --files --hidden --follow --no-ignore"
#set -gx FZF_CTRL_T_COMMAND "rg --files --hidden --follow --no-ignore"
#set -gx FZF_ALT_C_COMMAND "find . -depth"
##set -gx FZF_ALT_C_COMMAND "rg --hidden --files --null | xargs -0 dirname | uniq"
##set -gx FZF_ALT_C_COMMAND "rg --hidden --sort-files --files --null 2> /dev/null | xargs -0 dirname | uniq"
#
# VENV
set -gx WORKON_HOME $HOME/.virtualenvs

#source ~/.mintty-colors-solarized/mintty-solarized-dark.sh
