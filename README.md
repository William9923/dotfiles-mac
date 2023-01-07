# Tyranitar Dotfiles

<p align="center"><b>Tyranitar: My Personal MacOS Work Setup</b></p>

<p align="center">
    <img alt="MacOS" src="https://img.shields.io/badge/Mac-silver?style=flat-square&logo=MacOS" />
    <img alt="Editor" src="https://img.shields.io/badge/editor-nvim-019733?style=flat-square&logo=neovim" />
    <img alt="Git" src="https://img.shields.io/badge/git-lazygit-pink?style=flat-square&logo=git" />
    <img alt="Workflow Manager" src="https://img.shields.io/badge/multiplexer-tmux-1BB91F?style=flat-square&logo=tmux" />
  </p>

## ✨ Table of Contents
* [Screenshots](#Screenshots)
* [Overview](#Overview)
* [Application](#Application)

## Screenshots

<img alt="MacOS Rice" src="docs/screenshot/rice.png" />

## Overview
Tyranitar is my MacOS specific workflow & tools for my daily work (as software engineer) in Shopee.
It contains most of the configuration that I use, mainly application and customization for my programming setup. 

While it feels great for me, Tyranitar might not works well for you, so this repo is meant to archive my my dev toolbox along the year. Think of this dotfiles as your "engineer" work toolbox. A great engineer usually have their own set of tools that they bring everywhere because they feel comfortable using them.

 I'm using [Gruvbox Theme](https://github.com/morhetz/gruvbox) as my color scheme for my daily usage theme (as it pretty comfortable in my eye, others might find it quite old but I like it) and [Jetbrains Nerd Font](https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete%20Mono.ttf) as default font.

## Application
As I'm mainly working with Golang & Java, I usually use: (TODO: should make into a table...)
1. Terminal-based:
- alacritty : as my terminal emulator
- tmux : to control pane and window in terminal
- zsh : as my shell
- Neovim : as my fully Text Editor
- Lazygit + Delta: as my git client and git diff visualizer
- Lazydocker : to help view my running docker application
- redis-cli : as my redis client
- htop : system profiller
- vimwiki / Notes : personal note taking apps
- Fig : for CLI Autocompletion
- lf : file manager

2. Gui-based:
- VSCode : as my debugging tools (i only open it to debug my apps lol...)
- Intellij : as my IDE (when working with Java), along with the .ideavimrc
- dbeaver : as my database client GUI apps
- Postman : for my API Client GUI apps
- Mockoon : for my Mock API apps
- Firefox : browser
- Filezilla: SFTP-file manager
- Zoom : online video meeting

## How to setup...
Here is the step by step to setup all my work laptop. This is not going to be a script that are run once, but a step by step and reference on how to install it.

**Homebrew**
0. Install xcode dev tools
```bash
$ xcode-select --install
```
1. Verify Installation of xcode (should show result if installed properly)
```bash
$ xcode-select -p
```
2. Install homebrew
```bash
$ /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```
3. Update homebrew & check the installation
```bash
$ brew update && brew doctor
```
4. Install Go v1.17
```bash
$ brew install go@1.17
```
5. Install Node & NPM
```bash
$ brew install node
```

**Zsh**
0. Install zsh
```bash
$ brew install zsh
```
1. Setup the .zshrc & alias with PATH
```bash
$ ln .zshrc ~/.zshrc 
```
2. Install omz for theme
```bash
$ sh -c "$(wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
```
3. Setup terminal prompt (POWERLEVEL 10K)
```bash
$ git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
```
4. Configure powerlevel10k with helper wizard
```bash
$ p10k configure
```
5. Install directory jumper (guide:
https://github.com/agkozak/zsh-z#installation)
6. Install zsh autosuggestion (guide:
https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md#oh-my-zsh)

**Jetbrains Mono Nerd Font**
1. Tap the homebrew
```bash
$ brew tap homebrew/cask-fonts
```
2. Install the font
```bash
$ brew install --cask font-jetbrains-mono
```
3. Check if the font already installed or not in the Font Book (Mac Built-in
Apps)

**Alacritty**
1. Install alacritty via homebrew
```bash
$ brew install --cask alacritty
```
2. Enable application from system preference
![Security&Privacy -> General](./docs/screenshot/security-privacy.png)

3. Setup alacritty with custom configuration
```bash
$ cd ~/.config/ && ln <path-to-dotfile>/alacritty alacritty
```
4. Reload...

**Vim**
1. Vim installation should be done by system (available immediately...)
2. Copy .vimrc to `~/.vimrc` in ~/ directory
```bash
$ cp .vimrc ~/.vimrc
```
3. (Optional) Or, link the .vimrc to the ~/.vimrc
```bash
$ ln .vimrc ~/.vimrc
```

**Git**
1. Copy the .gitconfig file (or you could link it)
```bash
$ ln .gitconfig ~/.gitconfig
```
2. Copy the .ssh folder (or you could link it) -> maybe not available in repo
```bash
$ cd && ln <path-to-dotfile>/.ssh .ssh
```
3. Copy the .netrc file for authentication issue when accessing some repo
```bash
$ ln .netrc ~/.netrc
```

**Tmux**
1. Install tmux
```bash
$ brew install tmux
```
2. Setup tmux configuration (using oh-my-tmux, with slight modification)
```bash
$ cp ./tmux.conf ~/.tmux.conf && cp ./tmux.conf.local ~/.tmux.conf.local
```
3. Or, can link the config file to the ~/ directory
```bash
$ ln ./tmux.conf ~/.tmux.conf && ln /tmux.conf.local ~/.tmux.conf.local
```

**Neovim**
1. Install neovim via homebrew (v.0.8)
```bash
$ brew install neovim
```
2. Copy .config/nvim directory to ~/.config/nvim 
```bash
$ cp -r .config/nvim ~/.config/nvim
```
3. (Optional) Or, link the directory
```bash
$ cd ~/.config && ln <path-to-dotfile>/.config/nvim nvim
```
4. Save the plugin file to re-download all neovim plugin used
```bash
$ nvim ~/.config/nvim/lua/user/plugin.lua  
```

**VSCode**

**Intellij**

**Lazygit**

**Lazydocker**

**Firefox**
1. Install Firefox Developer Version using homebrew
```bash
$ brew tap homebrew/cask-versions
$ brew install --cask firefox-developer-edition
```
2. Import bookmark (from bookmark manager)
![Import Bookmark Guide](./docs/screenshot/import-bookmark.png)
3. Change the theme to Gruvbox (ref: https://addons.mozilla.org/en-US/firefox/addon/gruvbox-dark-theme/)
4. Add Vimium addsOn (ref: https://addons.mozilla.org/en-US/firefox/addon/vimium-c/)
5. Add Youtube AddsOn (ref: https://addons.mozilla.org/id/firefox/addon/adblock-for-youtube/)
6. Apply Firefox CSS (ref: https://github.com/andreasgrafen/cascade)

**Fig**
1. Install using brew
```bash
$ brew install fig
```

**Zoom**
1. Install Zoom using homebrew
```bash
brew install --cask zoom
```
2. Login your account


## ❤️ Support
If you feel that this repo have helped you provide more example on learning software engineering, then it is enough for me! Wanna contribute more? Please ⭐ this repo so other can see it too!
