---
abstract: |
  One of the common things that brings programmers together is dealing
  with \"dotfiles\"---configuration files that often begin with a \"`.`\"
  character.

  This repository is meant to be cloned inside `~.dotfiles/.pub/`, and
  from that directory, package\'s dotfiles are meant to be installed by
  running `stow PACKAGE`.
date: '2021-12-03'
subtitle: 'rolandog\''s public dotfiles'
title: dotpub
---

## Downloading dotfiles

This repository is meant to be cloned inside `~.dotfiles/.pub/`:

``` {.bash exports="code" eval="never" dir="~" wrap="SRC text"}
mkdir -p ~/.dotfiles/.pub
git clone https://git.sr.ht/~rolandog/dotpub ~/.dotfiles/.pub
cd ~/.dotfiles/.pub
```

## Inspecting dotfiles

This is a way to inspect our current repository:

``` {.bash exports="both" results="output" cache="yes" dir="~/.dotfiles/.pub" wrap="SRC text"}
tree -Fan -I '.git' --charset=ascii --dirsfirst ~/.dotfiles/.pub
```

``` {.text}
/home/rolandog/.dotfiles/.pub
|-- bash/
|   |-- .bash_aliases
|   |-- .bash_colors
|   |-- .bash_logout
|   |-- .bashrc
|   `-- .profile
|-- emacs/
|   `-- .emacs
|-- firewall/
|   |-- firewall.sh*
|   `-- unfirewall.sh*
|-- git/
|   `-- .gitconfig
|-- gpg/
|   `-- .gnupg/
|       |-- dirmngr.conf
|       |-- gpg-agent.conf
|       `-- gpg.conf
|-- htop/
|   `-- .config/
|       `-- htop/
|           `-- htoprc
|-- lynx/
|   `-- .lynxrc
|-- org/
|   `-- .local/
|       `-- share/
|           `-- org/
|               `-- setup/
|                   |-- en-a4.config
|                   |-- en-letter.config
|                   |-- es-a4.config
|                   |-- es-letter.config
|                   |-- nl-a4.config
|                   `-- nl-letter.config
|-- pandoc/
|   `-- .local/
|       `-- share/
|           `-- pandoc/
|               |-- filters/
|               |   |-- cleanup-markdown-metadata.lua
|               |   `-- move-markdown-abstract.lua
|               `-- style/
|-- ssh/
|   `-- .ssh/
|       |-- config
|       `-- known_hosts
|-- stow/
|   `-- .stow-global-ignore
|-- user-dirs/
|   `-- .config/
|       |-- user-dirs.dirs
|       `-- user-dirs.locale
|-- vim/
|   `-- .vimrc
|-- youtube-dl/
|   `-- .config/
|       `-- youtube-dl/
|           `-- config
|-- .build.yml
|-- COPYING
|-- .gitignore
|-- Makefile
|-- README
|-- README.md
|-- README.org
|-- .stow-local-ignore
`-- .stowrc

30 directories, 38 files
```

## Installing dotfiles

After cloning, one can \"install\" the dotfiles of a certain `package`
by running:

``` {.bash exports="code" eval="never" dir="~/.dotfiles/.pub" wrap="SRC text"}
stow PACKAGE
```

## Pushing local changes

The first time we want to push additional changes back:

``` {.bash exports="code" eval="never" dir="~/.dotfiles/.pub" wrap="SRC text"}
git remote add origin git@git.sr.ht:~rolandog/dotpub
git push --set-upstream origin main
```

## Online resources

### Programmer\'s dotfiles

-   <https://github.com/podiki/dot.me>
-   <https://github.com/kalkayan/dotfiles>
-   <https://github.com/gfarrell/dotfiles>

### Online discussions or tutorials

-   <https://news.ycombinator.com/item?id=11071754>
-   <https://news.ycombinator.com/item?id=11070797>
-   <https://www.atlassian.com/git/tutorials/dotfiles>
