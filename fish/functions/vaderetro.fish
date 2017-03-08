function vaderetro 

    set lang ( basename ( readlink -f .. ) )

    set exercism ( basename ( readlink -f . ) )

    set entry \
        scalar      'src/main/scala/*.scala' \
        perl6       '*.pm' \
        javascript  '*.js' \
        ecmascript  '*.js | grep -v -e spec -e gulp' \
        ruby        '*.rb | grep -v -e test' \
        swift       '*.swift | grep -v -e main -e Test'

    exercism submit ( eval ls $entry[( math 1 + ( contains -i $lang $entry ) )] )

    emit exercism $lang $exercism

    exercism fetch $lang

end

function _vaderetro.taskwarrior --on-event exercism

    task +$argv[1] project:exercism progress $argv[2]

end

function _vaderetro.brag --on-event exercism

    if test $argv[1] = swift
        echo "yanick exorcised '$argv[2]'" | slacker -c swift -n exercism -i :imp: 
    end

    if test $argv[1] = ecmascript
        echo "yanick exorcised '$argv[2]'" | slacker -c node -n exercism -i :imp: 
    end

    echo "yanick exorcised '$argv[1]/$argv[2]'" | slacker -c projecteuler -n exercism -i :imp: 
end
