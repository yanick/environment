function __timew_prompt
    if test -z $TIMEW_TASK
        return
    end

    set_color red
    echo \U02757 " $TIMEW_TASK"
    set_color normal

end
