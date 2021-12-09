                      ____________________________

                                 DOTPUB
                       rolandog's public dotfiles

                             Rolando Garza
                           rolandog@gmail.com
                      ____________________________


                               2021-12-03


Table of Contents
_________________

1. Downloading dotfiles
2. Inspecting dotfiles
3. Installing dotfiles
4. Pushing local changes
5. Online resources
.. 1. Programmer's dotfiles
.. 2. Online discussions or tutorials


One of the common things that brings programmers together is dealing
with "dotfiles"---configuration files that often begin with a "`.'"
character.

This repository is meant to be cloned inside `~.dotfiles/.pub/', and
from that directory, package's dotfiles are meant to be installed by
running `stow PACKAGE'.


1 Downloading dotfiles
======================

  This repository is meant to be cloned inside `~.dotfiles/.pub/':

  ,----
  | mkdir -p ~/.dotfiles/.pub
  | git clone https://git.sr.ht/~rolandog/dotpub ~/.dotfiles/.pub
  | cd ~/.dotfiles/.pub
  `----


2 Inspecting dotfiles
=====================

  This is a way to inspect our current repository:
  ,----
  | tree -Fan -I '.git' --charset=ascii --dirsfirst ~/.dotfiles/.pub
  `----

  ,----
  | /home/rolandog/.dotfiles/.pub
  | |-- bash/
  | |   |-- .bash_aliases
  | |   |-- .bash_colors
  | |   |-- .bash_logout
  | |   |-- .bashrc
  | |   `-- .profile
  | |-- emacs/
  | |   `-- .emacs
  | |-- firewall/
  | |   |-- firewall.sh*
  | |   `-- unfirewall.sh*
  | |-- git/
  | |   `-- .gitconfig
  | |-- gpg/
  | |   `-- .gnupg/
  | |       |-- dirmngr.conf
  | |       |-- gpg-agent.conf
  | |       `-- gpg.conf
  | |-- htop/
  | |   `-- .config/
  | |       `-- htop/
  | |           `-- htoprc
  | |-- lynx/
  | |   `-- .lynxrc
  | |-- org/
  | |   `-- .local/
  | |       `-- share/
  | |           `-- org/
  | |               `-- setup/
  | |                   |-- en-a4.config
  | |                   |-- en-letter.config
  | |                   |-- es-a4.config
  | |                   |-- es-letter.config
  | |                   |-- nl-a4.config
  | |                   `-- nl-letter.config
  | |-- pandoc/
  | |   `-- .local/
  | |       `-- share/
  | |           `-- pandoc/
  | |               |-- filters/
  | |               |   |-- cleanup-markdown-metadata.lua
  | |               |   `-- move-markdown-abstract.lua
  | |               `-- style/
  | |-- ssh/
  | |   `-- .ssh/
  | |       |-- config
  | |       `-- known_hosts
  | |-- stow/
  | |   `-- .stow-global-ignore
  | |-- user-dirs/
  | |   `-- .config/
  | |       |-- user-dirs.dirs
  | |       `-- user-dirs.locale
  | |-- vim/
  | |   `-- .vimrc
  | |-- youtube-dl/
  | |   `-- .config/
  | |       `-- youtube-dl/
  | |           `-- config
  | |-- .build.yml
  | |-- COPYING
  | |-- .gitignore
  | |-- Makefile
  | |-- README
  | |-- README.md
  | |-- README.org
  | |-- .stow-local-ignore
  | `-- .stowrc
  | 
  | 30 directories, 38 files
  `----


3 Installing dotfiles
=====================

  After cloning, one can "install" the dotfiles of a certain `package'
  by running:

  ,----
  | stow PACKAGE
  `----


4 Pushing local changes
=======================

  The first time we want to push additional changes back:

  ,----
  | git remote add origin git@git.sr.ht:~rolandog/dotpub
  | git push --set-upstream origin main
  `----


5 Online resources
==================

5.1 Programmer's dotfiles
~~~~~~~~~~~~~~~~~~~~~~~~~

  - <https://github.com/podiki/dot.me>
  - <https://github.com/kalkayan/dotfiles>
  - <https://github.com/gfarrell/dotfiles>


5.2 Online discussions or tutorials
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

  - <https://news.ycombinator.com/item?id=11071754>
  - <https://news.ycombinator.com/item?id=11070797>
  - <https://www.atlassian.com/git/tutorials/dotfiles>
