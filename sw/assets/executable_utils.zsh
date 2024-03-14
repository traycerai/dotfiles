#!/usr/bin/env zsh

RESET="\e[0m"
BOLD="\e[1m"

BLACK="\e[30m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[37m"

BLACK_BRIGHT="\e[90m"
RED_BRIGHT="\e[91m"
GREEN_BRIGHT="\e[92m"
YELLOW_BRIGHT="\e[93m"
BLUE_BRIGHT="\e[94m"
MAGENTA_BRIGHT="\e[95m"
CYAN_BRIGHT="\e[96m"
WHITE_BRIGHT="\e[97m"

function silent_background() {
   set +m && { "$@" 2>&3 & disown; pid=$!; } 3>&2 2>/dev/null && set -m
}

function zsh_stats() {
  echo -e "${CYAN_BRIGHT}  == Zsh history statistics == ${RESET}"
  HISTFILE=~/.zsh_history fc -R
  fc -l 1 | awk '{CMD[$2]++;count++;}END { for (a in CMD)print CMD[a] " " "\033[33m"CMD[a]/count*100 "% " "\033[36m"a"\033[0m";}' | grep -v "./" | column -c3 -s " " -t | sort -nr | nl | head -n25
}

# This script was automatically generated by the broot program
# More information can be found in https://github.com/Canop/broot
# This function starts broot and executes the command
# it produces, if any.
# It's needed because some shell commands, like `cd`,
# have no useful effect if executed in a subshell.
function br {
	local cmd cmd_file code
	cmd_file=$(mktemp)
	if broot --outcmd "$cmd_file" "$@"; then
		cmd=$(<"$cmd_file")
		rm -f "$cmd_file"
		eval "$cmd"
	else
		code=$?
		rm -f "$cmd_file"
		return "$code"
	fi
}

# define a function to display bindings
function tmux_bindings {
  tput sgr0
  echo -e "${BOLD}${RED}tmux bindings:${RESET}"
  local BINDINGS=(
    "${YELLOW} Local Sessions <prefix>:${RESET} C-a or C-b (default tmux binding)"
    "${YELLOW} <prefix> C-Space:${RESET} fuzzy menu"
    "${YELLOW} F12:${RESET} menu"
    "${YELLOW} C-l:${RESET} clear screen and tmux history"
    "${YELLOW} Nested Sessions (e.g. ssh) <prefix>:${RESET} Repeat local <prefix>, i.e. C-a C-a ... or C-b C-b ...${RESET}"
    "${YELLOW} F1:${RESET} suspend local tmux so as to work on remote tmux session. Only default bindings (C-b prefix) are suspended."
    "${YELLOW} <prefix> d:${RESET} detaches current client"
    "${YELLOW} <prefix> C-w or <prefix> w:${RESET} select sessions or windows/panes"
    "${YELLOW} <prefix> C-/:${RESET} fuzzy search scrollback buffer"
    "${YELLOW} <prefix> C-c:${RESET} creates new session"
    "${YELLOW} <prefix> C-s:${RESET} save environment"
    "${YELLOW} <prefix> C-r:${RESET} restore environment"
    "${YELLOW} <prefix> Tab:${RESET} last active window"
    "${YELLOW} <prefix> C-h and <prefix> C-l:${RESET} navigate windows"
    "${YELLOW} <prefix> <number>:${RESET} goto window by number"
    "${YELLOW} <prefix> -:${RESET} split current pane vertically"
    "${YELLOW} <prefix> _:${RESET} split current pane horizontally"
    "${YELLOW} <prefix> Space:${RESET} cycle layouts"
    "${YELLOW} <prefix> <h,j,k,l> or <arrow keys>:${RESET} navigate panes"
    "${YELLOW} <prefix> <H,J,K,L>:${RESET} resize panes"
    "${YELLOW} <prefix> < or <prefix> >:${RESET} swap left or right"
    "${YELLOW} <prefix> +:${RESET} maximizes current pane to a new window"
    "${YELLOW} <prefix> m:${RESET} toggles mouse on/off"
    "${YELLOW} <prefix> P:${RESET} choose the paste-buffer to paste from"
    "${YELLOW} <prefix> F:${RESET} launch Facebook PathPicker"
    "${YELLOW} <prefix> u:${RESET} launch Fzf Url Picker"
    "${YELLOW} <prefix> U:${RESET} launch Urlview"
    "${YELLOW} <prefix> r:${RESET} reload config"
    "${YELLOW} <prefix> /:${RESET} describe key binding for a key"
    "${YELLOW} <prefix> ?:${RESET} show all bindings"
    "${YELLOW} == vi copy-mode == ${RESET}"
    "${YELLOW} <prefix> Enter:${RESET} enter vi-style copy mode"
    "${YELLOW} v:${RESET} begin selection / visual mode"
    "${YELLOW} y:${RESET} copies the selection to the paste-buffer"
    "${YELLOW} C-v:${RESET} toggles between blockwise visual mode and visual mode")
  for i in "${BINDINGS[@]}"; do
    echo "$i"
  done
  tput sgr0
}

