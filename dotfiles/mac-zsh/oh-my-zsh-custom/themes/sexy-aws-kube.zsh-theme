# sexy-aws-kube.zsh-theme
#
# Oh My Zsh port of the old sexy-bash-prompt setup, with AWS profile and
# Kubernetes context segments.
#
#   user (aws-profile) (kube-context) in ~/dir on branch*△ [rebase]
#   %
#
# Install: symlink into $ZSH_CUSTOM/themes/ and set ZSH_THEME="sexy-aws-kube".
# Requires the `git`, `aws` and `kube-ps1` plugins.
#
# IMPORTANT: PROMPT must contain the literal string `$(git_prompt_info)`.
# oh-my-zsh only registers its async git handler when it finds that exact text
# in a prompt variable (see lib/git.zsh, _defer_async_git_register). Building
# the segment inside a precmd instead silently disables async and makes the
# prompt block on `git status` -- roughly 3.9s in a 100k-file repo.

setopt prompt_subst

# --- colors ----------------------------------------------------------------
if (( ${terminfo[colors]:-0} >= 256 )); then
  _sexy_user_color="%B%F{27}"    # BOLD BLUE
  _sexy_prep_color="%B%F{7}"     # BOLD WHITE
  _sexy_dev_color="%B%F{39}"     # BOLD CYAN
  _sexy_dir_color="%B%F{76}"     # BOLD GREEN
  _sexy_git_color="%B%F{154}"    # BOLD YELLOW
  _sexy_prog_color="%B%F{9}"     # BOLD RED
else
  _sexy_user_color="%B%F{blue}"
  _sexy_prep_color="%B%F{white}"
  _sexy_dev_color="%B%F{cyan}"
  _sexy_dir_color="%B%F{green}"
  _sexy_git_color="%B%F{yellow}"
  _sexy_prog_color="%B%F{red}"
fi
_sexy_reset="%b%f"

# --- git segment -----------------------------------------------------------
# The leading space lives inside the prefix so no stray gap is left when the
# segment is empty (outside a repo, or before the async result arrives).
ZSH_THEME_GIT_PROMPT_PREFIX=" ${_sexy_prep_color}on${_sexy_reset} ${_sexy_git_color}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${_sexy_reset}"
ZSH_THEME_GIT_PROMPT_DIRTY="*"
ZSH_THEME_GIT_PROMPT_CLEAN=""

# Ahead/behind markers, rendered by git_remote_status
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE="${_sexy_git_color}△${_sexy_reset}"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE="${_sexy_git_color}▽${_sexy_reset}"
ZSH_THEME_GIT_PROMPT_DIVERGED_REMOTE="${_sexy_git_color}⬡${_sexy_reset}"
ZSH_THEME_GIT_PROMPT_EQUAL_REMOTE=""

# --- aws segment -----------------------------------------------------------
# These are read at render time, so setting them here is fine. SHOW_AWS_PROMPT
# by contrast is read when the plugin loads, so it lives in .zshrc before
# oh-my-zsh.sh is sourced.
ZSH_THEME_AWS_PROFILE_PREFIX=" ${_sexy_prep_color}(${_sexy_reset}${_sexy_dev_color}"
ZSH_THEME_AWS_PROFILE_SUFFIX="${_sexy_reset}${_sexy_prep_color})${_sexy_reset}"

# --- in-progress git operations --------------------------------------------
# oh-my-zsh has no equivalent. These are file-existence checks against the git
# dir, adding no subprocess beyond locating that directory.
# https://github.com/git/git/blob/v1.9-rc2/wt-status.c#L1199-L1241
_sexy_git_progress() {
  local git_dir out=""
  git_dir=$(command git rev-parse --git-dir 2>/dev/null) || return 0

  if [[ -f "$git_dir/MERGE_HEAD" ]]; then
    out=" [merge]"
  elif [[ -d "$git_dir/rebase-apply" ]]; then
    if [[ -f "$git_dir/rebase-apply/applying" ]]; then
      out=" [am]"
    else
      out=" [rebase]"
    fi
  elif [[ -d "$git_dir/rebase-merge" ]]; then
    out=" [rebase]"
  elif [[ -f "$git_dir/CHERRY_PICK_HEAD" ]]; then
    out=" [cherry-pick]"
  fi
  [[ -f "$git_dir/BISECT_LOG" ]]  && out+=" [bisect]"
  [[ -f "$git_dir/REVERT_HEAD" ]] && out+=" [revert]"

  [[ -n "$out" ]] && print -rn -- "${_sexy_prog_color}${out}${_sexy_reset}"
}

# kube_ps1 only exists when the kube-ps1 plugin is enabled; degrade gracefully
# so the prompt still renders if the plugin is removed.
if (( ! $+functions[kube_ps1] )); then
  kube_ps1() { :; }
fi

# --- prompt ----------------------------------------------------------------
# Single quotes matter: these substitutions are evaluated on every render, not
# once at load. %~ abbreviates $HOME to ~, %# is `%` for a normal user and `#`
# for root, and %(?.A.B) selects on the previous command's exit status.
PROMPT='${_sexy_reset}${_sexy_user_color}%n${_sexy_reset}'
PROMPT+='$(aws_prompt_info)$(kube_ps1)'
PROMPT+=' ${_sexy_prep_color}in${_sexy_reset} ${_sexy_dir_color}%~${_sexy_reset}'
PROMPT+='$(git_prompt_info)$(git_remote_status)$(_sexy_git_progress)'
PROMPT+=$'\n''%(?.%B.%B%F{red})%# ${_sexy_reset}'
