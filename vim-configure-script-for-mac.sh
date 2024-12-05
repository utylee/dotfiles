#export LUA_PREFIX="/usr/local/Cellar/lua/5.3.4_2"
#./configure --with-features=huge --enable-multibyte --enable-rubyinterp=yes --enable-perlinterp=yes --enable-luainterp=yes --enable-python3interp=yes --with-python3-config-dir=/Users/utylee/.pyenv/versions/3.7.2/lib/python3.7/config-3.7m-darwin/ --enable-gui=gtk2 --enable-cscope
# export LUA_PREFIX="/usr/local/Cellar/lua/5.4.3"
export LUA_PREFIX="/opt/homebrew/Cellar/lua/5.4.7"
# ./configure --with-features=huge --enable-multibyte --enable-rubyinterp=yes --enable-perlinterp=yes --enable-luainterp=yes --enable-python3interp=yes --with-python3-config-dir=/Users/utylee/.pyenv/versions/3.12.7/lib/python3.12/config-3.12-darwin/ --enable-gui=gtk2 --enable-cscope
./configure --with-features=huge --enable-multibyte --enable-rubyinterp=dynamic --with-ruby-command=/usr/local/bin/ruby --enable-perlinterp=yes --enable-luainterp=yes --enable-python3interp=yes --with-python3-config-dir=/Users/utylee/.pyenv/versions/3.12.7/lib/python3.12/config-3.12-darwin/ --enable-gui=gtk2 --enable-cscope
# 참고: http://utylee.duckdns.org/macOS%20Installing%20Vim%20From%20Source%20With%20Python3%2C%20Python2%20and%20Ruby%20Support.%20%C2%B7%20GitHub.htm
