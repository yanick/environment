function __task.prompt
    if test -z "$TW_CURRENT"
        return
    end

    set task ( task $TW_CURRENT export \
        | jq -r '.[0]|.description,.start,.id,.project?' )

    set since ( echo $task[2] |  perl -pe's/(\d{4})(\d\d)(\d\d)T(\d\d)(\d\d)(\d\d)/$1-$2-$3T$4:$5:$6/' )
    set spent ( task calc now - $since | perl -pe's/^PT|\d+S//g' )

    set chrono \U1F567 \U1F550 \U1F55C \U1F551 \U1F55D \U1F552 \U1F55E \U1F553 \U1F55F \U1F554 \U1F560 \U1F555 \U1F561 \U1F556 \U1F562 \U1F557 \U1F563 \U1F558 \U1F564 \U1F559 \U1F565 \U1F55A \U1F566 \U1F55B 

    set spent_index ( echo $spent | \
        perl -pe's!H?(\d+)M!+ ($1/60)!; $_ = int 2* ( 0.5 + eval % 12 )' 
    )

    set_color EFB170
    echo -n ( date -d $since +%H:%M )
    set_color 1B586C
    echo -n -s $chrono[$spent_index] ' '
    set_color EFB170
    echo -n $spent
    if not test "$task[4]" = "null"
        set_color 498295
        echo -n '' $task[4] '-'
    end
    set_color 094254
    echo -s ' '  $task[3] ' ' $task[1]
    set_color normal

end
