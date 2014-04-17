function echo_success 
    eval $argv
    set -l st $status
    echo ( math ! $status )
    return $st
end

function echo_test
    echo_success test $argv
end

function test_boolean
    set -l value $argv[1]

    if test $value = "" -o $value = "0" -o $value = "false"
        return 0
    end

    return 1
end

function show_all_symbols
    # final line
    echo  $is_a_git_repo_symbol $has_stashes_symbol $has_untracked_files_symbol \
        $has_adds_symbol $has_deletions_symbol $has_deletions_cached_symbol \
        $has_modifications_symbol $has_modifications_cached_symbol \
        $ready_to_commit_symbol $detached_symbol $has_upstream_symbol \
        detached -1 $rebase_tracking_branch_symbol $merge_tracking_branch_symbol \
        +1 $can_fast_forward_symbol $should_push_symbol +3 \
        '(' $current_branch $type_of_upstream $upstream ')' \
        $is_on_a_tag_symbol 'tag'
end

function enrich 
    set -l flag $argv[1]
    set -l symbol $argv[2]
    if test (count $argv) -eq 3;
        set_color $argv[3]
    else
        set_color normal
    end

    if test $flag = false -o $flag -eq 0
        set symbol (printf "%"(echo $symbol | wc -c )"s")
    end

    echo -n $symbol
    set_color normal
    set_color -b normal
end

