#!/bin/bash

usage()
{
cat << _EOT_
Usage:
  $0 [ git | vim | tmux | ruby | dotfiles ]

Description:
  Install Tools Script.
  Install Tools are Git,Vim,Ruby and dotfiles.

Options:
  git     : Install Git with Latest Version.
  vim     : Install Vim with Latest Version.
  ruby    : Install Ruby 2.3.0
  dotfiles: Clone dotfiles

_EOT_
exit 1
}

install_git()
{
	# 依存モジュールのインストール
	yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel perl-ExtUtils-MakeMaker gcc make

	# Gitのクローン
	cd /usr/local/src
	git clone git://git.kernel.org/pub/scm/git/git.git

	# 古いGitの削除
	yum -y remove git > /dev/null 2>&1

	# Gitのインストール
	cd /usr/local/src/git
	./configure
	make prefix=/usr/local all
	make prefix=/usr/local install
}

install_tmux()
{
	# OSのバージョン情報取得
	version=`cat /etc/redhat-release | awk '{print $(NF-1)}' | awk -F. '{print $1}'`

	# 依存モジュールのインストール
	if [ $version -eq 7 ]; then
		yum -y install libevent-devel ncurses-devel
	elif [ $version -eq 6 ]; then
		yum -y remove libevent libevent-devel libevent-headers
		cd /usr/local/src
		wget https://github.com/libevent/libevent/releases/download/release-2.0.22-stable/libevent-2.0.22-stable.tar.gz
		tar -xvf libevent-2.0.22-stable.tar.gz
		cd libevent-2.0.22-stable
		./configure && make
		make install
		echo "/usr/local/lib" > /etc/ld.so.conf.d/libevent.conf
		ldconfig
		ln -s /usr/local/lib/libevent-2.0.so.5 /usr/lib64/libevent-2.0.so.5
	fi

	# tmuxのインストール
	cd /usr/local/src
	wget https://github.com/tmux/tmux/releases/download/2.3/tmux-2.3.tar.gz
	tar -xvf tmux-2.3.tar.gz
	cd tmux-2.3
	./configure && make
	make install
}

install_vim()
{
	# 古いVimの削除
	yum -y remove vim

	# 依存モジュールのインストール
	yum -y install ncurses-devel lua lua-devel gtk2-devel atk-devel libX11-devel libXt-devel

	# 最新のVimのダウンロード
	cd /usr/local/src
	git clone https://github.com/vim/vim.git

	# Vimのインストール
	cd vim/
	./configure --with-features=huge --enable-multibyte --enable-luainterp=dynamic --enable-gpm --enable-cscope --enable-fontset
	make
	make install
}

install_ruby()
{
	# rbenvと関連プラグインのダウンロード
	cd /opt
	git clone https://github.com/sstephenson/rbenv.git
	mkdir -p /opt/rbenv/plugins
	cd /opt/rbenv/plugins
	git clone https://github.com/sstephenson/ruby-build.git

	# .bashrcへのrbenv関連設定追加
	grep "rbenv global config" ${HOME}/.bashrc > /dev/null 2>&1
	if [ $? -ne 0 ]; then
		echo >> ~/.bashrc
		echo "# rbenv global config" >> ~/.bashrc
		echo 'export RBENV_ROOT="/opt/rbenv"' >> ~/.bashrc
		echo 'export PATH="${RBENV_ROOT}/bin:${PATH}"' >> ~/.bashrc
		echo 'eval "$(rbenv init -)"' >> ~/.bashrc
	fi

	# Ruby関連モジュールのインストール
	yum -y install gcc make openssl-devel libffi-devel ruby-devel readline-devel rubygems sqlite-devel bzip2

	# Rubyのインストール
	/bin/bash -lc "rbenv install 2.3.0"
	/bin/bash -lc "rbenv rehash"
	/bin/bash -lc "rbenv global 2.3.0"
}

clone_dotfiles()
{
	# dotfilesのダウンロード
	cd $HOME
	git clone https://github.com/Tocyuki/dotfiles.git

	# 既存設定ファイルの退避
	mv $HOME/.vimrc $HOME/.vimrc_`date +%Y%m%d%s`
	mv $HOME/.bashrc $HOME/.bashrc_`date +%Y%m%d%s`
	mv $HOME/.tmux.conf $HOME/.tmux_`date +%Y%m%d%s`.conf

	# シンボリックリンクの作成
	ln -s $HOME/dotfiles/.vimrc $HOME/.vimrc
	ln -s $HOME/dotfiles/.bashrc $HOME/.bashrc
	ln -s $HOME/dotfiles/.tmux.conf $HOME/.tmux.conf
}

case "$1" in
	git)			install_git			;;
	tmux)			install_tmux		;;
	vim)			install_vim			;;
	ruby)			install_ruby		;;
	dotfiles)	clone_dotfiles	;;
	*)				usage
esac
