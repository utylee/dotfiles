if status is-interactive
    # Commands to run in interactive sessions can go here
	# CURSOR
	#echo -ne '\eP\e]12;#207dab\a'	# wsl1
	echo -ne '\eP\e]12;#7fa31c\a'	# mac
	#echo -ne '\eP\e]12;#e034a1\a'	# wsl2
end

set fish_greeting ''
fish_vi_key_bindings

#set -gx EDITOR /usr/bin/vi

#set -gx LANG en_US.UTF-8
#set -gx LC_CTYPE en_US.UTF-8

# PATH
#set CLANGHOME /usr/local/clang+llvm-12.0.1-x86_64-linux-gnu-ubuntu-16.04
#set -x PATH $PATH $CLANGHOME/bin
#set -x PATH $PATH /usr/local/node-v14.18.1-linux-x64/bin /mnt/c/Windows/System32/WindowsPowrShell/v1.0/ /mnt/c/Python310/ /mnt/c/Python310/Scripts
#set -gx CC $CLANGHOME/bin/clang
#set -gx CXX $CLANGHOME/bin/clang++
#set -gx LD_LIBRARY_PATH $LD_LIBRARY_PATH $CLANGHOME/lib 
#fish_add_path /usr/local/opt/llvm/bin
fish_add_path /usr/local/bin
#set -gx LDFLAGS "-L/usr/local/opt/llvm/lib"
#set -gx CPPFLAGS "-I/usr/local/opt/llvm/include"

# FZF
set -gx FZF_DEFAULT_COMMAND 'fd --type file --color=always --follow --hidden --exclude .git'
set -gx FZF_DEFAULT_OPTS "--ansi"
set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
set -gx FZF_ALT_C_COMMAND "fd --type d --color=always"
#set -gx FZF_DEFAULT_COMMAND "rg --files --no-ignore --hidden --follow --glob '!.git/*' --no-messages"
#set -gx FZF_DEFAULT_COMMAND 'fd --type file --color=always --follow --hidden --exclude .git'
#set -gx FZF_CTRL_T_COMMAND "find . -depth"
#set -gx FZF_DEFAULT_COMMAND "rg --files --hidden --follow --no-ignore"
# mac에서 자꾸 잡탕 os error 2 메세지가 나옵니다
#set -gx FZF_CTRL_T_COMMAND "rg --files --hidden --follow --no-ignore --no-messages"
#set -gx FZF_CTRL_T_COMMAND "find . -depth"
_
#set -gx FZF_ALT_C_COMMAND "rg --hidden --files --null | xargs -0 dirname | uniq"
#set -gx FZF_ALT_C_COMMAND "rg --hidden --sort-files --files --null 2> /dev/null | xargs -0 dirname | uniq"

# VENV
set -gx WORKON_HOME $HOME/.virtualenvs


starship init fish | source
