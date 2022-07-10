#!/usr/bin/env sh

# pip3, pipenv, yt-dlp
sudo apt install -y python3-pip && python3 -m pip install --upgrade pip
python3 -m pip install -U pipenv yt-dlp

# bat
sudo apt install -y bat && ln -s /usr/bin/batcat ~/.local/bin/bat

# fd-find
sudo apt install -y fd-find && ln -s $(command -v fdfind) ~/.local/bin/fd

# lf
if ! command -v lf > /dev/null; then
	curl -L https://github.com/gokcehan/lf/releases/latest/download/lf-linux-amd64.tar.gz | tar xzC ~/.local/bin
fi

# automatic CPU speed & power optimizer for linux
install_auto_cpufreq(){
	if [ ! -d "$HOME/auto-cpufreq" ]; then
		git clone https://github.com/AdnanHodzic/auto-cpufreq.git
		cd auto-cpufreq && sudo ./auto-cpufreq-installer
		sudo auto-cpufreq --install
	fi
}


download_nerdfonts(){
	mkdir -p "$HOME/.local/share/fonts/nerdfonts"
	sudo aria2c --continue=true --max-concurrent-downloads=1 --auto-save-interval=5 --auto-file-renaming=false --dir=${HOME}/.local/share/fonts/nerdfonts -i "$HOME/.tools/nerdfonts"

	# generate fonts cache
	fc-cache -f -v
	
	# verify if font was cached successfully
	# fc-list | grep "font-name"
}


# enable usb support in virutalbox
command -v virtualbox > /dev/null && sudo adduser $USER vboxusers


install_vscode(){
	if ! command -v code > /dev/null; then
		sudo apt-get install wget gpg
		wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
		sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
		sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
		rm -f packages.microsoft.gpg

		sudo apt install -y apt-transport-https
		sudo apt update -y
		sudo apt install -y code

		# uninstall vscode
		# sudo apt-get remove code
		# remov all user settings
		# rm -rf ~/.config/Code
		# rm -rf ~/.vscode
	fi
}


install_neovim(){
	if ! command -v nvim > /dev/null; then
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
	fi
}


install_lvim(){
    if command -v nvim > /dev/null; then
        #  Pre-requisites
        sudo install -y ripgrep rust
        sudo npm install -g tree-sitter-cli prettier
        python3 -m pip install -U pynvim autopep8 flake8
        cargo install stylua

        bash <(curl -s https://raw.githubusercontent.com/lunarvim/lunarvim/master/utils/installer/install.sh) --no-install-dependencies

        #lvim -c 'autocmd User PackerComplete quitall' -c 'PackerSync'
		
		if command -v lvim > /dev/null; then
			if [ -f "$HOME/.aliases" ]; then
				echo -ne '\nalias nvim="lvim"' >> "$HOME/.aliases"
				lvim
			elif
				echo -ne '\nalias nvim="lvim"' >> "$HOME/.zsh"
				lvim
			fi
		fi
		
        # uninstall lvim
        # rm -rf ~/.config/nvim/
        # rm -rf ~/.local/share/nvim/
		
    fi


}


install_fzf(){
    if ! command -v fzf > /dev/null; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --all
    fi
}


# install these packages when
# MPEG-4 and H.264 (High Profile) decoders are required
# gstreamer1.0-libav
# gstreamer1.0-plugins-ugly
# gstreamer1.0-plugins-bad
# ubuntu-restricted-extras

download_nerdfonts
install_vscode

install_auto_cpufreq
