# name: bobthefish
#
# bobthefish is a Powerline-style, Git-aware fish theme optimized for awesome.
#
# You will probably need a Powerline-patched font for this to work:
#
#     https://powerline.readthedocs.org/en/latest/fontpatching.html
#
# I recommend picking one of these:
#
#     https://github.com/Lokaltog/powerline-fonts
#
# You can override some default options in your config.fish:
#
#     set -g theme_display_user yes
#     set -g default_user your_normal_user

set -g current_bg NONE

# Powerline glyphs
set branch_glyph            \uE0A0
set ln_glyph                \uE0A1
set padlock_glyph           \uE0A2
set right_black_arrow_glyph \uE0B0
set right_arrow_glyph       \uE0B1
set left_black_arrow_glyph  \uE0B2
set left_arrow_glyph        \uE0B3

# Additional glyphs
set detached_glyph          \u27A6
set nonzero_exit_glyph      '! '
set superuser_glyph         '$ '
set bg_job_glyph            '% '

# Colors
set lt_green   addc10
set med_green  189303
set dk_green   0c4801

set lt_red     C99
set med_red    ce000f
set dk_red     600

set slate_blue 255e87

set lt_orange  f6b117
set dk_orange  3a2a03

set dk_grey    333
set med_grey   999
set lt_grey    ccc

set cyan       008787

# ===========================
# Helper methods
# ===========================

function __bobthefish_in_git
  command git rev-parse --is-inside-work-tree >/dev/null 2>&1
end

function __bobthefish_git_branch
  set -l ref (command git symbolic-ref HEAD 2> /dev/null)
  if [ $status -gt 0 ]
    set -l branch (command git show-ref --head -s --abbrev |head -n1 2> /dev/null)
    set ref "$detached_glyph $branch"
  end
  echo $ref | sed  "s-refs/heads/-$branch_glyph -"
end

function __bobthefish_pretty_parent -d 'Print a parent directory, shortened to fit the prompt'
  echo -n (dirname $argv[1]) | sed -e 's|/private||' -e "s|^$HOME|~|" -e 's-/\(\.\{0,1\}[^/]\)\([^/]*\)-/\1-g' -e 's|/$||'
end

function __bobthefish_project_dir -d 'Print the current git project base directory'
  command git rev-parse --show-toplevel 2>/dev/null
end

function __bobthefish_project_pwd -d 'Print the working directory relative to project root'
  set -l base_dir (__bobthefish_project_dir)
  echo "$PWD" | sed -e "s*$base_dir**g" -e 's*^/**'
end


# ===========================
# Segment functions
# ===========================

function __yanick_start_segment -d 'Start a segment'

  if test (count $argv ) -eq 1
    set argv $argv[1] normal
  end

  set_color -b $argv[2]
  set_color $argv[1]
  if [ "$current_bg" = 'NONE' ]
    # do nuthin
  else
    echo -n ' '
  end
  set current_bg $argv[2]
end

function __bobthefish_start_segment -d 'Start a segment'
  set_color -b $argv[1]
  set_color $argv[2]
  if [ "$current_bg" = 'NONE' ]
    # If there's no background, just start one
    echo -n ' '
  else
    # If there's already a background...
    if [ "$argv[1]" = "$current_bg" ]
      # and it's the same color, draw a separator
      echo -n "$right_arrow_glyph "
    else
      # otherwise, draw the end of the previous segment and the start of the next
      set_color $current_bg
      echo -n "$right_black_arrow_glyph "
      set_color $argv[2]
    end
  end
  set current_bg $argv[1]
end

function __bobthefish_path_segment -d 'Display a shortened form of a directory'
  if test -w "$argv[1]"
    __yanick_start_segment $fish_color_cwd
  else
    __yanick_start_segment $lt_red
  end

  set -l directory
  set -l parent

  switch "$argv[1]"
    case /
      set directory '/'
    case "$HOME"
      set directory '~'
    case '*'
      set parent    (__bobthefish_pretty_parent "$argv[1]")
      set parent    "$parent/"
      set directory (basename "$argv[1]")
  end

  test "$parent"; and echo -n -s "$parent"
  set_color $fish_color_cwd --bold
  echo -n "$directory "
  set_color normal
