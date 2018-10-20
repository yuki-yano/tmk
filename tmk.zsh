#!/usr/bin/env zsh

function _tmk-kill-session() {
  answer=$(_tmk-kill-session-list | fzf-tmux --ansi --prompt="tmk >" )

  case $answer in
    *kill*Server* ) tmux kill-server ;;
    *kill*windows* )
      echo $answer | while read -r session; do
        tmux kill-session -t $(echo $session | awk '{print $4}' | sed "s/://g")
      done
    ;;
  esac
}

function _tmk-kill-session-list() {
  list_sessions=$(tmux list-sessions 2>/dev/null);
  echo "$list_sessions" | while read line; do
    [[ "$line" =~ "attached" ]] && line="${GREEN}"$line"${DEFAULT}"
    echo -e "${RED}kill${DEFAULT} ==> [ "$line" ]"
  done
  [ $(echo "$list_sessions" | grep -c '')  = 1 ] || echo -e "${RED}kill${DEFAULT} ==> [ ${RED}Server${DEFAULT} ]"
}

function set-color() {
  if [[ "${filter[@]}" =~ "fzf" ]]; then
    readonly BLACK="\033[30m"
    readonly RED="\033[31m"
    readonly GREEN="\033[32m"
    readonly YELLOW="\033[33m"
    readonly BLUE="\033[34m"
    readonly MAGENTA="\033[35m"
    readonly CYAN="\033[36m"
    readonly WHITE="\033[37m"
    readonly BOLD="\033[1m"
    readonly DEFAULT="\033[m"
  fi
}

function tmk() {
  set-color
  if [[ $# = 0 ]]; then
    _tmk-kill-session
  elif [[ $# = 1 ]] || [[ $# = 2 ]]; then
    case $1 in
      * ) echo "tmk: illegal option $1" 1>&2 && exit 1 ;;
    esac
  else
    echo "tmk: option must be one" 1>&2 && exit 1
  fi
}

zle -N tmk
