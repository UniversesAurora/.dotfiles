# .dotfiles

Dot config files repo

## Requirements

Ensure you have `stow` installed on your system

## Installation

First, check out this repo in your `$HOME` directory

```sh
$ git clone git@github.com:UniversesAurora/.dotfiles.git
$ cd .dotfiles
```

then use GNU stow to create symlinks

```sh
$ stow zsh
$ stow vim
# or to a specific path
$ stow -t ~ zsh
$ stow -t ~ vim
```

If file exists, use this to **overwrite file in repo**:

```sh
$ stow --adopt zsh
```
