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
$ stow .
# or to a specific path
$ stow -t ~ .
```

If file exists, use this to **overwrite file in repo**:

```sh
$ stow --adopt .
```
