# dotfiles

Reusable macOS shell, Git, Vim, terminal, and editor configuration.
Inspired by [Mathias Bynens’ dotfiles](https://github.com/mathiasbynens/dotfiles).

## Install

Clone this repository, then preview the explicit file list:

```sh
./symlink-setup.sh --dry-run
./symlink-setup.sh
```

Run the script from any directory. It preserves existing files and reports
conflicts with a nonzero exit status. Back up and move conflicting files yourself
before retrying. It refuses symlinked parent directories; if your current setup
links all of `~/.config`, `~/bin`, or `~/.ssh` into another checkout, migrate those
directories separately before installing. It never links those whole directories.

Shell configuration and selected individual configuration files are symlinked.
VS Code settings, npm/pnpm configuration, and the SSH template are copied so application
changes stay outside the checkout. Copies that later change are preserved on reruns.
Vim plugins can be installed with `:PlugInstall` after installing Vim-plug.

`./setup-a-new-machine.sh` offers optional installation of development tools and
macOS preferences. Review its steps before running it. No bootstrap or installer
steps run automatically when cloning.

## Private settings

Keep personal identity, internal hosts, work configuration, and credentials outside
this public repository. Optional files loaded by the public configuration are:

- `~/.gitconfig.local` for Git identity and private Git settings.
- `~/.zshrc.local` and `~/.bash_profile.local` for shell overrides.
- `~/.aliases.local` for private aliases.
- `~/.ssh/config.local` for SSH hosts and identities.

Copy `.gitconfig.local.example` to `~/.gitconfig.local` and fill in your identity.
A separate private companion repository can contain these files under
`private-overlay/`. Install it explicitly with:

```sh
./symlink-setup.sh --dry-run --private-dir /path/to/private-repository
./symlink-setup.sh --private-dir /path/to/private-repository
```

Application authentication stores, databases, logs, and caches belong outside Git.
Load actual credentials from a credential manager at runtime. Keep private
repository contents and its Git history out of this checkout.

## Checks before committing

```sh
python3 -m unittest discover -s tests -v
git add <explicit-files>
python3 scripts/check-public.py
gitleaks git --pre-commit --staged --redact
```

To enable the supplied commit hook, install Gitleaks and run:

```sh
git config core.hooksPath .githooks
```

CI checks the file policy, installer tests, and complete published Git history.
Secret scanners cannot establish that arbitrary configuration is safe to publish;
review new files and staged diffs before committing.

This repository starts with an independent, sanitized snapshot. Previous private
commits, application data, and credentials are intentionally absent from its history.
