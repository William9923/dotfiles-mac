# Default OMZ theme for Archcraft

NEWLINE=$'\n'

if [[ "$USER" == "root" ]]; then
  PROMPT="%(?:%{$fg_bold[red]%}%{$fg_bold[yellow]%}%{$fg_bold[red]%} :%{$fg_bold[red]%} )"
  PROMPT+='%{$fg[cyan]%} %~%{$reset_color%} $(git_prompt_info)%{$fg[cyan]%}${NEWLINE} ➜%{$reset_color%} '
else
  PROMPT="%(?:%{$fg_bold[red]%}%{$fg_bold[green]%}%{$fg_bold[yellow]%} :%{$fg_bold[red]%} )"
  PROMPT+='%{$fg[cyan]%} %~%{$reset_color%} $(git_prompt_info)%{$fg[cyan]%}${NEWLINE} ➜%{$reset_color%} '
fi

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}  git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"

#Adds the new line and ➜ as the start character.
printf "\n ➜";
