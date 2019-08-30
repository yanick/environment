
# after each call to timewarrior, update TIMEW_TASK with
# the current task (if any)
function after_timew -e fish_postexec
    echo $argv | grep -q "^timew "

    if test $status -ne 0
        return
    end

    set -x -U TIMEW_TASK ( timew export now | jq -r '.[].tags | join( ", " )' )
end
