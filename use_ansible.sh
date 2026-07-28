#!/bin/bash
# Usage:
#   source use_ansible.sh <version>  # to change current shell
#   bash use_ansible.sh <version>    # to start a new shell with the env

(return 0 2>/dev/null) && SOURCED=1 || SOURCED=0

# Define script directory relative to where it was sourced or executed.
if [ -n "${BASH_SOURCE:-}" ]; then
    SCRIPT_PATH="${BASH_SOURCE[0]}"
elif [ -n "${ZSH_VERSION:-}" ]; then
    SCRIPT_PATH="${(%):-%N}"
else
    SCRIPT_PATH="$0"
fi
SCRIPT_DIR="$(cd "$(dirname "$SCRIPT_PATH")" &> /dev/null && pwd)"

if [ -z "$1" ]; then
    echo "Error: Please specify an Ansible version: 5, 6, 7, 8, 9, 10"
    echo "Usage: use_ansible.sh <version>"
    [ "$SOURCED" -eq 1 ] && return 1 2>/dev/null || exit 1
fi

VERSION=$1
case "$VERSION" in
    5|6|7|8|9|10) ;;
    *)
        echo "Error: Invalid Ansible version '$VERSION'. Valid versions: 5, 6, 7, 8, 9, 10"
        [ "$SOURCED" -eq 1 ] && return 1 2>/dev/null || exit 1
        ;;
esac

TARGET_DIR="$SCRIPT_DIR/ansible-$VERSION"

if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory $TARGET_DIR does not exist."
    [ "$SOURCED" -eq 1 ] && return 1 2>/dev/null || exit 1
fi

if [ ! -f "$TARGET_DIR/.venv/bin/activate" ]; then
    echo "Error: Virtual environment not found in $TARGET_DIR."
    echo "Please run './setup_all.sh' first or 'uv sync' in that directory."
    [ "$SOURCED" -eq 1 ] && return 1 2>/dev/null || exit 1
fi

# Deactivate current venv if one is active
if type deactivate &> /dev/null; then
    deactivate
fi

# Activate the target environment
source "$TARGET_DIR/.venv/bin/activate"
echo "Successfully switched to Ansible $VERSION environment"
ansible --version | head -n 3

if [ "$SOURCED" -eq 0 ]; then
    echo "--------------------------------------------------------"
    echo "Starting a new shell session with Ansible $VERSION."
    echo "Type 'exit' to leave this environment."
    echo "--------------------------------------------------------"
    # Execute user's default shell
    exec "${SHELL:-bash}"
fi
