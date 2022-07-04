## What is this?

This is Rolando Garza's personal repository of public configuration
files and utility scripts for the programs he uses on an almost daily
basis.

### But,... why?

The intent of sharing this publicly is that these files may
hopefully be of some use to others.

### TL;DR?

This repository is meant to be cloned inside
`~/.local/share/dotfiles/pub/`, and from that directory, package's
dotfiles are meant to be installed by running `stow PACKAGE` inside
that subdirectory (using [GNU Stow](https://www.gnu.org/software/stow/manual/stow.html)).

## Downloading dotfiles

This repository is meant to be cloned inside `~/.local/share/dotfiles/pub/`:

``` bash
git clone https://git.sr.ht/~rolandog/dotpub ~/.local/share/dotfiles/pub
cd ~/.local/share/dotfiles/pub
```

## Installing dotfiles

A quick way to install all the dotfiles is by running (the `SHELL`
part is optional, but allows for the use of colors in the output):

``` bash
make install SHELL=/usr/bin/bash
```

If, however, one wishes to only install a particular set of dotfiles
for a particular `PACKAGE`, one could run:

``` bash
stow PACKAGE
```

## What dotfiles are installed?

GNU Stow is a handy utility that lets us package a directory structure
inside a folder, and it will create symbolic links to the files and
folders inside our virtual package.

In our case, this directory (`$HOME/.dotfiles/.pub/`) is configured to
have stow treat it as the source, and to treat `$HOME` as its target.

For a given `PACKAGE`:

  - The file `~/.local/share/dotfiles/pub/PACKAGE/.config/hello/world`
  - Will end in `~/.config/hello/world`

Here is an overview of the 'branches' that will be 'transplanted'.

``` text
/home/rolandog/.local/share/dotfiles/pub
|-- applications/
|   `-- .local/
|       `-- share/
|-- bash/
|   `-- .config/
|       `-- bash/
|-- emacs/
|   `-- .config/
|       `-- emacs/
|-- firewall/
|   `-- .local/
|       `-- bin/
|-- gpg/
|   `-- .gnupg/
|-- htop/
|   `-- .config/
|       `-- htop/
|-- lynx/
|-- make/
|-- org/
|   `-- .local/
|       `-- share/
|-- pandoc/
|   `-- .local/
|       `-- share/
|-- python/
|   `-- .config/
|       `-- python/
|-- stow/
|-- user-dirs/
|   `-- .config/
|-- vim/
|   `-- .config/
|       `-- vim/
`-- youtube-dl/
    `-- .config/
        `-- youtube-dl/
```

## Pushing local changes

The first time we want to push additional changes back:

``` bash
git remote add origin git@git.sr.ht:~rolandog/dotpub
git push --set-upstream origin main
```

## Online resources

### Programmer's dotfiles

  - <https://github.com/podiki/dot.me>
  - <https://github.com/kalkayan/dotfiles>
  - <https://github.com/gfarrell/dotfiles>

### Online discussions or tutorials

  - <https://news.ycombinator.com/item?id=11071754>
  - <https://news.ycombinator.com/item?id=11070797>
  - <https://www.atlassian.com/git/tutorials/dotfiles>
