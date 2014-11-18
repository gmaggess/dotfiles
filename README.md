# Fast [iTerm](http://iterm2.com/) Setup

This is quick reference to help me setup iTerm.

1\. Install [brew](http://brew.sh/) if you haven't done so.

```
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

2\. Install bash git completion

```
sudo port install git +bash_completion
```

3\. Copy all __dotfiles__, except for .gitignore, to your home folder. Don't forget to create a folder called _bin_ under the user's home directory. The bin folder should host all application aliases that will be accessible by command line.
