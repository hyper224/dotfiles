#!/usr/bin/env sh

if [ ! -d "$HOME/.local/bin" ]; then
	mkdir -p "$HOME/.local/bin"
fi

# bat
sudo apt install -y bat && ln -s /usr/bin/batcat ~/.local/bin/bat

# fd-find
sudo apt install -y fd-find && ln -s $(command -v fdfind) ~/.local/bin/fd

# directory for mpv video recorded clips
mkdir -p ~/Video/mpv_videoclips

# replace user with username
sed -i "s/\<user\>/$(whoami)/" "$HOME/.config/mpv/script-opts/videoclip.conf"

# lf
if [ ! -f "$HOME/.local/bin/lf" ]; then
	curl -L https://github.com/gokcehan/lf/releases/latest/download/lf-linux-amd64.tar.gz | tar xzC ~/.local/bin
fi

# pip3, pipenv, yt-dlp
python3 -m pip install --upgrade pip
sudo apt install -y python3-pip && python3 -m pip install -U pipenv yt-dlp

# download nerdfonts
if [ ! -d "$HOME/.local/share/fonts/nerdfonts" ]; then
	mkdir -p "$HOME/.local/share/fonts/nerdfonts"
	sudo aria2c --dir=${HOME}/.local/share/fonts/nerdfonts -i "$HOME/.tools/nerdfonts"

	# generate fonts cache
	fc-cache -f -v
fi

# verify if font was cached successfully
# fc-list | grep "font-name"

# enable usb support in virutalbox
command -v virtualbox >/dev/null && sudo adduser $USER vboxusers

install_vscodium(){
  wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg \
	  | gpg --dearmor \
	  | sudo dd of=/usr/share/keyrings/vscodium-archive-keyring.gpg

  echo 'deb [ signed-by=/usr/share/keyrings/vscodium-archive-keyring.gpg ] https://download.vscodium.com/debs vscodium main' \
	  | sudo tee /etc/apt/sources.list.d/vscodium.list

  sudo apt update -y && sudo apt install -y codium
}

install_vscodium_extensions(){
	while read extension; do
		codium --install-extension $extension --force
	done < "$HOME/.tools/vscodium_extensions"
}

install_neovim(){
	# Build prerequisites
	sudo apt-get install -y ninja-build gettext libtool libtool-bin autoconf automake cmake g++ pkg-config unzip curl doxygen

	# Build neovim
	git clone https://github.com/neovim/neovim
	cd "$HOME/neovim" && make
	git checkout stable
	sudo make install
	cd "$HOME"

	# Uninstall or remove neovim
	# sudo rm /usr/local/bin/nvim
	# sudo rm -r /usr/local/share/nvim/
}

install_nvoid(){
	#  Pre-requisites
	sudo apt-get install -y nodejs npm ripgrep cargo
	sudo npm install -g prettier
	python3 -m pip install -U pynvim black flake8
	cargo install stylua

	# install nvoid
	bash -c "$(curl -s https://raw.githubusercontent.com/ysfgrgO7/nvoid/main/.github/installer.sh)"

	# git clone --depth 1 https://github.com/wbthomason/packer.nvim\
	# ~/.local/share/nvim/site/pack/packer/start/packer.nvim
	# git clone https://github.com/ysfgrgO7/nvoid.git ~/.config/nvim

	# mkdir "$HOME/.config/nvim/lua/custom"
	# cp "$HOME/dotfiles/others/nvoidrc.lua" "$HOME/.config/nvim/lua/custom"

	nvim -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
	nvim


	# uninstall nvoid
	# rm -rf ~/.config/nvim/
	# rm -rf ~/.local/share/nvim/
}

install_fzf(){
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
  ~/.fzf/install --all
}

set_default_shell(){
	# If this user's login shell is already "zsh", do not attempt to switch.
	if [ "$(basename -- "$SHELL")" = "zsh" ]; then
		return
	else
		sudo chsh -s "$(command -v zsh)" "${USER}"
	fi
}

install_package(){
	# do not install if package already exists
	# $1 package name
	# $2 function to install package
	command -v $1 >/dev/null
	if [ $? -ne 0 ]; then
		$2
	else
		echo "$1 already installed."
	fi
}

# install these packages when
# MPEG-4 and H.264 (High Profile) decoders are required
# gstreamer1.0-libav
# gstreamer1.0-plugins-ugly
# gstreamer1.0-plugins-bad
# ubuntu-restricted-extras

set_default_shell

install_package codium install_vscodium
install_package nvim install_neovim
install_package fzf install_fzf

vscodium_user_settings

command -v codium >/dev/null && install_vscodium_extensions

command -v nvim >/dev/null
if [ $? -eq 0 ]; then
	if [ ! -d "$HOME/.config/nvim" ]; then
		install_nvoid
	fi
fi
