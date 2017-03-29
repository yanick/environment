function perl-autoinstall

    set deps dummy

    while true;
        set prev_deps $deps

        set output ( perl $argv 2>&1 )
        echo $output

        set deps ( echo $output | perl -nE'say $1 if /you may need to install the (\S+) module/' )

        if test -z $deps
            break
        end

        if test $deps = $prev_deps
            echo "dependencies didn't change"
            break
        end

        echo $deps | cpanm -n
    end;


end
