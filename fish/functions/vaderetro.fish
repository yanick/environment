function vaderetro 

    set lang ( basename ( readlink -f .. ) )

    set entry \
        scalar      'src/main/scala/*.scala' \
        perl6       '*.pm' \
        javascript  '*.js' \
        swift       '*.swift | grep -v -e main -e Test'

    exercism submit ( eval ls $entry[( math 1 + ( contains -i $lang $entry ) )] )

    exercism fetch $lang

end
