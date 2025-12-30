#!/bin/bash

# Check Git Repositories Script
# Recursively scans a directory for git repositories and reports divergence from origin

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Load .env file if it exists
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
if [ -f "$SCRIPT_DIR/.env" ]; then
    source "$SCRIPT_DIR/.env"
fi

# Default directory to scan (use command line arg, then env var, then fallback)
SCAN_DIR="${1:-${ARCHIVE_DIR:-$HOME/Documents/gdrive/Drive/Archive}}"

# Log file
LOG_FILE="$SCRIPT_DIR/check-git-repos.log"

# Function to log output to both console and file
log() {
    echo -e "$1"
    # Strip color codes for log file
    echo -e "$1" | sed 's/\x1b\[[0-9;]*m//g' >> "$LOG_FILE"
}

# Clear/create log file with timestamp
echo "Git Repository Check - $(date)" > "$LOG_FILE"
echo "" >> "$LOG_FILE"

log "=================================="
log "Checking Git Repositories"
log "=================================="
log "Scanning: $SCAN_DIR"
log ""

total=0
diverged=0
declare -a diverged_repos

# Find all .git directories
while IFS= read -r git_dir; do
    total=$((total + 1))
    repo_dir=$(dirname "$git_dir")
    repo_name=$(basename "$repo_dir")

    cd "$repo_dir" || continue

    # Check if repo has uncommitted changes
    has_changes=false
    has_unpushed=false
    has_unpulled=false
    no_remote=false
    detached_head=false

    # Check for uncommitted changes
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
        has_changes=true
    fi

    # Check if HEAD is detached
    if ! git symbolic-ref HEAD &>/dev/null; then
        detached_head=true
    fi

    # Get current branch
    current_branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

    # Determine repository ownership
    owner_tag=""
    origin_url=$(git remote get-url origin 2>/dev/null || echo "")

    if [[ -z "$origin_url" ]]; then
        owner_tag="${YELLOW}[NO HEAD]${NC}"
        no_remote=true
    elif [[ "$origin_url" == *"$GITHUB_USERNAME"* ]]; then
        owner_tag="${GREEN}[MY REPO]${NC}"
    else
        owner_tag="${RED}[OTHER REPO]${NC}"
    fi

    # Check if remote exists
    if ! git remote get-url origin &>/dev/null; then
        no_remote=true
    else
        # Fetch from origin (quietly)
        git fetch origin &>/dev/null || true

        # Check for unpushed commits
        if [[ -n $(git log origin/$current_branch..HEAD 2>/dev/null) ]]; then
            has_unpushed=true
        fi

        # Check for unpulled commits
        if [[ -n $(git log HEAD..origin/$current_branch 2>/dev/null) ]]; then
            has_unpulled=true
        fi
    fi

    # Report if diverged
    # Skip repos that only have detached head + no remote (these are likely example/tutorial repos)
    if $detached_head && $no_remote && ! $has_changes && ! $has_unpushed && ! $has_unpulled; then
        # Not considered diverged - just a local example repo
        log "${GREEN}[CLEAN]${NC} $owner_tag $repo_name"
        log "  Path: $repo_dir"
        log "  Status: clean (local example repo)"
        log ""
    elif $has_changes || $has_unpushed || $has_unpulled || $no_remote || $detached_head; then
        diverged=$((diverged + 1))

        status_msg=""
        if $detached_head; then
            status_msg="${status_msg}DETACHED HEAD, "
        fi
        if $has_changes; then
            status_msg="${status_msg}uncommitted changes, "
        fi
        if $has_unpushed; then
            status_msg="${status_msg}unpushed commits, "
        fi
        if $has_unpulled; then
            status_msg="${status_msg}unpulled commits, "
        fi
        if $no_remote; then
            status_msg="${status_msg}no remote, "
        fi

        # Remove trailing comma and space
        status_msg=${status_msg%, }

        diverged_repos+=("$repo_dir|$status_msg")

        log "${YELLOW}[DIVERGED]${NC} $owner_tag $repo_name"
        log "  Path: $repo_dir"
        log "  Status: $status_msg"
        log ""
    else
        # Repository is clean
        log "${GREEN}[CLEAN]${NC} $owner_tag $repo_name"
        log "  Path: $repo_dir"
        log "  Status: clean"
        log ""
    fi

done < <(find "$SCAN_DIR" -name ".git" -type d 2>/dev/null | sort)

log "=================================="
log "SUMMARY"
log "=================================="
log "Total repositories: $total"
log "${YELLOW}Diverged repositories: $diverged${NC}"
log "${GREEN}Clean repositories: $((total - diverged))${NC}"
log ""

if [ $diverged -gt 0 ]; then
    log "=================================="
    log "DIVERGED REPOSITORIES"
    log "=================================="
    for entry in "${diverged_repos[@]}"; do
        IFS='|' read -r path status <<< "$entry"
        repo_name=$(basename "$path")
        log "${YELLOW}• $repo_name${NC}"
        log "  Path: $path"
        log "  Status: $status"
        log ""
    done
fi

log "Log saved to: $LOG_FILE"