# source zinit and it's minimum setup to allow usage in win_split

if [ -z "$ZINIT_TURBO" ]; then
  ZINIT_TURBO=true
fi

source $HOME/.local/share/zinit/zinit.git/zinit.zsh

zinit light marzocchi/zsh-notify
zstyle ':notify:*' error-icon "$HOME/sw/assets/lose.png"
zstyle ':notify:*' error-title "wow such #fail"
zstyle ':notify:*' success-icon "$HOME/sw/assets/win.png"
zstyle ':notify:*' success-title "very #success. wow"
# aggressively notify when commands complete as we use a whitelist
zstyle ':notify:*' command-complete-timeout 1
zstyle ':notify:*' always-check-active-window yes
zstyle ':notify:*' enable-on-ssh yes
zstyle ':notify:*' notifier term-notify
zstyle ':notify:*' blacklist-regex 'vim|nvim|less|more|man|top|htop|btm|ssh'

if [[ $OSTYPE == 'linux'* ]]; then
  # linux
  zstyle ':notify:*' app-name sh
  zstyle ':notify:*' expire-time 5000
  zstyle ':notify:*' error-sound "$HOME/sw/assets/lose.ogg"
  zstyle ':notify:*' success-sound "$HOME/sw/assets/win.ogg"
fi

if [[ $OSTYPE == 'darwin'* ]]; then
  zstyle ':notify:*' error-sound "Sonumi"
  zstyle ':notify:*' success-sound "Breeze"
fi

APP_ATTN_PATTERNS=(
  'autoupdate.zsh'
  'sync_brews.sh'
  'sync_repos.sh'
  'brew'
  'git commit'
  'make'
  'go build'
  'go test'
  'gotestsum'
  'git_ship'
  'speedtest'
)

function term-notify() {
	local notification_type="$1"
	local cmd=$(<&0)
	local attention='none'
	# check whether last command contained any of the APP_ATTN_PATTERNS
	for pattern in "${APP_ATTN_PATTERNS[@]}"; do
		if [[ $cmd =~ $pattern ]]; then
			if [[ $notification_type == 'success' ]]; then
				attention='once'
			else
				attention='start'
			fi
		fi
	done

	# check whether $attention is not 'none'
	if [[ $attention != 'none' ]]; then
		if [[ $OSTYPE == 'darwin'* ]] && [[ "$TERM_PROGRAM" == 'iTerm.app' ]]; then
			if $ITERM2_INTEGRATION_DETECTED; then
				$HOME/.iterm2/it2attention $attention
			fi
		fi
		# ring the bell
		tput bel
		# pass-through
		zsh-notify $1 $2 <<<"$cmd"
	fi
}

# check if $ZINIT_TURBO is true
if $ZINIT_TURBO; then
  zinit ice wait'0' lucid atload'export PATH="$PATH:$(dirname $FORGIT)"'
  zinit light wfxr/forgit
else
  zinit light wfxr/forgit
  export PATH="$PATH:$(dirname $FORGIT)"
fi

if [[ $OSTYPE == 'linux'* ]]; then
  export FORGIT_COPY_CMD='xclip -selection clipboard'
fi

zinit snippet OMZ::lib/history.zsh
