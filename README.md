# git-branch-metadata

A Git extension for storing and managing metadata for branches using a custom Git ref namespace. Store key-value pairs associated with any Git branch, locally or remotely.

## Features

- **Store metadata** as key-value pairs for any Git branch
- **Custom ref namespace** - stores metadata in `refs/branch-metadata/*` (outside `refs/heads/`)
- **Sync metadata** between local and remote repositories
- **Track history** of metadata changes with full Git commit history
- **No external dependencies** - pure Bash and Git
- **Bash completion** support included
- **Customizable namespace** via environment variables

## Requirements

- Git
- Bash

## Installation

1. Clone or download this repository
2. Make the script executable:

   ```bash
   chmod +x git-branch-metadata
   ```

3. Add to your PATH or install as a Git subcommand:

   ```bash
   # Option 1: Add to PATH
   sudo cp git-branch-metadata /usr/local/bin/
   
   # Option 2: Install in Git's exec path
   sudo cp git-branch-metadata "$(git --exec-path)/"
   ```

4. (Optional) Enable bash completion:

   ```bash
   source git-branch-metadata-completion.bash
   # Or add to your ~/.bashrc
   ```

## Usage

Once installed, you can use it as a Git subcommand:

```bash
git branch-metadata <command> [options]
```

### Commands

#### Set metadata

```bash
git branch-metadata set <branch_name> <key> <value> [<key> <value> ...]
git branch-metadata set main author "John Doe" timestamp "2024-01-01"
```

Set metadata on a remote branch:

```bash
git branch-metadata set -r <remote> <branch_name> <key> <value>
```

#### Get metadata value

```bash
git branch-metadata get <branch_name> <key>
git branch-metadata get main author
```

Get from remote:

```bash
git branch-metadata get -r <remote> <branch_name> <key>
```

#### Get all metadata

```bash
git branch-metadata get-all <branch_name>
```

Returns key-value pairs (one per line in `key=value` format).

Get all from remote:

```bash
git branch-metadata get-all -r <remote> <branch_name>
```

#### Unset a metadata key

```bash
git branch-metadata unset <branch_name> <key>
```

Unset on remote:

```bash
git branch-metadata unset -r <remote> <branch_name> <key>
```

#### Delete all metadata for a branch

```bash
git branch-metadata delete <branch_name>
```

Delete on remote:

```bash
git branch-metadata delete -r <remote> <branch_name>
```

#### List branches with metadata

```bash
git branch-metadata list
```

List remote branches with metadata:

```bash
git branch-metadata list -r <remote>
```

#### View metadata history

```bash
git branch-metadata history <branch_name>
```

View remote metadata history:

```bash
git branch-metadata history -r <remote> <branch_name>
```

#### Push metadata to remote

```bash
git branch-metadata push <remote> <branch_name>
```

#### Fetch metadata from remote

```bash
git branch-metadata fetch <remote> <branch_name>
```

#### Help

```bash
git branch-metadata help
```

## Configuration

### Environment Variables

- `METADATA_REF_PREFIX`: Customize the metadata namespace (default: `branch-metadata`)

  ```bash
  export METADATA_REF_PREFIX="custom-metadata"
  ```

- `METADATA_VERBOSE`: Enable verbose output (default: `0`)

  ```bash
  export METADATA_VERBOSE=1
  ```

## How It Works

Metadata is stored using a custom Git ref namespace `refs/branch-metadata/<branch-name>`. Unlike regular branches (which live under `refs/heads/`), these metadata refs exist in their own namespace, keeping them completely separate from your code branches.

Each metadata ref points to a Git commit containing a tree where each key-value pair is stored as a separate file (one file per key). This approach:

- **Custom ref namespace** - metadata refs live outside `refs/heads/`, avoiding clutter in branch listings
- **Separate from code** - metadata doesn't mix with your actual branches
- **Full Git versioning** - metadata changes are tracked as Git commits with history
- **Easy syncing** - push/fetch metadata refs just like branches
- **Atomic updates** - each metadata change creates a new commit
- **No external dependencies** - pure Git plumbing operations
- **Efficient storage** - only changed keys create new blobs

## Examples

```bash
# Track who created a branch and when
git branch-metadata set feature/new-feature creator "alice@example.com" created_at "2024-01-15"

# Add a ticket reference
git branch-metadata set feature/new-feature ticket "JIRA-1234"

# Get specific metadata
git branch-metadata get feature/new-feature creator
# Output: alice@example.com

# Get all metadata
git branch-metadata get-all feature/new-feature
# Output:
# creator=alice@example.com
# created_at=2024-01-15
# ticket=JIRA-1234

# List all branches with metadata
git branch-metadata list

# Push metadata to origin
git branch-metadata push origin feature/new-feature

# View metadata change history
git branch-metadata history feature/new-feature
```

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.
