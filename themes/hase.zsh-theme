# Based on Paulo theme
# my_git_prompt_status() from mortalscumbag.zsh-theme
# better than git_prompt_status() on .oh-my-zsh/lib/git.zsh
# because of the STAGED|UNSTAGED behavior
function my_git_prompt_status() {
  tester=$(git rev-parse --git-dir 2> /dev/null) || return
  
  INDEX=$(git status --porcelain 2> /dev/null)
  STATUS=""

  # is branch ahead?
  if $(echo "$(git log origin/$(git_current_branch)..HEAD 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_AHEAD"
  fi

  # is branch behind?
  if $(echo "$(git log HEAD..origin/$(git_current_branch) 2> /dev/null)" | grep '^commit' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_BEHIND"
  fi

  # is anything staged?
  if $(echo "$INDEX" | command grep -E -e '^(D[ M]|[MARC][ MD]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_STAGED"
  fi

  # is anything unstaged?
  if $(echo "$INDEX" | command grep -E -e '^[ MARC][MD] ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNSTAGED"
  fi

  # is anything untracked?
  if $(echo "$INDEX" | grep '^?? ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNTRACKED"
  fi

  # is anything unmerged?
  if $(echo "$INDEX" | command grep -E -e '^(A[AU]|D[DU]|U[ADU]) ' &> /dev/null); then
    STATUS="$STATUS$ZSH_THEME_GIT_PROMPT_UNMERGED"
  fi

  if [[ -n $STATUS ]]; then
    STATUS="$STATUS"
  fi

  echo "$STATUS"
}

function my_current_branch() {
  echo $(git_current_branch || echo "(no branch)")
}

function ssh_connection() {
  if [[ -n $SSH_CONNECTION ]]; then
    echo "%{$CYAN%}(ssh) "
  fi
}

# colors
local WHITE=$fg_bold[white]
local RED=$FG[196]
local YELLOW=$fg_bold[yellow]
local GREEN=$FG[049]
local BLUE=$FG[033]
local CYAN=$FG[051]
local MAGENTA=$FG[099]
local ret_status="%(?:%{$WHITE%}:%{$RED%})"

# Grab the current date (%D) and time (%T) wrapped in {}: {%D %T}
CURRENT_TIME_="🕗 %{$GREEN%}%T%{$fg[white]%}%{$reset_color%}"


# left
PROMPT='\
$CURRENT_TIME_ 
$(ssh_connection)\
${ret_status}\
🤖 \
%{$reset_color%}'

# right
RPROMPT='\
%{$CYAN%}\
${PWD/#$HOME/~}\
%{$WHITE%}\
$(git_remote_status) \
%{$GREEN%}\
$(my_current_branch)\
%{$reset_color%}\
$(my_git_prompt_status)\
%{$reset_color%}'

# my_git_prompt_status()
ZSH_THEME_GIT_PROMPT_AHEAD="%{$MAGENTA%} ↑" # committed
ZSH_THEME_GIT_PROMPT_BEHIND="%{$RED%} ↓" # behind
ZSH_THEME_GIT_PROMPT_STAGED="%{$YELLOW%} ●" # staged
ZSH_THEME_GIT_PROMPT_UNSTAGED="%{$RED%} ●" # unstaged
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$BLUE%} ●" # untracked
ZSH_THEME_GIT_PROMPT_UNMERGED="%{$RED%} ✕" # unmerged

# git_remote_status() from .oh-my-zsh/lib/git.zsh
ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE=""
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=" ↑"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE=" ↓"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE=" ≠"
