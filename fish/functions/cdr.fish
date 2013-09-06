function cdr
	
set -l repo_dir ( perl -MPath::Tiny \
    -E'$x = path(".")->absolute; while(1){ exit say $x if $x->child(".git")->is_dir; exit if $x eq "/"; $x = $x->parent }' )

if [ $repo_dir != "" ] 
    cd $repo_dir
else
    echo "not in a git repo"
end

end