end

function __bobthefish_finish_segments -d 'Close open segments'
  if [ -n $current_bg -a $current_bg != 'NONE' ]
    set_color -b normal
    set_color $current_bg
    set_color normal
  end
  set -g current_bg NONE
end


# ===========================
# Theme components
# ===========================

function __bobthefish_prompt_status -d 'the symbols for a non zero exit status, root and background jobs'
  set -l nonzero
  set -l superuser
  set -l bg_jobs

  # Last exit was nonzero
  if [ $RETVAL -ne 0 ]
    set nonzero $nonzero_exit_glyph
  end

  # if superuser (uid == 0)
  set -l uid (id -u $USER)
  if [ $uid -eq 0 ]
    set superuser $superuser_glyph
  end

  # Jobs display
  if [ (jobs -l | wc -l) -gt 0 ]
    set bg_jobs $bg_job_glyph
  end

  set -l status_flags "$nonzero$superuser$bg_jobs"

  if test "$nonzero" -o "$superuser" -o "$bg_jobs"
    __bobthefish_start_segment fff 000
    if [ "$nonzero" ]
      set_color $med_red --bold
      echo -n $nonzero_exit_glyph
    end

    if [ "$superuser" ]
      set_color $med_green --bold
      echo -n $superuser_glyph
    end

    if [ "$bg_jobs" ]
      set_color $slate_blue --bold
      echo -n $bg_job_glyph
    end
  end
end

function __bobthefish_prompt_user -d 'Display actual user if different from $default_user'
  if [ "$theme_display_user" = 'yes' ]
    if [ "$USER" != "$default_user" -o -n "$SSH_CLIENT" ]
      __bobthefish_start_segment $lt_grey $slate_blue
      echo -n -s (whoami) '@' (hostname | cut -d . -f 1) ' '
    end
  end
end

function __yanick_prompt_git -d 'Display the actual git state'
  set -l dirty   (command git diff --no-ext-diff --quiet --exit-code; or echo -n \u2623)
  set -l staged  (command git diff --cached --no-ext-diff --quiet --exit-code; or echo -n \u2766)
  set -l stashed (command git rev-parse --verify refs/stash > /dev/null 2>&1; and echo -n \u2692)
  set -l ahead   (command git branch -v 2> /dev/null | grep -Eo '^\* [^ ]* *[^ ]* *\[[^]]*\]' | grep -Eo '\[[^]]*\]$' | awk 'ORS="";/ahead/ {print "+"} /behind/ {print "-"}' | sed -e 's/+-/±/')

  set -l new (command git ls-files --other --exclude-standard);
  test "$new"; and set new '…'

  set -l flags   "$stashed$ahead$dirty$staged$new"
  test "$flags"; and set flags " $flags"

  set -l flag_bg $lt_green
  set -l flag_fg $dk_green
  if test "$dirty" -o "$staged"
    set flag_bg $med_red
    set flag_fg $lt_red
  else
    if test "$stashed"
      set flag_bg $lt_orange
      set flag_fg $dk_orange
    end
  end

  __bobthefish_path_segment (__bobthefish_project_dir)

  __yanick_start_segment $flag_fg
  set_color $flag_fg --bold
  echo -n -s (__bobthefish_git_branch) $flags ' '
  set_color normal

  set -l project_pwd  (__bobthefish_project_pwd)
  if test "$project_pwd"
    if test -w "$PWD"
      __yanick_start_segment $fish_color_cwd
    else
      __yanick_start_segment $lt_red
    end

    echo -n -s $project_pwd
  end
end

