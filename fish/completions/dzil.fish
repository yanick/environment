eval (dzil help | perl -ne'print qq{complete -c dzil -a $1 -f -d \"$2\";\n} if /(\w+):\s+(.*?)\s+$/')
