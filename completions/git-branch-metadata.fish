# Fish shell completion for git-branch-metadata
# Install to: ~/.config/fish/completions/git-branch-metadata.fish

# Disable file completion by default
complete -c git-branch-metadata -f

# Helper function to get list of branches with metadata
function __fish_git_branch_metadata_branches
    git branch-metadata list 2>/dev/null
end

# Helper function to get list of branches with metadata from remote
function __fish_git_branch_metadata_remote_branches
    set -l cmd (commandline -opc)
    set -l remote_idx (contains -i -- -r $cmd; or contains -i -- --remote $cmd)
    if test -n "$remote_idx"
        set -l remote $cmd[(math $remote_idx + 1)]
        git branch-metadata list -r $remote 2>/dev/null
    end
end

# Helper function to get keys for a branch
function __fish_git_branch_metadata_keys
    set -l cmd (commandline -opc)
    # Check if -r/--remote is used
    set -l remote_idx (contains -i -- -r $cmd; or contains -i -- --remote $cmd)
    if test -n "$remote_idx"
        set -l remote $cmd[(math $remote_idx + 1)]
        set -l branch $cmd[(math $remote_idx + 2)]
        if test -n "$branch"
            git branch-metadata keys -r $remote $branch 2>/dev/null
        end
    else
        # Local branch
        set -l branch $cmd[3]
        if test -n "$branch"
            git branch-metadata keys $branch 2>/dev/null
        end
    end
end

# Helper function to get git remotes
function __fish_git_branch_metadata_remotes
    git remote 2>/dev/null
end

# Helper function to check if -r/--remote flag is present
function __fish_git_branch_metadata_using_remote
    set -l cmd (commandline -opc)
    contains -- -r $cmd; or contains -- --remote $cmd
end

# Helper function to check if --force flag is present
function __fish_git_branch_metadata_using_force
    set -l cmd (commandline -opc)
    contains -- --force $cmd; or contains -- -f $cmd
end

# Main commands
complete -c git-branch-metadata -n "__fish_use_subcommand" -a "set" -d "Set metadata for a branch"
complete -c git-branch-metadata -n "__fish_use_subcommand" -a "get" -d "Get metadata value for a branch"
complete -c git-branch-metadata -n "__fish_use_subcommand" -a "show" -d "Show all metadata for a branch"
complete -c git-branch-metadata -n "__fish_use_subcommand" -a "unset" -d "Remove a key from branch metadata"
complete -c git-branch-metadata -n "__fish_use_subcommand" -a "delete" -d "Delete all metadata for a branch"
complete -c git-branch-metadata -n "__fish_use_subcommand" -a "history" -d "Show metadata change history"
complete -c git-branch-metadata -n "__fish_use_subcommand" -a "list" -d "List branches with metadata"
complete -c git-branch-metadata -n "__fish_use_subcommand" -a "keys" -d "List keys for a branch"
complete -c git-branch-metadata -n "__fish_use_subcommand" -a "push" -d "Push metadata to remote"
complete -c git-branch-metadata -n "__fish_use_subcommand" -a "fetch" -d "Fetch metadata from remote"
complete -c git-branch-metadata -n "__fish_use_subcommand" -a "unescape" -d "Decode an encoded value"
complete -c git-branch-metadata -n "__fish_use_subcommand" -a "help" -d "Show help message"

# Remote flag for commands that support it
complete -c git-branch-metadata -n "__fish_seen_subcommand_from set get show unset delete history list keys" -s r -l remote -d "Operate on remote" -f
complete -c git-branch-metadata -n "__fish_seen_subcommand_from set get show unset delete history list keys; and __fish_seen_subcommand_from -r --remote" -a "(__fish_git_branch_metadata_remotes)" -d "Remote name"

# Force flag for fetch
complete -c git-branch-metadata -n "__fish_seen_subcommand_from fetch" -s f -l force -d "Force overwrite local metadata"

# Completions for 'set' command
complete -c git-branch-metadata -n "__fish_seen_subcommand_from set; and not __fish_git_branch_metadata_using_remote" -a "(__fish_git_branch_metadata_branches)" -d "Branch name"

# Completions for 'get' command
complete -c git-branch-metadata -n "__fish_seen_subcommand_from get; and not __fish_git_branch_metadata_using_remote" -a "(__fish_git_branch_metadata_branches)" -d "Branch name"
complete -c git-branch-metadata -n "__fish_seen_subcommand_from get; and not __fish_git_branch_metadata_using_remote" -a "(__fish_git_branch_metadata_keys)" -d "Key name"

# Completions for 'show' command
complete -c git-branch-metadata -n "__fish_seen_subcommand_from show; and not __fish_git_branch_metadata_using_remote" -a "(__fish_git_branch_metadata_branches)" -d "Branch name"

# Completions for 'unset' command
complete -c git-branch-metadata -n "__fish_seen_subcommand_from unset; and not __fish_git_branch_metadata_using_remote" -a "(__fish_git_branch_metadata_branches)" -d "Branch name"
complete -c git-branch-metadata -n "__fish_seen_subcommand_from unset; and not __fish_git_branch_metadata_using_remote" -a "(__fish_git_branch_metadata_keys)" -d "Key name"

# Completions for 'delete' command
complete -c git-branch-metadata -n "__fish_seen_subcommand_from delete; and not __fish_git_branch_metadata_using_remote" -a "(__fish_git_branch_metadata_branches)" -d "Branch name"

# Completions for 'history' command
complete -c git-branch-metadata -n "__fish_seen_subcommand_from history; and not __fish_git_branch_metadata_using_remote" -a "(__fish_git_branch_metadata_branches)" -d "Branch name"

# Completions for 'keys' command
complete -c git-branch-metadata -n "__fish_seen_subcommand_from keys; and not __fish_git_branch_metadata_using_remote" -a "(__fish_git_branch_metadata_branches)" -d "Branch name"

# Completions for 'push' command
complete -c git-branch-metadata -n "__fish_seen_subcommand_from push" -a "(__fish_git_branch_metadata_remotes)" -d "Remote name"
complete -c git-branch-metadata -n "__fish_seen_subcommand_from push" -a "(__fish_git_branch_metadata_branches)" -d "Branch name"

# Completions for 'fetch' command
complete -c git-branch-metadata -n "__fish_seen_subcommand_from fetch; and not __fish_git_branch_metadata_using_force" -a "(__fish_git_branch_metadata_remotes)" -d "Remote name"
complete -c git-branch-metadata -n "__fish_seen_subcommand_from fetch; and __fish_git_branch_metadata_using_force" -a "(__fish_git_branch_metadata_remotes)" -d "Remote name"
complete -c git-branch-metadata -n "__fish_seen_subcommand_from fetch" -a "(__fish_git_branch_metadata_branches)" -d "Branch name"

# Completions when using -r/--remote flag
complete -c git-branch-metadata -n "__fish_seen_subcommand_from set get show delete history keys; and __fish_git_branch_metadata_using_remote" -a "(__fish_git_branch_metadata_remote_branches)" -d "Branch name"
complete -c git-branch-metadata -n "__fish_seen_subcommand_from get unset; and __fish_git_branch_metadata_using_remote" -a "(__fish_git_branch_metadata_keys)" -d "Key name"
