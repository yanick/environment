function manode -d "convert a node_modules README into html"

    set -l path "node_modules/$argv"

    if test ! -d $path 
        echo "no directory $path found"
        return
    end 

    set -l readme ( eval ls "$path"/README*.m*d )

    if test (count readme) -ne 1
        echo "didn't find a README"
    end 

    # set -l html_file ( perl -E"say '$readme' =~ s/(.*)\.m.*?d\$/\$1.html/r" )

    if test ! -d $path/manode
        # pandoc $readme -o $html_file 

        # you'll need npm install -g markdown-styles
        generate-md --layout github --input $path --output $path/manode
    end 

    xdg-open $path/manode/README.html

end
