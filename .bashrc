# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Load starship prompt if starship is installed
if [ -x /usr/bin/starship ]; then
	__main() {
		local major="${BASH_VERSINFO[0]}"
		local minor="${BASH_VERSINFO[1]}"

		if ((major > 4)) || { ((major == 4)) && ((minor >= 1)); }; then
			source <("/usr/bin/starship" init bash --print-full-init)
		else
			source /dev/stdin <<<"$("/usr/bin/starship" init bash --print-full-init)"
		fi
	}
	__main
	unset -f __main
fi

# Advanced command-not-found hook
if [[ -f /usr/share/doc/find-the-command/ftc.bash ]]; then
  source /usr/share/doc/find-the-command/ftc.bash
fi

## Trying out autocomplete
 # ============================================
# ENHANCED AUTOCOMPLETION
# ============================================

# Enable programmable completion
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Better history completion with arrow keys
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'

# Case-insensitive completion
bind 'set completion-ignore-case on'

# Treat hyphens and underscores as equivalent
bind 'set completion-map-case on'

# Display matches immediately
bind 'set show-all-if-ambiguous on'

# Show all autocomplete results in one go
bind 'set page-completions off'

# Color completion prefixes
bind 'set colored-completion-prefix on'

# Color files by type
bind 'set colored-stats on'

# Append slash to symlinked directories
bind 'set mark-symlinked-directories on'

# Enable menu completion (tab cycles through options)
bind 'set menu-complete-display-prefix on'
bind '"\t": menu-complete'
bind '"\e[Z": menu-complete-backward'

# Git autocompletion (if not already loaded)
if [ -f /usr/share/git/completion/git-completion.bash ]; then
  . /usr/share/git/completion/git-completion.bash
fi

# Docker completion (if docker is installed)
if [ -x /usr/bin/docker ] && [ -f /usr/share/bash-completion/completions/docker ]; then
  . /usr/share/bash-completion/completions/docker
fi

# Kubectl completion (if kubectl is installed)
if [ -x /usr/bin/kubectl ]; then
  source <(kubectl completion bash)
fi

# NPM completion
if [ -x /usr/bin/npm ]; then
  eval "$(npm completion 2>/dev/null)"
fi

 # FZF fuzzy finder integration
if [ -f /usr/share/fzf/key-bindings.bash ]; then
  source /usr/share/fzf/key-bindings.bash
fi

if [ -f /usr/share/fzf/completion.bash ]; then
  source /usr/share/fzf/completion.bash
fi


## Useful aliases

# Replace ls with eza
if [[ -x /usr/bin/eza ]]; then
  alias ls='eza -al --color=always --group-directories-first --icons'     # preferred listing
  alias la='eza -a --color=always --group-directories-first --icons'      # all files and dirs
  alias ll='eza -l --color=always --group-directories-first --icons'      # long format
  alias lt='eza -aT --color=always --group-directories-first --icons'     # tree listing
  alias l.='eza -ald --color=always --group-directories-first --icons .*' # show only dotfiles
fi


# Replace some more things with better alternatives
if [[ -x /usr/bin/bat ]]; then
  alias cat='bat --style header --style snip --style changes --style header'
fi

[ ! -x /usr/bin/yay ] && [ -x /usr/bin/paru ] && alias yay='paru'

# Common use
alias grubup="sudo update-grub"
alias fixpacman="sudo rm /var/lib/pacman/db.lck"
alias tarnow='tar -acf '
alias untar='tar -zxvf '
alias wget='wget -c '
alias rmpkg="sudo pacman -Rdd"
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias upd='/usr/bin/garuda-update'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
alias ......='cd ../../../../..'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='ugrep --color=auto'
alias fgrep='ugrep -F --color=auto'
alias egrep='ugrep -E --color=auto'
alias hw='hwinfo --short'                          # Hardware Info
alias big="expac -H M '%m\t%n' | sort -h | nl"     # Sort installed packages according to size in MB (expac must be installed)
alias gitpkg='pacman -Q | grep -i "\-git" | wc -l' # List amount of -git packages
alias ip='ip -color'

# Get fastest mirrors
alias mirror="sudo reflector -f 30 -l 30 --number 10 --verbose --save /etc/pacman.d/mirrorlist"
alias mirrord="sudo reflector --latest 50 --number 20 --sort delay --save /etc/pacman.d/mirrorlist"
alias mirrors="sudo reflector --latest 50 --number 20 --sort score --save /etc/pacman.d/mirrorlist"
alias mirrora="sudo reflector --latest 50 --number 20 --sort age --save /etc/pacman.d/mirrorlist"

# Help people new to Arch
alias apt='man pacman'
alias apt-get='man pacman'
alias please='sudo'
alias tb='nc termbin.com 9999'
alias helpme='cht.sh --shell'
alias pacdiff='sudo -H DIFFPROG=meld pacdiff'

# My own alias
alias cpwd='pwd | tr -d "\n" | xclip -selection clipboard && echo "Path copied!"'

# Cleanup orphaned packages
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# Get the error messages from journalctl
alias jctl="journalctl -p 3 -xb"

# Recent installed packages
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "$HOME/.cargo/env"

export PATH="$PATH:/home/clinton/.config/.foundry/bin"
export PATH="$PATH:/home/clinton/.local/Jetbrains/idea-IC/bin"

# pnpm
export PNPM_HOME="/home/clinton/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end
#
figlet D4RK P4SS3NG3R
export PATH="$HOME/.local/bin:$PATH"
xset led 3

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"
export PATH=$PATH:$HOME/go/bin

export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools


