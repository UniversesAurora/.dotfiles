# .dotfiles

Dot config files repo

## Requirements

Ensure you have `stow` installed on your system

## Installation

First, check out this repo in your `$HOME` directory

```sh
$ git clone --recurse-submodules git@github.com:UniversesAurora/.dotfiles.git
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

### nvim

nvim config file is in another repo, so if you forgot to clone submodule, you need to run this:

```sh
# if you forgot to clone submodule
$ git submodule update --init --recursive
$ stow -v -t ~ nvim
```

If nvim config repo has update, you need to also update this repo. And in other clone need to run:

```sh
$ git submodule update --remote --merge
```
