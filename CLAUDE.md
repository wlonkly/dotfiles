# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository managed with [Homesick](https://github.com/andsens/homeshick), a tool that symlinks dotfiles from `~/.homesick/repos/dotfiles/home/` to the home directory. The actual dotfiles live in the `home/` subdirectory.

## Repository Management

### File Structure
- `home/` - Contains all dotfiles that will be symlinked to `~/`
- `home/gbin/` - programs committed to *g*ithub, this is in the user's $PATH
- `home/.config/` - XDG config directory for modern tools
- `home/LaunchAgents/` - macOS LaunchAgents for background tasks

## Development Environment

### Shell Environment
This repository configures a Bash environment optimized for DevOps/infrastructure work:

**Configuration layering:**
1. `.bash_profile` - Login shells only (macOS Terminal, SSH). Things we don't want in subshells. Sources `.bashrc`, sets EDITOR, runs daily homeshick check, then sources `.profile-local`
2. `.bashrc` - Interactive shells (login and non-login).  Things that we want in subshells.
3. `.profile-local` - Machine/OS/hostname-specific overrides loaded last. Contains Homebrew setup, FZF theming, and host-specific configs. "flounder" is the user's personal laptop. "rlafferty*" is the user's work laptops.

## macOS Automation

### Hammerspoon
Lua-based automation in `home/.hammerspoon/`:
- Window management
- Application launching
- Custom hotkeys

### Raycast Scripts
Scripts in `home/.config/raycast/` for quick actions.

## Configuration Philosophies

1. **AWS-first**: The environment assumes heavy AWS usage with multiple profiles
2. **Git power user**: Advanced git features enabled by default (rebase workflow, auto-squash, rerere)
3. **Modern CLI tools**: Prefers rust-based replacements (rg, bat, fd, delta, starship)
4. **Clean namespace**: Custom scripts in `gbin/` to avoid conflicts
5. **Shell functions over aliases**: Complex operations use functions that handle edge cases
6. **Theme consistency**: Catppuccin Mocha theme across tools (bat, delta, starship)

## SSH Configuration

- ControlMaster enabled (sockets in `~/.ssh/c/`)
- `sshnc` alias disables ControlMaster for specific connections
- `colorssh` wrapper colorizes terminal per host

## Notes for Development

- When adding new scripts pr programs, place them in `home/gbin/` and make them executable
- When adding shell functions, add to `.bashrc` with a comment explaining purpose
- When adding git aliases, document in this file if non-obvious
- The Claude CLI is aliased to inject 1Password secrets via `op run`