function git_prompt
    # Symbols
    set -l is_a_git_repo_symbol ' ' #' ' # '❤ '  ±
    set -l has_untracked_files_symbol '∿ '
    set -l has_adds_symbol '+ '
    set -l has_deletions_symbol '- '
    set -l has_deletions_cached_symbol '✖ '
    set -l has_modifications_symbol '✎ '
    set -l has_modifications_cached_symbol '☲ '
    set -l ready_to_commit_symbol '▪► ' #'→ '▬►
    set -l is_on_a_tag_symbol ' ' #⌫ '
    set -l needs_to_merge_symbol  ' '# 'ᄉ '
    set -l has_upstream_symbol ( printf "\uf201 " ) # ' ' #  ' # '⇅ '
    set -l detached_symbol '⚯  '
    set -l can_fast_forward_symbol '» '  
    set -l has_diverged_symbol 'Ⴤ '
    set -l rebase_tracking_branch_symbol '↶ '
    set -l merge_tracking_branch_symbol ' ' # 'λ ' # 'ᄉ '
    set -l should_push_symbol '↑ '
    set -l has_stashes_symbol '★ '

        # Flags
    set -l display_has_upstream true
    set -l display_tag false
    set -l display_tag_name true
    set -l two_lines true
    set -l use_color_off false

        # Colors
    set -l on "\[\033[1;37m\]"
    set -l off black #"\[\033[0m\]"
    set -l red red #'(set_color red)' #"\[\033[0;31m\]"
    set -l green green  #"\[\033[0;32m\]"
    set -l yellow yellow # "\[\033[1;33m\]"
    set -l violet purple  # "\[\033[0;35m\]"
    set -l branch_color brown  # "\[\033[1;34m\]"
    set -l reset  "\[\033[0m\]"

    set -l color_okay    green
    set -l color_todo    yellow
    set -l color_achtung red

    # Git info
    set current_commit_hash (git rev-parse HEAD 2> /dev/null)

    if test -z "$current_commit_hash"
        return
    end

    set current_branch (git rev-parse --abbrev-ref HEAD 2> /dev/null | tr -d ' ')

    set detached ( echo_test "$current_branch" = 'HEAD' )

    set number_of_logs (git log --pretty=oneline -n1 2> /dev/null | wc -l)

    if test "$number_of_logs" -eq 0
        set just_init true
    else
        set upstream (git rev-parse --symbolic-full-name --abbrev-ref @\{upstream\} 2> /dev/null)

        set has_upstream ( echo_test -n "$upstream" -a "$upstream" != @upstream )

        set git_status (git status --porcelain 2> /dev/null)
    
        set has_modifications false
        for s in $git_status
            if echo $s | grep -q -E '^.M'
                set has_modifications true
                break
            end
        end
    
        set has_modifications_cached 0
        for s in $git_status
            if echo $s | grep -q -E '^M'
                set has_modifications_cached true
                break
            end
        end

        set has_adds 0 
        for s in $git_status
            if echo $s | grep -q -E '^A'
                set has_adds true
                break
            end
        end
    
        set has_deletions ( echo_success "echo $git_status | grep -q -E '(\n|^).D'" )

        set has_deletions_cached ( echo_success "echo $git_status | grep -q -E '(\n|^)D'" )

        if begin
                echo $git_status | grep -q -E '(\n|^)[MAD]'; 
                and not echo $git_status | grep -q -E '(\n|^).[MAD?]';
            end;
            set ready_to_commit 1
        else
            set ready_to_commit 0
        end
    
    
        set number_of_untracked_files (echo $git_status | grep -c "^??")

        set has_untracked_files ( echo_test "$number_of_untracked_files" -gt 0 )
    
        set tag_at_current_commit (git describe --exact-match --tags $current_commit_hash 2> /dev/null)
        set is_on_a_tag ( echo_test -n $tag_at_current_commit )
    
        set has_diverged false
        set can_fast_forward false

        set commits_ahead 0
        set commits_behind 0
        if test $has_upstream -gt 0
            set commits_diff (git log --pretty=oneline --topo-order --left-right {$current_commit_hash}...{$upstream} 2> /dev/null)
            set commits_ahead (echo $commits_diff | grep -c "^<" )
            set commits_behind ( echo $commits_diff | grep -c "^>")
        end

        if test $commits_ahead -gt 0 -a $commits_behind -gt 0 
            set has_diverged true
        end

        if test $commits_ahead -eq 0 -a $commits_behind -gt 0
            set can_fast_forward true
        end
    
        set will_rebase (git config --get branch.$current_branch.rebase 2> /dev/null)
        echo $will_rebase
    
        set git_dir (git rev-parse --show-toplevel)
        set stash_file = $git_dir/refs/stash
        if test -f $stash_file
            set number_of_stashes (wc -l 2> /dev/null < $stash_file )
        else
            set number_of_stashes 0
        end

        if test $number_of_stashes -gt 0
            set has_stashes true
        else 
            set has_stashes false
        end
    end
    
    enrich true $is_a_git_repo_symbol
    enrich $has_stashes $has_stashes_symbol $yellow
    enrich $has_untracked_files $has_untracked_files_symbol $red
    enrich $has_adds $has_adds_symbol $yellow

    enrich $has_deletions $has_deletions_symbol $red
    enrich $has_deletions_cached $has_deletions_cached_symbol $yellow

    enrich $has_modifications $has_modifications_symbol $red
    enrich $has_modifications_cached $has_modifications_cached_symbol $yellow
    enrich $ready_to_commit $ready_to_commit_symbol $green
    
    enrich $detached "$detached_symbol" $red
    
    if test $display_has_upstream = true
        enrich $has_upstream $has_upstream_symbol
    end

    if test $detached = true
        if test $just_init = true
            enrich true 'detached' $red
        else
            enrich true $current_commit_hash
        end
    else
        if test $has_upstream -gt 0
            if test "$will_rebase" -gt 0
                set type_of_upstream $rebase_tracking_branch_symbol
            else
                set type_of_upstream $merge_tracking_branch_symbol
            end

            if test $has_diverged -gt 0
                echo -n " -$commits_behind $has_diverged_symbol +$commits_ahead"
            else
                if test $commits_behind -gt 0
                    echo -n " -$commits_behind $can_fast_forward_symbol "
                end
                if test $commits_ahead -gt 0
                    echo -n " $should_push_symbol +$commits_ahead "
                end
            end

            enrich true "$current_branch" $green

            set upstream ( echo $upstream | sed s/\\/$current_branch// )
            set upstream ( echo $upstream | sed "s/github/ /" )
            if test $upstream = 'github'
             #   set upstream '  '
            end

            enrich true " $type_of_upstream$upstream"
        else
            enrich true "$current_branch" $green
        end
    end

    if test "$display_tag" = true
        enrich true "$is_on_a_tag_symbol $tag_at_current_commit" $green
    end

end
