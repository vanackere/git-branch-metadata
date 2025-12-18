#!/bin/bash

_git_branch_metadata() {
    local cur words cword
    _init_completion || return

    local commands="set get show unset delete history list keys push fetch unescape help"
    local command=${words[2]}

    case "$cword" in
    2)
        mapfile -t COMPREPLY < <(compgen -W "$commands" -- "$cur")
        ;;
    3)
        # Position right after command
        case "$command" in
        set|delete|show)
            if [[ "$cur" == -* ]]; then
                # Completing a flag
                mapfile -t COMPREPLY < <(compgen -W "-r --remote" -- "$cur")
            else
                # Complete branches that have metadata
                local branches
                branches=$(git branch-metadata list 2>/dev/null)
                mapfile -t COMPREPLY < <(compgen -W "$branches" -- "$cur")
            fi
            ;;
        get|unset)
            if [[ "$cur" == -* ]]; then
                # Completing a flag
                mapfile -t COMPREPLY < <(compgen -W "-r --remote" -- "$cur")
            else
                # Complete branches that have metadata
                local branches
                branches=$(git branch-metadata list 2>/dev/null)
                mapfile -t COMPREPLY < <(compgen -W "$branches" -- "$cur")
            fi
            ;;
        history)
            if [[ "$cur" == -* ]]; then
                # Completing a flag
                mapfile -t COMPREPLY < <(compgen -W "-r --remote" -- "$cur")
            else
                # Complete branches that have metadata
                local branches
                branches=$(git branch-metadata list 2>/dev/null)
                mapfile -t COMPREPLY < <(compgen -W "$branches" -- "$cur")
            fi
            ;;
        list)
            if [[ "$cur" == -* ]]; then
                # Only -r/--remote flag
                mapfile -t COMPREPLY < <(compgen -W "-r --remote" -- "$cur")
            fi
            ;;
        keys)
            if [[ "$cur" == -* ]]; then
                # Completing a flag
                mapfile -t COMPREPLY < <(compgen -W "-r --remote" -- "$cur")
            else
                # Complete branches that have metadata
                local branches
                branches=$(git branch-metadata list 2>/dev/null)
                mapfile -t COMPREPLY < <(compgen -W "$branches" -- "$cur")
            fi
            ;;
        push)
            # Complete remote names
            local remotes
            remotes=$(__git_remotes)
            mapfile -t COMPREPLY < <(compgen -W "$remotes" -- "$cur")
            ;;
        fetch)
            if [[ "$cur" == -* ]]; then
                # Completing a flag
                mapfile -t COMPREPLY < <(compgen -W "--force -f" -- "$cur")
            else
                # Complete remote names
                local remotes
                remotes=$(__git_remotes)
                mapfile -t COMPREPLY < <(compgen -W "$remotes" -- "$cur")
            fi
            ;;
        esac
        ;;
    *)
        # Position 4+
        case "$command" in
        set|delete|show)
            # Check if -r/--remote flag is at position 3
            if [[ "${words[3]}" == "-r" ]] || [[ "${words[3]}" == "--remote" ]]; then
                if [[ "$cword" -eq 4 ]]; then
                    # Complete remote name after -r/--remote
                    local remotes
                    remotes=$(__git_remotes)
                    mapfile -t COMPREPLY < <(compgen -W "$remotes" -- "$cur")
                elif [[ "$cword" -eq 5 ]]; then
                    # Complete branch name from remote
                    local remote_name="${words[4]}"
                    local branches
                    branches=$(git branch-metadata list -r "$remote_name" 2>/dev/null)
                    mapfile -t COMPREPLY < <(compgen -W "$branches" -- "$cur")
                fi
                # No further completion for set/delete/show
            else
                # No remote flag - no further completion needed
                COMPREPLY=()
            fi
            ;;
        get|unset)
            # get/unset: <branch> <key> OR -r <remote> <branch> <key>
            if [[ "${words[3]}" == "-r" ]] || [[ "${words[3]}" == "--remote" ]]; then
                if [[ "$cword" -eq 4 ]]; then
                    # Complete remote name
                    local remotes
                    remotes=$(__git_remotes)
                    mapfile -t COMPREPLY < <(compgen -W "$remotes" -- "$cur")
                elif [[ "$cword" -eq 5 ]]; then
                    # Complete branch name from remote
                    local remote_name="${words[4]}"
                    local branches
                    branches=$(git branch-metadata list -r "$remote_name" 2>/dev/null)
                    mapfile -t COMPREPLY < <(compgen -W "$branches" -- "$cur")
                elif [[ "$cword" -eq 6 ]]; then
                    # Complete key name from remote branch
                    local remote_name="${words[4]}"
                    local branch_name="${words[5]}"
                    local keys
                    keys=$(git branch-metadata keys -r "$remote_name" "$branch_name" 2>/dev/null)
                    mapfile -t COMPREPLY < <(compgen -W "$keys" -- "$cur")
                fi
            else
                # No remote flag: branch at position 3, key at position 4
                if [[ "$cword" -eq 4 ]]; then
                    # Complete key name from local branch
                    local branch_name="${words[3]}"
                    local keys
                    keys=$(git branch-metadata keys "$branch_name" 2>/dev/null)
                    mapfile -t COMPREPLY < <(compgen -W "$keys" -- "$cur")
                fi
            fi
            ;;
        history)
            # history: <branch> [max_count] OR -r <remote> <branch> [max_count]
            if [[ "${words[3]}" == "-r" ]] || [[ "${words[3]}" == "--remote" ]]; then
                if [[ "$cword" -eq 4 ]]; then
                    # Complete remote name
                    local remotes
                    remotes=$(__git_remotes)
                    mapfile -t COMPREPLY < <(compgen -W "$remotes" -- "$cur")
                elif [[ "$cword" -eq 5 ]]; then
                    # Complete branch name from remote
                    local remote_name="${words[4]}"
                    local branches
                    branches=$(git branch-metadata list -r "$remote_name" 2>/dev/null)
                    mapfile -t COMPREPLY < <(compgen -W "$branches" -- "$cur")
                fi
                # Position 6 would be max_count (numeric), no completion
            else
                # No remote flag - no completion at position 4 (would be max_count)
                COMPREPLY=()
            fi
            ;;
        list)
            # list only accepts -r <remote>, nothing after remote name
            if [[ "${words[3]}" == "-r" ]] || [[ "${words[3]}" == "--remote" ]]; then
                if [[ "$cword" -eq 4 ]]; then
                    # Complete remote name after -r/--remote
                    local remotes
                    remotes=$(__git_remotes)
                    mapfile -t COMPREPLY < <(compgen -W "$remotes" -- "$cur")
                fi
                # No completion after remote name for list command
            fi
            ;;
        keys)
            # keys: <branch> OR -r <remote> <branch>
            if [[ "${words[3]}" == "-r" ]] || [[ "${words[3]}" == "--remote" ]]; then
                if [[ "$cword" -eq 4 ]]; then
                    # Complete remote name
                    local remotes
                    remotes=$(__git_remotes)
                    mapfile -t COMPREPLY < <(compgen -W "$remotes" -- "$cur")
                elif [[ "$cword" -eq 5 ]]; then
                    # Complete branch name from remote
                    local remote_name="${words[4]}"
                    local branches
                    branches=$(git branch-metadata list -r "$remote_name" 2>/dev/null)
                    mapfile -t COMPREPLY < <(compgen -W "$branches" -- "$cur")
                fi
                # No completion after branch name
            else
                # No remote flag - no completion after branch name
                COMPREPLY=()
            fi
            ;;
        push)
            # push: <remote> <branch>
            if [[ "$cword" -eq 4 ]]; then
                # Complete branch names that have metadata
                local branches
                branches=$(git branch-metadata list 2>/dev/null)
                mapfile -t COMPREPLY < <(compgen -W "$branches" -- "$cur")
            fi
            # No completion after branch name
            ;;
        fetch)
            # fetch: [--force] <remote> <branch>
            if [[ "${words[3]}" == "--force" ]] || [[ "${words[3]}" == "-f" ]]; then
                # --force flag at position 3
                if [[ "$cword" -eq 4 ]]; then
                    # Complete remote name after --force
                    local remotes
                    remotes=$(__git_remotes)
                    mapfile -t COMPREPLY < <(compgen -W "$remotes" -- "$cur")
                elif [[ "$cword" -eq 5 ]]; then
                    # Complete branch name
                    local branches
                    branches=$(git branch-metadata list 2>/dev/null)
                    mapfile -t COMPREPLY < <(compgen -W "$branches" -- "$cur")
                fi
            else
                # No --force flag
                if [[ "$cword" -eq 4 ]]; then
                    # Complete branch names that have metadata
                    local branches
                    branches=$(git branch-metadata list 2>/dev/null)
                    mapfile -t COMPREPLY < <(compgen -W "$branches" -- "$cur")
                fi
            fi
            # No completion after branch name
            ;;
        esac
        ;;
    esac
}
