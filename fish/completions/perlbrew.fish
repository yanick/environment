function __fish_perlbrew_needs_command
  set cmd (commandline -opc)
  if [ (count $cmd) -eq 1 -a $cmd[1] = 'perlbrew' ]
    return 0
  end
  return 1
end

function __fish_perlbrew_using_command
  set cmd (commandline -opc)
  if [ (count $cmd) -gt 1 ]
    if [ $argv[1] = $cmd[2] ]
      return 0
    end
  end
end

for com in (perlbrew help | perl -ne'print lc if s/^COMMAND:\s+//') 
    complete -f -c perlbrew -n '__fish_perlbrew_needs_command' -a $com 
end

complete -f -c perlbrew -n '__fish_perlbrew_using_command switch' \
    -a '(perlbrew list | perl -pe\'s/\*?\s*(\S+).*/$1/\')'