# TODO: clean up the fugly $ahead business
function __bobthefish_prompt_git -d 'Display the actual git state'
  set -l dirty   (command git diff --no-ext-diff --quiet --exit-code; or echo -n '*')
  set -l staged  (command git diff --cached --no-ext-diff --quiet --exit-code; or echo -n '~')
  set -l stashed (command git rev-parse --verify refs/stash > /dev/null 2>&1; and echo -n '$')
  set -l ahead   (command git branch -v 2> /dev/null | grep -Eo '^\* [^ ]* *[^ ]* *\[[^]]*\]' | grep -Eo '\[[^]]*\]$' | awk 'ORS="";/ahead/ {print "+"} /behind/ {print "-"}' | sed -e 's/+-/±/')

  set -l new (command git ls-files --other --exclude-standard);
  test "$new"; and set new '…'

  set -l flags   "$dirty$staged$stashed$ahead$new"
  test "$flags"; and set flags " $flags"

  set -l flag_bg $lt_green
  set -l flag_fg $dk_green
  if test "$dirty" -o "$staged"
    set flag_bg $med_red
    set flag_fg $dk_orange
  else
    if test "$stashed"
      set flag_bg $lt_orange
      set flag_fg $dk_orange
    end
  end

  __bobthefish_path_segment (__bobthefish_project_dir)

  __yanick_start_segment $flag_fg
  echo '>>>' $flag_fg
  set_color $flag_fg --bold
  echo -n -s (__bobthefish_git_branch) $flags ' '
  set_color normal

  set -l project_pwd  (__bobthefish_project_pwd)
  if test "$project_pwd"
    if test -w "$PWD"
      __bobthefish_start_segment 333 999
    else
      __bobthefish_start_segment $med_red $lt_red
    end

    echo -n -s $project_pwd ' '
  end
end

function __bobthefish_prompt_dir -d 'Display a shortened form of the current directory'
  __bobthefish_path_segment "$PWD"
end

function __yanick_prompt_current_time -d "Display the current time"
    __yanick_start_segment $cyan
    echo -n (date +%H:%M)
end

function __yanick_prompt_user -d "Display the current user"
    __yanick_start_segment $fish_color_user
    echo -n $USER
    set_color normal
    echo -n @
    set_color $fish_color_host

    if not set -q __fish_prompt_hostname
        set -g __fish_prompt_hostname (hostname|cut -d . -f 1)
    end
    echo -n $__fish_prompt_hostname

end

function __yanick_prompt_dir -d "Display the current directory"
    __yanick_start_segment $fish_color_cwd
    echo -n ( prompt_pwd )
end

function __yanick_prompt_status
    __yanick_start_segment $dk_red

	if test $last_status -ne 0
        set _bad_status_sign \u2639" "
        echo -n $_bad_status_sign
    end

  if [ (jobs -l | wc -l) -gt 0 ]
    echo -n \u2699" "
  end

end

function __yanick_prompt_sigil
    switch $USER
    case root
        __yanick_start_segment $lt_red
        echo -n "# "
    case '*'
        __yanick_start_segment $med_grey
        echo -n "\$ "
    end
end

function __prompt_pwd 
    set -l color_major green
    set -l color_minor 005f00

    set -l pwd $PWD

    set -l git_root ( git rev-parse --show-toplevel )

    set pwd ( echo $pwd | sed s:$HOME:~: )
    set git_root ( echo $git_root | sed s:$HOME:~: )

    if test -z $git_root
        set_color $color_major
        echo -n $pwd
        set_color normal
    end

    set -l len ( echo $git_root | wc -c | tr -d ' ')
    set pwd ( echo $pwd | cut -c {$len}- )

    set_color $color_minor
    echo -n $git_root
    set_color $color_major
    echo -n $pwd
    set_color normal

end

# ===========================
# Apply theme
# ===========================

# what I want:
# 12:35 yanick@enkidu % :-( ~/path/to/here [git stuff]
# $|#

function fish_prompt
    set -g last_status $status
  echo ""
  __yanick_prompt_current_time
  __yanick_prompt_user
  __yanick_prompt_status
  #__bobthefish_prompt_dir

  __prompt_pwd
 
   echo ""
   git prompt

  __bobthefish_finish_segments
  __yanick_prompt_sigil
  __bobthefish_finish_segments
end
